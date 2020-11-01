function! PlugLoaded(name)
    return (
        \ has_key(g:plugs, a:name) &&
        \ isdirectory(g:plugs[a:name].dir) &&
        \ stridx(&rtp, g:plugs[a:name].dir) >= 0)
endfunction

" async tasks
let g:asyncrun_open = 6

" exrc setting adds searching of the current directory for the .vimrc file and loads it.
set exrc
" Enabling the secure setting ensures that shell, autocmd and write commands are not allowed in the .vimrc file that was found in the current directory
" set secure
" vim shell
set shell=/bin/bash
" no vi-compatible
set nocompatible
" allow plugins by file type (required for plugins!)
filetype plugin on
filetype indent on
" always show status bar
set ls=2
" incremental search
set incsearch
" highlighted search results
set hlsearch
" syntax highlight on
syntax on
" show line numbers
set nu
" old autocomplete keyboard shortcut
imap <C-J> <C-X><C-O>
" Comment this line to enable autocompletion preview window
" (displays documentation related to the selected completion option)
" Disabled by default because preview makes the window flicker
set completeopt-=preview
" save as sudo
ca w!! w !sudo tee "%"
" simple recursive grep
nmap ,r :Ack 
nmap ,wr :Ack <cword><CR>
" when scrolling, keep cursor 3 lines away from screen border
set scrolloff=3
" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest
" fix bacspace
set backspace=indent,eol,start
" use mouse for tab navigation
:set mouse=a
" Quickly edit/reload this configuration file
nnoremap gev :e $MYVIMRC<CR>
nnoremap gsv :so $MYVIMRC<CR>
if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd
