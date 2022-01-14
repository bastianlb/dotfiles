let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_save_on_switch = 1

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

" git helpers such as :Gdiff
Plug 'tpope/vim-fugitive'
" github integration
Plug 'tpope/vim-rhubarb'
" easily modify surrounding quotes
Plug 'tpope/vim-surround'
" comment out things easily
Plug 'tpope/vim-commentary'
" explore directory listings
Plug 'tpope/vim-vinegar'
" adjusts tabs and spaces
Plug 'tpope/vim-sleuth'
" common pairs of commands
Plug 'tpope/vim-unimpaired'
" repeat sets of commands
Plug 'tpope/vim-repeat'

" file directory explore
Plug 'preservim/nerdtree'
" completion engine
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

" LSP-server integration
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Install nvim-cmp
Plug 'hrsh7th/nvim-cmp'
" Install snippet engine (This example installs [hrsh7th/vim-vsnip](https://github.com/hrsh7th/vim-vsnip))
Plug 'hrsh7th/vim-vsnip'
" Install the buffer completion source
Plug 'hrsh7th/cmp-buffer'
" Install plugin for lsp
Plug 'hrsh7th/cmp-nvim-lsp'
" plugin for filepaths
Plug 'hrsh7th/cmp-path'


" temp keep ctrlp, telescope broken on nightly vim build
Plug 'ctrlpvim/ctrlp.vim'

" fuzzy search plugins
Plug 'mileszs/ack.vim'

" dependencies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
" telescope
Plug 'nvim-telescope/telescope.nvim'

" split panes
Plug 'mattboehm/vim-accordion'

" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" ?
Plug 'editorconfig/editorconfig-vim'

" writing modes? check and use
Plug 'reedes/vim-pencil'

" jupyter-like code execution
Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }

" themes
Plug 'freeo/vim-kalisi'
Plug 'altercation/vim-colors-solarized'
Plug 'folke/tokyonight.nvim'
Plug 'EdenEast/nightfox.nvim'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

Plug 'jakewvincent/texmagic.nvim'

call plug#end()

" Markdown Preview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1

lua << EOF
local lspconfig = require'lspconfig'
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', '<leader>gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<leader>gD', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
end

local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
  ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.close(),
  ['<C-y>'] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  })
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'vsnip' },
  }
})

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

lspconfig.ccls.setup {
  cmd = { "ccls" },
  init_options = {
    compilationDatabaseDirectory = "build",
    clang = {
      excludeArgs = { "-frounding-math"},
    },
  },
  on_attach = on_attach,
  capabilities = capabilities,
};

lspconfig.pylsp.setup {
  on_attach = on_attach,
  settings={
        pylsp = {
            configurationSources = { "flake8", "jedi", "rope" },
            plugins = { 
              -- gives doc linting errors
              -- pydocstyle = {enabled = true},
              jedi = {
                enabled=true,
              },
              flake8 = {
                config = "~/.config/flake8",
                enabled=true,
              },
            },
            type = "string"
        }
  },
  capabilities = capabilities,
};
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"cpp", "python"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "rust" },  -- list of language that will be disabled
  },
}
EOF

lua <<EOF
require('telescope').setup{
  defaults = {
    previewer = true,
    vimgrep_arguments = {
      'rg %s --files --color=never --glob ""'
    },
    color_devicons = true,
    sorting_strategy = 'ascending',
--    preview_cutoff = 1,
    file_ignore_patterns = {'build/*', 'cmake/*', 'data/*'},
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  }
}
EOF
"nnoremap <c-p> :lua require'telescope.builtin'.find_files{}<CR>
"nnoremap <silent> gr <cmd>lua require'telescope.builtin'.lsp_references{ shorten_path = true }<CR>
" autocmd User TelescopePreviewerLoaded setlocal wrap

" possibility to use ycm with ccls
"let g:ycm_language_server =
"  \ [{
"  \   'name': 'ccls',
"  \   'cmdline': [ 'ccls' ],
"  \   'filetypes': [ 'c', 'cpp', 'cuda', 'objc', 'objcpp' ],
"  \   'project_root_files': [ '.ccls-root', 'build/compile_commands.json' ]
"  \ }]
"
"let g:ycm_global_ycm_extra_conf = '$HOME/.ycm_extra_conf.py'

