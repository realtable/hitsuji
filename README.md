# Hitsuji

![https://travis-ci.com/realtable/hitsuji](https://travis-ci.com/realtable/hitsuji.svg)
![https://github.com/realtable/hitsuji/issues](https://img.shields.io/github/issues/realtable/hitsuji.svg)
![https://rubygems.org/gems/hitsuji](https://img.shields.io/gem/v/hitsuji.svg)

Hitsuji is a library that implements a tree data structure, where each node is
represented by a value, points to other values, or performs a function on some
values. When the tree is updated, the inputs to the functions will change, hence
changing the outputs, eventually propagating the update through the entire tree.
Data structures can also be exported to disk, allowing for wide applications of
this software, e.g. handling big data, managing content, etc.

| home  | https://github.com/realtable/hitsuji          |
|:----- |:--------------------------------------------- |
| docs  | https://www.rubydoc.info/gems/hitsuji/Hitsuji |
| gem   | https://rubygems.org/gems/hitsuji             |
| build | https://travis-ci.com/realtable/hitsuji       |

    $ gem install hitsuji
