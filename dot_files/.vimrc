""required for vim-plug 
set nocompatible
filetype plugin on

"check for vim-plug if missing install 
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
   \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"plugins
call plug#begin('~/.vim/plugged')
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
"Plug 'tpope/vim-fugitive'
"Plug 'qpkorr/vim-bufkill'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'sainnhe/edge'
Plug 'jmcantrell/vim-virtualenv'
"Plug 'jimmy-sha256/bettertree'
call plug#end()

"----------------------------------------------------------------------------------------------------
"plugin settings
"----------------------------------------------------------------------------------------------------

"---
"vim-airline colour theme
"---

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline_theme='edge'

colorscheme edge

if (has("termguicolors"))
   set termguicolors
endif

syntax on


"---
"markdown plasticboy settings
"---

autocmd FileType markdown normal zM
autocmd FileType markdown set conceallevel=2
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_folding_disabled = 0


"---
"vim-virtualenv
"---

let g:virtualenv_directory = '.'

"function to change dir if furrent dir not contain venv/
function! VenvCD()
    let g:virtualenv_directory = getcwd()
endfunction

"map venv keys
nnoremap <Leader>' :VirtualEnvActivate venv<CR>
nnoremap <Leader># :call system('virtualenv --python=/usr/bin/python3.10 venv')<CR>


function! PipInstall()
    let prompt=input('pip3 install ') 
    let var=join(['pip3 install', prompt], ' ')
    call system(var)
    echo ' '
    let var=join([prompt, 'added to list'], ' ')
    echo var
endfunction


"---
"fuzzy finder
"---

" https://github.com/junegunn/fzf.vim
command! -nargs=1 -bang Locate call fzf#run(fzf#wrap(
      \ {'source': 'locate <q-args>', 'options': '-m'}, <bang>0))


" Ctrl p
nmap <c-p> :FZF~<CR>  

function! s:copy_results(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  let @+ = joined_lines
endfunction


function! s:open_search(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  exec "e ".joined_lines
endfunction
            

function! s:vertical_search(lines)
  let joined_lines = join(a:lines, "\n")
  if len(a:lines) > 1
    let joined_lines .= "\n"
  endif
  vsplit
  exec "e ".joined_lines
endfunction


let g:fzf_action = {
  \ 'ctrl-y': function('s:copy_results'),
  \ 'ctrl-v': function('s:vertical_search'),
  \ 'ctrl-m': function('s:open_search'),
  \ }


"---
"general settings
"---
set noshowmode
set encoding=utf-8
set cursorline
set cursorcolumn
set cmdheight=2
set pythondll=/usr/bin/python
set pythonthreedll=/usr/bin/python3
set pythonthreehome=/usr
set nohidden
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set path+=**
set noswapfile "set no .swp file
set splitright "open split to the right
set splitbelow "open split to the below
set confirm "save prompt
set autochdir "automatically chnge the current directory
set clipboard=unnamedplus "yank to system clipboard
set shortmess=I "disable Welcome message
set number relativenumber "line numbering
 

"search highlight
set ignorecase
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>


"---
"custom key shortcuts
"---

let mapleader = "\<Space>"

"insert mode remaps
imap ii <Esc>

noremap <Leader>f :Files<CR>

"insert date
nnoremap <Leader>d :put =strftime(\"%d/%m/%y\")<CR> 

"markdown preview
nnoremap <Leader>p :MarkdownPreview<CR>

"jump list
nnoremap <Leader>] :jumps<CR>

"buffers
noremap <Leader>n :split -o<CR>
noremap <Leader>v :vnew<CR>

"auto-complete
inoremap hh <C-p>

"terminal
nnoremap <Leader>t :term ++curwin<CR>
"nnoremap <Leader>t :term ++curwin ++close<CR>

"---
"Switch back to NORMAL mode after 15 secs
"---

augroup numbertoggle
 autocmd!
 autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
 autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

function! CursorModeOn()
    set cursorline
    set cursorcolumn
endfunction


function! CursorModeOff()
    set nocursorline
    set nocursorcolumn
endfunction


augroup cursor_show
au CursorMovedI,InsertEnter,BufLeave,WinLeave  * call CursorModeOff() 

au InsertLeave,InsertLeave,BufEnter,WinEnter  * call CursorModeOn()
augroup END

" Exit insert mode after 30 secs with no cursor movement
let g:inactivity_limit = 10  " max Insert mode inactivity before fail, in seconds
let g:check_frequency = 1    " seconds between checks

augroup monitor
    au!
    " when vim starts kick off the infinitely repeating calls to the monitor function
    au VimEnter * call timer_start(g:check_frequency * 1000, 'MonitorActivity', {'repeat' : -1})
    " when cursor moves in Insert mode update the last activity time
    au CursorMovedI * let g:last_activity = reltime()
augroup END

func! MonitorActivity(timer_id)
    " when we start we'll initialize the last activity time then return
    " ...gives a little grace period at beginning
    if ! exists('g:last_activity') || empty(g:last_activity)
        let g:last_activity = reltime()
        return
    endif


    " very handy function for our purposes, reltime
    let l:diff = reltime(g:last_activity)[0]

    if l:diff > g:inactivity_limit
        stopinsert
        let g:last_activity = []
        call CursorModeOn()
    endif
endfunc


"toggle run python script
let s:py_buf_nr = -1
function! s:RunPy() abort
    if s:py_buf_nr == -1
        execute "bo ter ++rows=10 python3 %"
        wincmd p
        let s:py_buf_nr = bufnr("$")
    else
        try
            execute "bdelete! " . s:py_buf_nr
        catch
            let s:py_buf_nr = -1
            call <SID>RunPy()
            return
        endtry
        let s:py_buf_nr = -1
    endif
endfunction

nnoremap <silent> <Leader>; :call <SID>RunPy()<CR>
tnoremap <silent> <Leader>; <C-w>N:call <SID>RunPy()<CR>

"close unused windows
function! OrganiseWindows()
    let currentWindowID = win_getid()
    windo if win_getid() != currentWindowID && &filetype != 'netrw' | close | endif
endfunction

function! CountWindow()        
    BD
    let window_counter = 0
    let buff_counter = 0
    let buff_counter = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    windo let window_counter = window_counter + 1
    if (window_counter > buff_counter)
        call OrganiseWindows()
    endif

endfunction

function! SilentWindow()
    exec 'silent! call CountWindow()'
endfunction

command! Only call SilentWindow()

function SearchReplace()
    let search_pattern=input('Enter string to be replaced: ')
    let replace_pattern=input('Enter new string : ')
    exec '%s/'.search_pattern.'/'.replace_pattern.'/gc'
endfunction



