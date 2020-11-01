" multicursor settings
" github.com/mg979/vim-visual-mult
" mapping : https://github.com/mg979/vim-visual-multi/wiki/Mappings
"
"
" to minimize chances for collision, specify multicursor leader
let g:VM_leader = '\\'
" use default mapping
let g:VM_default_mappings = 1
" enable using mouse to drop cursors , i.e ctrl+left click
let g:VM_mouse_mappings = 1
" undo or redo changes made by multi cursor
let g:VM_maps["Undo"] = 'u'
let g:VM_maps["Redo"] = '<C-r>'

