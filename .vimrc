set ignorecase
set incsearch
set clipboard=unnamed
set number relativenumber

" Don't add new empty line at end of file if it doesn't exist
set nofixendofline

" Use the same indent level when starting a new line
set autoindent

" Enable syntax highlighting
syntax on
colorscheme murphy

" Width of tab
set tabstop=4

" Match indentation of < and > the same as setting of tabstop
set shiftwidth=0

" Tab creates spaces instead of inserting tab
set expandtab

nnoremap Y y$
