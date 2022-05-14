<?xml version="1.0" standalone="yes"?>

<!-- Index file for RISC OS documentation by RISCOS Ltd.
     Based on style sheet originally created by Justin Fletcher
     for his documentation project. -->

<!DOCTYPE doc [
<!-- <!ENTITY escaped_extsep "&lt;47&gt;"> -->
<!-- <!ENTITY extsep "/"> -->
<!-- <!ENTITY dirsep "."> -->
<!ENTITY escaped_extsep ".">
<!ENTITY extsep ".">
<!ENTITY dirsep "/">
<!ENTITY indent "&#9;">
<!-- <!ENTITY remove "remove"> -->
<!ENTITY remove "rm -f">
<!ENTITY removedir "rmdir -p">
<!-- <!ENTITY throwback "&#45;&#45;throwback"> -->
<!ENTITY throwback "">
<!ENTITY outputdir "${OUTPUT_DIR}">
<!ENTITY indexdir "${INDEX_DIR}">
<!ENTITY helpdir "${HELP_DIR}">
<!ENTITY headerdir "${HEADER_DIR}">
<!ENTITY inputdir "${INPUT_DIR}">
<!ENTITY tempdir "${TEMP_DIR}">
]>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" indent="no" />

<xsl:param name="index-xml">index.xml</xsl:param>

<xsl:template match="/">
<xsl:text># Makefile for building all the documetation
# (this file is autogenerated)
#

# Configured directories
INDEX_XML = </xsl:text>
<xsl:value-of select="$index-xml" />
<xsl:text>
OUTPUT_DIR = </xsl:text>
<xsl:value-of select="//dirs/@output" />
<xsl:text>
INDEX_DIR = </xsl:text>
<xsl:value-of select="//dirs/@index" />
<xsl:text>
HELP_DIR = </xsl:text>
<xsl:value-of select="//dirs/@help" />
<xsl:text>
HEADER_DIR = </xsl:text>
<xsl:value-of select="//dirs/@header" />
<xsl:text>
INPUT_DIR = </xsl:text>
<xsl:value-of select="//dirs/@input" />
<xsl:text>

TEMP_DIR = </xsl:text>
<xsl:value-of select="//dirs/@temp" />
<xsl:text>

</xsl:text>

<xsl:text>
# Configured options
CATALOG_VERSION = </xsl:text>
<xsl:value-of select="//options/@catalog-version"/>
<xsl:text>
CATALOG_VERSION := $(if ${CATALOG_VERSION},${CATALOG_VERSION},102)</xsl:text>
<xsl:text>
PAGE_FORMAT = </xsl:text>
<xsl:value-of select="//options/@page-format"/>
<xsl:text>
PAGE_FORMAT := $(if ${PAGE_FORMAT},${PAGE_FORMAT},html)
</xsl:text>

<xsl:text>
PAGE_CSS_BASE = </xsl:text>
<xsl:value-of select="//options/@page-css-base"/>
<xsl:text>
PAGE_CSS_BASE := $(if ${PAGE_CSS_BASE},${PAGE_CSS_BASE},standard)
</xsl:text>

<xsl:text>
PAGE_CSS_VARIANT = </xsl:text>
<xsl:value-of select="//options/@page-css-variant"/>
<xsl:text>
</xsl:text>

<xsl:text>
PAGE_CSS_FILE = </xsl:text>
<xsl:value-of select="//options/@page-css-file"/>
<xsl:text>
</xsl:text>


<xsl:text>
INDEX_CSS_BASE = </xsl:text>
<xsl:value-of select="//options/@index-css-base"/>
<xsl:text>
INDEX_CSS_BASE := $(if ${INDEX_CSS_BASE},${INDEX_CSS_BASE},standard)
</xsl:text>

<xsl:text>
INDEX_CSS_VARIANT = </xsl:text>
<xsl:value-of select="//options/@index-css-variant"/>
<xsl:text>
</xsl:text>

<xsl:text>
INDEX_CSS_FILE = </xsl:text>
<xsl:value-of select="//options/@index-css-file"/>
<xsl:text>
</xsl:text>


<xsl:text>

all: images indices \&#10;</xsl:text>
<xsl:if test='//make-indexdata'>
    <xsl:text>&indent;&indexdir;&dirsep;index-data.xml \&#10;</xsl:text>
