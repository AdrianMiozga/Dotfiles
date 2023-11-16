set incsearch
set ignorecase
set clipboard=unnamed
set number relativenumber

let mapleader = " "

" Yank without new line at the end
nnoremap Y y$

" Don't replace unnamed register when pasting text in visual mode
xnoremap p P
