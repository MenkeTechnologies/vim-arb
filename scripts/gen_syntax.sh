#!/usr/bin/env bash
# Stamp syntax/arb.vim with the arb version it was checked against.
#
# arb's language surface (widgets, directives, query verbs, keywords) is fixed
# and defined by the language, so the keyword lists are hand-curated in
# syntax/arb.vim — there is no giant reflection table to dump. This script keeps
# the one volatile piece — the "verified against arb vX.Y.Z" line and the
# dynamically-counted token totals — in sync with the binary.
#
#   ./scripts/gen_syntax.sh        # uses `arb` on $PATH
#   ARB=/path/to/arb ./scripts/gen_syntax.sh
set -euo pipefail

arb="${ARB:-arb}"
here="$(cd "$(dirname "$0")/.." && pwd)"
out="$here/syntax/arb.vim"

ver="$("$arb" --version 2>/dev/null | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
ver="${ver:-unknown}"

# Count the curated token surface straight out of the syntax file (source of
# truth), so the reported numbers never drift from what is highlighted.
count() { grep -hoE "syntax keyword $1 .*" "$out" | perl -pe "s/syntax keyword $1 //" | tr ' ' '\n' | grep -c .; }
nverb="$(count arbFunction)"
nwidget="$(count arbWidget)"

# Rewrite only the single "Verified against ..." stamp line in place (perl, not
# sed — portable across BSD/GNU).
perl -i -pe "s|^\" Verified against arb .*|\" Verified against arb ${ver} — declarative pipeline DSL on fusevm/JIT.|" "$out"

echo "stamped $out (arb ${ver}; ${nverb} query verbs, ${nwidget} widgets)"
