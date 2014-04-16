runtime plugin/source.vim
syntax on
filetype plugin indent on

" Determine machine (alpha.mydevbox.com, beta.mydevbox.com, something.local)
let hostname = substitute(system('hostname'), '\n', '', '')

" Comma is the leader character
let mapleader = ","

" Sensible settings
Source https://github.com/tpope/vim-sensible

" Basic stuff
set encoding=utf-8                     " always use the good encoding
set mouse=a                            " allow the mouse to be used
set title                              " set the window's title to the current filename
set visualbell                         " no more beeping from Vim
set number                             " show line numbers
set cursorline                         " highlight current line
set fillchars=vert:│                   " Solid line for vsplit separator
set showmode                           " show what mode (Insert/Normal/Visual) is currently on
set timeoutlen=500




" Airline Status Line
Source https://github.com/bling/vim-airline
let g:airline_left_sep='' "⮀
let g:airline_left_alt_sep = '' "⮁
let g:airline_right_sep='' "⮂
let g:airline_right_alt_sep = '' "⮃
let g:airline_symbols = {}
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.linenr = '⭡'

" Wild stuff!
set wildmenu                           " visual autocomplete for command menu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,*.pyc,*.rbc,*.class,.svn,test/fixtures/*,vendor/gems/*,*.DS_STORE,*.db,*.swc,*.tar,*.tgz,.git,*/public_html/images/**,*/public_html/upload/**,*/public/images/**,*/public/upload/**,./var/**,*/uploads/**,*/pear/**,*/build/**

" Whitespace
set nowrap
set tabstop=2                           " number of visual spaces per tab
set softtabstop=2                       " number of spaces in tab when editing
set expandtab                           " tabs are spaces!
set shiftwidth=2                        " how many spaces to indent/outdent

" F5 will remove trailing whitespace and tabs
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" Use modeline overrides
set modeline
set modelines=10

" Fix popmenu with :Pmenu or <space>p if it's unreadable (bad colorscheme!)
command! Pmenu call s:Pmenu()
function! s:Pmenu()
  highlight Pmenu      ctermfg=white ctermbg=darkgray guifg=white    guibg=gray40
  highlight PmenuSel   ctermfg=white ctermbg=black    guifg=white    guibg=black
  highlight PmenuSbar                                 guifg=white    guibg=gray40
  highlight PmenuThumb                                guifg=#c0c0c0
endfunction
nnoremap <silent> <space>p :Pmenu<CR>

" Colors
" Source https://github.com/bzx/vim-theme-pack
" Source https://github.com/ndzou/vim-colorschemes
colorscheme hemisu-dark
call s:Pmenu()


" Directories for undo backup, swp files
set undofile
set undodir=~/.vim/backup
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Remember last location in file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

" Visual shifting (builtin-repeat)
vmap < <gv
vmap > >gv

" Better visual block selecting
set virtualedit+=block
set virtualedit+=insert
set virtualedit+=onemore

" Hide buffers or auto-save?
set hidden       " allow unsaved buffers to be hidden
" set autowriteall  " Automatically save buffers

" ,u will show undo history graph
Source https://github.com/sjl/gundo.vim
nnoremap <leader>u :GundoToggle<CR>
let g:gundo_right = 1

" Redraw shortcut
noremap <C-m> <Esc>:redraw!<CR>

" Opens an edit command with the path of the currently edited file filled in
map :ee :e <C-R>=expand("%:p:h") . "/" <CR>

" ;cd to current file
nnoremap ;cd :cd %:p:h<CR>:pwd<CR>

" Alt-tab between buffers
nnoremap <leader><leader> <c-^>
nmap <leader>6 <C-^>
nmap <leader>^ <C-^>

" Use OS X clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard
  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif


"============="
" https://gist.github.com/burke/5960455

function! PropagatePasteBufferToOSX()
  let @n=getreg("*")
  call system('pbcopy', @n)
  echo "done"
endfunction

function! PopulatePasteBufferFromOSX()
  let @+ = system('pbpaste')
  echo "done"
endfunction

nnoremap <leader>6 :call PopulatePasteBufferFromOSX()<cr>
nnoremap <leader>7 :call PropagatePasteBufferToOSX()<cr>

"============="

" Make 'Y' follow 'D' and 'C' conventions'
nnoremap Y y$

