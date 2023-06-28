# PRM-in-XML tool and transforms

## Introduction

PRM-in-XML is a specialised XML format for writing RISC OS documentation in the style
of the Programmers Reference Manuals. The format is designed with 4 major goals:

* To be structured
* To provide a flexible base for documentation
* To be translatable to other formats easily
* To provide cross-referencing facilities

This repository contains the PRM-in-XML tool and the transformations necessary to
convert the format into HTML and other formats. The primary transformation is HTML 2 with
tables, with a HTML 5/CSS transformation coming in later versions.

The tool, `riscos-prminxml`, is a Perl script intended to be used to process
XML files into other formats without installation.

## Installation on RISC OS

The release archives contain the tool ready to be installed into your `PATH` (on POSIX
systems) or on `Run$Path` (on RISC OS systems). The tool requires Perl 5 on later to
function.

## Requirements

* Perl 5
* The `xsltproc` tool
* The `xmllint` tool

For installation on RISC OS you will require:

* A copy of `perl5`
* `xsltproc`: https://github.com/gerph/libxslt/releases
* `xmllint`: https://github.com/gerph/libxml2/releases

For installation on Ubuntu Linux you will require:

* `sudo apt-get install perl xsltproc libxml2`

Other Linux distributions will need different tools.

For installation on macOS:

* `perl`, `xsltproc` and `xmllint` are supplied with the operating system.


## Usage

The tool contains help on the its usage. However, the most common usage of the tool
(on a POSIX-like system) would be something like:

    riscos-prminxml myfile.xml

which will generate a file `myfile.html`, after transforming the content.

On RISC OS, the tool would be placed into the library, and filenames will be in
RISC OS format, for example:

    riscos-prminxml myfile/xml

The tool can be used to generate skeleton documents from which you can begin processing
content:

    riscos-prminxml -f skeleton -o myfile.xml

And can be used to process many documents in succession:

    riscos-prminxml -O outputdir myfile.xml anotherfile.xml

There is also a specialised format where a whole indexed manual can be generated from
many documents, through an 'index' document which describes the layout of the manual:

    riscos-prminxml -f index index.xml

The tool itself contains help describing its usage:

    riscos-prminxml --help
    riscos-prminxml --help-indexed

Individual tags within the documentation format can be described with a command:

    riscos-prminxml --help-tag chapter

## Tested platforms

The PRM-in-XML tool is tested and known to work on a number of platforms:

* RISC OS
* Ubuntu (18.04, 20.04, 22.04)
* CentOS (7 and 8)
* Debian (10)
* Linux Mint (18, 20, 21)

Other platforms may work, but are not tested as part of the standard testing process.
Although not part of the automated testing, the tool also works and is developed on
macOS.

## Documentation

The PRM-in-XML format is documented within the text files in the [`catalog/docs`](catalog/docs)
directory. A skeleton document is available in [`catalog/gerph/skeleton.xml`](catalog/gerph/skeleton.xml)
which can be used to construct new documents or as a guide for creating them. A 'HowTo' document
in the documentation directory describes the process of creating new documents.

## Examples

The PRM-in-XML format contains some [example documents](examples) which are used to check the
behaviour of the tool. These show some of the elements that can be used by the PRM-in-XML
format. A larger set of examples can be found in the repository at https://github.com/gerph/riscos-prminxml-examples.
