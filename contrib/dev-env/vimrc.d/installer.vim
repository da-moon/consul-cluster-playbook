let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path) 
endif 
" ============================================================================
" Active plugins
call plug#begin('~/.vim/plugged')
" themes and colorscheme
" Terminal Vim with 256 colors colorscheme
Plug 'fisadev/fisa-vim-colorscheme'
" solarized theme
Plug 'altercation/vim-colors-solarized'
" Gvim colorscheme
Plug 'vim-scripts/Wombat'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" vscode language server
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" git integration
Plug 'tpope/vim-fugitive'
" task runner
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'

Plug 'ryanoasis/vim-devicons'
Plug 'airblade/vim-gitgutter'
"fuzzy find files
Plug 'ctrlpvim/ctrlp.vim' 
"fix comments
Plug 'scrooloose/nerdcommenter'
" File explorer
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'morhetz/gruvbox'
" TS Syntax
Plug 'HerringtonDarkholme/yats.vim' 
" ansible plugin
Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }
" add surrounding characters in pairs
Plug 'tpope/vim-surround'
" help with snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" multicursor with ctrl support
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
" Tab list panel
Plug 'kien/tabman.vim'
call plug#end()
" ============================================================================
" Install plugins the first time vim runs
if vim_plug_just_installed
  echo "Installing Bundles, please ignore key map error messages"
  :PlugInstall
  echo ""
endif

