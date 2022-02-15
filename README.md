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

## Installation

The release archives contain the tool ready to be installed into your `PATH` (on posix
systems) or on `Run$Path` (on RISC OS systems).

## Usage

The tool contains help on the tool's use. However, the most common usage of the tool
(on a POSIX-like system) would be something like:

    riscos-prminxml myfile.xml

which will generate a file `myfile.html`, after transforming the content.

On RISC OS, the command would be called `riscos-prminxml` would be used, and filenames
will be in RISC OS format.

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

## Documentation

The PRM-in-XML format is documented within the text files in the [`catalog/docs`](catalog/docs)
directory. A skeleton document is available in [`catalog/gerph/skeleton.xml`](catalog/gerph/skeleton.xml)
which can be used to construct new documents or as a guide for creating them. A 'HowTo' document
in the documentation directory describes the process of creating new documents.

## Examples

The PRM-in-XML format contains some [example documents](examples) which are used to check the
behaviour of the tool. These show some of the elements that can be used by the PRM-in-XML
format. A larger set of examples can be found in the repository at https://github.com/gerph/riscos-prminxml-examples.
