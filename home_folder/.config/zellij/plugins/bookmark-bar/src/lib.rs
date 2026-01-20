use zellij_tile::prelude::*;
use std::collections::BTreeMap;

#[derive(Default)]
struct State {
    bookmarks: BTreeMap<usize, String>,
}

register_plugin!(State);

impl ZellijPlugin for State {
    fn load(&mut self, _configuration: BTreeMap<String, String>) {
        request_permission(&[
            PermissionType::ReadApplicationState,
        ]);
        subscribe(&[EventType::Timer]);
        set_timeout(2.0);
    }

    fn update(&mut self, event: Event) -> bool {
        match event {
            Event::Timer(_) => {
                // Reload bookmarks
                self.load_bookmarks();
                set_timeout(2.0);
                true
            }
            Event::PermissionRequestResult(_) => {
                self.load_bookmarks();
                true
            }
            _ => false,
        }
    }

    fn render(&mut self, _rows: usize, cols: usize) {
        let mut output = String::new();

        // Build bookmark bar similar to tmux
        let mut bookmark_text = String::new();

        for i in 1..=5 {
            if let Some(session) = self.bookmarks.get(&i) {
                if !bookmark_text.is_empty() {
                    bookmark_text.push_str(" │ ");
                }
                bookmark_text.push_str(&format!("[{}] {}", i, session));
            }
        }

        if bookmark_text.is_empty() {
            bookmark_text = "No bookmarks (Ctrl+a b to bookmark)".to_string();
        }

        // Center the text
        let padding = if cols > bookmark_text.len() {
            (cols - bookmark_text.len()) / 2
        } else {
            0
        };

        for _ in 0..padding {
            output.push(' ');
        }
        output.push_str(&bookmark_text);

        print!("{}", output);
    }
}

impl State {
    fn load_bookmarks(&mut self) {
        // Read bookmark file
        // Note: In a real implementation, we would use proper file I/O
        // For now, this is a placeholder
        // Zellij plugins run in WASM and have limited file system access

        // This would need to be implemented using Zellij's pipe mechanism
        // or by reading from a shared state

        self.bookmarks.clear();
        // Placeholder data - in real implementation, read from cache file
    }
}