" sudo & write if you forget to sudo first
cmap w!! w !sudo tee % >/dev/null

"============="

" Let split windows be different sizes
set noequalalways

" Tmux Navigator - Smart way to move between splits. Ctrl-[h,j,k,l]
Source https://github.com/christoomey/vim-tmux-navigator

" Vimux - send commands to tmux panes from vim
Source https://github.com/benmills/vimux
map <leader>g :call VimuxRunCommand("git status")<CR>

" If in Visual Mode, resize window instead of changing focus. Ctrl-[h,j,k,l]
vmap <C-j> <C-W>+
vmap <C-k> <C-W>-
vmap <C-h> <C-W><
vmap <C-l> <C-W>>

" Let directional keys work in Insert Mode. Ctrl-[h,j,k,l]
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

" Cursor movement in command mode
cmap <C-j> <Down>
cmap <C-k> <Up>
cmap <C-h> <Left>
cmap <C-l> <Right>
cmap <C-x> <Del>
cmap <C-z> <BS>
cmap <C-v> <C-R>"

"============="


" Multiple Cursors
Source https://github.com/terryma/vim-multiple-cursors


"============="
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<CR>

" Move to the next misspelled word
map <leader>sn ]s

" Move to the previous misspelled word
map <leader>sp [s

" Add word to dictionary
map <leader>sa zg

" View spelling suggestions for misspelled word
map <leader>s? z=

"============="

" Searching
" -----------------------------
set hlsearch
set ignorecase
set smartcase
set gdefault

" Shows what match number/total we're at when searching
Source https://github.com/vim-scripts/IndexedSearch

" Clear search with comma-space
noremap <leader><space> :noh<CR>:match none<CR>:2match none<CR>:3match none<CR>

" Ag - The Silver Searcher
Source https://github.com/rking/ag.vim

" Use Ag instead of Grep when available
if executable("ag")
  set grepprg=ag\ -H\ --nogroup\ --nocolor
  nnoremap <leader>a :Ag ""<left>
endif

"============="

Source https://github.com/vim-scripts/bufexplorer.zip

command! Buffers call s:Buffers()
function! s:Buffers()
  let l:title = expand("%:t")
  if (l:title == '[BufExplorer]')
    :b#
  else
    :silent BufExplorer
  endif
endfunction

nmap <S-k> :Buffers<CR>


" CtrlP
Source https://github.com/kien/ctrlp.vim

let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_map = ''
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$',
  \ 'file': '\.pyc$\|\.pyo$\|\.rbc$|\.rbo$\|\.class$\|\.o$\|\~$\',
  \ }
vmap <C-g> <ESC>:CtrlP .<CR>
nmap <C-g> <ESC>:CtrlP .<CR>

"============="

" Unite & Unite-related Plugins
" -----------------------------

" VimProc for async magic
Source https://github.com/Shougo/vimproc.vim make

" Unite
Source https://github.com/Shougo/unite.vim
Source https://github.com/Shougo/neomru.vim

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#set_profile('files', 'smartcase', 1)
call unite#custom#source('line,outline','matchers','matcher_fuzzy')

let g:unite_data_directory='~/.vim/.cache/unite'
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1
let g:unite_source_rec_max_cache_files=5000
let g:unite_prompt='» '
" let g:unite_winheight = 10
let g:unite_split_rule = 'botright'

" Ag searching
let g:unite_source_grep_command='ag'
let g:unite_source_grep_default_opts='--nocolor --nogroup -S -C4'
let g:unite_source_grep_recursive_opt=''

function! s:unite_settings()
  nmap <buffer> Q <plug>(unite_exit)
  nmap <buffer> <esc> <plug>(unite_exit)
  imap <buffer> <esc> <plug>(unite_exit)
  nmap <buffer> <C-s> <Plug>(unite_redraw)
  imap <buffer> <C-s> <Plug>(unite_redraw)
endfunction
autocmd FileType unite call s:unite_settings()

" Unite mappings
nmap <space> [unite]
nnoremap [unite] <nop>

nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async:! buffer file_mru bookmark<cr><c-u>
nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async:!<cr><c-u>
nnoremap <silent> [unite]e :<C-u>Unite -buffer-name=recent file_mru<cr>
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> [unite]l :<C-u>Unite -auto-resize -buffer-name=line line<cr>
nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]m :<C-u>Unite -auto-resize -buffer-name=mappings mapping<cr>
nnoremap <silent> [unite]s :<C-u>Unite -quick-match buffer<cr>
nnoremap <silent> [unite]b :<C-u>Unite -no-split -no-start-insert -buffer-name=buffers buffer<cr>

