" vim-arb — language-server / linter wiring for arb
"
" arb CLI flags used here:
"   --check   static check (parse + check, no run)
"   --lsp     Language Server (JSON-RPC on stdio)
"   --dap     Debug Adapter (DAP on stdio)
"
" LSP / DAP: the wiring below registers `arb --lsp` (Language Server, JSON-RPC
" on stdio) and documents `arb --dap` (Debug Adapter, DAP on stdio). Each MUST
" be invoked with ONLY that flag (no appended `--stdio`), mirroring
" `stryke --lsp`; vim-lsp / nvim-dap clients must NOT add transport args. The
" wiring is guarded so the plugin still loads and lints cleanly if the binary
" is absent.
"
" Opt-outs:
"   let g:vim_arb_no_ale = 1   " skip ALE linter registration
"   let g:vim_arb_no_lsp = 1   " skip vim-lsp server registration

if exists('g:loaded_vim_arb')
  finish
endif
let g:loaded_vim_arb = 1

" ---------------------------------------------------------------------------
" ALE linter
" ---------------------------------------------------------------------------
function! ArbProjectRoot(buffer) abort
  let l:git = ale#path#FindNearestDirectory(a:buffer, '.git')
  return !empty(l:git) ? fnamemodify(l:git, ':h:h') : expand('#' . a:buffer . ':p:h')
endfunction

function! ArbHandler(buffer, lines) abort
  let l:output = []
  for l:line in a:lines
    " arb-style: "arb: <file>:<line>: <message>" or "<file>:<line>: <message>"
    let l:match = matchlist(l:line, '\v^%(arb:\s*)?.{-}:(\d+):\s*(.+)$')
    if !empty(l:match)
      call add(l:output, {'lnum': l:match[1] + 0, 'text': l:match[2], 'type': 'E'})
      continue
    endif
    " fallback: "<message> at <file> line <n>"
    let l:match = matchlist(l:line, '\v^(.+) at .+ line (\d+)')
    if !empty(l:match)
      call add(l:output, {'lnum': l:match[2] + 0, 'text': l:match[1], 'type': 'E'})
    endif
  endfor
  return l:output
endfunction

function! s:RegisterArbALE() abort
  if get(g:, 'vim_arb_no_ale', 0)
    return
  endif
  if exists('*ale#linter#Define')
    call ale#linter#Define('arb', {
    \   'name': 'arb',
    \   'executable': 'arb',
    \   'command': 'arb --check %t 2>&1',
    \   'callback': 'ArbHandler',
    \   'project_root': function('ArbProjectRoot'),
    \})
    let g:ale_linters = get(g:, 'ale_linters', {})
    let g:ale_linters.arb = ['arb']
  endif
endfunction

augroup vim_arb_ale
  autocmd!
  autocmd VimEnter * call s:RegisterArbALE()
augroup END

" ---------------------------------------------------------------------------
" vim-lsp
" ---------------------------------------------------------------------------
if !get(g:, 'vim_arb_no_lsp', 0) && exists('*lsp#register_server')
  call lsp#register_server({
  \   'name': 'arb',
  \   'cmd': ['arb', '--lsp'],
  \   'allowlist': ['arb'],
  \})
endif

" ---------------------------------------------------------------------------
" coc.nvim — add to coc-settings.json:
"   {
"     "languageserver": {
"       "arb": {
"         "command": "arb",
"         "args": ["--lsp"],
"         "filetypes": ["arb"]
"       }
"     }
"   }
" ---------------------------------------------------------------------------

" ---------------------------------------------------------------------------
" nvim-dap — add to your Neovim config (debug adapter via `arb --dap`):
"   local dap = require('dap')
"   dap.adapters.arb = {
"     type = 'executable',
"     command = 'arb',
"     args = { '--dap' },   -- no extra transport args; arb rejects them
"   }
"   dap.configurations.arb = {
"     { type = 'arb', request = 'launch', name = 'Run arb spec',
"       program = '${file}' },
"   }
" ---------------------------------------------------------------------------
