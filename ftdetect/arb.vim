" vim-arb — filetype detection for arb source
" Loaded automatically by pathogen / vim-plug / native packages via ftdetect/.

" By extension: every *.arb file is arb.
autocmd BufNewFile,BufRead *.arb setfiletype arb

" By shebang: files run as `#!/usr/bin/env arb` (or a direct arb path) with no
" .arb extension still light up.
autocmd BufNewFile,BufRead * call s:DetectArbShebang()

function! s:DetectArbShebang() abort
  if did_filetype() || &filetype ==# 'arb'
    return
  endif
  let l:first = getline(1)
  if l:first =~# '^#!.*\<arb\>'
    setfiletype arb
  endif
endfunction
