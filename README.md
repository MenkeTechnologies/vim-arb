```
__     _____ __  __         _    ____  ____  
\ \   / /_ _|  \/  |       / \  |  _ \| __ ) 
 \ \ / / | || |\/| |_____ / _ \ | |_) |  _ \ 
  \ V /  | || |  | |_____/ ___ \|  _ <| |_) |
   \_/  |___|_|  |_|    /_/   \_\_| \_\____/ 
```

[![CI](https://github.com/MenkeTechnologies/vim-arb/actions/workflows/ci.yml/badge.svg)](https://github.com/MenkeTechnologies/vim-arb/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-online-05d9e8.svg)](https://menketechnologies.github.io/vim-arb/)
[![Syntax](https://img.shields.io/badge/syntax-standalone%20arb-ff2a6d.svg)](https://menketechnologies.github.io/vim-arb/)
[![LSP](https://img.shields.io/badge/LSP%20%2F%20DAP-arb-39ff14.svg)](https://github.com/MenkeTechnologies/vim-arb)
[![License: MIT](https://img.shields.io/badge/License-MIT-d300c5.svg)](https://opensource.org/licenses/MIT)

### `[VIM PLUGIN // NEON SYNTAX // STANDALONE ARB GRAMMAR // ALE + LSP + DAP]`

> *"Load it with pathogen. Open a `.arb`. It lights up."*

Vim / Neovim support for **arb** — the pipe-native language that turns a Unix pipeline into a dynamic TUI or served web dashboard from a declarative, Tcl/Tk-flavored spec, on the `fusevm` bytecode VM + Cranelift JIT. Standalone syntax highlighting, filetype detection, brace-aware indentation, `:make` / `:ArbRun` wiring, ALE checking, and vim-lsp / coc.nvim / nvim-dap integration. Zero configuration.

```bash
cd ~/.vim/bundle && git clone https://github.com/MenkeTechnologies/vim-arb   # pathogen
```

### [`Read the Docs`](https://menketechnologies.github.io/vim-arb/) &middot; [`Engineering Report`](https://menketechnologies.github.io/vim-arb/report.html)

---

## [0x00] OVERVIEW

**vim-arb** is Vim / Neovim support for **arb** — a jq/xpath/css/yq superset that shapes a live pipeline into an interface. It ships as a standard Vim runtime tree, so **pathogen / vim-plug / native packages** add it to `runtimepath` with zero special handling and zero configuration.

The syntax file is a **standalone arb grammar** covering the language's declarative surface. arb's vocabulary is small and fixed, so the keyword / verb lists are hand-curated rather than generated; `scripts/gen_syntax.sh` stamps the file with the arb version it was verified against.

- **inputs** — `in` `in.json` `in.csv` `in.tsv` `in.xml` `in.html` `in.yaml` `in.yml` `in.toml` `in.logfmt`
- **directives** — `source` `bind` `configure` `grid` `search` `timeout` `expect`
- **widgets** — `text` `tail` `table` `list` `gauge` `spark` `bars` `histo` `chart` `select` `input` `tabs` `block` `frame` `slider` `check` `facet` `filter`
- **query verbs** — `field` `where` `map` `tally` `sort_by` `group_by` `pick` `percentile` `sma` `ewma` `bins` `delta` `cumsum` … (the pipeline vocabulary)

> The `arb` binary must be on `$PATH` for running, checking and LSP.

---

## [0x01] FEATURE MATRIX

| Capability | Status |
|---|---|
| Filetype detection — `*.arb` | **Implemented** — every `*.arb` buffer becomes `filetype=arb` |
| Filetype detection — shebang | **Implemented** — extensionless scripts with `#!/usr/bin/env arb` are detected |
| Syntax highlighting | **Implemented** — standalone arb grammar (keywords, inputs, directives, widgets, query verbs, actions, widget paths, flags, regex/duration/size literals, strings, operators) |
| Indentation | **Implemented** — standalone brace-aware indenter |
| Comments | **Implemented** — `commentstring=# %s`, comment-continuation `formatoptions` |
| Run / make | **Implemented** — `:compiler arb` (`:make` → quickfix) and `:ArbRun` (`<LocalLeader>r`) |
| Checking | **Implemented** — ALE linter running `arb --check` |
| Language server (vim-lsp) | **Implemented** — `arb --lsp`, allowlisted for `arb` |
| Language server (coc.nvim) | **Implemented** — ready-to-paste `languageserver` config |
| Debug adapter (nvim-dap) | **Implemented** — ready-to-paste `arb --dap` adapter config |
| Help | **Implemented** — `:help vim-arb` |
| Config required | **None** — opt-outs to disable ALE, LSP, or the run mapping |

---

## [0x02] INSTALL

**pathogen**

```bash
cd ~/.vim/bundle
git clone https://github.com/MenkeTechnologies/vim-arb
# then inside vim:  :Helptags
```

**vim-plug** (add to `~/.vimrc` / `init.vim`)

```vim
Plug 'MenkeTechnologies/vim-arb'
```

**native packages** (Vim 8+ / Neovim)

```bash
git clone https://github.com/MenkeTechnologies/vim-arb \
    ~/.vim/pack/plugins/start/vim-arb
```

Open any `.arb` file and it lights up — no further configuration. See `:help vim-arb`.

---

## [0x03] SYNTAX // TOKEN CATEGORIES

The grammar classifies tokens into the categories the arb language defines:

| Category | Tokens (sample) | Highlight |
|---|---|---|
| Declarations | `fn` `var` `let` `import` `save` `as` | `Keyword` |
| Control flow | `if` `elif` `else` `for` `while` `match` `case` `when` `return` `break` `continue` `do` | `Statement` |
| Word operators | `and` `or` `not` `in` `every` `out` `spawn` `send` `matches` | `Operator` |
| Inputs | `in` `in.json` `in.csv` `in.tsv` `in.xml` `in.html` `in.yaml` `in.toml` `in.logfmt` | `PreProc` |
| Directives | `source` `bind` `configure` `grid` `search` `timeout` `expect` | `Keyword` |
| Widgets | `text` `tail` `table` `list` `gauge` `spark` `bars` `histo` `chart` `select` `input` `tabs` `block` `frame` `slider` `check` `facet` `filter` | `Type` |
| Query verbs | `field` `where` `map` `tally` `sort_by` `group_by` `pick` `percentile` `sma` `ewma` `bins` … | `Function` |
| Actions | `alert` `beep` `exec` `flash` `quit` | `Special` |
| Widget paths | `.errors` `.codes` `.a.b.c` | `Identifier` |

`/.../i` regex literals, double- and single-quoted strings with escapes, `-flags`, `#` comments, numbers with duration (`500ms`) / size (`4mb`) suffixes, and the operator set (`|>` `<-` `=>` `..`) are all handled. Everything links to standard highlight groups, so every colorscheme covers it.

---

## [0x04] RUN // CHECK

`:compiler arb` wires `:make` to static-check the current spec through arb and route diagnostics to the quickfix list:

```bash
arb --check %
```

To run the current buffer as an arb spec: `:ArbRun [args...]` (mapped to `<LocalLeader>r`). arb reads the stream from stdin, so pipe data in for a live dashboard.

When **[ALE](https://github.com/dense-analysis/ale)** is installed, vim-arb registers a linter that runs the same `arb --check %t` inline. Diagnostics of the form `<file>:<line>: <message>` are surfaced. Skipped silently if ALE is absent or `g:vim_arb_no_ale` is set.

---

## [0x05] LANGUAGE SERVER

### vim-lsp

Registered automatically as `arb --lsp`, allowlisted for the `arb` filetype — no extra config when **[vim-lsp](https://github.com/prabirshrestha/vim-lsp)** is installed. arb must be invoked with **only** `--lsp` — it rejects an appended `--stdio`, so do not add transport args.

### coc.nvim

Add to `coc-settings.json`:

```json
{
  "languageserver": {
    "arb": {
      "command": "arb",
      "args": ["--lsp"],
      "filetypes": ["arb"]
    }
  }
}
```

---

## [0x06] DEBUG ADAPTER

arb exposes a Debug Adapter via `arb --dap` (DAP on stdio). For **[nvim-dap](https://github.com/mfussenegger/nvim-dap)**, add to your Neovim config:

```lua
local dap = require('dap')
dap.adapters.arb = {
  type = 'executable',
  command = 'arb',
  args = { '--dap' },   -- no extra transport args; arb rejects them
}
dap.configurations.arb = {
  { type = 'arb', request = 'launch', name = 'Run arb spec',
    program = '${file}' },
}
```

---

## [0x07] OPTIONS

Set before the plugin loads (e.g. in your `vimrc`):

| Variable | Effect |
|---|---|
| `let g:vim_arb_no_ale = 1` | Skip ALE linter registration |
| `let g:vim_arb_no_lsp = 1` | Skip vim-lsp server registration |
| `let g:vim_arb_no_maps = 1` | Skip the `<LocalLeader>r` run mapping |

---

## [0x08] LAYOUT

```
vim-arb/
├── ftdetect/arb.vim     # *.arb + arb shebang -> filetype=arb
├── syntax/arb.vim       # standalone arb grammar
├── scripts/gen_syntax.sh # stamps syntax/arb.vim with the arb version
├── ftplugin/arb.vim     # commentstring '# %s', :compiler arb, :ArbRun
├── compiler/arb.vim     # :make via arb --check -> quickfix
├── indent/arb.vim       # standalone brace-aware indenter
├── plugin/arb.vim       # ALE linter + vim-lsp + coc + nvim-dap wiring
└── doc/arb.txt          # :help vim-arb
```

Standard Vim runtime layout — pathogen / vim-plug / native packages add it to `runtimepath` with no special handling.

---

## [0x09] LICENSE

MIT © **[MenkeTechnologies](https://github.com/MenkeTechnologies)**
