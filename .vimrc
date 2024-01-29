set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
set spellfile=~/.vim/spell/en.utf-8.add
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
"Plugin 'Valloric/YouCompleteMe'
Plugin 'tpope/vim-fugitive'
Plugin 'MattesGroeger/vim-bookmarks'
Plugin 'majutsushi/tagbar'
Plugin 'ruedigerha/vim-fullscreen'
Plugin 'NLKNguyen/papercolor-theme'
call vundle#end()
filetype plugin indent on    " required

let g:airline_powerline_fonts=1
let g:Powerline_symbols='fancy'

"set statusline+=%#warningmsg#
"set statusline+=%*

let g:ycm_global_ycm_extra_conf = '/home/tim/.ycm_extra_conf.py'
let g:ycm_always_populate_location_list = 1
let g:airline#extensions#branch#enabled = 1
let gitgutter_max_signs=10000

syntax on
set noshowmatch
"call NoMatchParen()
set number
set hlsearch
set autochdir
set smartcase
set cindent
set shiftwidth=3
set tabstop=3
set expandtab
set ruler
filetype plugin on
filetype indent on
set list
set listchars=tab:>.
set incsearch
set scroll=1
set nocompatible
set wildmode=longest,list,full
set wildmenu
set laststatus=2
set visualbell

" ctags
set tags=tags;

augroup Binary
  au!
  au BufReadPre   *.bin,*.a,*.o,*.exe,*.elf let &bin=1
  au BufReadPost  *.bin,*.a,*.o,*.exe,*.elf if &bin | %!xxd
  au BufReadPost  *.bin,*.a,*.o,*.exe,*.elf set ft=xxd | endif
  au BufWritePre  *.bin,*.a,*.o,*.exe,*.elf if &bin | %!xxd -r
  au BufWritePre  *.bin,*.a,*.o,*.exe,*.elf endif
  au BufWritePost *.bin,*.a,*.o,*.exe,*.elf if &bin | %!xxd
  au BufWritePost *.bin,*.a,*.o,*.exe,*.elf set nomod | endif
augroup END

function! HighlightWhiteSpace()
    hi ExtraWhitespace ctermbg=DarkGreen guibg=darkgreen
    hi SpellBad cterm=underline ctermfg=red ctermbg=black
    match ExtraWhitespace /\s\+$/
endfunction

function! GNUMode()
   set shiftwidth=2
   set tabstop=2
   set expandtab
   set list
endfunction


function! KernelMode()
   set shiftwidth=8
   set tabstop=8
   set noexpandtab
endfunction

function! Brightscript()
   set syntax=brs
   set shiftwidth=4
   set tabstop=4
   set expandtab
 endfunction

function! GitCommitMode()
   set shiftwidth=4
   set tabstop=4
   set expandtab
   set foldmethod=manual
   set list
   set colorcolumn=80
   set nospell
endfunction

function! CModeVC()
   set shiftwidth=3
   set tabstop=3
   set expandtab
   set list
   set foldmethod=syntax
endfunction

function! CMode()
   set shiftwidth=4
   set tabstop=4
   set expandtab
   set foldmethod=syntax
   set list
endfunction

function! YMLMode()
   set shiftwidth=2
   set tabstop=2
   set expandtab
   set foldmethod=manual
   set list
endfunction


function! Build()
    make
    cope
endfunction

function! TracepointMode()
   set syntax=c
   set shiftwidth=4
   set tabstop=4
   set expandtab
   set foldmethod=manual
   set list
endfunction

function! PythonMode()
   set shiftwidth=4
   set tabstop=4
   set expandtab
   set foldmethod=manual
   set list
endfunction

function! MakefileMode()
   set shiftwidth=4
   set tabstop=4
   set noexpandtab
   set foldmethod=manual
   set list
endfunction

" Simple re-format for minified Javascript
command! UnMinify call UnMinify()
function! UnMinify()
    %s/{\ze[^\r\n]/{\r/g
    %s/){/) {/g
    %s/};\?\ze[^\r\n]/\0\r/g
    %s/;\ze[^\r\n]/;\r/g
    %s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
    normal ggVG=
endfunction

function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()

"set colorcolumn=80
set background=dark
if has("gui_running")
    set guioptions=
    "colorscheme molokai
    colorscheme PaperColor
    set spell
    "set guifont=Liberation\ Mono\ for\ Powerline\ 11
endif

nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>
nmap <F2> :set foldmethod=syntax<CR>
nmap <F3> :set foldmethod=manual<CR>
nmap <F4> :TagbarToggle<CR>
nmap <F5> :call Build()<CR>
nmap <F7> :cn<CR>
nmap <F8> :cp<CR>
nmap <F9> :GitGutterNextHunk<CR>:GitGutterPreviewHunk<CR>
nmap <F10> :GitGutterPrevHunk<CR>:GitGutterPreviewHunk<CR>
nmap <F11> :call VullScreen()<CR>
map <F12> :%s/ *$//g<CR>
map <C-h> :noh<CR>

augroup ModeGroup
    autocmd!
    au BufRead,BufNewFile */.git/*      call GitCommitMode()
    au BufRead,BufNewFile *.tp          call TracepointMode()
    au BufRead,BufNewFile *.lbk         call LogBookMode()
    au BufRead,BufNewFile *.c           call CMode()
    au BufRead,BufNewFile *.h           call CMode()
    au BufRead,BufNewFile *.cc          call CMode()
    au BufRead,BufNewFile *.cpp         call CMode()
    au BufRead,BufNewFile *.brs         call Brightscript()
    au BufRead,BufNewFile *.py          call PythonMode()
    au BufRead,BufNewFile *.mk          call MakefileMode()
    au BufRead,BufNewFile *.bb          call MakefileMode()
    au BufRead,BufNewFile *.yml         call YMLMode()
    au BufRead,BufNewFile Makefile      call MakefileMode()
    au BufRead,BufNewFile */vc4*        call CModeVC()
    au BufRead,BufNewFile */helium*     call CModeVC()
    au BufRead,BufNewFile */nuboot/*     call CModeVC()
    au BufRead,BufNewFile */linux-*/*   call KernelMode()
    au WinEnter,TabEnter *              call HighlightWhiteSpace()
augroup END
filetype indent plugin on

map <C-i> <C-a>

let g:bookmark_sign = '♥'
let g:bookmark_highlight_lines = 1
nmap <Leader><Leader> <Plug>BookmarkToggle
nmap <Leader>i <Plug>BookmarkAnnotate
nmap <Leader>a <Plug>BookmarkShowAll
nmap <Leader>j <Plug>BookmarkNext
nmap <Leader>k <Plug>BookmarkPrev
nmap <Leader>c <Plug>BookmarkClear
nmap <Leader>x <Plug>BookmarkClearAll
nmap <Leader>kk <Plug>BookmarkMoveUp
nmap <Leader>jj <Plug>BookmarkMoveDown
nmap <Leader>g <Plug>BookmarkMoveToLine
nmap <Leader>t :tabs<CR>

"let $PATH .= '/home/tim/metaware/MetaWare/VideoCore/linux.x86'
:set nofixendofline
:set foldlevel=20
