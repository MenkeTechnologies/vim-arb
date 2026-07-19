" vim-arb — filetype-local settings for arb buffers

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" arb comments run '#' to end of line.
setlocal commentstring=#\ %s
setlocal comments=:#

" Continue the comment leader on <Enter> / o / O, recognize numbered lists.
setlocal formatoptions-=t
setlocal formatoptions+=croql

" Static-check the current arb spec through arb. `:make` uses the arb compiler
" (compiler/arb.vim); :ArbRun runs the buffer through arb directly. Guard the
" :compiler call so the file still sources cleanly when the plugin dir is not
" yet on runtimepath (e.g. an isolated `:source` lint).
if !empty(globpath(&runtimepath, 'compiler/arb.vim'))
  compiler arb
else
  setlocal makeprg=arb\ --check\ %
  setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m,%m\ at\ %f\ line\ %l
endif

" arb takes the spec as a positional argument and reads the stream from stdin,
" so :ArbRun runs `arb %` (pipe data in when you want a live dashboard).
if !exists(':ArbRun')
  command! -buffer -nargs=* -complete=file ArbRun
        \ echo system('arb ' . shellescape(expand('%:p')) . ' ' . <q-args>)
endif

" <LocalLeader>r runs the current file via `arb %`.
if !get(g:, 'vim_arb_no_maps', 0)
  nnoremap <buffer> <silent> <LocalLeader>r :ArbRun<CR>
endif

" Restore on filetype change.
let b:undo_ftplugin = 'setlocal commentstring< comments< formatoptions<'
      \ . '| silent! nunmap <buffer> <LocalLeader>r'
      \ . '| silent! delcommand ArbRun'
