#!/bin/bash
: ' ----------------------------------------
* Creation Time : Sat 26 Aug 2023 12:09:58 BST
* Author : Charles N. Christensen
* Github : github.com/charlesnchr
----------------------------------------'

# Path to the Alacritty configuration file
CONFIG_FILE="$HOME/.config/alacritty/alacritty.yml"

# Counter for the number of reruns
rerun_counter=0

# Function to replace the font family and size in the Alacritty config
update_font() {
    sed -i -E "s/family: .+ Nerd Font/family: $1 Nerd Font/g" "$CONFIG_FILE"
    sed -i -E "s/size: [0-9]+(\.[0-9]+)?/size: $2/g" "$CONFIG_FILE"
    echo "Font updated to $1 Nerd Font with size $2."
}

# Function to increment or decrement the current font size
update_font_size() {
    current_size=$(grep -m1 "size:" "$CONFIG_FILE" | awk '{print $2}' | tr -d '\n')
    current_size_int=$(echo "$current_size * 10" | awk '{printf "%d", $0}')
    increment=$(echo "$1 * 10" | awk '{printf "%d", $0}')
    new_size_int=$((current_size_int + increment))
    new_size=$(echo "$new_size_int * 0.1" | awk '{printf "%.1f", $0}')

    if [ -n "$new_size" ]; then
        sed -i -E "s/size: $current_size/size: $new_size/" "$CONFIG_FILE"
        if [ $? -eq 0 ]; then
            echo "Font size updated to $new_size."
        else
            echo "sed command failed. Could not update the font size."
        fi
    else
        echo "Failed to update the font size. Please check your configuration file."
    fi
}

# Interactive menu
while [ $rerun_counter -lt 100 ]; do
    echo "Select a font to set in Alacritty:"
    echo "1) FiraCode"
    echo "2) SourceCode"
    echo "3) RobotoMono"
    echo "4) UbuntuMono"
    echo "5) Hack"
    echo "6) JetBrainsMono"
    echo "7) CascadiaCode"
    echo "-) Decrease font size"
    echo "=) Increase font size"
    echo "q) Exit"
    read -n1 -p "Enter your choice (1-7): " choice

    case $choice in
        1) update_font "FiraCode" "13.0";;
        2) update_font "SauceCodePro" "13.0";;
        3) update_font "RobotoMono" "13.0";;
        4) update_font "UbuntuMono" "15.0";;
        5) update_font "Hack" "13.0";;
        6) update_font "JetBrainsMono" "13.0";;
        7) update_font "CaskaydiaCove" "13.0";;
        -) update_font_size "-1";;
        =) update_font_size "+1";;
        q) echo "Exiting..."; break;;
        *) echo "Invalid choice. Please try again.";;
    esac

    # Increment the rerun counter
    rerun_counter=$((rerun_counter + 1))

    # Check if the rerun counter has reached 100
    if [ $rerun_counter -ge 100 ]; then
        echo "Maximum number of reruns reached. Exiting..."
        break
    fi
done
