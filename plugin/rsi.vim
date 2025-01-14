" rsi.vim - Readline style insertion
" Maintainer:   Tim Pope
" Version:      1.0
" GetLatestVimScripts: 4359 1 :AutoInstall: rsi.vim

if exists("g:loaded_rsi") || v:version < 700 || &cp
  finish
endif
let g:loaded_rsi = 1

set ttimeout
if &ttimeoutlen == -1
  set ttimeoutlen=50
endif

if !get(g:, 'rsi_disable_in_insert_mode')
  inoremap        <C-A> <C-O>^
  inoremap   <C-X><C-A> <C-A>

  inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"

  inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"

  inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"

  inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
endif

if !get(g:, 'rsi_disable_in_cmdline_mode')
  cnoremap        <C-A> <Home>
  cnoremap   <C-X><C-A> <C-A>

  cnoremap        <C-B> <Left>

  cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"

  cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

  function! s:transpose() abort
    let pos = getcmdpos()
    if getcmdtype() =~# '[?/]'
      return "\<C-T>"
    elseif pos > strlen(getcmdline())
      let pre = "\<Left>"
      let pos -= 1
    elseif pos <= 1
      let pre = "\<Right>"
      let pos += 1
    else
      let pre = ""
    endif
    return pre . "\<BS>\<Right>".matchstr(getcmdline()[0 : pos-2], '.$')
  endfunction

  cnoremap <expr> <C-T> <SID>transpose()

  function! s:ctrl_u()
    if getcmdpos() > 1
      let @- = getcmdline()[:getcmdpos()-2]
    endif
    return "\<C-U>"
  endfunction

  cnoremap <expr> <C-U> <SID>ctrl_u()
  cnoremap        <C-Y> <C-R>-
endif

if exists('g:rsi_no_meta')
  finish
endif

if &encoding ==# 'latin1' && has('gui_running') && !empty(findfile('plugin/sensible.vim', escape(&rtp, ' ')))
  set encoding=utf-8
endif

if !get(g:, 'rsi_disable_in_insert_mode')
  inoremap        <M-b> <S-Left>
  inoremap        <M-d> <C-O>dw
  inoremap        <M-f> <S-Right>
  inoremap        <M-n> <Down>
  inoremap        <M-p> <Up>
  inoremap        <M-BS> <C-W>
  inoremap        <M-C-h> <C-W>
endif

if !get(g:, 'rsi_disable_in_cmdline_mode')
  cnoremap        <M-b> <S-Left>
  cnoremap        <M-d> <S-Right><C-W>
  cnoremap        <M-f> <S-Right>
  cnoremap        <M-n> <Down>
  cnoremap        <M-p> <Up>
  cnoremap        <M-BS> <C-W>
  cnoremap        <M-C-h> <C-W>
endif

if !has("gui_running") && !has('nvim')
  silent! exe "set <M-b>=\eb"
  silent! exe "set <M-d>=\ed"
  silent! exe "set <M-f>=\ef"
  silent! exe "set <M-n>=\en"
  silent! exe "set <M-p>=\ep"
  silent! exe "set <M-Char-127>=\e\<C-?>"
  silent! exe "set <M-C-h>=\e\<C-H>"
endif

" vim:set et sw=2:
