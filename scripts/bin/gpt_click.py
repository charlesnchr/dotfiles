#!/usr/bin/env python3
"""
Click automation using GPT-4.1 vision to determine click targets.

Takes a screenshot with a coordinate grid overlay, prompts GPT-4.1 to identify
which cell to click for a given action, then executes the click.
"""

import argparse
import base64
import io
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

import pyautogui
from openai import OpenAI
from PIL import Image, ImageDraw, ImageFont


def cell_to_code(x: int, y: int, grid_size: int) -> str:
    """
    Convert cell coordinates to 3-letter code.

    Parameters
    ----------
    x : int
        Column number (0-indexed)
    y : int
        Row number (0-indexed)
    grid_size : int
        Size of the grid

    Returns
    -------
    str
        3-letter code (AAA, AAB, ..., ZZZ)
    """
    # Convert 2D coordinates to linear index
    index = y * grid_size + x

    # Convert to base-26 representation with 3 letters
    # index 0 = AAA, index 1 = AAB, etc.
    third = index % 26
    second = (index // 26) % 26
    first = (index // (26 * 26)) % 26

    return chr(65 + first) + chr(65 + second) + chr(65 + third)


def code_to_cell(code: str, grid_size: int) -> tuple[int, int]:
    """
    Convert 3-letter code to cell coordinates.

    Parameters
    ----------
    code : str
        3-letter code (AAA, AAB, ..., ZZZ)
    grid_size : int
        Size of the grid

    Returns
    -------
    tuple[int, int]
        (x, y) cell coordinates
    """
    code = code.upper()
    if len(code) != 3:
        raise ValueError(f"Code must be exactly 3 letters, got: {code}")

    # Convert from base-26 to linear index
    first = ord(code[0]) - 65
    second = ord(code[1]) - 65
    third = ord(code[2]) - 65

    index = first * (26 * 26) + second * 26 + third

    # Convert linear index to 2D coordinates
    y = index // grid_size
    x = index % grid_size

    return x, y


def capture_screenshot_with_grid(grid_size: int = 50) -> tuple[Image.Image, float, float]:
    """
    Capture screenshot and overlay coordinate grid with labels on every cell.

    Parameters
    ----------
    grid_size : int
        Number of cells per dimension (default 50x50 grid)

    Returns
    -------
    tuple[Image.Image, float, float]
        Image with grid overlay, cell width in pixels, cell height in pixels
    """
    # Try multiple screenshot methods
    screenshot = None
    width = height = 0

    # Method 1: Try pyautogui with PIL backend
    try:
        print("Attempting screenshot with pyautogui...")
        import mss

        with mss.mss() as sct:
            # Capture the first monitor
            monitor = sct.monitors[1]  # 0 is all monitors, 1 is primary
            sct_img = sct.grab(monitor)

            # Convert to PIL Image
            screenshot = Image.frombytes("RGB", sct_img.size, sct_img.bgra, "raw", "BGRX")
            width, height = screenshot.size
            print(f"Captured screenshot with mss: {width}x{height} pixels")
    except Exception as e:
        print(f"mss method failed: {e}")

    # Method 2: Try pyautogui directly
    if screenshot is None:
        try:
            print("Attempting screenshot with pyautogui...")
            screenshot = pyautogui.screenshot()
            width, height = screenshot.size
            print(f"Captured screenshot with pyautogui: {width}x{height} pixels")
        except Exception as e:
            print(f"pyautogui method failed: {e}")

    # Method 3: Fall back to screencapture
    if screenshot is None:
        print("Attempting screenshot with macOS screencapture...")
        with tempfile.NamedTemporaryFile(suffix=".png", delete=False) as tmp:
            tmp_path = tmp.name

        try:
            result = subprocess.run(
                ["screencapture", "-x", tmp_path],
                check=True,
                capture_output=True,
                text=True,
            )
            screenshot = Image.open(tmp_path)
            width, height = screenshot.size
            print(f"Captured screenshot with screencapture: {width}x{height} pixels")
        except Exception as e:
            print(f"screencapture method failed: {e}")
            raise RuntimeError("All screenshot methods failed!")
        finally:
            if Path(tmp_path).exists():
                Path(tmp_path).unlink()

    if screenshot is None:
        raise RuntimeError("Failed to capture screenshot with any method!")

    width, height = screenshot.size

    # Calculate cell dimensions
    cell_width = width / grid_size
    cell_height = height / grid_size

    # Create drawing context
    draw = ImageDraw.Draw(screenshot)

    # Draw vertical lines
    for i in range(grid_size + 1):
        x = int(i * cell_width)
        draw.line([(x, 0), (x, height)], fill="red", width=2)

    # Draw horizontal lines
    for i in range(grid_size + 1):
        y = int(i * cell_height)
        draw.line([(0, y), (width, y)], fill="red", width=2)

    # Font size - smaller to fit better
    font_size = max(8, min(int(cell_height * 0.3), 14))
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", font_size)
    except Exception:
        font = ImageFont.load_default()

    # Label EVERY cell with 3-letter code (AAA, AAB, AAC, ...)
    print(f"Drawing {grid_size * grid_size} cell labels...")
    for grid_y in range(grid_size):
        for grid_x in range(grid_size):
            label = cell_to_code(grid_x, grid_y, grid_size)

            # Calculate centroid of cell
            pixel_x = int((grid_x + 0.5) * cell_width)
            pixel_y = int((grid_y + 0.5) * cell_height)

            # Get text bounding box to center it
            bbox = draw.textbbox((0, 0), label, font=font)
            text_width = bbox[2] - bbox[0]
            text_height = bbox[3] - bbox[1]

            # Center text in cell
            text_x = pixel_x - text_width // 2
            text_y = pixel_y - text_height // 2

            # Draw text with transparent background (bright yellow with outline for readability)
            # Draw black outline for better visibility
            for dx, dy in [(-1, -1), (-1, 1), (1, -1), (1, 1), (-1, 0), (1, 0), (0, -1), (0, 1)]:
                draw.text((text_x + dx, text_y + dy), label, fill="black", font=font)
            # Draw main text
            draw.text((text_x, text_y), label, fill="yellow", font=font)

    return screenshot, cell_width, cell_height


def image_to_base64(image: Image.Image) -> str:
    """
    Convert PIL Image to base64 string.

    Parameters
    ----------
    image : Image.Image
        PIL Image to convert

    Returns
    -------
    str
        Base64 encoded image string
    """
    buffered = io.BytesIO()
    image.save(buffered, format="PNG")
    return base64.b64encode(buffered.getvalue()).decode("utf-8")


def ask_gpt_for_cell(
    client: OpenAI, screenshot_b64: str, action: str, grid_size: int
) -> tuple[int, int]:
    """
    Ask GPT-4.1 vision which cell to click for the given action.

    Parameters
    ----------
    client : OpenAI
        OpenAI client instance
    screenshot_b64 : str
        Base64 encoded screenshot with grid
    action : str
        Description of the action to perform
    grid_size : int
        Size of the grid (number of cells per dimension)

    Returns
    -------
    tuple[int, int]
        Grid coordinates (x, y) to click
    """
    # Calculate the max code for the grid
    max_index = grid_size * grid_size - 1
    max_code = cell_to_code(max_index % grid_size, max_index // grid_size, grid_size)

    response = client.chat.completions.create(
        model="gpt-4.1",
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": f"""This is a screenshot with a {grid_size}x{grid_size} grid overlay.
Each cell is labeled with a unique 3-LETTER code.
- Top-left cell: AAA
- Bottom-right cell: {max_code}
- Cells are numbered sequentially from left to right, top to bottom
- Every cell code is EXACTLY 3 letters (AAA, AAB, AAC, ... {max_code})

I want to: {action}

Please respond with ONLY the 3-letter cell code (e.g., "AAA" or "BCD").
Do not include any other text in your response.""",
                    },
                    {
                        "type": "image_url",
                        "image_url": {"url": f"data:image/png;base64,{screenshot_b64}"},
                    },
                ],
            }
        ],
        max_tokens=50,
    )

    # Parse response (e.g., "ABC" or "DXQ")
    content = response.choices[0].message.content.strip().upper()
    try:
        x, y = code_to_cell(content, grid_size)
        return x, y
    except Exception as e:
        raise ValueError(f"Failed to parse GPT response '{content}': {e}")


def click_cell(cell_x: int, cell_y: int, cell_width: float, cell_height: float) -> None:
    """
    Click the centroid of the specified grid cell.

    Parameters
    ----------
    cell_x : int
        Grid X coordinate (0-99)
    cell_y : int
        Grid Y coordinate (0-99)
    cell_width : float
        Width of each cell in pixels
    cell_height : float
        Height of each cell in pixels
    """
    # Calculate centroid pixel coordinates
    pixel_x = int((cell_x + 0.5) * cell_width)
    pixel_y = int((cell_y + 0.5) * cell_height)

    print(f"Clicking cell ({cell_x},{cell_y}) at pixel position ({pixel_x},{pixel_y})")
    pyautogui.click(pixel_x, pixel_y)


def check_screen_recording_permission() -> None:
    """Check if Screen Recording permission might be an issue."""
    # Check if running in tmux
    in_tmux = os.environ.get("TMUX") is not None

    print("\n" + "=" * 70)
    print("IMPORTANT: macOS Screen Recording Permission Required")
    print("=" * 70)

    if in_tmux:
        print("\n⚠️  DETECTED: You are running inside tmux")
        print("\nFor tmux, you need to grant permission to BOTH:")
        print("1. Your terminal app (Terminal.app, iTerm2, etc.)")
        print("2. The tmux process itself")
        print("\nTo fix:")
        print("1. Exit tmux completely: 'tmux kill-server'")
        print("2. Open System Settings → Privacy & Security → Screen Recording")
        print("3. Enable permission for your terminal app")
        print("4. Start tmux again and run this script")
        print("\nAlternatively, run this script OUTSIDE of tmux:")
        print("   1. Detach from tmux: Ctrl+B then D")
        print("   2. Run: uv run python scripts/gpt_click.py '<your action>'")
    else:
        print("\nIf you only see your desktop background (not actual windows):")
        print("1. Open System Settings")
        print("2. Go to Privacy & Security → Screen Recording")
        print("3. Enable permission for your terminal app:")
        print("   - Terminal.app")
        print("   - iTerm2")
        print("   - VS Code (if using integrated terminal)")
        print("   - Claude Desktop (if using claude.ai/code)")
        print("4. RESTART your terminal completely")
        print("5. Run this script again")

    print("=" * 70 + "\n")


def main() -> None:
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(
        description="Use GPT-4.1 vision to determine where to click on screen"
    )
    parser.add_argument(
        "action",
        type=str,
        help="Description of the action to perform (e.g., 'click the Chrome icon')",
    )
    parser.add_argument(
        "--grid-size",
        type=int,
        default=50,
        help="Grid size (default: 50x50)",
    )
    parser.add_argument(
        "--save-screenshot",
        type=str,
        help="Optional path to save the annotated screenshot",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Don't actually click, just show where it would click",
    )
    parser.add_argument(
        "--skip-permission-warning",
        action="store_true",
        help="Skip the Screen Recording permission warning",
    )

    args = parser.parse_args()

    # Show permission warning
    if not args.skip_permission_warning:
        check_screen_recording_permission()

    # Get API key
    api_key = os.environ.get("PRIVATE_OPENAI_API_KEY")
    if not api_key:
        print("Error: PRIVATE_OPENAI_API_KEY environment variable not set", file=sys.stderr)
        sys.exit(1)

    # Initialize OpenAI client
    client = OpenAI(api_key=api_key)

    print(f"Capturing screenshot with {args.grid_size}x{args.grid_size} grid...")
    screenshot, cell_width, cell_height = capture_screenshot_with_grid(args.grid_size)

    # Optionally save screenshot
    if args.save_screenshot:
        screenshot.save(args.save_screenshot)
        print(f"Screenshot saved to {args.save_screenshot}")

    # Convert to base64
    print("Converting screenshot to base64...")
    screenshot_b64 = image_to_base64(screenshot)

    # Ask GPT-4.1
    print(f"Asking GPT-4.1: {args.action}")
    cell_x, cell_y = ask_gpt_for_cell(client, screenshot_b64, args.action, args.grid_size)

    # Validate coordinates
    if not (0 <= cell_x < args.grid_size and 0 <= cell_y < args.grid_size):
        print(
            f"Error: GPT returned invalid coordinates ({cell_x},{cell_y})",
            file=sys.stderr,
        )
        sys.exit(1)

    cell_label = cell_to_code(cell_x, cell_y, args.grid_size)
    print(f"GPT-4.1 suggests clicking cell {cell_label} (grid position: col={cell_x}, row={cell_y})")

    # Execute click
    if args.dry_run:
        pixel_x = int((cell_x + 0.5) * cell_width)
        pixel_y = int((cell_y + 0.5) * cell_height)
        print(f"Dry run: Would click at pixel position ({pixel_x},{pixel_y})")
    else:
        click_cell(cell_x, cell_y, cell_width, cell_height)
        print("Click executed!")


if __name__ == "__main__":
    main()
