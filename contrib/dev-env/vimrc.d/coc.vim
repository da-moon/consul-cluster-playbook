let $bookmark = '~/.vimrc.d/coc-bookmark.vim'
let $list = '~/.vimrc.d/coc-list.vim'
let $snippets = '~/.vimrc.d/coc-snippets.vim'
" let $explorer = '~/.vimrc.d/coc-explorer.vim'
let $navigation = '~/.vimrc.d/coc-navigation.vim'
" coc config di
" eq = :CocConfig
" https://github.com/tktwr/env/blob/master/etc/vim/vimrc.51.vim-plug.vim
if !empty(glob(expand(g:cwd.'/.vim/coc-settings.json')))
  let g:coc_config_home = expand(g:cwd. '/.vim')
elseif !empty(glob(expand('~/.vim/coc-settings.json')))
  let g:coc_config_home = expand('~/.vim')
elseif has("win32unix") || has("win32") || has("win64")
  let g:coc_config_home = expand('$MY_VIM/coc/win')
else
  let g:coc_config_home = expand('$MY_VIM/coc/linux')
endif
if has("win32unix") || has("win32") || has("win64")
  let g:coc_data_home = expand('$MY_VIM/coc_data/win')
endif
" TextEdit might fail if hidden is not set.
set hidden
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-git',
  \ 'coc-bookmark',
  \ 'coc-snippets',
  \ 'coc-highlight',
  \ 'coc-json',
  \ 'coc-lists',
  \ 'coc-markdownlint',
  \ 'coc-tabnine',
  \ 'coc-tasks',
  \ 'coc-todolist',
  \ 'coc-template',
  \ 'coc-yank',
  \ 'coc-pairs',
  \ 'coc-svg',
  \ 'coc-yaml',
  \ 'coc-spell-checker',
  \ 'coc-sh',
  \ 'coc-prettier',
  \ ]
"  \ 'coc-explorer',
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-@> coc#refresh()

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" multi-cursor
" [TIP] add surronding characters e.g ysiw"
" https://github.com/neoclide/coc.nvim/wiki/Multiple-cursors-support
nmap <expr> <silent> <C-d> <SID>select_current_word()
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc
nmap <silent> <C-c> <Plug>(coc-cursors-position)
xmap <silent> <C-d> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn
nmap <leader>x  <Plug>(coc-cursors-operator)
if !empty(glob($navigation))
  source $navigation
  echo '[~/.vimrc.d/coc.vim] => '. $navigation." was sourced"
  echo ""
endif
if !empty(glob($bookmark))
  source $bookmark
  echo '[~/.vimrc.d/coc.vim] => '. $bookmark." was sourced"
  echo ""
endif
if !empty(glob($list))
  source $list
  echo '[~/.vimrc.d/coc.vim] => '. $list." was sourced"
  echo ""
endif
if !empty(glob($snippets))
  source $snippets 
  echo '[~/.vimrc.d/coc.vim] => '. $snippets." was sourced"
  echo ""
endif
"if !empty(glob($explorer))
"  source $explorer 
"  echo '[~/.vimrc.d/coc.vim] => '. $explorer." was sourced"
"endif