</xsl:if>
<xsl:apply-templates select="//page|//front-matter[@href != '']|//cover" mode="targets"/>
<xsl:apply-templates select="//help" mode="targets"/>
<xsl:apply-templates select="//page" mode="header-targets"/>
<xsl:apply-templates select="//page|//front-matter[@href != '']" mode="sourcexml-targets"/>
<xsl:text>&#10;&#10;</xsl:text>
<xsl:apply-templates select="//page|//front-matter[@href != '']|//cover"/>
<xsl:apply-templates select="//help"/>
<xsl:apply-templates select="//page" mode="header-build"/>
<xsl:apply-templates select="//page|//front-matter[@href != '']" mode="sourcexml-build"/>
<xsl:text>&#10;</xsl:text>
<xsl:text>&#10;</xsl:text>
<xsl:text>validate: &#10;</xsl:text>
<xsl:apply-templates select="//page" mode="validate"/>
<xsl:text>&#10;</xsl:text>
<xsl:text>&#10;</xsl:text>
<xsl:text>clean: clean-headers clean-html clean-sourcexml clean-help clean-images&#10;</xsl:text>
<xsl:text>clean-help: &#10;</xsl:text>
<xsl:apply-templates select="//help" mode="clean"/>
<xsl:text>clean-headers: &#10;</xsl:text>
<xsl:apply-templates select="//page" mode="header-clean"/>
<xsl:text>clean-sourcexml: &#10;</xsl:text>
<xsl:apply-templates select="//page|//front-matter[@href != '']" mode="sourcexml-clean"/>
<xsl:text>clean-html: &#10;</xsl:text>
<xsl:apply-templates select="//page|//front-matter[@href != '']|//cover" mode="clean"/>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-swis.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-swis.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-swis-n.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-commands.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-commands.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-messages.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-messages.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-messages-n.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-upcalls.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-upcalls.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-upcalls-n.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-services.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-services.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-services-n.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-sysvars.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-sysvars.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-entrys.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-entrys.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-vectors.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-vectors.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-vectors-n.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-errors.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-errors.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-errors-n.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-vdus.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-vdus.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-vdus-n.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-tboxmethods.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-tboxmethods.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-tboxmethods-n.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-tboxmessages.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-tboxmessages.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-tboxmessages-n.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-source.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &tempdir;&dirsep;index-sections.xml&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;index-sections.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; &outputdir;&dirsep;contents-*.html&#10;</xsl:text>
<xsl:text>&indent;-&remove; logs&dirsep;*stdout&#10;</xsl:text>

<xsl:text>
DRAWFILES_SRC = $(shell find &inputdir; -type f -name '*.draw')
DRAWFILES_DEST = $(patsubst &inputdir;/%.draw, &outputdir;/%.draw, $(DRAWFILES_SRC))

PNGS_SRC = $(shell find &inputdir; -type f -name '*.png')
PNGS_DEST = $(patsubst &inputdir;/%.png, &outputdir;/%.png, $(PNGS_SRC))

GIFS_SRC = $(shell find &inputdir; -type f -name '*.gif')
GIFS_DEST = $(patsubst &inputdir;/%.gif, &outputdir;/%.gif, $(GIFS_SRC))

SVGS_SRC = $(shell find &inputdir; -type f -name '*.svg')
SVGS_DEST = $(patsubst &inputdir;/%.svg, &outputdir;/%.svg, $(SVGS_SRC))

images: $(DRAWFILES_DEST) $(PNGS_DEST) $(GIFS_DEST) $(SVGS_DEST)
clean-images:
&indent;&remove; $(DRAWFILES_DEST) $(PNGS_DEST) $(GIFS_DEST) $(SVGS_DEST)

&outputdir;/%.draw: &inputdir;/%.draw
&indent;@mkdir -p "$(@D)"
&indent;@cp "$&lt;" "$@"

&outputdir;/%.png: &inputdir;/%.png
&indent;@mkdir -p "$(@D)"
&indent;@cp "$&lt;" "$@"

&outputdir;/%.gif: &inputdir;/%.gif
&indent;@mkdir -p "$(@D)"
&indent;@cp "$&lt;" "$@"

&outputdir;/%.svg: &inputdir;/%.svg
&indent;@mkdir -p "$(@D)"
&indent;@cp "$&lt;" "$@"

indices: ${INDEX_XML}
&indent;xsltproc --stringparam css-base '${INDEX_CSS_BASE}' --stringparam css-variant '${INDEX_CSS_VARIANT}' --stringparam css-file '${INDEX_CSS_FILE}' </xsl:text>
<xsl:apply-templates select="/" mode="docgroup-name"/>
<xsl:apply-templates select="/" mode="docgroup-part"/>
<xsl:apply-templates mode="edgeindex-number" select="/"/>
<xsl:apply-templates mode="edgeindex-max" select="/"/>
<!-- Note that we need to be careful with the base directory here - if it contains spaces or any other special characters they will need to be escaped -->
<xsl:text> -stringparam base-dir "$$(pwd | sed 's/ /%20/g')" -o "${OUTPUT_DIR}/index.html" http://gerph.org/dtd/${CATALOG_VERSION}/prmindex-${PAGE_FORMAT}.xsl "${INDEX_XML}"

&indexdir;&dirsep;index-data.xml: ${INDEX_XML}
&indent;xsltproc -stringparam base-dir "$$(pwd | sed 's/ /%20/g')" -o "${INDEX_DIR}/index-data.xml" http://gerph.org/dtd/${CATALOG_VERSION}/prmindex-data.xsl "${INDEX_XML}"

</xsl:text>

</xsl:template>

<!-- This recurses up the tree, processing each section with a directory to
     create a full path as its result -->
<xsl:template match="section" mode="uri">
<xsl:if test="@dir != ''">
 <xsl:apply-templates select=".." mode="uri" />
 <xsl:value-of select="@dir" />
 <xsl:text>/</xsl:text>
</xsl:if>
</xsl:template>
<xsl:template match="*" mode="uri"/>
<!-- and the same thing but as a RISC OS name -->
<xsl:template match="section" mode="dir">
<xsl:if test="@dir != ''">
 <xsl:apply-templates select=".." mode="dir" />
 <xsl:value-of select="@dir" />
 <xsl:text>&dirsep;</xsl:text>
</xsl:if>
</xsl:template>
<xsl:template match="*" mode="dir"/>

<!-- Similar recursion, to get the docgroup-name to use (or none) -->
<xsl:template match="section" mode="docgroup-name">
<xsl:choose>
    <xsl:when test="@docgroup-name != ''">
        <xsl:text> --stringparam override-docgroup '</xsl:text>
        <xsl:value-of select="@docgroup-name" />
        <xsl:text>'</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        <xsl:apply-templates select=".." mode="docgroup-name" />
    </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="index" mode="docgroup-name">
<xsl:if test="//options/@docgroup-name != ''">
 <xsl:text> --stringparam override-docgroup '</xsl:text>
 <xsl:value-of select="//options/@docgroup-name" />
 <xsl:text>'</xsl:text>
</xsl:if>
</xsl:template>
<xsl:template match="*" mode="docgroup-name"/>

<!-- Similar recursion, to get the docgroup-part to use (or none) -->
<xsl:template match="section" mode="docgroup-part">
<xsl:choose>
    <xsl:when test="@docgroup-part != ''">
        <xsl:text> --stringparam override-docgroup-part '</xsl:text>
        <xsl:value-of select="@docgroup-part" />
        <xsl:text>'</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        <xsl:apply-templates select=".." mode="docgroup-part" />
    </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="index" mode="docgroup-part">
<xsl:if test="//options/@docgroup-part != ''">
 <xsl:text> --stringparam override-docgroup-part '</xsl:text>
 <xsl:value-of select="//options/@docgroup-part" />
 <xsl:text>'</xsl:text>
</xsl:if>
</xsl:template>
<xsl:template match="*" mode="docgroup-part"/>

<!-- Similar recursion, to get the edgeindex-number to use (or none) -->
<xsl:template match="section" mode="edgeindex-number">
<xsl:choose>
    <xsl:when test="@edgeindex != ''">
        <xsl:text> --stringparam edgeindex '</xsl:text>
        <xsl:value-of select="@edgeindex" />
        <xsl:text>'</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        <xsl:apply-templates select=".." mode="edgeindex-number" />
    </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="index" mode="edgeindex-number">
<xsl:if test="//options/@edgeindex-number != ''">
 <xsl:text> --stringparam edgeindex '</xsl:text>
 <xsl:value-of select="//options/@edgeindex" />
 <xsl:text>'</xsl:text>
