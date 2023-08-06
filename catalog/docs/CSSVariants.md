# CSS variants for PRM-in-XML

## Introduction

There are a selection of CSS variants which are built into the `prm-css.xml`,
for use with the HTML 5 transformation. These can be applied to the generated
documents using a parameter to list the named variants to
include.

Each variant has a simple name which can be used to include the necessary CSS
from the built-in file, in the generated document.

Some variants expect to be used in conjunction with others, but in general
they should be able to be combined arbitrarily, with the later variants
overriding those specified earlier in the list.

In particular, the variants that change fonts will commonly be applied
in pairs. The `webfont-*` variants will declare that the font specified
will be made available from an Internet-accessible source, and the `body-*`
or `heading-*` will then use that font for the body or heading text.


## Usage

The `css-variants` parameter is a space-separated list of these variants.
It would commonly be supplied to the `riscos-prminxml` tool in a form like
this:

    riscos-prminxml --param "css-variant=prm prm-modern" myfile.xml

Within the indexed documentation generation the `index.xml` file may use
the `page-css-variant` or `index-css-variant` attribute on the `options`
element to change all the page content. Each of the `front-matter`,
`cover` and `page` elements supports the `css-variant` attribute to
specific explicit variants to use within individual documents. Consult
the `riscos-prminxml --help-indexed` documentation for more details.

## Large scale style variants

### Variant: `acornfs`

The `acornfs` ('Acorn Functional Specification') variant is a large scale style change to make the document match the style of the functional specifications
that Acorn produced as part of their NC, Ursula, and Browse projects.

It shares many features with the PRM so is appropriate for a lot of the uses, but...

* It doesn't have the common indented text format that was used in the paper manuals.
* Tables are bordered and given header dividers.
* The highlight colour for links is green.
* A background colour is used for the definition header title, to separate sections.

This style varies from the original Acorn style in that:

* The sections/subsections/subsubsections/categories are indented slightly, to make it clearer
  what level they are at
* Green dividers are used between sections to ensure that the content is divided up in a
  more clear way.

The variant can be applied on its own, for example:

    riscos-prminxml --param "css-variant=acornfs" myfile.xml

### Variant: `prm`

The `prm` variant is intended to style the generated documentation to match the
RISC OS 3 Programmer's Reference Manuals. It is a large scale style change.

The variant can be applied on its own, for example:

    riscos-prminxml --param "css-variant=prm" myfile.xml

When printed, this variant applies a size which is close to the original
size of the RISC OS 3 PRMs.

For best effect it is recommended that it be used with the Fraunces and Raleway fonts, together with large bullets:

    riscos-prminxml --param "css-variant=prm body-fraunces heading-raleway webfont-fraunces webfont-raleway large-bullets" myfile.xml


### Variant: `prm-ro2`

The `prm-ro2` variant is an extension to the `prm` variant, which changes the
style to be closer to that of the RISC OS 2 Programmer's Reference Manuals.
It is a large scale style change.

There are a lot of similarities to the RISC OS 3 manuals, but in particular
there is a large left margin and the headings are placed within it. This makes
it particularly easy to skim for sections but at the cost of introducing large
areas of whitespace.

When printed, this variant applies a size which is close to the original
size of the RISC OS 2 PRMs.

The variant should be applied after `prm`, for example:

    riscos-prminxml --param "css-variant=prm prm-ro2" myfile.xml

For best effect it is recommended that it be used with the Fraunces and Raleway fonts, together with large bullets:

    riscos-prminxml --param "css-variant=prm prm-ro2 body-fraunces heading-raleway webfont-fraunces webfont-raleway large-bullets" myfile.xml


### Variant: `prm-modern`

The `prm-ro2` variant is an extension to the `prm` variant, which changes the
style to use a more modern style. It is a large scale style change.

Whilst much of the layout is similar to the PRM, sections are more clearly
delineated with green headings, tables are given borders and indentation is
removed. This makes for a more compact presentation.

