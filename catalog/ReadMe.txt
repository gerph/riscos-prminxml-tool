Catalog files
=============

This directory contains the files necessary to build the PRM documents
provided here. If you are using the `riscos-prminxml` tool, these will
be handled for you. However, if you are using the catalog directory, you
must set system/environment variables:

* Under RISC OS, you should set `XML$CatalogFiles` to point to the `root/xml`
file.
* Under Linux, you should set `XML_CATALOG_FILES` to point to the `root.xml`
file.

Documentation can be found in the docs directory:

    - `docs/PRMinXML.txt` - documents the elements and usage of the PRM-in-XML format.
    - `docs/BNF.txt` - documents the BNF elements which can be used by PRM-in-XML.
    - `docs/HowTo.md` - describes how you can use the tool and build documentation.

A skeleton PRM-in-XML document can be found in `gerph/skeleton.xml`.
