<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet for HTML covers.

     Generates a simple page for covers in HTML 5/CSS.
     (c) Gerph, distribution unlimited.
     Version 1.03.
  -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:output method="html" indent="no" encoding="utf-8"/>


<xsl:template match="/">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html>
<xsl:comment>
  Auto-generated using XSLT stylesheet created by Gerph.
</xsl:comment>
<xsl:apply-templates select="//cover"/>
</html>
</xsl:template>

<xsl:template match="text()" />

<xsl:template match="cover">
<head>
  <meta charset="utf-8"/>
  <title>
    <xsl:value-of select='@title'/>
  </title>
</head>

<body>
    <h1 align='center'>
        <xsl:value-of select='@title'/>
    </h1>
    <h2 align='center'>
        <xsl:value-of select='@subtitle'/>
    </h2>
    <div>
        <img title="Cover image">
            <xsl:attribute name="src">
                <xsl:value-of select="@src"/>
            </xsl:attribute>
        </img>
    </div>
    <h3 align='right'>
        <xsl:value-of select='@publisher'/><br/>
        <xsl:value-of select='@author'/>
    </h3>
</body>

</xsl:template>

</xsl:stylesheet>
