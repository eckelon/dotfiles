call plug#begin('~/.local/share/nvim/plugged')

" git
Plug 'tpope/vim-fugitive' "A Git wrapper so awesome, it should be illegal
Plug 'airblade/vim-gitgutter' "shows a git diff in the gutter (sign column) and stages/undoes hunks

" gui
Plug 'ap/vim-css-color', { 'for': ['vue', 'scss', 'css'] } "Preview colours in source code while editing
Plug 'itchyny/lightline.vim' "A light and configurable statusline/tabline plugin for Vim
" Plug 'kaicataldo/material.vim', { 'branch': 'main' } "A port of the Material color scheme for Vim/Neovim
Plug 'itchyny/vim-highlighturl' "URL highlight everywhere
Plug 'Luxed/ayu-vim' "Modern theme for modern VIMs
" Plug 'lifepillar/vim-solarized8' "Optimized Solarized colorschemes.

"programming
Plug 'nestorsalceda/vim-strip-trailing-whitespaces'
Plug 'tpope/vim-commentary' "comment stuff out
Plug 'editorconfig/editorconfig-vim' "editorconfig support
Plug 'elzr/vim-json', { 'for': 'json'}
Plug 'neoclide/coc.nvim', {'branch': 'release', 'for': ['javascriptfoo', 'typescript', 'scss', 'css', 'vue', 'svelte']}
Plug 'honza/vim-snippets', { 'for': ['javascript', 'vue']}
Plug 'cespare/vim-toml', { 'for': 'toml' } "Vim syntax for TOML
Plug 'Chiel92/vim-autoformat', { 'for': 'rust'} "Provide easy code formatting in Vim by integrating existing code formatters.
Plug 'neovim/nvim-lspconfig' " Collection of common configurations for the Nvim LSP client
Plug 'nvim-lua/lsp_extensions.nvim' " Extensions to built-in LSP, for example, providing type inlay hints
Plug 'nvim-lua/completion-nvim' " Autocompletion framework for built-in LSP



" better navigation
Plug 'andymass/vim-matchup' "even better %. Navigate and highlight matching words
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "Install fzf for user
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-dirvish' "Directory viewer for Vim
Plug 'mengelbrecht/lightline-bufferline' "A lightweight plugin to display the list of buffers in the lightline vim plugin

" better vim
Plug 'tpope/vim-eunuch' "Helpers for UNIX - works nice with vim-dirvish
Plug 'junegunn/vim-slash' "Enhancing in-buffer search experience
Plug 'tpope/vim-sleuth' "Heuristically set buffer options
" Plug 'skywind3000/asyncrun.vim' "Run Async Shell Commands in Vim 8.0 / NeoVim and Output to Quickfix Window
" Plug 'vimwiki/vimwiki' "Personal Wiki for Vim
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']} "markdown preview plugin for (neo)vim
" Plug 'junegunn/goyo.vim', { 'for': 'markdown' } "Distraction-free writing in Vim
" Plug 'junegunn/limelight.vim' "Hyperfocus-writing in Vim.

" javascript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'evanleck/vim-svelte', {'branch': 'main', 'for': 'svelte'}
Plug '~/.vim/npm-test-plugin', { 'for': 'javascript' }
Plug '~/.vim/json-format-plugin', { 'for': 'json' }
Plug 'leafOfTree/vim-vue-plugin', { 'for': 'vue' } "Vim syntax and indent plugin for .vue files.

call plug#end()
let g:coc_global_extensions = [
			\ 'coc-json',
			\ 'coc-tsserver',
			\ 'coc-css',
			\ 'coc-vetur',
			\ 'coc-snippets',
			\ 'coc-svelte',
			\ 'coc-rust-analyzer'
			\ ]

" Add CoC ESLint if ESLint is installed
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Add CoC Prettier if prettier is installed
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif
