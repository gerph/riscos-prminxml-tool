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

INDEX_XML = </xsl:text>
<xsl:value-of select="$index-xml" />
<xsl:text>
OUTPUT_DIR = </xsl:text>
<xsl:value-of select="//dirs/@output" />
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

<xsl:text>all: images indices \&#10;</xsl:text>
<xsl:apply-templates select="//page" mode="targets"/>
<xsl:apply-templates select="//help" mode="targets"/>
<xsl:apply-templates select="//page" mode="header-targets"/>
<xsl:apply-templates select="//page" mode="sourcexml-targets"/>
<xsl:text>&#10;&#10;</xsl:text>
<xsl:apply-templates select="//page"/>
<xsl:apply-templates select="//help"/>
<xsl:apply-templates select="//page" mode="header-build"/>
<xsl:apply-templates select="//page" mode="sourcexml-build"/>
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
<xsl:apply-templates select="//page" mode="sourcexml-clean"/>
<xsl:text>clean-html: &#10;</xsl:text>
<xsl:apply-templates select="//page" mode="clean"/>
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

SVGS_SRC = $(shell find &inputdir; -type f -name '*.svg')
SVGS_DEST = $(patsubst &inputdir;/%.svg, &outputdir;/%.svg, $(SVGS_SRC))

images: $(DRAWFILES_DEST) $(PNGS_DEST) $(SVGS_DEST)
clean-images:
&indent;&remove; $(DRAWFILES_DEST) $(PNGS_DEST) $(SVGS_DEST)

&outputdir;/%.draw: &inputdir;/%.draw
&indent;@mkdir -p "$(@D)"
&indent;@cp "$&lt;" "$@"

&outputdir;/%.png: &inputdir;/%.png
&indent;@mkdir -p "$(@D)"
&indent;@cp "$&lt;" "$@"

&outputdir;/%.svg: &inputdir;/%.svg
&indent;@mkdir -p "$(@D)"
&indent;@cp "$&lt;" "$@"

indices: ${INDEX_XML}
&indent;xsltproc -stringparam base-dir "$$(pwd)" -o "${OUTPUT_DIR}/index.html" http://gerph.org/dtd/102/prmindex-html.xsl "${INDEX_XML}"

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
 <xsl:text>http://gerph.org/dtd/102/prm-command.xsl</xsl:text>
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
 <xsl:text>http://gerph.org/dtd/102/prm-header.xsl</xsl:text>
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
<xsl:template match="page" mode="sourcexml-targets">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>&outputdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>&escaped_extsep;xml</xsl:text>
 <xsl:text> \&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="page" mode="sourcexml-clean">
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

<xsl:template match="page" mode="sourcexml-build">
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
<xsl:template match="page" mode="targets">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>&outputdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>&escaped_extsep;html</xsl:text>
 <xsl:text> \&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="page" mode="validate">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-xmllint &throwback; --noout --valid &inputdir;/</xsl:text>
 <xsl:apply-templates mode="uri" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>.xml</xsl:text>
 <xsl:text>&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="page" mode="clean">
<xsl:if test="@href != ''">
 <xsl:text>&indent;</xsl:text>
 <xsl:text>-@&remove; &outputdir;&dirsep;</xsl:text>
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
 <xsl:text>&extsep;html</xsl:text>
 <xsl:text>&#10;</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="page">
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
 <xsl:text> </xsl:text>
 <xsl:text>http://gerph.org/dtd/102/prm-html.xsl</xsl:text>
 <xsl:text> </xsl:text>
 <xsl:text>&inputdir;&dirsep;</xsl:text>
 <xsl:value-of select="$uri" /><xsl:text>.xml</xsl:text>
 <xsl:text>&#10;</xsl:text>
</xsl:if>

</xsl:template>

</xsl:stylesheet>
