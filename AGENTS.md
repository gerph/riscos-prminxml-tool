# Working on the PRM-in-XML tool

This repository holds `riscos-prminxml` (a Perl script), the DTDs and
stylesheets it uses (`catalog/`), and the documentation of the format
(`catalog/docs/`). For *writing documents* with the tool, use the
`writing-prminxml` skill; this file is about maintaining the tool itself.

## Layout

* `riscos-prminxml` - the tool. Written in Perl and kept compatible with old
  Perls and with RISC OS, so avoid recent Perl features.
* `catalog/gerph/<version>/` - the DTD and stylesheets for each catalogue
  version. The version in `VersionNum` follows the schema, so it is not
  bumped for changes to the tool script alone.
* `catalog/gerph/bnf/100/bnf.dtd` - the BNF DTD, which the main DTD includes
  through an external parameter entity.
* `catalog/docs/PRMinXML.txt` and `catalog/docs/BNF.txt` - the written
  element reference.
* `crosscompile/check-element-docs` - checks the written reference against
  the DTD.

## The element reference must agree with the DTD

The element reference has to stay readable as plain text, so it is
hand-written. The DTD is authoritative.

* Give each element its own entry. A combined heading (such as `sup & sub`)
  cannot be found by `--help-tag <element>` for either name.
* Write the `Attributes:` and `Children:` lines on a single line. The tool
  reads only that line, so a continuation line is never shown.
* Use the DTD's own notation for `Children:`, with `<text>` for `#PCDATA`,
  `<none>` for empty, `<any>` for `ANY`, and `%name;` for the DTD's named
  groups (explained in the "Element descriptions" section of
  `PRMinXML.txt`). Use the DTD's group names; do not invent them.
* List attributes in DTD order. Attribute descriptions go in the first
  paragraph after the header, as `name: text`.
* When describing how an element is rendered, check the stylesheet rather
  than guessing.

Run `crosscompile/check-element-docs` after changing either the DTD or the
reference. It fails if an element is undocumented or documented but not in
the DTD, if a `Children:` line differs from the DTD's content model (after
expanding groups), if an `Attributes:` line differs from the DTD's
attributes, or if a described attribute does not exist. CI runs it in both
GitLab (the primary) and GitHub (the public mirror). When changing CI, push
a branch to GitLab and check the pipeline before merging.

## Reading the schema from a program

Do not scrape the prose help or add another DTD reader. Use
`riscos-prminxml --help-tag [<element>] --json [-C <version>]`, which reports
the elements, the DTD's parameter entities, and (for catalogue 103) the
descriptions from the written reference. Any code that reads the DTDs must
follow the external BNF entity, or it will miss the BNF elements.

## Conventions

* Use British English in comments and documentation.
* Keep commits separate for separate concerns (for example a tool feature, then
  the documentation and check that go with it).
