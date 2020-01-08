#! /bin/bash
#
# benchmark--gen-multiple-layouts.bash
# Copyright (C) 2020 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#


outdir='../bench-gen-multi'
minidx=1
maxidx=32000

shell_loop()
{
    local i="$minidx"
    while test "$i" -le "$maxidx"
    do
        ./board_gen/pi-make-microsoft-freecell-board -t "$i" > "$outdir/$i.board"
        let ++i
    done
}

c_gen()
{
    ./board_gen/gen-multiple-solitaire-layouts--c --dir "$outdir" --suffix .board seq "$minidx" "$maxidx"
}

pypy_gen()
{
    pypy3 board_gen/gen-multiple-pysol-layouts --dir "$outdir" --ms --prefix '' --suffix .board --game freecell seq "$minidx" "$maxidx"
}

python_gen()
{
    python3 board_gen/gen-multiple-pysol-layouts --dir "$outdir" --ms --prefix '' --suffix .board --game freecell seq "$minidx" "$maxidx"
}

wrapper()
{
    local fn="$1"
    shift
    mkdir -p "$outdir"
    time "$fn"
    mv "$outdir" "$outdir-$fn"
}

wrapper shell_loop
wrapper python_gen
wrapper pypy_gen
wrapper c_gen
