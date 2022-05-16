<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet for HTML covers.

     Generates a simple page for covers in HTML 5/CSS.
     (c) Gerph, distribution unlimited.
     Version 1.03.
  -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict"
                xmlns:localdb="local-file-database"
                xmlns:saxon="http://icl.com/saxon"
                xmlns:str="http://exslt.org/strings"
                xmlns:exslt="http://exslt.org/common"
                xmlns:pixparams="http://gerph.org/dtd/prminxml-params"
                exclude-result-prefixes="localdb saxon str exslt pixparams">

<xsl:include href="http://gerph.org/dtd/bnf/100/html.xsl" />

<xsl:param name="css-base">standard</xsl:param>
<xsl:param name="css-variant">none</xsl:param>
<xsl:param name="css-file">none</xsl:param>

<xsl:output method="html" indent="no" encoding="utf-8"/>


<xsl:template match="/">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html lang='en'>
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

  <meta name='description'>
   <xsl:attribute name='content'>
    <xsl:value-of select='@title'/>
   </xsl:attribute>
  </meta>

  <title>
    <xsl:value-of select='@title'/>
  </title>
  <xsl:call-template name='head-css'/>
</head>

<body class='cover'>

<article>
    <h1 class='cover-title'>
        <xsl:value-of select='@title'/>
    </h1>
    <h2 class='cover-subtitle'>
        <xsl:value-of select='@subtitle'/>
    </h2>
    <img class='cover-image'>
        <xsl:attribute name="src">
            <xsl:value-of select="@src"/>
        </xsl:attribute>
    </img>
    <h3 class='cover-publisher'>
        <xsl:value-of select='@publisher'/>
    </h3>
    <h3 class='cover-author'>
        <xsl:value-of select='@author'/>
    </h3>
</article>

</body>

</xsl:template>



<xsl:template name='head-css'>
<xsl:variable name="prm-css" select="document('prm-css.xml')/prm-css" />
<xsl:if test="$css-base != 'none'">
 <style type='text/css'>
  <xsl:value-of disable-output-escaping='yes' select="$prm-css/css[@type=$css-base and not(@variant)]"/>
 </style>
 <xsl:for-each select='str:tokenize($css-variant, " ")'>
  <xsl:variable name="variant" select="text()" />
  <xsl:if test="$variant != 'none'">
   <xsl:choose>
    <xsl:when test="$prm-css/css[@type=$css-base and @variant=$variant]">
     <style type='text/css'>
       <xsl:value-of disable-output-escaping='yes' select="$prm-css/css[@type=$css-base and @variant=$variant]"/>
     </style>
    </xsl:when>
    <xsl:when test="$prm-css/css[@variant=$variant]">
     <style type='text/css'>
       <xsl:value-of disable-output-escaping='yes' select="$prm-css/css[not(@type) and @variant=$variant]"/>
     </style>
    </xsl:when>
    <xsl:otherwise>
     <xsl:message>CSS variant '<xsl:value-of select="$variant"/>' is not known.</xsl:message>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:if>
 </xsl:for-each>
</xsl:if>
<xsl:if test="$css-file != 'none' and $css-file != ''">
 <link rel="stylesheet">
  <xsl:attribute name='href'>
   <xsl:value-of select="$css-file"/>
  </xsl:attribute>
 </link>
</xsl:if>
</xsl:template>



</xsl:stylesheet>