Whilst this style is usable within a desktop browser, it is significantly
better when generated as a PDF.

The variant should be applied after `prm`, for example:

    riscos-prminxml --param "css-variant=prm prm-modern" myfile.xml

For best effect it is recommended that it be used with Noto Sans and Saira fonts:

    riscos-prminxml --param "css-variant=prm prm-modern body-notosans heading-saira webfont-notosans webfont-saira" myfile.xml

This variant was found to benefit (in some documentation) from using the
`packed-definitions` variant to make the introduction to definitions more
concise.


## Specific styling variants


### Variant: `numbered-sections`

The `numbered-sections` variant attempts to introduce numbering to each
of the sections of the document. These section numbers are generated
automatically by the CSS, so the feature may not be supported by your
browser.

Sections numbers are useful in printed documents, but in live documents
they may change, so it may not be as useful to use this feature.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=numbered-sections" myfile.xml

### Variant: `large-bullets`

The `large-bullets` variant introduces a larger bullet than the default.
This is closer to the PRM's standard bullets, so is useful with the
standard PRM styles.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=large-bullets" myfile.xml

### Variant: `drop-character`

The `drop-character` variant attempts to provide a large drop character
for the first letter of the section. It does not work very well.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=drop-character" myfile.xml

### Variant: `offsets-align-right`

The `offsets-align-right` variant makes the offset and message table
offsets align to the right of their boxes. This makes the numbers
line up on the right edge of the table cell, but has the effect of
producing a ragged left which may make the table look oddly indented.
Together with variants which use a border for tables, this may look
much better than without.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=offsets-align-right" myfile.xml

### Variant: `packed-definitions`

The `packed-definitions` variant moves the properties within the definitions
to be more compact. Within code entry points (SWIs, Vectors, etc) the entry
and exits parameters are listed in two columns, and the processor and interrupt
state are placed on a single line.

Whilst this does save space, the different sizes of the blocks means that
they can look uncomfortably untidy.

This variant was originally designed for use with the `prm-modern` variant.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=packed-definitions" myfile.xml

### Variant: `input-red-function-keys`

The `input-red-function-keys` variant makes the use function keys as
`input` elements appear in red. This matches the keyboard style of the
BBC Micro and is generally considered to be iconic of Acorn's earlier
systems.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=input-red-function-keys" myfile.xml


### Variant: `input-mouse-icons`

The `input-mouse-icons` variant makes the use of mouse buttons in the
`input` element use a small mouse icon beside the text to be clearer,
and gives the drag operation an icon, rather than text.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=input-mouse-icons" myfile.xml


## Document size variants

### Variant: `page-a4`

The `page-a4` variant forces the page size to be A4, overriding the
sizes specified by other variants.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=page-a4" myfile.xml

### Variant: `page-a5`

The `page-a5` variant forces the page size to be A5, overriding the
sizes specified by other variants.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=page-a5" myfile.xml


## Index variants

The index variants change the layout of the indexes within indexed
collections of documents.

### Variant: `index-no-descriptions-in-print`

The `index-no-descriptions-in-print` variant removes the column that
gives the description of the indexed item when the document is printed.
Generally, when printed, the space in the printed index is at a premium,
and a very dense index may not be as readable.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=index-no-descriptions-in-print" myfile.xml


### Variant: `index-no-headings-in-print`

The `index-no-headings-in-print` variant removes the heading column
that describes the fields, when the document is printed. As this
row is often repeated on each page, it might be unnecessary as it is
clear what the columns represent.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=index-no-headings-in-print" myfile.xml


### Variant: `index-reason-linebreak-in-print`

The `index-reason-linebreak-in-print` variant makes the reason
in indexed elements pass to a separate line, when the document is
printed. This may make it easier to find the specific reason within
a large collection of interfaces.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=index-reason-linebreak-in-print" myfile.xml


