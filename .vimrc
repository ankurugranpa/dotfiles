set hlsearch
set incsearch
set encoding=utf-8
set number

"" bafferの切り替え設定
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>

"" nvimの設定
if !has('nvim')
	set ttymouse=xterm2
endif

call plug#begin('~/.vim/plugged')

"" vim-lsp周りのインストール
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

"" fzf for vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"" ddc.vim本体
"Plug 'Shougo/ddc.vim'
"" DenoでVimプラグインを開発するためのプラグイン
"Plug 'vim-denops/denops.vim'
"" ポップアップウィンドウを表示するプラグイン
"Plug 'Shougo/pum.vim'
"" カーソル周辺の既出単語を補完するsource
"Plug 'Shougo/ddc-around'
"" ファイル名を補完するsource
"Plug 'LumaKernel/ddc-file'
"" 入力中の単語を補完の対象にするfilter
"Plug 'Shougo/ddc-matcher_head'
"" 補完候補を適切にソートするfilter
"Plug 'Shougo/ddc-sorter_rank'
"" 補完候補の重複を防ぐためのfilter
"Plug 'Shougo/ddc-converter_remove_overlap'

""オートコンプリート
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

"" fernのインストール
Plug 'lambdalisue/fern.vim'

"" nerd fonts周りの設定用
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
call plug#end()

"" fern周りの設定
let g:fern#renderer = 'nerdfont'
let g:fern#default_hidden=1
nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=30<CR>
"
"call plug#('Shougo/ddc.vim')
"call plug#('vim-denops/denops.vim')
"call plug#('Shougo/pum.vim')
"call plug#('Shougo/ddc-around')
"call plug#('LumaKernel/ddc-file')
"call plug#('Shougo/ddc-matcher_head')
"call plug#('Shougo/ddc-sorter_rank')
"call plug#('Shougo/ddc-converter_remove_overlap')
"call plug#('prabirshrestha/vim-lsp')
"call plug#('mattn/vim-lsp-settings')
"
"call ddc#custom#patch_global('completionMenu', 'pum.vim')
"call ddc#custom#patch_global('sources', [
" \ 'around',
" \ 'vim-lsp',
" \ 'file'
" \ ])
"call ddc#custom#patch_global('sourceOptions', {
" \ '_': {
" \   'matchers': ['matcher_head'],
" \   'sorters': ['sorter_rank'],
" \   'converters': ['converter_remove_overlap'],
" \ },
" \ 'around': {'mark': 'Around'},
" \ 'vim-lsp': {
" \   'mark': 'LSP',
" \   'matchers': ['matcher_head'],
" \   'forceCompletionPattern': '\.|:|->|"\w+/*'
" \ },
" \ 'file': {
" \   'mark': 'file',
" \   'isVolatile': v:true,
" \   'forceCompletionPattern': '\S/\S*'
" \ }})
"call ddc#enable()
"inoremap <Tab> <Cmd>call pum#map#insert_relative(+1)<CR>
"inoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>

"オートコンプリートの設定
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

"pythonの実行
command! Python call s:Python()
nmap <F5> :Python<CR>

function! s:Python()
        :w
	        :!python3 %
		endfunction
"C言語
command! Gcc call s:Gcc()
nmap <F6> :Gcc<CR>

function! s:Gcc()
	:w
		:!gcc -Wall % -o %.out -lm
		:!./%.out
		endfunction