</xsl:if>
</xsl:template>
<xsl:template match="*" mode="edgeindex-number"/>

<!-- Similar recursion, to get the edgeindex-max to use (or none) -->
<xsl:template match="index" mode="edgeindex-max">
<xsl:if test="//options/@edgeindex-max != ''">
 <xsl:text> --stringparam edgeindex-max '</xsl:text>
 <xsl:value-of select="//options/@edgeindex-max" />
 <xsl:text>'</xsl:text>
</xsl:if>
</xsl:template>
<xsl:template match="*" mode="edgeindex-max"/>


<xsl:template match="text()">
<!-- <xsl:variable name="t" select="." /> -->
<!-- <xsl:value-of select="translate($t,'&#10;',' ')" /> -->
</xsl:template>

<!-- HELP generation -->
<xsl:template match="help" mode="targets">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>&helpdir;&dirsep;</xsl:text>
 <!-- <xsl:apply-templates mode="dir" select=".."/> -->
 <xsl:value-of select="@path"/>
 <xsl:text>&dirsep;</xsl:text>
 <xsl:value-of select="@href"/>
 <xsl:text>&escaped_extsep;txt</xsl:text>
 <xsl:text> \&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="help" mode="clean">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-&remove; &helpdir;&dirsep;</xsl:text>
 <!-- <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/> -->
 <xsl:value-of select="@path"/>
 <xsl:text>&dirsep;</xsl:text>
 <xsl:value-of select="@href"/>
 <xsl:text>&extsep;txt</xsl:text>
 <xsl:text>&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="help">
<xsl:if test="@href != ''">
 <xsl:variable name="dir">
  <!-- <xsl:apply-templates mode="dir" select=".."/>
  <xsl:value-of select="@href"/> -->
  <xsl:value-of select="@path"/>
  <xsl:text>&dirsep;</xsl:text>
  <xsl:value-of select="@href"/>
 </xsl:variable>
 <xsl:variable name="uri">
  <!-- <xsl:apply-templates mode="uri" select=".."/> -->
  <xsl:value-of select="@path"/>
  <xsl:text>&dirsep;</xsl:text>
  <xsl:value-of select="@href"/>
 </xsl:variable>

 <!-- build rule -->
 <xsl:text>&helpdir;&dirsep;</xsl:text>
 <xsl:value-of select="$dir" /><xsl:text>&escaped_extsep;txt</xsl:text>
 <xsl:text>: </xsl:text>
 <xsl:text>&inputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$dir" /><xsl:text>&escaped_extsep;xml</xsl:text>
 <xsl:text>&#10;</xsl:text>

 <xsl:text>&indent;</xsl:text>
 <xsl:text>xsltproc -output </xsl:text>
 <xsl:text>&helpdir;&dirsep;</xsl:text>
 <xsl:value-of select="$uri" /><xsl:text>.txt</xsl:text>
 <xsl:text> </xsl:text>
 <xsl:text>http://gerph.org/dtd/${CATALOG_VERSION}/prm-command.xsl</xsl:text>
 <xsl:text> </xsl:text>
 <xsl:text>&inputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$uri" /><xsl:text>.xml</xsl:text>
 <xsl:text>&#10;</xsl:text>
</xsl:if>
</xsl:template>


<!-- Header generation -->
<xsl:template match="page" mode="header-targets">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>&headerdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>&escaped_extsep;h</xsl:text>
 <xsl:text> \&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="page" mode="header-clean">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-@&remove; &headerdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>&extsep;h</xsl:text>
 <xsl:text>&#10;</xsl:text>
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-@&removedir; &headerdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:text>&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="page" mode="header-build">
<xsl:if test="@href != ''">
 <xsl:variable name="dir">
  <xsl:apply-templates mode="dir" select=".."/>
  <xsl:value-of select="@href"/>
 </xsl:variable>
 <xsl:variable name="uri">
  <xsl:apply-templates mode="uri" select=".."/>
  <xsl:value-of select="@href"/>
 </xsl:variable>

 <!-- build rule -->
 <xsl:text>&headerdir;&dirsep;</xsl:text>
 <xsl:value-of select="$dir" /><xsl:text>&escaped_extsep;h</xsl:text>
 <xsl:text>: </xsl:text>
 <xsl:text>&inputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$dir" /><xsl:text>&escaped_extsep;xml</xsl:text>
 <xsl:text>&#10;</xsl:text>

 <xsl:text>&indent;</xsl:text>
 <xsl:text>xsltproc -output </xsl:text>
 <xsl:text>&headerdir;&dirsep;</xsl:text>
 <xsl:value-of select="$uri" /><xsl:text>.h</xsl:text>
 <xsl:text> </xsl:text>
 <xsl:text>http://gerph.org/dtd/${CATALOG_VERSION}/prm-header.xsl</xsl:text>
 <xsl:text> </xsl:text>
 <xsl:text>&inputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$uri" /><xsl:text>.xml</xsl:text>
 <xsl:text>&#10;</xsl:text>

 <xsl:text>&indent;</xsl:text>
 <xsl:text>-@&removedir; &headerdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:text>&#10;</xsl:text>

