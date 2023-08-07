# PRM-in-XML tool and transforms

[![Download: RISC OS](https://img.shields.io/badge/Download-RISC_OS-blue)](https://github.com/gerph/riscos-prminxml-tool/releases/download/v1.03.65.html5-css.267/RISCOS-PRMinXML-1.03.65.html5-css.267.zip)
[![Download: POSIX](https://img.shields.io/badge/Download-POSIX-blue)](https://github.com/gerph/riscos-prminxml-tool/releases/download/v1.03.65.html5-css.267/POSIX-PRMinXML-1.03.65.html5-css.267.tar.gz)
[![Download: Examples](https://img.shields.io/badge/Download-Example_Documents-blue)](https://github.com/gerph/riscos-prminxml-tool/releases/download/v1.03.65.html5-css.267/Example-Output-1.03.65.html5-css.267.zip)
[![Documentation: Usage](https://img.shields.io/badge/Documentation-Usage-yellow)](catalog/docs/HowTo.md)
[![Documentation: File format](https://img.shields.io/badge/Documentation-File_Format-yellow)](catalog/docs/PRMinXML.txt)

## Introduction

PRM-in-XML is a specialised XML format for writing RISC OS documentation in the style
of the Programmers Reference Manuals. The format is designed with 4 major goals:

* To be structured
* To provide a flexible base for documentation
* To be translatable to other formats easily
* To provide cross-referencing facilities

This repository contains the PRM-in-XML tool and the transformations necessary to
convert the format into HTML and other formats. The primary transformation is HTML 2 with
tables, with an HTML 5/CSS transformation coming in later versions.

The tool, `riscos-prminxml`, is intended to be used to process XML files into other
formats.

For more information on the rationale for the PRM-in-XML format, see the article on [Iconbar](https://www.iconbar.com/articles/RISC_OS_Documentation/index1700.html).


## Installation on POSIX systems

The release archives contain the tool ready to be installed into your `PATH`. Copy the `riscos-prminxml` file and `riscos-prminxml-resources` directory
to a location where they can be executed from, such as `/usr/local/bin` or `~/bin`.

## Installation on RISC OS systems

The RISC OS archive contains a set of tools to place somewhere that they can be
executed, such as within your library. A common installation would be to copy all
the files and directories from `Tools.XML` into `!Boot.Library`.

The distribution for RISC OS includes the `xsltproc` and `xmllint` binaries.
The version of Perl supplied is suitable for use with the tool only.


## Requirements

* Perl 5
* The `xsltproc` tool
* The `xmllint` tool

For RISC OS, these components are all supplied with the distribution. Updated versions
of the XSLTProc and XMLLint if needed can be found at:

* `xsltproc`: https://github.com/gerph/libxslt/releases
* `xmllint`: https://github.com/gerph/libxml2/releases

For installation on Ubuntu Linux you will require:

* `sudo apt-get install perl xsltproc libxml2`

Other Linux distributions will need different tools.

For installation on macOS:

* `perl`, `xsltproc` and `xmllint` are supplied with the operating system.


## Usage

### Basic operations

The tool contains help on its usage. However, the most common usage of the tool
(on a POSIX-like system) would be something like:

    riscos-prminxml myfile.xml

which will generate a file `myfile.html`, after transforming the content.

On RISC OS the filenames will be in RISC OS format, for example:

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

### Advanced usage

The `riscos-prminxml` tool can be supplied parameters for the transformation
to use. As each format has its own implementation, these parameters will be specific to the transformation. A list of the transformations which are
supported for each format can be listed with a help switch:

    riscos-prminxml --help-params

The parameters option may be specified multiple times with different parameters

For example, in the `html` and `html5` formats, the parameter `create-contents`
can be used to modify whether the links to each of the sections will be
created at the top of the document. To disable this table of contents for the
document, use:

    riscos-prminxml --param "create-contents=no" myfile.xml

Most commonly this switch would be used to control the type of CSS content
used by the `html5` format. There are three parameters which are generally
used to control the styling of the HTML 5 documents:

* `css-base` - used to specify the base style for the document. The value
  `standard` will use the built in CSS styling. The value `none` will omit
  the built in CSS styling entirely.
* `css-file` - includes the supplied CSS file.
* `css-variant` - specifies a variant to apply on top of the CSS as a space-separated list of variant names. The variants are defined in the `prm-css.xml` file.

The default CSS style is suitable for viewing within a desktop browser, but
for a style which is closer to the PRM you might apply the `prm` variant:

    riscos-prminxml --param "css-variant=prm" myfile.xml

To modify this to be produce documentation in the style of the
RISC OS 2's PRMs:

    riscos-prminxml --param "css-variant=prm prm-ro2" myfile.xml

More information about the CSS variants which can be applied can be found in the [`CSSVariants.md` document](catalog/docs/CSSVariants.md).


To introduce your own CSS styling on top of the standard, you might
create a small CSS file to change the features you felt needed changing,
and apply this with the `css-file` parameter:

    riscos-prminxml --param "css-file=my.css" myfile.xml


### Video guides

Some video guides have been produced which explain how to use the PRM-in-XML
tool. See https://presentation.riscos.online/prminxml/index.html for more details.


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
which can be used to construct new documents or as a guide for creating them. A '[How To](catalog/docs/HowTo.md)'
in the documentation directory describes the process of creating new documents.

## Examples

Example PRM-in-XML documents can be found on GitHub tagged with the `prmxinml` topic.

In particular, there are example documents in a repository at https://github.com/gerph/riscos-prminxml-examples

The Releases section includes built HTML and PDF documents within the archives.

As part of the work towards making available more RISC OS documentation, many existing documents have been converted to PRM-in-XML format. Whilst these are incomplete or do not have their own place to be stored, these can be found in the `riscos-prminxml-staging` repository.

This can be found at: https://github.com/gerph/riscos-prminxml-staging

Again, the Releases section includes built versions of the documentation.


### Test example files

This repository contains some [example documents](examples) which are used to check the
behaviour of the tool. These show some of the elements that can be used by the PRM-in-XML
format.

The example documents can be built from POSIX systems with the following commands:

    cd crosscompile
    ./build-examples.sh

To build with PDF output, using Prince XML (personal and non-commercial use is
a valid use of Prince XML - see https://www.princexml.com/purchase/license_faq/), use:

    env PRINCEXML_I_HAVE_A_LICENSE=1 ./build-examples.sh

This will process the indexed documents in the `examples` directory to generate the different forms of output in the `test-output` directory.
