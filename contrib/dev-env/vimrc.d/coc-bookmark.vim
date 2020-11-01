
" ------------------------------------------------------------
" bookmark plugin
" ------------------------------------------------------------
" https://github.com/voldikss/coc-bookmark
function! s:my_bookmark_color() abort
  let s:scl_guibg = matchstr(execute('hi SignColumn'), 'guibg=\zs\S*')
  if empty(s:scl_guibg)
    let s:scl_guibg = 'NONE'
  endif
  exe 'hi MyBookmarkSign guifg=' . s:scl_guibg
endfunction
call s:my_bookmark_color() " don't remove this line!

augroup UserGitSignColumnColor
  autocmd!
  autocmd ColorScheme * call s:my_bookmark_color()
augroup END
nmap <Leader>bn <Plug>(coc-bookmark-next)
nmap <Leader>bp <Plug>(coc-bookmark-prev)
nmap <Leader>bt <Plug>(coc-bookmark-toggle)
nmap <Leader>ba <Plug>(coc-bookmark-annotate)
