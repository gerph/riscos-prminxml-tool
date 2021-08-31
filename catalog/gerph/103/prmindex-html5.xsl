<?xml version="1.0" standalone="yes"?>

<!-- Index file for RISC OS documentation by RISCOS Ltd.
     Based on style sheet originally created by Justin Fletcher
     for his documentation project.

     For more details on this style sheet, contact gerph@gerph.org.
  -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:localdb="local-file-database"
                xmlns:str="http://exslt.org/strings"
                xmlns="http://www.w3.org/TR/xhtml1/strict">





<localdb:sections type="source" filename="source" title="XML" />
<localdb:sections type="command" filename="commands" title="Commands" />
<localdb:sections type="swi" filename="swis" title="SWIs" number="yes"/>
<localdb:sections type="upcall" filename="upcalls" title="UpCalls" number="yes"/>
<localdb:sections type="message" filename="messages" title="Messages" number="yes"/>
<localdb:sections type="service" filename="services" title="Services" number="yes"/>
<localdb:sections type="vector" filename="vectors" title="Vectors" number="yes"/>
<localdb:sections type="sysvar" filename="sysvars" title="SysVars" />
<localdb:sections type="entry" filename="entrys" title="Entry points" />
<localdb:sections type="error" filename="errors" title="Errors" number="yes"/>
<localdb:sections type="vdu" filename="vdus" title="VDU codes" number="no"/>
<localdb:sections type="tboxmethod" filename="tboxmethods" title="TBox methods" number="yes"/>
<localdb:sections type="tboxmessage" filename="tboxmessages" title="TBox messages" number="yes"/>

<xsl:output method="html" indent="no"/>

<xsl:param name="include-source" select="//options/@include-source" />
<xsl:param name="hide-empty" select="//options/@hide-empty" />
<xsl:param name="make-contents" select="//options/@make-contents" />
<xsl:param name="include-sections" select="//options/@include-sections" />
<xsl:param name="include-sections-depth" select="//options/@include-sections-depth" />

<xsl:param name="base-dir" select="'.'"/>
<xsl:param name="output-dir" select="//dirs/@output" />
<xsl:param name="input-dir" select="//dirs/@input" />
<xsl:param name="temp-dir" select="//dirs/@temp" />

<!-- These are handled the same as in the prm-html5.xsl file -->
<xsl:param name="css-base">standard</xsl:param>
<xsl:param name="css-variant">no-thumb-bar</xsl:param>
<xsl:param name="css-file">none</xsl:param>

<xsl:variable name="title-to-id-src">ABCDEFGHIJKLMNOPQRSTUVWXYZ ,$:()-*?</xsl:variable>
<xsl:variable name="title-to-id-map">abcdefghijklmnopqrstuvwxyz_-_-</xsl:variable>

<xsl:template match="/">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html lang='en'>
 <xsl:apply-templates />
</html>
</xsl:template>

<!-- hide the footer declaration when producing the index itself -->
<xsl:template match="footer">
</xsl:template>

<xsl:template match="make-index">
<xsl:param name="index-entity" />
<xsl:variable name="type" select="@type" />
<xsl:if test="($index-entity = '')">
 <!-- Produce an organised contents page -->
 <xsl:message>
  <xsl:text>Processing </xsl:text>
  <xsl:value-of select="@type" />
  <xsl:text>:</xsl:text>
 </xsl:message>

 <xsl:if test="$make-contents = 'yes'">
  <xsl:message>  Contents</xsl:message>
  <xsl:document href="{concat('contents-',@type,'s.html')}" method="xml" indent="no">
   <html>
    <xsl:apply-templates select="/index">
     <xsl:with-param name="index-entity" select="@type" />
    </xsl:apply-templates>
   </html>
  </xsl:document>
 </xsl:if>
 
 <xsl:message>  Index</xsl:message>
 <!-- Now produce some index xml files -->
 <xsl:document href="{concat($base-dir, '/', $temp-dir, '/', 'index-',@type,'s.xml')}" method="xml" indent="no">
  <index xmlns="">
   <xsl:apply-templates select="//page" mode="index">
    <xsl:with-param name="index-entity" select="@type" />
   </xsl:apply-templates>
  </index>
 </xsl:document>
 
 <xsl:variable name="document" select="document(concat($base-dir, '/', $temp-dir, '/', 'index-',@type,'s.xml'))" />
 
 <xsl:message>  Sorting (names)</xsl:message>
 <!-- and then produce the HTML for those indexes -->
 <xsl:document href="{concat('index-',@type,'s.html')}" method="xml" indent="no">
