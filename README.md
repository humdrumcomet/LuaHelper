# LuaHelper - A collection of Lua functions and LuaLatex commands to ease LuaLatex coding
## Introduction

## Warnings
This code is experimental, and has so far only been tested on a linux system (though I suspect it
will work without too much effort on any unix based system).

## Requirements
This package requires the following LuaLaTeX packages:

`luapackageloader` - Available in standard tex distributions\
`luacode` - Available in standard tex distributions\
`siunitx` - Available in standard tex distributions\

## Installation
To install this package manually, first make sure that you have a local texmf directory with a
subdirectory named tex. You can do this with the following command, which will create the needed 
directories in your home directory. 

`
$ mkdir -p ~/texmf/tex/
`

This gives the system tex a specific place to look for the package.

Next, using bash (or similar shell) navigate into a folder you plan on storing the luaHelper
package (DO NOT clone into the texmf folder. This will significantly slow down all latex compilations 
as KSPE will try to traverse the .git directory) execut the following commands:

```
$ git clone https://github.com/humdrumcomet/luaHelper
$ cd luaHelper
$ ln -s luaHelper ~/texmf/tex/
$ texhash
```

## Basic Usage

## To Do's
