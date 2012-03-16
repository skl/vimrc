" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.

" Disable the splash screen
:set shortmess +=I

" Enable pathogen bundles
" See http://www.vim.org/scripts/script.php?script_id=2332
" Put github plugins under .vim/bundle/ -- which allows keeping them updated
" without having to do separate installation.
" Call "filetype off" first to ensure that bundle ftplugins can be added to the
" path before we re-enable it later in the vimrc.
:filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

:set hidden

:set nocompatible
:set ai                           " set auto-indenting on for programming

:set showcmd                      " display incomplete commnds
:set list                         " show invisibles
:set number                       " show line numbers
:set ruler                        " show the current row and column
:set hlsearch

" set tabwidth to 4 and use spaces
:set tabstop=4
:set shiftwidth=4
:set softtabstop=4
:set expandtab
:set textwidth=80
:set encoding=utf-8

:set visualbell t_vb=             " turn off error beep/flash
:set novisualbell                 " turn off visual bell

" Make backspace behave in a sane manner.
:set backspace=indent,eol,start

call pathogen#infect()

" Switch syntax highlighting on
syntax on

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

:set mouse=a
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
:set listchars=tab:▸\ ,eol:¬

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " Enable file type detection
  filetype on

  " Syntax of these languages is fussy over tabs Vs spaces
  autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Customisations based on house-style (arbitrary)
  "autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
  "autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
  "autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab

  " Treat .rss files as XML
  autocmd BufNewFile,BufRead *.rss,*.atom setfiletype xml
endif

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>

autocmd BufWritePre *.py,*.js,*.php,*.html,*.htm :call <SID>StripTrailingWhitespaces()

" Run PHP linter on write
augroup php
  au BufNewFile,BufRead *.inc,*.php,*.html,*.ihtml,*.php3 set efm=%E,%C%m\ in\ %f\ on\ line\ %l,%CErrors\ parsing\ %f,%C,%Z
  au BufNewFile,BufRead *.inc,*.php,*.html,*.ihtml,*.php3 set makeprg=php\ -ddisplay_errors=on\ -l\ %
  au BufWritePost *.inc,*.php,*.html,*.ihtml,*.php3 :make
augroup END

" PHP Manual
autocmd FileType php set keywordprg=/usr/local/zend/bin/pman

autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

color blackboard