Source https://github.com/osyo-manga/unite-airline_themes
nnoremap <silent> [unite]a :<C-u>Unite -winheight=10 -auto-preview -buffer-name=airline_themes airline_themes<cr>

Source https://github.com/ujihisa/unite-colorscheme
nnoremap <silent> [unite]c :<C-u>Unite -winheight=10 -auto-preview -buffer-name=colorschemes colorscheme<cr>

Source https://github.com/tsukkee/unite-tag
nnoremap <silent> [unite]t :<C-u>Unite -auto-resize -buffer-name=tag tag tag/file<cr>

Source https://github.com/Shougo/unite-outline
nnoremap <silent> [unite]o :<C-u>Unite -auto-resize -buffer-name=outline outline<cr>

Source https://github.com/Shougo/unite-help
nnoremap <silent> [unite]h :<C-u>Unite -auto-resize -buffer-name=help help<cr>

Source https://github.com/Shougo/junkfile.vim
let g:junkfile#directory=expand("~/.vim/.cache/junk")
nnoremap <silent> [unite]j :<C-u>Unite -auto-resize -buffer-name=junk junkfile junkfile/new<cr>


" VimShell
Source https://github.com/Shougo/vimshell.vim
if has('gui_macvim')
  let g:vimshell_editor_command='mvim'
else
  let g:vimshell_editor_command='vim'
endif
let g:vimshell_right_prompt='getcwd()'
let g:vimshell_data_directory='~/.vim/.cache/vimshell'
let g:vimshell_vimshrc_path='~/.vim/vimshrc'

nnoremap <leader>c :VimShell -split<cr>
nnoremap <leader>cc :VimShell -split<cr>
nnoremap <leader>cn :VimShellInteractive node<cr>
nnoremap <leader>cl :VimShellInteractive lua<cr>
nnoremap <leader>cr :VimShellInteractive irb<cr>
nnoremap <leader>cp :VimShellInteractive python<cr>


" This plugin overwrites my Source command! Bad plugin.
" " VimFiler
" Source https://github.com/Shougo/vimfiler.vim
" " let g:vimfiler_as_default_explorer = 1
" let g:vimfiler_safe_mode_by_default=0
" let g:vimfiler_quick_look_command = 'qlmanage -p'
" let g:vimfiler_tree_leaf_icon = ' '
" let g:vimfiler_tree_opened_icon = '▾'
" let g:vimfiler_tree_closed_icon = '▸'
" let g:vimfiler_file_icon = '-'
" let g:vimfiler_marked_file_icon = '*'

"============="

Source https://github.com/rgarver/Kwbd.vim

" :bd deletes a buffer, :BD deletes a buffer and keeps its window
command! BD Kwbd

" Don't save, close buffer, keep window
nmap ZX :BD<CR>

" Don't save, close buffer, close window
nmap ZXX :bd!<CR>

" Save, close buffer, keep window
nmap ZSX :w<CR>:BD<CR>

" Save, close buffer, close window
nmap ZSXX :w<CR>:bd!<CR>

" Save the buffer
nmap ZS :w<CR>
nmap <leader>w :w<CR>

"============="

Source https://github.com/justinmk/vim-sneak
let g:sneak#streak = 0
" nmap <C-s> <Plug>Sneak_s
" nmap <C-S> <Plug>Sneak_S

"============="

" Unimpaired - see all mappings at :help unimpaired
Source https://github.com/tpope/vim-unimpaired
" cob bgcolor cow softwrap, coc cursorline, cou cursorcolumn, con number, cor relativenumber
" yp yP yo YO yI YA paste with paste toggled on
" []x encode xml, []u encode url, []y encode C string
" []b buffers, []f files, []<Space> blank lines
" []e bubble multiple lines, visual mode mappings below:
vmap _ [egv
vmap + ]egv

"============="

" Show Syntax Errors
Source https://github.com/scrooloose/syntastic
let g:syntastic_enable_signs=1
let g:syntastic_check_on_open=1
let g:syntastic_quiet_messages = {'level': 'warnings'}

" Highlight matching tags while inside
Source https://github.com/Valloric/MatchTagAlways.git

"============="

" Ruby Helpers
Source https://github.com/tpope/vim-rails
Source https://github.com/tpope/vim-rake
Source https://github.com/tpope/vim-bundler

"============="


" Auto-close parenthesis and quotes
Source https://github.com/Raimondi/delimitMate

" Auto-close functions, loops, ifs, etc
Source https://github.com/tpope/vim-endwise

" Comment code with gc
Source https://github.com/tomtom/tcomment_vim

"============="

" Git wrapper
Source https://github.com/tpope/vim-git
Source https://github.com/tpope/vim-fugitive
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
Source https://github.com/gregsexton/gitv
let g:Gitv_DoNotMapCtrlKey = 1

" Change working directory to root when a project is dectected (triggered when opening a file)
Source https://github.com/airblade/vim-rooter

" Surround ys" cs"<div> dst, or visual mode with S, . to repeat
Source https://github.com/tpope/vim-surround
Source https://github.com/tpope/vim-repeat

" Quickly align text all nice-like, shortcut with <C-a> in visual mode
Source https://github.com/tsaleh/vim-align
vnoremap <C-a> :Align 

" Prepend , to w b e motions to respect camelCase, hyphen and underscore words
Source https://github.com/bkad/CamelCaseMotion

"============="

" YouCompleteMe autocomplete
" Source https://github.com/Valloric/YouCompleteMe git submodule update --init --recursive; ./install.sh

"============="

Source https://github.com/scrooloose/nerdtree

" NERDTree toggles with ,d
map <Leader>d :NERDTreeToggle \| :silent NERDTreeMirror<CR>
map <Leader>dd :NERDTreeFind<CR>
let NERDTreeIgnore=['\.rbc$', '\~$']
let NERDTreeDirArrows=1
let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1

"============="

" Folds
" set foldmethod=indent   "fold based on indent
" set foldnestmax=10      "deepest fold is 10 levels
" au BufWinEnter * let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))


" Filetypes and Syntax
"---------------------

" HTML5
Source https://github.com/othree/html5.vim

" Smarty
Source https://github.com/theprivileges/smarty.vim
au BufNewFile,BufReadPost *.html set ft=smarty

" Jade
Source https://github.com/vim-scripts/jade.vim

" CoffeeScript
Source https://github.com/kchmck/vim-coffee-script
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable | set ft=coffee

" Toffee
Source https://github.com/lchi/vim-toffee
au BufNewFile,BufReadPost *.toffee set ft=toffee

" jQuery
Source https://github.com/vim-scripts/jQuery

" CSS
Source https://github.com/skammer/vim-css-color
Source https://github.com/hail2u/vim-css3-syntax

" LESS
Source https://github.com/groenewege/vim-less
au BufNewFile,BufReadPost *.less set ft=less

" .ssh/config
au Bufread,BufNewFile {ssh-config} set ft=sshconfig

" .ruby-version
au Bufread,BufNewFile {.rvmrc,rvmrc,.ruby-version,ruby-version} set ft=sh

" .gitconfig
au Bufread,BufNewFile {.gitconfig,gitconfig} set ft=gitconfig

" Ruby special files
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Capfile,config.ru} set ft=ruby

" Markdown
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} set wrap | set wrapmargin=2 | set textwidth=72

" Python
au FileType python  set tabstop=4 textwidth=79

" Filetype mappings
nmap _vi :setfiletype vim<CR>
nmap _js :setfiletype javascript<CR>
nmap _rb :setfiletype ruby<CR>
nmap _ph :setfiletype php<CR>
nmap _sh :setfiletype sh<CR>
nmap _co :setfiletype coffee<CR>
nmap _cs :setfiletype css<CR>
nmap _le :setfiletype less<CR>
nmap _sm :setfiletype smarty<CR>
nmap _md :setfiletype markdown<CR>
nmap _hm :setfiletype haml<CR>

" :Man pages in Vim
runtime! ftplugin/man.vim

" Launch vimrc with ,v
nmap <leader>v :EditVimRC<CR>
command! EditVimRC call s:EditVimRC()
function! s:EditVimRC()
  let l:title = expand("%:t")
  if (l:title == '.vimrc')
    :edit ~/.gvimrc
  else
    :edit ~/.vimrc
  endif
endfunction

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
