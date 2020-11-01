" coc-explorer
let g:coc_explorer_global_presets = {
\   'tab': {
\     'position': 'tab',
\     'quit-on-open': v:true,
\   }
\ }
" List all presets
nmap <space>el :CocList explPresets
" generic explorer
nmap <space>e :CocCommand explorer<CR>
nmap <space>er :CocCommand explorer --preset root<CR>
nmap <space>et :CocCommand explorer --preset tab<CR>
" make coc-explorer default explorer (instead of netrw)
augroup MyCocExplorer
  autocmd!
  autocmd VimEnter * sil! au! FileExplorer *
  autocmd BufEnter * let d = expand('%') | if isdirectory(d) | bd | exe 'CocCommand explorer ' . d | endif
augroup END