<head>
  <meta charset="utf-8"/>
  <title>
    <xsl:text>RISC OS Programmers Reference Manuals : </xsl:text>
    <xsl:text>Index</xsl:text>
    <xsl:choose>
     <xsl:when test="@type != ''">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@type" />
      <xsl:text>)</xsl:text>
     </xsl:when>
    </xsl:choose>
  </title>
 <xsl:call-template name='head-css'/>
</head>
<body class='indexed indexed-index'>
 <xsl:call-template name='index-header'>
  <xsl:with-param name='title'>
    <xsl:text>Index</xsl:text>
    <xsl:choose>
     <xsl:when test="@type != ''">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="document('')//localdb:sections[(@type =$type)]/@title" />
      <xsl:text>)</xsl:text>
     </xsl:when>
    </xsl:choose>
  </xsl:with-param>
 </xsl:call-template>

<xsl:call-template name="index-bar">
 <xsl:with-param name="index-for" select="@type" />
 <xsl:with-param name="position" select="'top'" />
</xsl:call-template>

<section class='indexed-table'>
<table class='indexed-table'>
<tr><th>Link</th>
    <th>Description</th>
    <th>Section</th></tr>
  <xsl:apply-templates select="$document///ref">
<!--    <xsl:sort select="@section" order="ascending" data-type="text" case-order="upper-first" /> -->
   <xsl:sort select="@name" order="ascending" data-type="text" case-order="upper-first" />
  </xsl:apply-templates>
</table>
</section>

<xsl:call-template name="index-bar">
 <xsl:with-param name="index-for" select="@type" />
 <xsl:with-param name="position" select="'bottom'" />
</xsl:call-template>
<xsl:call-template name="footer" mode='render' />
</body>

 </xsl:document>
 
 <xsl:if test="document('')//localdb:sections[(@type=$type) and 
                                              (@number='yes')]">
 <xsl:message>  Sorting (numbers)</xsl:message>
 <!-- and then produce the HTML for those indexes -->
 <xsl:document href="{concat('index-',@type,'s-n.html')}" method="xml" indent="no">
<head>
  <meta charset="utf-8"/>
  <title>
    <xsl:text>RISC OS Programmers Reference Manuals : </xsl:text>
    <xsl:text>Index</xsl:text>
    <xsl:choose>
     <xsl:when test="@type != ''">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@type" />
      <xsl:text> numerically)</xsl:text>
     </xsl:when>
    </xsl:choose>
  </title>
 <xsl:call-template name='head-css'/>
</head>
<body class='indexed indexed-index'>
 <xsl:call-template name='index-header'>
  <xsl:with-param name='title'>
    <xsl:text>Index</xsl:text>
    <xsl:choose>
     <xsl:when test="@type != ''">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="document('')//localdb:sections[(@type =$type)]/@title" />
      <xsl:text> by number)</xsl:text>
     </xsl:when>
    </xsl:choose>
  </xsl:with-param>
 </xsl:call-template>

<xsl:call-template name="index-bar">
 <xsl:with-param name="index-for" select="concat(@type,'-n')" />
 <xsl:with-param name="position" select="'top'" />
</xsl:call-template>

<section class='indexed-table'>
<table class='indexed-table'>
<tr><th align="left">Link</th>
    <th align="left">Description</th>
    <th align="left">Section</th></tr>
  <xsl:choose>
   <xsl:when test="$type = 'tboxmethod'">
    <xsl:apply-templates select="$document///ref">
     <xsl:sort select="@section" order="ascending" data-type="text" case-order="upper-first" />
     <xsl:sort select="@number" order="ascending" data-type="number" />
     <xsl:sort select="count(@reason)" order="ascending" data-type="number" />
     <xsl:sort select="@reason" order="ascending" data-type="number" />
    </xsl:apply-templates>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="$document///ref">
     <xsl:sort select="@number" order="ascending" data-type="number" />
     <!-- we have to sort the reason slightly differently because if not set it might
          end up in the wrong place because its value (number('')) is NaN -->
     <xsl:sort select="count(@reason)" order="ascending" data-type="number" />
     <xsl:sort select="@reason" order="ascending" data-type="number" />
    </xsl:apply-templates>
   </xsl:otherwise>
  </xsl:choose>