### Variant: `index-include-indexed-header-label`

The `index-include-indexed-header-label` variant makes the page header
include the name of the indexed element. This makes it easier to
look through the index to find the necessary indexed section.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=index-include-indexed-header-label" myfile.xml


## Miscellaneous variants

### Variant: `no-edge-index`

The `no-edge-index` variant removes the indexing text from the edge
of the printed page. By default, the PRM styles have an
[edge index](https://en.wikipedia.org/wiki/Edge_index) - a coloured
block with text describing the section. This index is useful within
the printed document to find the required section. However, it is
entirely decorative when viewed within a PDF in the desktop.

This variant removes the block and text.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=no-edge-index" myfile.xml


### Variant: `no-meta-section`

The `no-meta-section` variant removes the section at the bottom of
the document which gives metadata information about the document.

The variant can be applied with any other variants, for example:

    riscos-prminxml --param "css-variant=no-meta-section" myfile.xml


## Font changing variants

### Font: Novarese (body)

The Novarese font was the primary body font for Acorn's manuals. It is
a nicely styled font, balancing serif elements with readability. It is
most familiar to RISC OS users who referenced the manuals regularly.

It is a commercial font that must be purchased and then installed
within your system. There is no webfont version.

The variant can be applied with any other variants, for example as a body font you would use:

    riscos-prminxml --param "css-variant=body-novarese" myfile.xml

### Font: Fraunces (body)

The [Fraunces font](https://fonts.google.com/specimen/Fraunces) is a serif
font, similar in intent to the Novarese font, and has a similar look.
It is a fair substitute for the commercial font.

The variant can be applied with any other variants, for example as a body font you would use:

    riscos-prminxml --param "css-variant=webfont-fraunces body-fraunces" myfile.xml


### Font: Raleway (heading)

The [Raleway font](https://fonts.google.com/specimen/Raleway) is a light
heading font which is similar in style to the font used by Acorn. It is
a freely available font.

The variant can be applied with any other variants, for example as a heading font you would use:

    riscos-prminxml --param "css-variant=webfont-raleway heading-raleway" myfile.xml


### Font: Noto Sans (body and heading)

The [Noto Sans font](https://fonts.google.com/specimen/Raleway) is a clean
sans-serif font, which is suitable for both the body and headings of
documents. It is a freely available font.

The variant can be applied with any other variants, for example as a heading font you would use:

    riscos-prminxml --param "css-variant=webfont-notosans heading-notosans" myfile.xml

Or as a body font you would use:

    riscos-prminxml --param "css-variant=webfont-notosans body-notosans" myfile.xml

For body and heading, you would use:

    riscos-prminxml --param "css-variant=webfont-notosans body-notosans heading-notosans" myfile.xml


### Font: Oswald (heading)

The [Oswald font](https://fonts.google.com/specimen/Oswald) is a clean
sans-serif font which may be used for headings. It has a few distinctive
features:

* It is a quite condensed font, with a tall aspect ratio.
* It has very legible text in both bold and normal presentation.
* It has rounded numbers, and no tall stems on the tops of p and bottom of d.
* It is a little too bold for large amounts of text when used in headings.

It is a freely available font.

The variant can be applied with any other variants, for example as a heading font you would use:

    riscos-prminxml --param "css-variant=webfont-oswald heading-oswald" myfile.xml


### Font: Saira (heading)

The [Saira font](https://fonts.google.com/specimen/Saira) is a clean
sans-serif font which may be used for headings. It has a few distinctive
features:

* It is a squarish font.
* It has very legible text in both bold and normal presentation.
* It has rounded numbers, and no tall stems on the tops of p and bottom of d.
* c has very little curl on it.

It is a freely available font.


The variant can be applied with any other variants, for example as a heading font you would use:

    riscos-prminxml --param "css-variant=webfont-saira heading-saira" myfile.xml
