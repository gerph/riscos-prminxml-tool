# How to create PRM-in-XML documentation

## Introduction

This document is a short 'how-to' guide for how to create documentation in PRM-in-XML format. For more information about the elements and concepts, please consult the fuller documentation of the structure of the format supplied with the distribution.

## Creating the PRM-in-XML file

The first step in creating PRM-in-XML documentation is to have a clear idea what it is that you're documenting. Usually what is being documented is a module, command or resource. You should know what the component being documented does, how it is used, and how it interacts with the rest of the system. It is also very useful to know what other interfaces might be used with it, so that the 'related' sections can be documented.

With this in mind, you can start out with a skeleton of the chapter you are creating. The PRM-in-XML skeleton contains some examples and placeholder text to provide a structure into which you can fill in the content. In this documentation I assume that you will hold the PRM-in-XML documentation in the `prminxml` directory of your project. For examples, we use a component called `Dice Roller`. Although any example text given for the component in this document may be short, this is for illustrative purposes; your own documentation should be as long as you need it to be.

The skeleton for the project can be created with the command:

    riscos-prminxml -f skeleton -o prminxml/diceroller.xml

This will build a new file which is a complete PRM-in-XML document, with text in each section to help guide you.

## Building HTML files

Having created a skeleton document, this can be converted to an HTML document. Even in this skeleton form, it will convert to an HTML file, which will allow you to see how the content will appear when converted. Remember the purpose of the PRM-in-XML format is to structure the content in a way that follows the PRM's general style and is able to be easily referenced.

You can create an HTML document with the command:

    riscos-prminxml -f html -o prminxml/diceroller.html prminxml/diceroller.xml

## Populate your new document

### Chapter

The very first element to populate in the document is the title of the chapter. Update the `<chapter title="">` to describe your chapter. Group names are acceptable when a conceptual area is discussed - the PRM uses this for chapters like 'Introduction to filing systems' or 'Software vectors' - but usually you will be documenting a particular component. Give the chapter a title that matches how you wish the user to refer to the component. Although some of the PRM chapters are preceded by 'The', this is discouraged, as it conveys no extra information and stylistically produces identically prefixed chapters.

For example, you might use:

    <chapter title="Dice Roller">

### 'Introduction' and 'Overview' sections

The introduction section is sometimes grouped into 'Introduction and Overview', if there is no necessity for a separate 'Overview' section. The 'Introduction' is intended to describe how the component relates to other parts of the system, and what, at a very high level it does.

The 'Overview' covers the concepts that the component documents, and any base knowledge that the reader will need to understand the technical details. If necessary, it is followed by a 'Terminology' section which defines any new terms that are needed by the component. This will be the master definition used throughout the PRM, so it should be sufficient to give the reader a good understanding of the terms and concepts in this component.

You should delete the placeholder content, and begin to populate it with information about your component.

For example:

    <section title="Introduction and Overview">
    <p>
    The DiceRoller is a module which provides pseudo-random numbers from simulated dice rolls.
    </p>
    </section>

If there is no content in a section, it should be removed - it's rare to need a 'Terminology' section, so remove it if you don't need it.



### 'Technical Details' section

The bulk of the documentation for your component will most likely live within the 'Technical Details' section. This should go into detail about how the component's interfaces fit together, the data structures that are used, and how they can be interpreted by the user. It does not go into detail about how those interfaces are called; they will be documented in the relevant `-definition` sections.

You should use `<subsection>`, `<subsubsection>` and `<category>` blocks as necessary to group information within this section. Data structures can be described with the `offset-table`, `message-table` and `bitfield-table` elements. Constants may be described with the `value-table` element.

Within the description of how the interfaces work, you can reference the `-definition` sections, with references like:

    <reference type='swi' name='DiceRoller_RollMany'/>

Include diagrams if they will aid in the explanation of the operation of the component.


### Definition sections

The sections following the 'Technical Details' contain `-definition` blocks, which are dedicated to describing specific types of interfaces to the component. Most components will only use a few of these sections - the others can be deleted.
Although these sections have example text in a paragraph in the skeleton, the PRM does not provide any introductory text to the sections, and these should be deleted. All relevant information should be within the 'Technical Details' section.

A good starting point when creating your new documentation from the skeleton is to remove all the sections for definitions which are not relevant to the component. This will keep the initial skeleton size down and remove clutter. If you find you need a section you had deleted, you can always create a new copy of the skeleton and copy the relevant sections to your new document for editing.

I find that updating the SWI and service definition documentation first is easier than trying to provide a complete 'Technical details' section.

It is very useful to reference the subsections of the 'Technical Details' when concepts are mentioned. References can be included with links like:

    <reference type='subsection' name='Multiple dice'/>

That said, definitions should include all the necessary information for a reader to understand how to use the API, focusing on how to use it - the technical details should have described why it is used and what effects the interface will have.

Most `-definition` blocks have an `example` element which can be used to include an example usage of the interface.
All `-definition` blocks have a `related` element, into which you should include `reference` elements that refer to other interfaces that may help the reader. For example, in the `DiceRoller_RollMany` SWI you might have:

    <related>
    <reference type='swi' name='DiceRoller_RollOne'/>
    </related>


### Examples sections

At the end of the chapter, an 'Examples' section exists. This sometimes includes explanatory text, but almost always includes 'extended-example' elements which provide example code, or pseudocode, to show how the component might be used.

### Metadata

After the end of the main chapter is an element containing metadata for the chapter. This is not a feature within the PRM, but is necessary within the more dynamic distribution that modern documentation gets. In particular, it includes the name of the maintainer(s), and a disclaimer for the document. This should be updated to be a useful contact point that the reader may use for communication about the document (not necessarily about the component, although these are usually the same).

The 'history' element should be updated with each major revision of the document, which generally should stay in step with the component being documented. There may be multiple revisions of the document corresponding to a given version of the component.

It may be easiest to update the Metadata when you first create the document, and then get into the
habit of updating it with details of the changes when the document is released. Or you may wish to update the metadata on each change. How you use it is up to you, but to be the most use to your readers, it should convey pertinent change information which helps them to understand how those changes affect them.


## Splitting up documentation

In general the RISC OS PRMs are organised into chapters which document an individual module, or a conceptual area. For example, the Window Manager is documented in a single chapter. This is actually quite unwieldy, and may be better handled in multiple chapters. Most of the time, though, it will make sense to document a module, command or resource in a single chapter.

When it comes to deciding how to separate out documentation, it is useful to consider the sections of the documentation that you will be creating. For example, the 'Technical details' section will be where the concepts and structures will be explained. If this section will cover many different areas, then it may be more appropriate to split the documentation into separate chapters.

Do not be concerned if the documentation you produce is actually very short. If the component being documented is simple and does not have much in the way of interactions with the rest of the system, this can be entirely reasonable.


## Checking that the format is right

The formatting of the document as HTML may work just fine for many documents which do not follow the stricter rules required by the PRM-in-XML DTD. This DTD defines what we expect to see in the document. If you deviate from this, it may work with the renderer but isn't guaranteed to work in the future, or with other parsers. The idea of the PRM-in-XML format is that others can parse the content to generate other documentation, or maybe even interface definitions.

There is a lint process that can be invoked from the PRM-in-XML tool which will check against this DTD.

    ßriscos-prminxml -f lint prminxml/diceroller.xml

This will show any structural issues with the document.