</table>
</section>

<xsl:call-template name="index-bar">
 <xsl:with-param name="index-for" select="concat(@type,'-n')" />
 <xsl:with-param name="position" select="'bottom'" />
</xsl:call-template>
<xsl:call-template name="footer" mode='render' />
</body>

 </xsl:document>
 </xsl:if>
</xsl:if>
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



<xsl:template name="footer" mode='render'>
<footer class='indexed-footer'>
    <xsl:apply-templates mode='literal' select='//footer'/>
</footer>
</xsl:template>

<xsl:template match='*' mode='literal'>
<xsl:apply-templates mode='literal'/>
</xsl:template>
<xsl:template match='br' mode='literal'>
<br/>
</xsl:template>

<xsl:template match='p' mode='literal'>
<p><xsl:apply-templates mode='literal'/></p>
</xsl:template>

<xsl:template match="ref">
<tr>
<td><a>
<xsl:attribute name="href"><xsl:value-of select="@href" /></xsl:attribute>
<xsl:value-of select="@name" />
</a></td>
<td><xsl:value-of select="@description" /></td>
<td>
<xsl:value-of select="@section" />
</td>
</tr>
<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template name="index-definition">
<xsl:param name="section" />
<xsl:param name="document" />
<xsl:param name="href" />
<xsl:if test="count($document) > 0">
 <xsl:for-each select="$document">
  <ref xmlns="">
   <xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
   <xsl:attribute name="href">
    <xsl:value-of select="$href"/>
    <xml:text>.html#</xml:text>
    <xsl:value-of select="substring-before(local-name(.),'-')" />
    <xml:text>_</xml:text>
    <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
    <xsl:if test="@reason!=''">
     <xsl:text>-</xsl:text>
     <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
    </xsl:if>
   </xsl:attribute>
   
   <xsl:attribute name="description">
    <xsl:choose>
     <xsl:when test="@internal='yes'">
      <xsl:text>For internal use only</xsl:text>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="@description" />
     </xsl:otherwise>
    </xsl:choose>
   </xsl:attribute>
   <xsl:attribute name="name">
    <xsl:if test="local-name(.) = 'command-definition'">
     <xsl:text>*</xsl:text>
    </xsl:if>
    <xsl:if test="local-name(.) = 'vdu-definition'">
     <xsl:text>VDU </xsl:text>
    </xsl:if>
    <xsl:value-of select="@name" />
    <xsl:if test="(document('')//localdb:sections[(@type=$deftype) and 
                                                  (@number='yes')]) and
                  (@number!='')">
     <xsl:text> (&amp;</xsl:text>
     <xsl:value-of select="@number" />
     <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:if test="@reason!=''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason" />
     <xsl:if test="@reasonname!=''">
      <xsl:text> - </xsl:text>
      <xsl:value-of select="@reasonname" />
     </xsl:if>
    </xsl:if>
   </xsl:attribute>
   
   <xsl:if test="@number != ''">
    <xsl:attribute name="number">
     <xsl:call-template name="convert-hex-to-decimal">
      <xsl:with-param name="hex" select="@number" />
     </xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="number-hex">
     <xsl:value-of select="@number" />
    </xsl:attribute>
    <xsl:if test="@reason != ''">
     <xsl:attribute name="reason">
      <xsl:value-of select="@reason" />
     </xsl:attribute>
    </xsl:if>
   </xsl:if>
   
   <xsl:attribute name="section">
    <xsl:value-of select="$section" />
   </xsl:attribute>
  </ref>
  <xsl:text>&#10;</xsl:text>
 </xsl:for-each>
</xsl:if>
</xsl:template>
 
<xsl:template name="convert-hex-to-decimal">
<xsl:param name="hex" />
<xsl:variable name="last" select="substring($hex,string-length($hex),1)"/>
<xsl:variable name="rest" select="substring($hex,1,string-length($hex)-1)"/>
<xsl:variable name="value">
 <xsl:choose>
  <xsl:when test="number($last)&gt;=0 and number($last)&lt;=9">
   <xsl:value-of select="number($last)" />
  </xsl:when>
  <xsl:when test="($last = 'A') or ($last = 'a')">10</xsl:when>
  <xsl:when test="($last = 'B') or ($last = 'b')">11</xsl:when>
  <xsl:when test="($last = 'C') or ($last = 'c')">12</xsl:when>
  <xsl:when test="($last = 'D') or ($last = 'd')">13</xsl:when>
  <xsl:when test="($last = 'E') or ($last = 'e')">14</xsl:when>
  <xsl:when test="($last = 'F') or ($last = 'f')">15</xsl:when>
  <xsl:otherwise>
   <xsl:message terminate="yes">
    Bad hex string <xsl:value-of select="$last" /> in <xsl:value-of select="$hex" />
   </xsl:message>
  </xsl:otherwise>
 </xsl:choose>
</xsl:variable>
<!-- <xsl:message>Evaluated <xsl:value-of select="$last" /> as <xsl:value-of select="$value" /> for <xsl:value-of select="$hex" />, leaving <xsl:value-of select="$rest" /></xsl:message> -->
<xsl:choose>
 <xsl:when test="$rest = ''"><xsl:value-of select="$value" /></xsl:when>
 <xsl:otherwise>
  <xsl:variable name="restvalue">
   <xsl:call-template name="convert-hex-to-decimal">
    <xsl:with-param name="hex" select="$rest" />
   </xsl:call-template>
  </xsl:variable>
<!--   <xsl:message>restvalue = <xsl:value-of select="$restvalue" /></xsl:message> -->
  <xsl:value-of select="number($value) + (number($restvalue)*16)" />
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="page" mode="index">
<xsl:param name = "index-entity" />
<xsl:if test="@href != ''">
  <xsl:variable name="href">
   <xsl:apply-templates mode="dir" select=".."/>
   <xsl:value-of select="@href"/>
  </xsl:variable>

   <!-- now any index links -->
   <xsl:choose>

    <!-- commands -->
    <xsl:when test="$index-entity = 'command'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//command-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- system variables -->
    <xsl:when test="$index-entity = 'sysvar'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//sysvar-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- vdu codes -->
    <xsl:when test="$index-entity = 'vdu'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//vdu-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- swis -->
    <xsl:when test="$index-entity = 'swi'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//swi-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- vectors -->
    <xsl:when test="$index-entity = 'vector'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//vector-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- upcalls -->
    <xsl:when test="$index-entity = 'upcall'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//upcall-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- messages -->
    <xsl:when test="$index-entity = 'message'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//message-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- Toolbox messages -->
    <xsl:when test="$index-entity = 'tboxmessage'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//tboxmessage-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>
    
    <!-- Toolbox methods -->
    <xsl:when test="$index-entity = 'tboxmethod'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//tboxmethod-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- services -->
    <xsl:when test="$index-entity = 'service'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//service-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- entry points -->
    <xsl:when test="$index-entity = 'entry'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//entry-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>

    <!-- errors -->
    <xsl:when test="$index-entity = 'error'">
     <xsl:call-template name="index-definition">
      <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//error-definition" />
      <xsl:with-param name="href" select="$href" />
      <xsl:with-param name="section" select="." />
     </xsl:call-template>
    </xsl:when>
    
   </xsl:choose>
</xsl:if>
</xsl:template>

<xsl:template match="index">
<xsl:param name="index-entity"/>
<head>
  <meta charset="utf-8"/>
  <title>
    <xsl:text>RISC OS Programmers Reference Manuals : </xsl:text>
    <xsl:text>Contents</xsl:text>
    <xsl:choose>
     <xsl:when test="$index-entity != ''">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="$index-entity" />
      <xsl:text>)</xsl:text>
     </xsl:when>
    </xsl:choose>
  </title>
 <xsl:call-template name='head-css'/>
</head>

<body class='indexed indexed-contents'>
 <xsl:call-template name='index-header'>
  <xsl:with-param name='title'>
    <xsl:text>Contents</xsl:text>
    <xsl:choose>
     <xsl:when test="$index-entity != ''">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="$index-entity" />
      <xsl:text>)</xsl:text>
     </xsl:when>
    </xsl:choose>
  </xsl:with-param>
 </xsl:call-template>

<xsl:call-template name="index-bar">
 <xsl:with-param name="contents-for" select="$index-entity" />
 <xsl:with-param name="position" select="'top'" />
</xsl:call-template>

<section class='indexed-root'>
 <xsl:apply-templates>
  <xsl:with-param name="index-entity" select="$index-entity" />
 </xsl:apply-templates>
</section>

<xsl:call-template name="index-bar">
 <xsl:with-param name="contents-for" select="$index-entity" />
 <xsl:with-param name="position" select="'bottom'" />
</xsl:call-template>

<xsl:call-template name="footer" mode='render' />
</body>
</xsl:template>

<!-- ********** Header text ********** -->
<xsl:template name="index-header">
<xsl:param name="title"/>
    <header>
        <h1><xsl:value-of select='$title'/></h1>
    </header>
</xsl:template>

<!-- ********** Index bar ********** -->
<xsl:template name="index-bar">
<xsl:param name="contents-for" select="''" />
<xsl:param name="index-for" select="''" />
<xsl:param name="position" />

<xsl:variable name="root" select="/" />
<xsl:variable name="section-names" select="document('')" />

<nav class='indexed-bar'>
 <xsl:attribute name='class'>
  <xsl:text>indexed-bar indexed-bar-</xsl:text>
  <xsl:value-of select='$position'/>
 </xsl:attribute>

 <ul class='indexed-bar'>

     <li class='index-bar-contents'>
      <span>
       <xsl:attribute name='class'>
        <xsl:text>index-bar-contents</xsl:text>
        <xsl:if test="($index-for = '') and
                      ($contents-for = '')">
         <xsl:text> index-bar-selected</xsl:text>
        </xsl:if>
       </xsl:attribute>
       <a href="index.html">Contents</a>
      </span>
      <xsl:if test="$make-contents = 'yes'">
       <span class='index-bar-contents'>Index</span>
      </xsl:if>
     </li>

    <xsl:for-each select="$section-names//localdb:sections">
        <xsl:variable name="type" select="@type" />
        <xsl:variable name="filename" select="@filename" />
        <xsl:variable name="title" select="@title" />
        <xsl:variable name="number" select="@number" />
        <xsl:if test="$root//make-index[@type=$type]">
            <li class='index-bar-index'>
                <!-- This is the contents page, but with the definitions inserted -->
                <xsl:if test="$make-contents = 'yes'">
                 <span>
                  <xsl:attribute name='class'>
                   <xsl:text>index-bar-contents-name index-bar-contents-for-</xsl:text>
                   <xsl:value-of select='@type'/>
                   <xsl:if test="$contents-for = @type">
                    <xsl:text> index-bar-selected</xsl:text>
                   </xsl:if>
                  </xsl:attribute>
                  <a href="{concat('contents-',$filename,'.html')}">
                   <xsl:value-of select="$title" />
                  </a>
                 </span>
                </xsl:if>

                <!-- Just the indexes of the definitions -->
                <span>
                 <xsl:attribute name='class'>
                  <xsl:text>index-bar-index-name index-bar-index-for-</xsl:text>
                  <xsl:value-of select='@type'/>
                  <xsl:if test="$index-for = @type">
                   <xsl:text> index-bar-selected</xsl:text>
                  </xsl:if>
                 </xsl:attribute>
                 <a href="{concat('index-',$filename,'.html')}">
                  <xsl:value-of select="$title" />
                 </a>
                </span>

                <!-- Now the numbered one -->
                <xsl:if test="$number='yes'">
                    <span>
                     <xsl:attribute name='class'>
                      <xsl:text>index-bar-index-number index-bar-index-for-</xsl:text>
                      <xsl:value-of select='@type'/>
                      <xsl:text>-numbered</xsl:text>
                      <xsl:if test="$index-for = concat(@type,'-n')">
                       <xsl:text> index-bar-selected</xsl:text>
                      </xsl:if>
                     </xsl:attribute>
                     <a href="{concat('index-',$filename,'-n.html')}">
                      <xsl:text>number</xsl:text>
                     </a>
                    </span>
                </xsl:if>
            </li>
        </xsl:if>
    </xsl:for-each>
 </ul>
</nav>
</xsl:template>

<xsl:template match="section">
<xsl:param name="index-entity" />
<xsl:choose>
<xsl:when test="($hide-empty = 'no') or
                (count(descendant-or-self::*//page[@href!=''])>0)">
<section class='indexed-section'>
 <h2 class='indexed-section-name'>
 <a><xsl:attribute name="name">
    <xsl:text>#section_</xsl:text>
    <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
    </xsl:attribute>
    <xsl:value-of select="@title" />
 </a>
 </h2>
 <xsl:apply-templates>
  <xsl:with-param name="index-entity" select="$index-entity" />
 </xsl:apply-templates>
</section>
</xsl:when>
<xsl:otherwise>
 <xsl:comment>
  <xsl:text>Empty section: </xsl:text><xsl:value-of select="@title" />
 </xsl:comment>
 <xsl:apply-templates />
 <xsl:comment>
  <xsl:text>End section: </xsl:text><xsl:value-of select="@title" />
 </xsl:comment>
</xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- This recurses up the tree, processing each section with a directory to
     create a full path as its result -->
<xsl:template match="section" mode="dir">
<xsl:if test="@dir != ''">
 <xsl:apply-templates select=".." mode="dir" />
 <xsl:value-of select="@dir" />
 <xsl:text>/</xsl:text>
</xsl:if>
</xsl:template>
<xsl:template match="*" mode="dir"/>


<xsl:template match="page">
<xsl:param name="index-entity"/>
<xsl:variable name="href">
 <xsl:apply-templates mode="dir" select=".."/>
 <xsl:value-of select="@href"/>
</xsl:variable>

<xsl:choose>
 <xsl:when test="@href!=''">
  <div class='indexed-page'>
    <a>
     <xsl:attribute name="href"><xsl:value-of select="$href"/>
                                <xml:text>.html</xml:text>
                                </xsl:attribute>
     <xsl:apply-templates />
    </a>
   <xsl:if test="$include-source = 'yes'">
    <xsl:text> (</xsl:text>
    <a>
     <xsl:attribute name="href"><xsl:value-of select="$href"/>
                                <xml:text>.xml</xml:text>
                                </xsl:attribute>
     <xsl:text>XML source</xsl:text>
    </a>
    <xsl:text>)</xsl:text>
   </xsl:if>
  </div>

   <xsl:choose>
    <xsl:when test="$index-entity = '' and $include-sections = 'no'">
     <!-- nothing -->
    </xsl:when>
    <xsl:otherwise>
     <xsl:variable name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))" />

   <!-- now any index links -->
     <xsl:choose>
  
      <!-- commands -->
      <xsl:when test="$index-entity = 'command'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="$document//command-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- vdu codes -->
      <xsl:when test="$index-entity = 'vdu'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="$document//vdu-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- system variables -->
      <xsl:when test="$index-entity = 'sysvar'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="$document//sysvar-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- swis -->
      <xsl:when test="$index-entity = 'swi'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="$document//swi-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- vectors -->
      <xsl:when test="$index-entity = 'vector'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="$document//vector-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- upcalls -->
      <xsl:when test="$index-entity = 'upcall'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//upcall-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- messages -->
      <xsl:when test="$index-entity = 'message'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//message-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  

      <!-- Toolbox messages -->
      <xsl:when test="$index-entity = 'tboxmessage'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//tboxmessage-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- Toolbox methods -->
      <xsl:when test="$index-entity = 'tboxmethod'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//tboxmethod-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- services -->
      <xsl:when test="$index-entity = 'service'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//service-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- entry points -->
      <xsl:when test="$index-entity = 'entry'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//entry-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
  
      <!-- errors -->
      <xsl:when test="$index-entity = 'error'">
       <xsl:call-template name="content-definition">
        <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//error-definition" />
        <xsl:with-param name="href" select="$href" />
       </xsl:call-template>
      </xsl:when>
      
      <!-- sections -->
      <xsl:when test="$index-entity = '' and $include-sections = 'yes'">
       <xsl:call-template name="index-sections" mode="index">
        <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//chapter/section" />
        <xsl:with-param name="href" select="$href" />
        <xsl:with-param name="depth" select="1" />
       </xsl:call-template>
      </xsl:when>
     </xsl:choose>
     
    </xsl:otherwise>
   </xsl:choose>
   
 </xsl:when>

 <xsl:otherwise>
  <xsl:if test="($hide-empty = 'no')">
   <div class='indexed-page'>
    <xsl:apply-templates />
   </div>
  </xsl:if>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- ********** Indexed document definitions ********** -->
