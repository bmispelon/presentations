presentations
=============

A repository for my presentations.

It uses rst2s5 (from docutils).

Run `./build.sh presentation.rst` to build a presentation

While working on a presentation, run `./continuous.sh` to automatically
rebuild the presentation when it's saved.

The `buildcss.sh` script can be used to generate pygments css files.

To count the number of real slides in a presentation, use
`grep -B 1 "^--*$" presentation.rst | awk "NR%3==1" | uniq | wc -l`
