# LuaHelper - A collection of Lua functions and LuaLatex commands to ease LuaLatex coding
## Introduction
with python code from within LuaLaTeX or LuaTeX easy.

## Warnings
This code is experimental, and has so far only been tested on a linux system (though I suspect it
will work without too much effort on any unix based system).

## Requirements
This package requires the following LuaLaTeX packages:

```
luapackageloader
luacode
luaHelper
```

Both `luapackageloader` and `luacode` are available in standard tex distributions but as of writing
`luaHelper` must be installed manually and can be found [here](https://github.com/humdrumcomet/luahelper).

## Installation
To install this package manually, first make sure that you have a local texmf directory with a
subdirectory named tex. You can do this with the following command, which will create the needed 
directories in your home directory. 

`
$ mkdir -p ~/texmf/tex/
`

This gives the system tex a specific place to look for the package.

Next, using bash (or similar shell) navigate into a folder you plan on storing the lunatexPython 
package (DO NOT clone into the texmf folder. This will significantly slow down all latex compilations 
as KSPE will try to traverse the .git directory) execut the following commands:

```
$ git clone https://github.com/humdrumcomet/lunatexpython
$ cd lunatexPython
$ bash setup.sh
$ ln -s lunatexPython ~/texmf/tex/
$ texhash
```

## Basic Usage

## To Do's
In the coming weeks (months?) proper documentation that details the usage and the possibilities of 
extending the tool will be completed and added to the project. It will also hopefully one day be
submitted to CTAN so that it can come with most standard tex distributions.