<xsl:template name="content-definition">
<xsl:param name="document" />
<xsl:param name="href" />
<xsl:if test="count($document) > 0">
 <section class='indexed-definitions'>
  <xsl:for-each select="$document">
   <div class='indexed-definition'>
    <a>
     <xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
     <xsl:attribute name="href">
      <xsl:value-of select="$href"/>
      <xml:text>.html#</xml:text>
      <xsl:value-of select="substring-before(local-name(.),'-')" />
      <xml:text>_</xml:text>
      <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
      <xsl:if test="@reason!=''">
       <xsl:text>-</xsl:text>
       <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
      </xsl:if>
     </xsl:attribute>
     
     <xsl:if test="local-name(.) = 'command-definition'">
      <xsl:text>*</xsl:text>
     </xsl:if>
     <xsl:if test="local-name(.) = 'vdu-definition'">
      <xsl:text>VDU </xsl:text>
     </xsl:if>
     <xsl:value-of select="@name" />
     <xsl:if test="(document('')//localdb:sections[(@type=$deftype) and 
                                                   (@number='yes')]) and
                   (@number!='')">
      <xsl:text> (&amp;</xsl:text>
      <xsl:value-of select="@number" />
      <xsl:text>)</xsl:text>
     </xsl:if>
     <xsl:if test="@reason!=''">
      <xsl:text> </xsl:text>
      <xsl:value-of select="@reason" />
      <xsl:if test="@reasonname!=''">
       <xsl:text> - </xsl:text>
       <xsl:value-of select="@reasonname" />
      </xsl:if>
     </xsl:if>
     
    </a>
   </div>
  </xsl:for-each>
 </section>
</xsl:if>
</xsl:template>


<!-- ********** Indexed document sections ********** -->
<xsl:template name="index-sections" mode="index">
<xsl:param name="document" />
<xsl:param name="depth"/>
<xsl:param name="href" />
<xsl:if test="count($document) > 0">
 <section>
  <xsl:attribute name='class'>
   <xsl:text>indexed-document-section indexed-document-section-</xsl:text>
   <xsl:value-of select='$depth'/>
  </xsl:attribute>

  <xsl:for-each select="$document">
   <xsl:if test="@title != ''">
    <div class='indexed-page-section'>
     <a>
      <xsl:attribute name="href">
       <xsl:value-of select="$href"/>
       <xml:text>.html#</xml:text>
       <xsl:value-of select="local-name(.)" />
       <xml:text>_</xml:text>
       <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
      </xsl:attribute>
      
      <xsl:value-of select="@title" />
     </a>
     <xsl:if test="$depth &lt; $include-sections-depth">
         <xsl:call-template name="index-sections" mode="index">
          <xsl:with-param name="document" select="section|subsection|subsubsection|category" />
          <xsl:with-param name="href" select="$href" />
          <xsl:with-param name="depth" select="$depth + 1" />
         </xsl:call-template>
         <xsl:call-template name="content-definition" mode="index">
          <xsl:with-param name="document" select="swi-definition|vector-definition|entry-definition|service-definition|upcall-definition|command-definition|sysvar-definition|message-definition|error-definition|vdu-definition|tboxmethod-definition|tboxmessage-definition" />
          <xsl:with-param name="href" select="$href" />
         </xsl:call-template>
     </xsl:if>
    </div>
   </xsl:if>
  </xsl:for-each>
 </section>
</xsl:if>
</xsl:template>

<xsl:template match="text()" mode="index" />


<xsl:template match="make-filelist">
    <xsl:document href="filelist.txt" method="text" indent="no">
        <xsl:text>index.html&#10;</xsl:text>

        <!-- Now the actual content referenced -->
        <xsl:apply-templates select="//page" mode="filelist"/>

        <!-- Finally, all the indices -->
        <xsl:variable name="root" select="/" />
        <xsl:variable name="section-names" select="document('')" />

        <xsl:for-each select="$section-names//localdb:sections">
            <xsl:variable name="type" select="@type" />
            <xsl:variable name="filename" select="@filename" />
            <xsl:variable name="title" select="@title" />
            <xsl:variable name="number" select="@number" />
            <xsl:if test="$root//make-index[@type=$type]">

                <xsl:value-of select="concat('index-',$filename,'.html')"/><xsl:text>&#10;</xsl:text>
                <xsl:if test="$number='yes'">
                    <xsl:value-of select="concat('index-',$filename,'-n.html')"/><xsl:text>&#10;</xsl:text>
                </xsl:if>
            </xsl:if>
         </xsl:for-each>
    </xsl:document>
</xsl:template>

<xsl:template match="page" mode="filelist">
<xsl:if test="@href != ''">
  <xsl:apply-templates mode="dir" select=".."/>
  <xsl:value-of select="@href"/>
  <xsl:text>.html&#10;</xsl:text>
</xsl:if>
</xsl:template>

</xsl:stylesheet>
