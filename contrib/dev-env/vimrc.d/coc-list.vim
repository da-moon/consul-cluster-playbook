" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>la  :<C-u>CocList diagnostics<cr>
" Manage extensions.
" nnoremap <silent><nowait> <space>le  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>lc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>lo  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>ls  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>ln  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>lp  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>lr  :<C-u>CocListResume<CR>
" coc-bookmark binding
nnoremap <silent><nowait> <space>lb  :<C-u>CocList bookmark<CR>
