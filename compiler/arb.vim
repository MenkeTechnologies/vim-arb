" vim-arb — :compiler arb
"
" Wires `:make` to static-check the current arb spec through the arb binary,
" so parse / check diagnostics land in the quickfix list. Flag verified against
" `arb --help`:
"   --check   parse + static-check the spec without running it

if exists('current_compiler')
  finish
endif
let current_compiler = 'arb'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" `arb --check %` parses + checks the spec without consuming input.
CompilerSet makeprg=arb\ --check\ %

" arb-style diagnostics: "arb: file:line: message" and "message at file line n".
CompilerSet errorformat=%f:%l:%c:\ %m
CompilerSet errorformat+=%f:%l:\ %m
CompilerSet errorformat+=%m\ at\ %f\ line\ %l
CompilerSet errorformat+=arb:\ %f:%l:\ %m
CompilerSet errorformat+=arb:\ %m
