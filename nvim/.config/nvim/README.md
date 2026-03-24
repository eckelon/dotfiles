# Minimal Neovim Config

A single-file, plugin-free configuration for Neovim 0.10+.

## Prerequisites
- **Nerd Font**: Required for icons in the statusline and diagnostic gutter.

## Optional (Recommended)
- **fd**: For fast file searching (`<leader>ff`).
- **ripgrep (rg)**: For fast project-wide grepping (`<leader>g`).

## Treesitter (Manual Installation)

This configuration uses Neovim's built-in Treesitter engine without the `nvim-treesitter` plugin. To enable highlighting for a language, you must manually compile and install its parser.

### How to install a new language (e.g., Go)

1. **Find the parser source**: Most are on GitHub under `tree-sitter/tree-sitter-<lang>`.
2. **Compile the parser**:
   ```bash
   # Clone the source
   git clone --depth 1 https://github.com/tree-sitter/tree-sitter-go.git /tmp/ts-go
   cd /tmp/ts-go

   # Compile to a shared object (.so)
   gcc -o go.so -shared src/parser.c src/scanner.c -I./src -fPIC -Os
   # Note: Some languages don't have src/scanner.c, just omit it if missing.
   ```
3. **Install the parser and queries**:
   Move the `.so` file and the `.scm` query files to your Neovim data directory. Without the queries, Neovim can parse the file but won't know how to color it.
   ```bash
   # 1. Install the binary parser
   mkdir -p ~/.local/share/nvim/site/parser
   mv go.so ~/.local/share/nvim/site/parser/

   # 2. Install the syntax highlighting rules
   mkdir -p ~/.local/share/nvim/site/queries/go
   cp queries/*.scm ~/.local/share/nvim/site/queries/go/
   ```

### Included Mappings
- `<leader>ff`: Fuzzy find files.
- `<leader>fF`: Find files using `fd`.
- `<leader>gr`: Grep word under cursor (visual mode supported).
- `<leader>e`: Toggle Netrw tree sidebar.
- `jj`: Return to Normal mode from Insert mode.
- `gh`/`gl`: Go to start/end of line.
- `-`: Open parent directory.
- `<leader>co`/`<leader>cc`: Open/close quickfix list.