let mapleader="\<SPACE>"

noremap <leader>o :GBrowse<cr>

set nowrap
set softtabstop=0 expandtab shiftwidth=2 smarttab
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set showmode            " Show current mode.
set ruler               " Show the line and column numbers of the cursor.
set formatoptions+=o    " Continue comment marker in new lines.
set textwidth=0         " Hard-wrap long lines as you type them.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=2           " Render TABs using this many spaces.

set noerrorbells        " No beeps.
set modeline            " Enable modeline.
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

" Edit vimrc configuration file
nnoremap <Leader>ve :e $MYVIMRC<CR>
" " Reload vimrc configuration file
nnoremap <Leader>vr :source $MYVIMRC<CR>

"
set backspace=2 " make backspace work like most other programs

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

" Use ; for commands.
nnoremap ; :

" window
nmap <leader>h :topleft  vnew<CR>
nmap <leader>l :botright vnew<CR>
nmap <leader>k :topleft  new<CR>
nmap <leader>j :botright new<CR>

"nerdtree
map \ :NERDTreeToggle<CR>

" search things usual way using /something
" hit cs, replace first match, and hit <Esc>
" hit n.n.n.n.n. reviewing and replacing all matches
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

""" THEME SETTINGS

let g:tokyonight_style = 'dark'
let g:tokyonight_italic_functions = 1
syntax enable
colorscheme nightfox
set background=dark
let g:airline_theme='kalisi'
set t_Co=256

" Accordion use 4 panes
autocmd VimEnter * AccordionAll 4
augroup ReduceNoise
    autocmd!
    " Automatically resize active split to 85 width
    autocmd WinEnter * :call ResizeSplits()
augroup END

function! ResizeSplits()
    set winwidth=120
    wincmd =
endfunction

" YouCompleteMe options
" ctrl+] when the cursor is positioned in a symbol to quickly jump to a definition
" or declaration
" au FileType js,py nnoremap <buffer> <c-]> :YcmCompleter GoTo<CR>
let g:ycm_filetype_whitelist = {'*': 1}
let g:ycm_filetype_blacklist = {
      \ 'cpp': 1,
      \}

" vim-airline options
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_error=''

autocmd Filetype javascript setlocal ts=2
let g:javascript_ignore_javaScriptdoc = 1

let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40

" telescope mappings
nnoremap <leader>ff <cmd>Telescope find_files<cr>

" Magma keybindings
nnoremap <expr> <leader>r nvim_exec('MagmaEvaluateOperator', v:true)
nnoremap <silent>       <leader>rr :MagmaEvaluateLine<CR>
xnoremap <silent>       <leader>r  :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <leader>rc :MagmaReevaluateCell<CR>
nnoremap <silent>       <leader>rd :MagmaDelete<CR>
nnoremap <silent>       <leader>ro :MagmaShowOutput<CR>

let g:magma_automatically_open_output = v:false

if executable('rg')
  " Use ag over grep
  set grepprg=rg\ --color=never
  let g:ackprg = 'rg --vimgrep'

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
else
  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
endif

"TexMagic

let g:tex_flavor = 'latex'
nnoremap <Leader>tb :TexlabBuild<CR>
nnoremap <Leader>tp :TexlabForward<CR>

autocmd BufWritePost,FileWritePost *.tex :TexlabBuild

lua <<EOF
-- Run setup and specify two custom build engines
require('texmagic').setup{
    engines = {
        pdflatex = {    -- This has the same name as a default engine but would
                        -- be preferred over the same-name default if defined
            executable = "latexmk",
            args = {
                "-pdflatex",
                "-interaction=nonstopmode",
                "-synctex=1",
                "-outdir=.build",
                "-pv",
                "%f"
            },
            isContinuous = false
        },
    }
}

require('lspconfig').texlab.setup{
    cmd = {"texlab"},
    filetypes = {"tex", "bib"},
    settings = {
        texlab = {
            rootDirectory = nil,
            build = _G.TeXMagicBuildConfig,
            forwardSearch = {
                executable = "evince",
                args = {"%p"}
            }
        }
    }
}
EOF