</xsl:if>
</xsl:template>

<!-- Source XML generation -->
<xsl:template match="page|front-matter[@href != '']" mode="sourcexml-targets">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>&outputdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>&escaped_extsep;xml</xsl:text>
 <xsl:text> \&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="page|front-matter[@href != '']" mode="sourcexml-clean">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-@&remove; &outputdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>&extsep;xml</xsl:text>
 <xsl:text>&#10;</xsl:text>
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-@&removedir; &outputdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:text>&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="page|front-matter[@href != '']" mode="sourcexml-build">
<xsl:if test="@href != ''">
 <xsl:variable name="dir">
  <xsl:apply-templates mode="dir" select=".."/>
  <xsl:value-of select="@href"/>
 </xsl:variable>
 <xsl:variable name="uri">
  <xsl:apply-templates mode="uri" select=".."/>
  <xsl:value-of select="@href"/>
 </xsl:variable>

 <!-- build rule -->
 <xsl:text>&outputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$dir" /><xsl:text>&escaped_extsep;xml</xsl:text>
 <xsl:text>: </xsl:text>
 <xsl:text>&inputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$dir" /><xsl:text>&escaped_extsep;xml</xsl:text>
 <xsl:text>&#10;</xsl:text>

 <xsl:text>&indent;</xsl:text>
 <xsl:text>cp </xsl:text>
 <xsl:text>&inputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$uri" /><xsl:text>.xml</xsl:text>
 <xsl:text> </xsl:text>
 <xsl:text>&outputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$uri" /><xsl:text>.xml</xsl:text>
 <xsl:text>&#10;</xsl:text>

</xsl:if>
</xsl:template>



<!-- PAGE generation -->
<xsl:template match="page|front-matter[@href != '']" mode="targets">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>&outputdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>&escaped_extsep;html</xsl:text>
 <xsl:text> \&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="cover" mode="targets">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>&outputdir;&dirsep;_cover_&escaped_extsep;html</xsl:text>
 <xsl:text> \&#10;</xsl:text>
</xsl:template>

<xsl:template match="page|front-matter[@href != '']" mode="validate">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-xmllint &throwback; --noout --valid &inputdir;/</xsl:text>
 <xsl:apply-templates mode="uri" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>.xml</xsl:text>
 <xsl:text>&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="page|front-matter[@href != '']" mode="clean">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-@&remove; &outputdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>&extsep;html</xsl:text>
 <xsl:text>&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="cover" mode="clean">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-@&remove; &outputdir;&dirsep;_cover_&escaped_extsep;html</xsl:text>
 <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="page|front-matter[@href != '']">
