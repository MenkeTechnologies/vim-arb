" vim-arb — syntax highlighting for the arb language
"
" arb is a pipe-native language that turns a Unix pipeline into a dynamic TUI
" or served web dashboard from a declarative, Tcl/Tk-flavored spec. This is a
" standalone grammar covering arb's surface: declaration/control keywords,
" input sources, directives, widgets (the "Tk" register), the query-verb
" pipeline vocabulary, trigger actions, dotted widget paths, -flags, /regex/i
" literals, strings, duration/size literals, and operators. Everything links to
" standard highlight groups, so every colorscheme covers it.
"
" Verified against arb — declarative pipeline DSL on fusevm/JIT.

if exists('b:current_syntax')
  finish
endif

syntax case match
syntax sync minlines=50

" ---------------------------------------------------------------------------
" Comments / shebang
" ---------------------------------------------------------------------------
syntax keyword arbTodo contained TODO FIXME XXX NOTE HACK
syntax match   arbComment "#.*$" contains=arbTodo,@Spell
syntax match   arbShebang "\%^#!.*$"

" ---------------------------------------------------------------------------
" Numbers — integers, floats, hex, durations (1s 500ms 2m 1h), sizes (4mb)
" ---------------------------------------------------------------------------
syntax match arbDuration "\<\d\+\%(\.\d\+\)\?\%(ms\|s\|m\|h\)\>"
syntax match arbSize     "\<\d\+\%(\.\d\+\)\?\%(kb\|mb\|gb\|tb\)\>"
syntax match arbNumber   "\<0[xX]\x\+\>"
syntax match arbNumber   "\<\d\+\>"
syntax match arbFloat    "\<\d\+\.\d*\%([eE][-+]\?\d\+\)\?\>"
syntax match arbFloat    "\.\d\+\%([eE][-+]\?\d\+\)\?\>"

" ---------------------------------------------------------------------------
" Strings
" ---------------------------------------------------------------------------
syntax match  arbStringEscape contained "\\."
syntax region arbString start=+"+ skip=+\\"+ end=+"+ contains=arbStringEscape,@Spell
syntax region arbString start=+'+ skip=+\\'+ end=+'+ contains=arbStringEscape,@Spell

" ---------------------------------------------------------------------------
" Regex literals /.../  with optional trailing i flag
" (bare `/` is deliberately left out of the operator set so `/re/` wins)
" ---------------------------------------------------------------------------
syntax match  arbMatchKw "\<matches\>"
syntax region arbRegex start=+/+ skip=+\\/+ end=+/[i]\?+ oneline contains=arbRegexEscape
syntax match  arbRegexEscape contained "\\."

" ---------------------------------------------------------------------------
" Constants
" ---------------------------------------------------------------------------
syntax keyword arbConstant true false nil

" ---------------------------------------------------------------------------
" Keywords — control flow, declarations, word operators
" ---------------------------------------------------------------------------
syntax keyword arbControl if elif else for while match case when return break continue do
syntax keyword arbDecl fn var let import save as
syntax keyword arbOperatorKw and or not in every out spawn send

" ---------------------------------------------------------------------------
" Input sources (in, in.json, in.csv, …)
" ---------------------------------------------------------------------------
syntax keyword arbInput in
syntax match   arbInput "\<in\.\%(json\|csv\|tsv\|xml\|html\|yaml\|yml\|toml\|logfmt\)\>"

" ---------------------------------------------------------------------------
" Directives
" ---------------------------------------------------------------------------
syntax keyword arbDirective source bind configure grid search timeout expect

" ---------------------------------------------------------------------------
" Widgets ("Tk" register)
" ---------------------------------------------------------------------------
syntax keyword arbWidget text tail table list gauge spark bars histo chart
syntax keyword arbWidget select input tabs block frame slider check facet filter

" ---------------------------------------------------------------------------
" Query verbs — the pipeline vocabulary
" ---------------------------------------------------------------------------
syntax keyword arbFunction field fields find attr where reject pick keys vals map each
syntax keyword arbFunction count sum min max avg tally sort sort_by group_by uniq unique_by
syntax keyword arbFunction count_by min_by max_by has entries flatten add over under between
syntax keyword arbFunction enumerate words dedup distinct tailn take drop first last nth slice
syntax keyword arbFunction pad lpad flip b64 b64d hex unhex urlenc urldec extract split substr
syntax keyword arbFunction chars title repeat replace set del rename default merge floor ceil
syntax keyword arbFunction clamp abs round commafy bytes duration delta cumsum rate sma ewma
syntax keyword arbFunction median stddev percentile p50 p90 p95 p99 range product bins apply
syntax keyword arbFunction basename dirname cut calc wc numeric nonempty ends starts append
syntax keyword arbFunction prepend rev sample index join lower upper trim len
syntax keyword arbFunction grep grepv grepf
" `contains` collides with the `contains=` argument of :syntax keyword, so match it.
syntax match   arbFunction "\<contains\>"

" ---------------------------------------------------------------------------
" Trigger actions
" ---------------------------------------------------------------------------
syntax keyword arbAction alert beep exec flash quit

" ---------------------------------------------------------------------------
" Widget paths (.a.b.c) and -flags
" ---------------------------------------------------------------------------
syntax match arbWidgetPath "\.\h[[:alnum:]_.]*"
syntax match arbFlag "\s\zs-\h[[:alnum:]-]*"

" ---------------------------------------------------------------------------
" Function definitions: fn NAME
" ---------------------------------------------------------------------------
syntax match arbFunctionDef "\<fn\s\+\zs\h\w*"

" ---------------------------------------------------------------------------
" Operators
" ---------------------------------------------------------------------------
syntax match arbOperator "|>"
syntax match arbOperator "<-"
syntax match arbOperator "=>"
syntax match arbOperator "\.\."
syntax match arbOperator "+\|-\|\*\|%"
syntax match arbOperator "==\|!=\|<=\|>=\|<\|>"
syntax match arbOperator "=\|+=\|-=\|\*=\|%="

" ---------------------------------------------------------------------------
" Highlight links
" ---------------------------------------------------------------------------
highlight default link arbComment      Comment
highlight default link arbShebang      PreProc
highlight default link arbTodo         Todo
highlight default link arbNumber       Number
highlight default link arbFloat        Float
highlight default link arbDuration     Number
highlight default link arbSize         Number
highlight default link arbString       String
highlight default link arbStringEscape SpecialChar
highlight default link arbRegex        String
highlight default link arbRegexEscape  SpecialChar
highlight default link arbMatchKw      Operator
highlight default link arbConstant     Constant
highlight default link arbControl      Statement
highlight default link arbDecl         Keyword
highlight default link arbOperatorKw   Operator
highlight default link arbInput        PreProc
highlight default link arbDirective    Keyword
highlight default link arbWidget       Type
highlight default link arbFunction     Function
highlight default link arbAction       Special
highlight default link arbWidgetPath   Identifier
highlight default link arbFlag         Special
highlight default link arbFunctionDef  Function
highlight default link arbOperator     Operator

let b:current_syntax = 'arb'
