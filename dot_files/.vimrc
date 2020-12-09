"
"vim-plug
"---

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
Plug 'tpope/vim-fugitive'
Plug 'qpkorr/vim-bufkill'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'sainnhe/edge'
Plug 'jmcantrell/vim-virtualenv'
Plug 'jimmy-sha256/bettertree'
call plug#end()

"---
"plugin settings
"---

colorscheme edge

if (has("termguicolors"))
   set termguicolors
endif

syntax on

"markdown plasticboy settings
autocmd FileType markdown normal zM
autocmd FileType markdown set conceallevel=2
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_folding_disabled = 0

"airline 
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme='edge'

"vim-virtualenv
let g:virtualenv_directory = '.'

nnoremap <Leader>' :VirtualEnvActivate venv<CR>
nnoremap <Leader># :call system('virtualenv --python=/usr/bin/python3.7 venv')<CR>

"fuzzy finder
command! -nargs=1 -bang Locate call fzf#run(fzf#wrap(
      \ {'source': 'locate <q-args>', 'options': '-m'}, <bang>0))


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

set cmdheight=2

set pythondll=/usr/bin/python
set pythonthreedll=/usr/bin/python3
set pythonthreehome=/usr

set nohidden

set tabstop=4
set shiftwidth=4
set expandtab

filetype indent on
set autoindent

set path+=**

"open split to the right
set splitright
set splitbelow

"save prompt
set confirm

"yank to system clipboard
set clipboard=unnamedplus

"disable Welcome message
set shortmess=I

"line numbering
set number relativenumber
 
augroup numbertoggle
 autocmd!
 autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
 autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"search highlight
set ignorecase
set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

"automatically chnge the current directory
set autochdir

"---
"custom key shortcuts
"---

"insert mode remaps
imap ii <Esc> 
imap jj <Down>
imap kk <Up>

"window navigations
nnoremap <Leader>j :wincmd j<CR>    
nnoremap <Leader>k :wincmd k<CR>
nnoremap <Leader>l :wincmd l<CR>
nnoremap <Leader>h :wincmd h<CR>

nmap <Right> :wincmd l<CR>
nmap <Left> :wincmd h<CR>
nmap <Up> :wincmd k<CR>
nmap <Down> :wincmd j<CR>

nmap <c-p> :FZF~<CR>

"list buffers
nnoremap <Leader>, :bp<CR>
nnoremap <Leader>. :bn<CR>

"insert date
nnoremap <Leader>d :put =strftime(\"%d/%m/%y\")<CR> 

"save
nnoremap <Leader>s :w <bar> :mkview<CR>

"markdown preview
nnoremap <Leader>p :MarkdownPreview<CR>

"nerd tree shortcut
nnoremap <Leader>ii :NERDTreeFocus<CR>
nnoremap <Leader>i :NERDTreeToggle <bar> :wincmd =<CR>

"jump list
nnoremap <Leader>] :jumps<CR>

"buffers
noremap <Leader>n :enew<CR>
noremap <Leader>v :vnew<CR>
noremap <Leader>c :Only<CR> 
noremap <Leader>q :qa<CR>

"command
nnoremap <Leader>/ :

"auto-complete
inoremap hh <C-p>

"terminal
nnoremap <Leader>t :term ++curwin ++close<CR>

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
