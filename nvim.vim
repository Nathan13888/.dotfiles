""" Vim-Plug
call plug#begin()

" Aesthetics
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
"Plug 'yuttie/hydrangea-vim'

" Functionalities
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'chrisbra/Colorizer'
Plug 'vim-scripts/loremipsum'
"Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" Plug 'metakirby5/codi.vim'
Plug 'dkarter/bullets.vim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-syntastic/syntastic'
"Plug 'ycm-core/YouCompleteMe'
Plug 'wakatime/vim-wakatime'

call plug#end()

""" Plugin Configurations

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" NERDTree
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '↠'
let g:NERDTreeDirArrowCollapsible = '↡'
noremap <silent> <C-n> :NERDTreeToggle<CR>

" Airline
let g:airline_powerline_fonts = 1
let g:airline_section_z = ' %{strftime("%-I:%M %p")}'
let g:airline_section_warning = ''
"let g:airline#extensions#tabline#enabled = 1

" Neovim : Terminal
tmap <Esc> <C-\><C-n>
tmap <C-w> <Esc><C-w>
"tmap <C-d> <Esc>:q<CR>
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

" Goyo
let g:goyo_width = "75%"
let g:goyo_height = "95%"
let g:goyo_linenr = 0

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Bullets.vim
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]

" Ultisnips
let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<C-x>"

" indentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

" TagBar
let g:tagbar_width = 30
let g:tagbar_iconchars = ['↠', '↡']
nmap <F8> :TagbarToggle<CR>

" fzf-vim
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'Type'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Character'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

""" Filetype-Specific Configurations

" Markdown and Journal
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType journal setlocal shiftwidth=2 tabstop=2 softtabstop=2

function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

""" Custom Mappings

let mapleader=","
nmap <leader>r :so ~/.config/nvim/init.vim<CR>

" Behave like Windows
source $VIMRUNTIME/mswin.vim
behave mswin
" CP
nmap <leader>Y ggVG"+y''
nmap <leader>y V"+y''
nnoremap gb :w<CR>:!printf "\033c" && printf "================\n  Compiling...\n================\n" && time g++ -g -std=c++17 -Wall -Wextra -Wno-unused-result -D LOCAL -O2 %:r.cpp -o %:r 2>&1 \| tee %:r.cerr && printf "\n================\n   Running...\n================\n" && time ./%:r < %:r.in > %:r.out 2> %:r.err && printf "\n\n\n\n"<CR>
autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -std=c++11 -Wshadow -Wall -O2 -Wno-unused-result -o '.shellescape('%:r').' && /usr/bin/time '.shellescape('%:p:r')<CR>

""" Key Mappings

" Cut, Copy & Paste
"noremap <Leader>d "*d
"noremap <Leader>p "*p
"noremap <Leader>Y "+y
"noremap <Leader>D "+d
"noremap <Leader>Y "+y
"noremap <Leader>P "+p
" Swapping Lines
noremap <silent> <C-k> :call <SID>swap_up()<CR>
noremap <silent> <C-j> :call <SID>swap_down()<CR>
noremap <silent> <C-up> :call <SID>swap_up()<CR>
noremap <silent> <C-down> :call <SID>swap_down()<CR>
" Clearing Search
nnoremap <silent> <space> :nohlsearch<CR>
" Tab Navigation
noremap <silent> <C-S-Tab> <esc>:tabprevious<CR>
noremap <silent> <C-Tab> <esc>:tabnext<CR>
noremap <silent> <C-t> <esc>:tabnew<CR>
noremap <silent> <C-w> <esc>:tabclose<CR>
noremap <silent> <A-1> 1gt
noremap <silent> <A-2> 2gt
noremap <silent> <A-3> 3gt
noremap <silent> <A-4> 4gt
noremap <silent> <A-5> 5gt
noremap <silent> <A-6> 6gt
noremap <silent> <A-7> 7gt
noremap <silent> <A-8> 8gt
noremap <silent> <A-9> 9gt
noremap <silent> <A-0> 10gt

""" Styling
syntax on
colorscheme dracula
highlight Pmenu guibg=white guifg=black gui=bold
highlight Comment gui=bold
highlight Normal gui=none
highlight NonText guibg=none
set termguicolors

""" Other Configurations
set autochdir
filetype plugin indent on
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set ruler laststatus=2 showcmd showmode
set list listchars=trail:»,tab:»-
set fillchars+=vert:\ 
set wrap breakindent
set encoding=utf-8
set number
set title
set mouse=a

