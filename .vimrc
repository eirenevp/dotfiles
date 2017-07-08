"Vundle (Plugins) {{{
"---------------------------------------------------------------------------------
set nocompatible
filetype off
" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" To install a plugin from a github repo add a line like:
"   Plugin 'tpope/vim-fugitive'
" and don't forget to restart vim and run `:PluginInstall`

Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-unimpaired'
Plugin 'tomtom/tcomment_vim'
Plugin 'b4winckler/vim-angry'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'leafgarland/typescript-vim'
Plugin 'chiskempson/base16-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-syntastic/syntastic'
Plugin 'DrTom/fsharp-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'derekwyatt/vim-scala'
Plugin 'valloric/youcompleteme'

" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on
" }}}
"General {{{
"---------------------------------------------------------------------------------
set backspace=indent,eol,start

syntax on
set number relativenumber
set ruler

set scrolloff=3
set scroll=15

set ttimeoutlen=50 " Make Esc work faster

" Indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

let base16colorspace=256

" Encoding
if exists("+encoding")
  set encoding=utf-8
endif

" Folding
set foldmethod=marker

let &t_Co=256
"" Interface
if has("gui_running")
  " Scrollbars and toolbars are so 2012. Remove them!
  set guioptions -=T
  set guioptions -=L
  set guioptions -=r

  " Set color scheme and font
  color Tomorrow-Night

  set guifont=Inconsolata-g\ Greek\ for\ PL:h13

  " Maximize (lolmac)
  set lines=55
else
  if &term == "xterm-256color"
    let &t_Co=256
  else
    let &t_Co=16
  endif

  colorscheme base16-default-dark
  set background=dark

  " Enable the mouse
  set mouse=a
endif

" Highlight the screen line of the cursor
set cursorline
" Always show a status line
set laststatus=2
" Always report the number of lines changed
set report=0
"Show partial command in the bottom-right corner
set showcmd

set noshowmode

" Don't jump to the start of line with CTRL+U / CTRL+D
set nostartofline

" Insert mode completion options
set completeopt=menu,longest,preview
" Zsh-like command line completion
set wildmenu
" Don't wrap text by default
set nowrap

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

set directory=/tmp

" set list listchars=trail:·

" Terminal-consistent shortcut keys for command line
cnoremap <C-A> <Home>
cnoremap <C-K> <C-\>estrpart(getcmdline(), 0, getcmdpos() - 1)<CR>
cnoremap <C-O> <CR>

" Window navigation
set winminheight=0
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-Q> <C-W>p

set previewheight=3
" Fix motions for wrapped lines
nnoremap j gj
nnoremap k gk

" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
  let col = col('.') - 1
  if pumvisible()
    return "\<c-e>\<c-n>"
  elseif !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-n>"
  endif
endfunction
inoremap <Tab> <C-R>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-P>
" Search for visually selected text, forwards or backwards (from
" http://vim.wikia.com/wiki/Search_for_visually_selected_text)
vnoremap <silent> * :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy/<C-R><C-R>=substitute(
      \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy?<C-R><C-R>=substitute(
      \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gV:call setreg('"', old_reg, old_regtype)<CR>

" }}}
" File Types / Autocommands {{{
"---------------------------------------------------------------------------------

autocmd Filetype gitcommit set expandtab textwidth=68 spell
autocmd Filetype ruby      set expandtab textwidth=80 tabstop=2 softtabstop=2 shiftwidth=2 formatoptions+=c path=.,,
autocmd FileType vim       set expandtab shiftwidth=2 softtabstop=2 keywordprg=:help
autocmd FileType c         set softtabstop=2 tabstop=2 shiftwidth=2 makeprg=gcc\ -O3
autocmd FileType cpp       set makeprg=g++\ -03 softtabstop=2 tabstop=2 shiftwidth=2

autocmd FileType help      wincmd K

" Don't highlight the cursor line on the quickfix window
autocmd BufReadPost quickfix setlocal nocursorline

" Maximize the window after entering it, be sure to keep the quickfix window
" at the specified height.
" From http://vim.wikia.com/wiki/Always_keep_quickfix_window_at_specified_height
au WinEnter * call MaximizeAndResizeQuickfix(10)

" Maximize current window and set the quickfix window to the specified height.
function MaximizeAndResizeQuickfix(quickfixHeight)
  " Redraw after executing the function.
  set lazyredraw
  " Ignore WinEnter events for now.
  set ei=WinEnter
  " Maximize current window.
  wincmd _
  " If the current window is the quickfix window
  if (getbufvar(winbufnr(winnr()), "&buftype") == "quickfix")
    " Maximize previous window, and resize the quickfix window to the
    " specified height.
    wincmd p
    resize
    wincmd p
    exe "resize " . a:quickfixHeight
  else
    " Current window isn't the quickfix window, loop over all windows to
    " find it (if it exists...)
    let i = 1
    let currBufNr = winbufnr(i)
    while (currBufNr != -1)
      " If the buffer in window i is the quickfix buffer.
      if (getbufvar(currBufNr, "&buftype") == "quickfix")
        " Go to the quickfix window, set height to quickfixHeight, and jump to
        " the previous window.
        exe i . "wincmd w"
        exe "resize " . a:quickfixHeight
        wincmd p
        break
      endif
      let i = i + 1
      let currBufNr = winbufnr(i)
    endwhile
  endif
  let i = 1
  let currBufNr = winbufnr(i)
  while (currBufNr != -1)
    " If the buffer in window i is the quickfix buffer.
    if (getbufvar(currBufNr, "&buftype") == "nofile")
      " Go to the quickfix window, set height to quickfixHeight, and jump to
      " the previous window.
      exe i . "wincmd w"
      exe "resize 5"
      wincmd p
      break
    endif
    let i = i + 1
    let currBufNr = winbufnr(i)
  endwhile
  set ei-=WinEnter
  set nolazyredraw
endfunction
"}}}

" }}}
" Plugin Configuration {{{
"---------------------------------------------------------------------------------

"CtrlP configuration
let g:ctrlp_max_height = 7
hi! CtrlPMatch ctermfg=9

" Ignore certain filetypes
set wildignore=*.o,*.out,*.class

"Airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_theme='base16'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_symbols.branch = '⭠'
let g:airline_symbols.readonly = '⭤'
let g:airline_symbols.linenr = '⭡'
" }}}
" Leader key mappings {{{
"---------------------------------------------------------------------------------

" Set mapleader (to <space>) for custom commands
let mapleader = ' '

"   n         : Rename current file
"   v         : Open .vimrc
"   h         : Show syntax highlighting group (useful when editing the scheme)
"   H         : Open a vertical window and edit the current colorscheme
"   s         : Remove trailing whitespaces and empty lines from the EOF
"   c         : Save, compile and run (if the compilation was successful)
"   f         : Open CtrlP
"   t         : Open CtrlP for tags
"   o         : Zoom window (alias to ctrl-w o)
"   <space>   : Edit the alternate file
"---------------------------------------------------------------------------------

function! DoWindowSwap()
  "Mark destination
  let curNum = winnr()
  let curBuf = bufnr( "%" )
  exe "1wincmd w"
  "Switch to source and shuffle dest->source
  let markedBuf = bufnr( "%" )
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' curBuf
  "Switch to dest and shuffle source->dest
  exe curNum . "wincmd w"
  "Hide and open so that we aren't prompted and keep history
  exe 'hide buf' markedBuf
  exe "wincmd h"
endfunction

nnoremap <silent> <leader>m :call DoWindowSwap()<CR>

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

map <leader>h :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

map<leader>H :exec "vsplit ~/.vim/colors/" . g:colors_name . ".vim"<cr>

" Clean up file
function! StripWhitespace ()
  " Remove trailing whitespaces
  exec ':%s/[ \t]*$//'
  " Remove empty lines at the EOF
  normal G
  while getline('.') == ''
    normal dd
  endwhile
  normal ``
endfunction
map <leader>s :call StripWhitespace ()<cr>

" Open .vimrc
map <leader>v :e $MYVIMRC<cr>

" Save, compile and run files
function! CompileAndRun()
  write
  silent! make %
  redraw!
  botright cwindow
  if len(getqflist()) == 0
    exec '!time ./a.out'
  endif
endfunction
map <leader>c :call CompileAndRun()<cr>

" CtrlP shortcuts
map <leader>t :CtrlPTag<cr>
map <leader>f :CtrlP<cr>
map <leader>o <c-w>o<cr>

map <leader><leader> <C-^>
" }}}
" Custom command definitions {{{
"---------------------------------------------------------------------------------

command! -bar -nargs=0 SudoW   :setl nomod|silent exe 'write !sudo tee % >/dev/null'|let &mod = v:shell_error
command! -bar -nargs=* -bang W :write<bang> <args>
command! -bar -nargs=* -bang Q :quit<bang> <args>

" Turn off syntax highlighting
command! C nohlsearch
"}}}
" Language maps {{{
"---------------------------------------------------------------------------------

" Make commands work when keyboard sends greek characters
if &encoding == "utf-8"
  set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz,¨:
endif
"}}}

map <space>u :make<cr>
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
