call plug#begin('~/.vim/plugged')

" Our lord and savior
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-markdown'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'othree/html5.vim'
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'kien/ctrlp.vim'
Plug 'Jelera/vim-javascript-syntax'
Plug 'mustache/vim-mustache-handlebars'
Plug 'ap/vim-css-color'
Plug 'neomake/neomake'
Plug 'rking/ag.vim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'editorconfig/editorconfig-vim'
Plug 'reedes/vim-pencil'
Plug 'chriskempson/base16-vim'
Plug 'altercation/vim-colors-solarized'

call plug#end()

let mapleader="\<SPACE>"

set nowrap
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode            " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=2           " Render TABs using this many spaces.
set shiftwidth=2        " Indentation amount for < and > commands.

set noerrorbells        " No beeps.
set modeline            " Enable modeline.
set esckeys             " Cursor keys in insert mode.
set linespace=0         " Set line-spacing to minimum.
set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

if !&scrolloff
  set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
  set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set nostartofline       " Do not jump to first character with page commands.

" ctrlp options
let g:ctrlp_working_path_mode = 0
set wildignore+=*/build/**
set wildignore+=*/tmp/**
set wildignore+=*/dist/**
set wildignore+=*/bower_components/**
set wildignore+=*/node_modules/**
set wildignore+=*/docs/**
set wildignore+=*/staticfiles/**
set wildignore+=*.pyc
set wildignore+=*/__pycache__/*

" .swp and backup file locations
set directory=~/.vim-tmp
set backupdir=~/.vim-tmp

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set magic               " Use 'magic' patterns (extended regular expressions).

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Search and Replace
nmap <leader>s :%s//g<Left><Left>

" save a file
nnoremap <Leader>w :w<CR>

" Use ; for commands.
nnoremap ; :
" Use Q to execute default register.
nnoremap Q @q

" window
nmap <leader>h :topleft  vnew<CR>
nmap <leader>l :botright vnew<CR>
nmap <leader>k :topleft  new<CR>
nmap <leader>j :botright new<CR>


" search things usual way using /something
" hit cs, replace first match, and hit <Esc>
" hit n.n.n.n.n. reviewing and replacing all matches
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

""" PLUGIN SETTINGS

" vim-airline options
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_error=''

autocmd Filetype javascript setlocal ts=2
let g:javascript_ignore_javaScriptdoc = 1

" Syntastic options
let g:syntastic_javascript_checkers = ['eslint']

" Neomake options
autocmd! BufWritePost,BufEnter * Neomake
let g:neomake_verbose = 0
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_tex_enabled_makers = []
let g:neomake_markdown_enabled_makers = []

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif


" use matcher for searching if available
if executable('matcher')
    let g:ctrlp_match_func = { 'match': 'GoodMatch' }

    function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

      " Create a cache file if not yet exists
      let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
      if !( filereadable(cachefile) && a:items == readfile(cachefile) )
        call writefile(a:items, cachefile)
      endif
      if !filereadable(cachefile)
        return []
      endif

      " a:mmode is currently ignored. In the future, we should probably do
      " something about that. the matcher behaves like "full-line".
      let cmd = 'matcher --limit '.a:limit.' --manifest '.cachefile.' '
      if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
        let cmd = cmd.'--no-dotfiles '
      endif
      let cmd = cmd.a:str

      return split(system(cmd), "\n")

    endfunction
end