<xsl:if test="@href != ''">
 <xsl:variable name="dir">
  <xsl:apply-templates mode="dir" select=".."/>
  <xsl:value-of select="@href"/>
 </xsl:variable>
 <xsl:variable name="uri">
  <xsl:apply-templates mode="uri" select=".."/>
  <xsl:value-of select="@href"/>
 </xsl:variable>

 <!-- build rule -->
 <xsl:text>&outputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$dir" /><xsl:text>&escaped_extsep;html</xsl:text>
 <xsl:text>: </xsl:text>
 <xsl:text>&inputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$dir" /><xsl:text>&escaped_extsep;xml</xsl:text>
 <xsl:text>&#10;</xsl:text>

 <xsl:text>&indent;</xsl:text>
 <xsl:text>xsltproc -output </xsl:text>
 <xsl:text>&outputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$uri" /><xsl:text>.html</xsl:text>
 <xsl:text> --stringparam css-base '${PAGE_CSS_BASE}'</xsl:text>

 <xsl:text> --stringparam css-variant '${PAGE_CSS_VARIANT}</xsl:text>
 <xsl:if test="@css-variant and @css-variant != ''">
    <xsl:value-of select="@css-variant"/>
 </xsl:if>
 <xsl:text>'</xsl:text>

  <xsl:text> --stringparam css-file '${PAGE_CSS_FILE}'</xsl:text>
 <xsl:choose>
    <xsl:when test="local-name() = 'front-matter'">
        <xsl:text> --stringparam create-contents 'no'</xsl:text>
    </xsl:when>

    <xsl:when test="//options/@chapter-contents">
        <xsl:text> --stringparam create-contents </xsl:text>
        <xsl:value-of select="//options/@chapter-contents"/>
    </xsl:when>
 </xsl:choose>
 <xsl:if test="local-name() = 'front-matter'">
    <xsl:text> --stringparam front-matter '</xsl:text>
    <xsl:value-of select='@type'/>
    <xsl:text>'</xsl:text>
 </xsl:if>
 <xsl:apply-templates mode="docgroup-name" select=".."/>
 <xsl:apply-templates mode="docgroup-part" select=".."/>
 <xsl:apply-templates mode="edgeindex-number" select=".."/>
 <xsl:apply-templates mode="edgeindex-max" select="/"/>
 <xsl:if test="//options/@chapter-numbers = 'yes' and local-name() != 'front-matter'">
  <xsl:text> --stringparam override-chapter-number '</xsl:text>
  <xsl:value-of select="count(preceding::page) + 1"/>
  <xsl:text>'</xsl:text>
 </xsl:if>
 <xsl:text> </xsl:text>
 <xsl:text>http://gerph.org/dtd/${CATALOG_VERSION}/prm-${PAGE_FORMAT}.xsl</xsl:text>
 <xsl:text> </xsl:text>
 <xsl:text>&inputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$uri" /><xsl:text>.xml</xsl:text>
 <xsl:text>&#10;</xsl:text>
</xsl:if>

</xsl:template>



<xsl:template match="cover">
 <xsl:variable name="uri">
  <xsl:apply-templates mode="uri" select=".."/>
  <xsl:value-of select="@src"/>
 </xsl:variable>

 <!-- build rule -->
 <xsl:text>&outputdir;&dirsep;_cover_&escaped_extsep;html</xsl:text>
 <xsl:text>: </xsl:text>
 <xsl:text>${INDEX_XML} </xsl:text>
 <xsl:choose>
    <xsl:when test="@src">
        <xsl:text>&inputdir;&dirsep;</xsl:text>
        <xsl:value-of select="@src" />
    </xsl:when>
    <xsl:otherwise>
        <xsl:text>&inputdir;&dirsep;</xsl:text>
        <xsl:value-of select="@html" />
    </xsl:otherwise>
 </xsl:choose>
 <xsl:text>&#10;</xsl:text>

 <xsl:choose>
    <xsl:when test="@src">
        <xsl:text>&indent;</xsl:text>
        <xsl:text>xsltproc -output </xsl:text>
        <xsl:text>&outputdir;&dirsep;_cover_.html</xsl:text>
        <xsl:text> --stringparam css-base '${PAGE_CSS_BASE}'</xsl:text>

        <xsl:text> --stringparam css-variant '${PAGE_CSS_VARIANT}</xsl:text>
        <xsl:if test="@css-variant and @css-variant != ''">
            <xsl:value-of select="@css-variant"/>
        </xsl:if>
        <xsl:text>'</xsl:text>

        <xsl:text> --stringparam css-file '${PAGE_CSS_FILE}'</xsl:text>
        <xsl:text> </xsl:text>
        <xsl:text>http://gerph.org/dtd/${CATALOG_VERSION}/prmcover-${PAGE_FORMAT}.xsl</xsl:text>
        <xsl:text> </xsl:text>
        <xsl:text>${INDEX_XML}</xsl:text>
        <xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        <xsl:text>&indent;cp "&inputdir;&dirsep;</xsl:text>
        <xsl:value-of select="@html" />
        <xsl:text>" "$@"</xsl:text>
        <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
 </xsl:choose>

</xsl:template>

</xsl:stylesheet>
