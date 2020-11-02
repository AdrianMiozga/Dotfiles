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

let mapleader = " "
:map <leader>ij mio<Esc>`i
:map <leader>ik miO<Esc>`i
nnoremap Y y$

if has('unix')
    " Remove delay when going out of insert mode
    set ttimeoutlen=0

    " Change cursor shape in different modes in Gnome-Terminal
    if has("autocmd")
        au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
        au InsertEnter,InsertChange *
            \ if v:insertmode == 'i' |
            \   silent execute '!echo -ne "\e[6 q"' | redraw! |
            \ elseif v:insertmode == 'r' |
            \   silent execute '!echo -ne "\e[4 q"' | redraw! |
            \ endif
        au VimLeave * silent !echo -ne "\e[6 q"
    endif
endif

" Jump to last edit location when entering a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal! g`\"" | endif
endif

" Insert date in ISO format
" Example: 2020-10-24
:iab <expr> ddd strftime("%F")

" Insert human-readable timestamp appropriate for file names
" Example: 2020-10-24 13-00-57
:iab <expr> dts strftime("%F %H-%M-%S")

" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif
