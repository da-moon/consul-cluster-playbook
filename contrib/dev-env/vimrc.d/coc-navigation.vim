" GoTo code navigation.
function! s:GoToDefinition()
  if CocAction('jumpDefinition')
    return v:true
  endif
let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" 
    call searchdecl(expand('<cword>'))
  endif
endfunction
nmap <silent> gd :call <SID>GoToDefinition()<CR>
"nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
" list types implementing selected interface
nmap <silent> gi <Plug>(coc-implementation)
" Lists all the references to the selected symbol, for example other types using said type,
nmap <silent> gr <Plug>(coc-references)
