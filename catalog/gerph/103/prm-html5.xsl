<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet for HTML.

     Converts XML descriptions to HTML 5/CSS.
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
                xmlns:pixparams="http://gerph.org/dtd/prminxml-params">

<xsl:include href="http://gerph.org/dtd/bnf/100/html.xsl" />

<!-- 'prefix-name' is used on heading titles, syntaxes and references for the name.
     'prefix-number' is used on heading titles for the number.
     'separator' is used when describing the syntax of the definition.
     'name' is used when describing what the definition is.
     'Name' is used when describing what the definition is (but capitalised)
  -->
<localdb:definition-titles type="swi"          prefix-definition=""         prefix-name="SWI "     prefix-number="SWI "     number-base="&amp;" name="SWI"              Name="SWI"                />
<localdb:definition-titles type="vdu"          prefix-definition="VDU "     prefix-name="VDU "     prefix-number=""         number-base=""      name="VDU code"         Name="VDU code"           separator=","/>
<localdb:definition-titles type="vector"       prefix-definition="Vector "  prefix-name=""         prefix-number="Vector "  number-base=""      name="vector"           Name="Vector"             />
<localdb:definition-titles type="command"      prefix-definition="*"        prefix-name="*"        prefix-number=""         number-base=""      name="* command"        Name="* command"          />
<localdb:definition-titles type="entry"        prefix-definition=""         prefix-name=""         prefix-number=""         number-base=""      name="entry point "     Name="Entry point "       />
<localdb:definition-titles type="sysvar"       prefix-definition=""         prefix-name=""         prefix-number=""         number-base=""      name="system variable " Name="System variable "   />
<localdb:definition-titles type="service"      prefix-definition="Service_" prefix-name="Service_" prefix-number="Service Call " number-base="&amp;" name="service call"     Name="Service call"       />
<localdb:definition-titles type="upcall"       prefix-definition="UpCall_"  prefix-name="UpCall_"  prefix-number="UpCall "  number-base="&amp;" name="upcall"           Name="Upcall"             />
<localdb:definition-titles type="error"        prefix-definition="Error_"   prefix-name="Error_"   prefix-number="Error "   number-base="&amp;" name="error message"    Name="Error message"      />
<localdb:definition-titles type="message"      prefix-definition="Message_" prefix-name="Message_" prefix-number=""         number-base="&amp;" name="message"          Name="Message"            />
<localdb:definition-titles type="tboxmessage"  prefix-definition=""         prefix-name=""         prefix-number="Event "   number-base="&amp;" name="Toolbox message"  Name="Toolbox message"    />
<localdb:definition-titles type="tboxmethod"   prefix-definition=""         prefix-name=""         prefix-number="Method "  number-base="&amp;" name="Toolbox method"   Name="Toolbox method"     />

<!-- Similar database for the subsections (also in the 'definition-titles' space because it's easier to lookup) -->
<localdb:definition-titles type="section" Name='Section'/>
<localdb:definition-titles type="subsection" Name='SubSection'/>
<localdb:definition-titles type="subsubsection" Name='SubSubSection'/>
<localdb:definition-titles type="category" Name='Category'/>

<!-- mapping from the key name to what we show on the screen -->
<localdb:key-name aname='shift' label="SHIFT"/>
<localdb:key-name aname='ctrl' label="CTRL"/>
<localdb:key-name aname='alt' label="ALT"/>
<localdb:key-name aname='meta' label="META"/>
<localdb:key-name aname='fn' label="FN"/>
<!-- FIXME: Consider making these unicode arrows -->
<localdb:key-name aname='up' label="UP"/>
<localdb:key-name aname='down' label="DOWN"/>
<localdb:key-name aname='left' label="LEFT"/>
<localdb:key-name aname='right' label="RIGHT"/>
<localdb:key-name aname='pageup' label="PAGE UP"/>
<localdb:key-name aname='pagedown' label="PAGE DOWN"/>
<!-- FIXME: Consider making these the symbols -->
<localdb:key-name aname='backspace' label="BACKSPACE"/>
<localdb:key-name aname='tab' label="TAB"/>
<localdb:key-name aname='return' label="RETURN"/>
<localdb:key-name aname='escape' label="ESC"/>
<localdb:key-name aname='enter' label="ENTER"/>
<localdb:key-name aname='insert' label="INSERT"/>
<localdb:key-name aname='delete' label="DELETE"/>
<localdb:key-name aname='home' label="HOME"/>
<localdb:key-name aname='end' label="END"/>
<localdb:key-name aname='copy' label="COPY"/>
<localdb:key-name aname='print' label="PRINT"/>
<localdb:key-name aname='break' label="BREAK"/>
<localdb:key-name aname='capslock' label="CAPS LOCK"/>
<localdb:key-name aname='scrolllock' label="SCROLL LOCK"/>
<localdb:key-name aname='numlock' label="NUM LOCK"/>
<localdb:key-name aname='space' label="SPACE"/>
<localdb:key-name aname='f1' label="F1"/>
<localdb:key-name aname='f2' label="F2"/>
<localdb:key-name aname='f3' label="F3"/>
<localdb:key-name aname='f4' label="F4"/>
<localdb:key-name aname='f5' label="F5"/>
<localdb:key-name aname='f6' label="F6"/>
<localdb:key-name aname='f7' label="F7"/>
<localdb:key-name aname='f8' label="F8"/>
<localdb:key-name aname='f9' label="F9"/>
<localdb:key-name aname='f10' label="F10"/>
<localdb:key-name aname='f11' label="F11"/>
<localdb:key-name aname='f12' label="F12"/>
<!-- Similar naming for the mouse -->
<localdb:key-name aname='select' label="SELECT"/>
<localdb:key-name aname='menu' label="MENU"/>
<localdb:key-name aname='adjust' label="ADJUST"/>
<localdb:key-name aname='scrollwheel' label="SCROLL"/>
<!-- action name strings -->
<localdb:input-action aname='click' prefix="" suffix=""/>
<localdb:input-action aname='press' prefix="Press " suffix=""/>
<localdb:input-action aname='release' prefix="Release " suffix=""/>
<localdb:input-action aname='hold' prefix="Hold " suffix=""/>
<localdb:input-action aname='drag' prefix="Drag " suffix=""/>
<localdb:input-action aname='up' prefix="" suffix=" UP"/>
<localdb:input-action aname='down' prefix="" suffix=" DOWN"/>
<localdb:input-action aname='left' prefix="" suffix=" LEFT"/>
<localdb:input-action aname='right' prefix="" suffix=" RIGHT"/>

<xsl:output method="html" indent="no" encoding="utf-8"/>

<xsl:variable name="title-to-id-src">ABCDEFGHIJKLMNOPQRSTUVWXYZ ,$:()-*?</xsl:variable>
<xsl:variable name="title-to-id-map">abcdefghijklmnopqrstuvwxyz_-_-</xsl:variable>

<pixparams:param name="create-contents" values="'yes' | 'no'" default="yes">
    Determines whether the contents part of the
    page will be generated.
</pixparams:param>
<pixparams:param name="create-body" values="'yes' | 'no'" default="yes">
    Determines whether the main body of the page
    will be generated.
</pixparams:param>
<pixparams:param name="create-contents-target" values="'yes' | 'no'" default="yes">
    Determines whether the page is being
    generated as part of a frameset; if set to
    a target name, it is assumed that a frame
    of that name exists and that the page
    (target)-right.html lives there.
    When used with prm-html-frameset.xsl, this
    can be used to generate a frameset suitable
    for use as a quick reference pair.
</pixparams:param>
<pixparams:param name="position-with-names" values="'yes' | 'no'" default="yes">
    Determines whether a long description of the
    path to areas with problems is given, or the
    shorter index-based form.
</pixparams:param>
<pixparams:param name="css-base" values="style-name | 'none'" default="standard">
    Determines the CSS style that will be used
    from the 'prm-css.xml' file. By default this
    is 'standard' which sets up the styling
    to look similar to the original PRM, but
    better suited for on screen viewing.
    Use 'none' to disable all the built in
    styles.
</pixparams:param>
<pixparams:param name="css-variant" values="style-variant-name" default="none">
    Applies additional styling variants on top of
    the css-base, for specific uses. Separate the
    list of variants with spaces. Use 'none' when
    no variant is required.
</pixparams:param>
<pixparams:param name="css-file" values="filename" default="none">
    Defines the relative name of the CSS
    stylesheet file to use.
    Use 'none' to not include an external
    stylesheet.
</pixparams:param>

<xsl:param name="create-contents">yes</xsl:param>
<xsl:param name="create-body">yes</xsl:param>
<xsl:param name="create-contents-target"></xsl:param>
<xsl:param name="position-with-names">yes</xsl:param>

<xsl:param name="css-base">standard</xsl:param>
<xsl:param name="css-variant">none</xsl:param>
<xsl:param name="css-file">none</xsl:param>


<xsl:template match="/">
<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
<html lang='en'>
<xsl:comment>
  Auto-generated using XSLT stylesheet created by Gerph.
</xsl:comment>
<xsl:apply-templates />
<xsl:apply-templates select="riscos-prm/meta" mode="tail"/>
</html>
</xsl:template>

<!-- ignore meta tags in main body -->
<xsl:template match="meta" />

<xsl:template match="chapter">
<head>
  <meta charset="utf-8"/>

  <xsl:if test="//meta/maintainer/email">
   <meta name='author'>
     <xsl:attribute name='content'>
      <xsl:for-each select='//meta/maintainer/email'>
       <xsl:if test='position() > 1'>, </xsl:if>
       <xsl:value-of select='@name'/>
      </xsl:for-each>
     </xsl:attribute>
   </meta>
  </xsl:if>
  <meta name='subject'>
   <xsl:attribute name='content'>
    <xsl:value-of select='@title'/>
   </xsl:attribute>
  </meta>

  <title>
  <xsl:value-of select="../@doc-group"/>
  <xsl:text> : </xsl:text>
  <xsl:value-of select="@title"/>
 </title>
 <xsl:call-template name='head-css'/>
</head>

<body>

<header>
<h1 class='chapter-title'>
    <span class='chapter-number'><!-- NYI --></span>
    <span class='chapter-docgroup'><xsl:value-of select="../@doc-group"/></span>
    <span class='chapter-name'><xsl:value-of select="@title"/></span>
</h1>
<xsl:choose>
 <xsl:when test="$create-contents-target = ''">
  <xsl:if test="$create-contents = 'yes'">
   <nav>
    <h2 class='contents'>Contents</h2>
     <ul>
      <xsl:apply-templates select="section|import" mode="contents" />
     </ul>
   </nav>
  </xsl:if>
 </xsl:when>

 <xsl:otherwise>
  <font size="-1">
   <xsl:apply-templates select="section|import" mode="contents" />
  </font>
 </xsl:otherwise>
</xsl:choose>
</header>

<xsl:if test="$create-body = 'yes'">
<article>
<xsl:apply-templates select="section|import"/>
</article>
</xsl:if>

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

<!-- Content definitions -->
<xsl:template name="section-content-expansion">
<li><a><xsl:attribute name="href">
        <xsl:if test="$create-contents-target != ''">
         <xsl:value-of select="$create-contents-target" />
         <xsl:text>-right.html</xsl:text>
        </xsl:if>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="local-name(.)" />
        <xsl:text>_</xsl:text>
        <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
       </xsl:attribute>
       <xsl:if test="$create-contents-target != ''">
        <xsl:attribute name="target">
         <xsl:value-of select="$create-contents-target" />
        </xsl:attribute>
       </xsl:if>
       <xsl:value-of select="@title" />
    </a>
    <xsl:if test="subsection or
                  subsubsection or
                  category or
                  swi-definition or
                  entry-definition or
                  service-definition or
                  upcall-definition or
                  command-definition or
                  sysvar-definition or
                  error-definition or
                  message-definition or
                  vector-definition or
                  vdu-definition or
                  tboxmessage-definition or
                  tboxmethod-definition or
                  import">
     <ul><xsl:apply-templates mode="contents" /></ul>
    </xsl:if>
</li>
</xsl:template>

<xsl:template name="definition-content-expansion">
<li><a><xsl:attribute name="href">
        <xsl:if test="$create-contents-target != ''">
         <xsl:value-of select="$create-contents-target" />
         <xsl:text>-right.html</xsl:text>
        </xsl:if>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="substring-before(local-name(.),'-')" />
        <xsl:text>_</xsl:text>
        <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
        <xsl:if test="@reason!=''">
         <xsl:text>-</xsl:text>
         <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
        </xsl:if>
       </xsl:attribute>
       <xsl:if test="$create-contents-target != ''">
        <xsl:attribute name="target">
         <xsl:value-of select="$create-contents-target" />
        </xsl:attribute>
       </xsl:if>
       <xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
       <xsl:value-of select="document('')//localdb:definition-titles[@type=$deftype]/@prefix-name" />
       <xsl:value-of select="@name" />
       <xsl:if test="((local-name(.)='message-definition') or
                      (local-name(.)='tboxmessage-definition')
                     ) and
                     (@number!='')">
        <xsl:text> (&amp;</xsl:text>
        <xsl:value-of select="@number" />
        <xsl:text>)</xsl:text>
       </xsl:if>
       <xsl:if test="@reason!=''">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@reason" />
        <xsl:choose>
         <xsl:when test="@reasonname!=''">
          <xsl:text> - </xsl:text>
          <xsl:value-of select="@reasonname" />
         </xsl:when>
         <xsl:otherwise>
          <xsl:message>Reason number given, but no name specified at
   <xsl:call-template name="describeposition" />.</xsl:message>
         </xsl:otherwise>
        </xsl:choose>
       </xsl:if>
    </a>
</li>
</xsl:template>

<!-- metadata content entry -->
<xsl:template match="meta" mode="contents">
<li><a href="#metadata">Document information</a></li>
</xsl:template>

<!-- import directive -->
<xsl:template match="import" mode="contents">
<xsl:apply-templates select="saxon:evaluate(concat('document(@document)/',@path))" mode="contents" />
</xsl:template>

<!-- section sections -->
<xsl:template match="section|subsection|subsubsection|category" mode="contents">
<xsl:call-template name="section-content-expansion" />
</xsl:template>
<!-- definition sections -->
<xsl:template match="swi-definition|service-definition|upcall-definition|command-definition|entry-definition|sysvar-definition|error-definition|message-definition|vector-definition|vdu-definition|tboxmessage-definition|tboxmethod-definition" mode="contents">
<xsl:call-template name="definition-content-expansion" />
</xsl:template>
<!-- kill off plain text -->
<xsl:template match="text()" mode="contents" />

<!-- Sections -->
<xsl:template match="section">
 <section class='section'>
    <h2 class='section'>
          <xsl:attribute name="id">
           <xsl:text>section_</xsl:text>
           <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@title" />
    </h2>
 <xsl:for-each select="*">
  <xsl:choose>
   <xsl:when test="local-name(.)='subsection'">
    <xsl:apply-templates select="."/>
   </xsl:when>
   <xsl:otherwise>
       <xsl:apply-templates select="."/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:for-each>
 </section>
</xsl:template>

<!-- Sub-Sections -->
<xsl:template match="subsection">
 <section class='subsection'>
    <h3 class='subsection'>
          <xsl:attribute name="id">
           <xsl:text>subsection_</xsl:text>
           <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@title" />
         </h3>
  <xsl:for-each select="*">
   <xsl:choose>
    <xsl:when test="local-name(.)='subsubsection'">
     <xsl:apply-templates select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="."/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:for-each>
 </section>
</xsl:template>

<!-- Sub-Sub-Sections -->
<xsl:template match="subsubsection">
 <section class='subsubsection'>
    <h4 class='subsubsection'>
          <xsl:attribute name="id">
           <xsl:text>subsubsection_</xsl:text>
           <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@title" />
         </h4>
 <xsl:apply-templates />
 </section>
</xsl:template>

<!-- Category -->
<xsl:template match="category">
<section class='category'>
<h5 class='category'>
          <xsl:attribute name="id">
           <xsl:text>category_</xsl:text>
           <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@title" />
         </h5>
<xsl:apply-templates />
</section>
</xsl:template>

<!-- command definitions ? -->
<xsl:template match="command-definition">
  <section class='command-definition'>
          <xsl:attribute name="id">
           <xsl:text>command_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
  <xsl:call-template name="definition-header"/>

  <xsl:call-template name="definition-syntax"/>
  <xsl:call-template name="definition-parameters"/>

<xsl:apply-templates select="use" />

  <xsl:call-template name="examples-block">
   <xsl:with-param name="where" select="." />
  </xsl:call-template>

<xsl:apply-templates select="related" />
</section>

</xsl:template>

<!-- VDU definitions ? -->
<xsl:template match="vdu-definition">
 <section class='vdu-definition'>
          <xsl:attribute name="id">
           <xsl:text>vdu_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
  <xsl:call-template name="definition-header"/>
  <xsl:call-template name="definition-syntax"/>
  <xsl:call-template name="definition-parameters"/>

<xsl:apply-templates select="use" />

<xsl:call-template name="examples-block">
 <xsl:with-param name="where" select="." />
</xsl:call-template>

<xsl:apply-templates select="related" />
</section>

</xsl:template>

<xsl:template match="related" mode="meta">
<xsl:choose>
 <xsl:when test="count(reference[@type='document' or @type='link']) = 0">
  <div class='meta-reference'><xsl:text>None</xsl:text></div>
 </xsl:when>

 <xsl:otherwise>
  <xsl:for-each select="reference[@type='document'] | reference[@type='link']">
   <div class='meta-reference'><xsl:apply-templates select="." /></div>
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="declaration">
<xsl:choose>
 <xsl:when test="count(*) = 0">
    <!-- No declarations, so no need to do anything -->
 </xsl:when>
 <xsl:otherwise>
  <section class='definition definition-declarations'>
    <!-- (<xsl:value-of select='@type'>)-->
    <xsl:apply-templates/>
  </section>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="related">
<div class='definition-related'>
<xsl:choose>
 <xsl:when test="count(*) = 0">
  <section class='definition definition-related-apis'>
    <span class='related-apis-none'>None</span>
  </section>
 </xsl:when>

 <xsl:otherwise>
  <xsl:if test="count(reference[@type='command']) > 0">
   <section class='definition definition-related-commands'>
   <xsl:for-each select="reference[@type='command']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='swi']) > 0">
   <section class='definition definition-related-swis'>
   <xsl:for-each select="reference[@type='swi']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='service']) > 0">
   <section class='definition definition-related-services'>
   <xsl:for-each select="reference[@type='service']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='tboxmethod']) > 0">
   <section class='definition definition-related-tboxmethods'>
   <xsl:for-each select="reference[@type='tboxmethod']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='tboxmessage']) > 0">
   <section class='definition definition-related-tboxmessages'>
   <xsl:for-each select="reference[@type='tboxmessage']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='vector']) > 0">
   <section class='definition definition-related-vectors'>
   <xsl:for-each select="reference[@type='vector']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='upcall']) > 0">
   <section class='definition definition-related-upcalls'>
   <xsl:for-each select="reference[@type='upcall']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='error']) > 0">
   <section class='definition definition-related-errors'>
   <xsl:for-each select="reference[@type='error']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='sysvar']) > 0">
   <section class='definition definition-related-sysvars'>
   <xsl:for-each select="reference[@type='sysvar']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='entry']) > 0">
   <section class='definition definition-related-entries'>
   <xsl:for-each select="reference[@type='entry']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='message']) > 0">
   <section class='definition definition-related-messages'>
   <xsl:for-each select="reference[@type='message']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='vdu']) > 0">
   <section class='definition definition-related-vdus'>
   <xsl:for-each select="reference[@type='vdu']">
   <xsl:if test="position() > 1"><span class='definition-related-divider'>, </span></xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>
 </xsl:otherwise>
</xsl:choose>
</div>
</xsl:template>


<!-- SWI definition -->
<!-- A SWI definition can have an offset defined, instead of a number, which is used for those cases
     where multiple provides all use the same interface. For example FileCore modules or DCI drivers.
 -->
<xsl:template match="swi-definition|vector-definition">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
  <section>
          <xsl:attribute name="class">
           <xsl:value-of select="$deftype" />
           <xsl:text>-definition</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="id">
           <xsl:value-of select="$deftype" />
           <xsl:text>_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>

   <xsl:call-template name='definition-header'/>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>

  <xsl:call-template name='definition-entry'/>
  <xsl:call-template name='definition-exit'/>

  <xsl:call-template name='definition-interrupts'/>
  <xsl:call-template name='definition-processor'/>
  <xsl:call-template name='definition-reentrancy'/>

  <xsl:apply-templates select="use" />

  <xsl:call-template name="examples-block">
   <xsl:with-param name="where" select="." />
  </xsl:call-template>

  <xsl:apply-templates select="declaration" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>

</xsl:template>

<!-- Entry-point definition -->
<xsl:template match="entry-definition">
    <section class='entry-definition'>
          <xsl:attribute name="id">
           <xsl:text>entry_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>

  <xsl:call-template name='definition-header'/>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>

  <xsl:call-template name='definition-entry'/>
  <xsl:call-template name='definition-exit'/>

  <xsl:call-template name='definition-interrupts'/>
  <xsl:call-template name='definition-processor'/>
  <xsl:call-template name='definition-reentrancy'/>

  <xsl:apply-templates select="use" />

  <xsl:call-template name="examples-block">
   <xsl:with-param name="where" select="." />
  </xsl:call-template>

  <xsl:apply-templates select="declaration" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>

</xsl:template>


<!-- Wimp Message definition -->
<xsl:template match="message-definition|tboxmessage-definition">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<section>
          <xsl:attribute name="class">
           <xsl:value-of select="$deftype" />
           <xsl:text>-definition</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="id">
           <xsl:value-of select="$deftype" />
           <xsl:text>_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
  <xsl:call-template name='definition-header'/>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>

  <section class='definition definition-message'>
  <div class="definition-message-data">
  <xsl:choose>
   <xsl:when test="count(message-table)>0">
    <xsl:apply-templates select="message-table" />
   </xsl:when>

   <xsl:when test="count(value-table)>0">
    <xsl:apply-templates select="value-table" />
   </xsl:when>

   <xsl:when test="count(offset-table)>0">
    <xsl:apply-templates select="offset-table" />
   </xsl:when>

   <xsl:otherwise>
    <xsl:text>No additional data</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  </div>
  </section>

  <xsl:if test="$deftype = 'message'">
   <!-- Source and destination only apply to messages -->
   <xsl:if test="@source!=''">
    <section class='definition definition-message-source'>
    <div class="definition-message-tasks">
    <xsl:choose>
     <xsl:when test="@source='*'">Any application</xsl:when>
     <xsl:otherwise><xsl:value-of select="@source" /></xsl:otherwise>
    </xsl:choose>
    </div>
    </section>
   </xsl:if>

   <xsl:if test="@destination!=''">
    <section class='definition definition-message-destination'>
    <div class="definition-message-tasks">
    <xsl:choose>
     <xsl:when test="@destination='*'">Any application</xsl:when>
     <xsl:otherwise><xsl:value-of select="@destination" /></xsl:otherwise>
    </xsl:choose>
    </div>
    </section>
   </xsl:if>

   <section class='definition definition-message-delivery'>
   <div class='definition-message-delivery-mode'>
   <xsl:choose>
    <xsl:when test="@broadcast='never'">Message must be sent directly to task</xsl:when>
    <xsl:when test="@broadcast='may'">Message may sent directly to task, or by broadcast (destination 0)</xsl:when>
    <xsl:when test="@broadcast='must'">Message must be broadcast (destination 0)</xsl:when>
    <xsl:otherwise>
     <xsl:message>Message 'broadcast' type not understood at
   <xsl:call-template name="describeposition" />.</xsl:message>
    </xsl:otherwise>
   </xsl:choose>
   <br/>

   <xsl:choose>
    <xsl:when test="@recorded='never'">Message may only be sent normally (reason code 17)</xsl:when>
    <xsl:when test="@recorded='may'">Message may sent recorded delivery (reason code 18) or normally (reason code 17)</xsl:when>
    <xsl:when test="@recorded='must'">Message must be sent recorded delivery (reason code 18)</xsl:when>
    <xsl:otherwise>
     <xsl:message>Message 'recorded' type not understood at
   <xsl:call-template name="describeposition" />.</xsl:message>
    </xsl:otherwise>
   </xsl:choose>
   </div>
   </section>
  </xsl:if>

  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="declaration" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>

</xsl:template>


<!-- System Variable definition -->
<xsl:template match="sysvar-definition">
  <section class='sysvar-definition'>
          <xsl:attribute name="id">
           <xsl:text>sysvar_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
  <xsl:call-template name="definition-header"/>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name="definition-internal"/>
 </xsl:when>
 <xsl:otherwise>

  <xsl:apply-templates select="use" />

  <xsl:call-template name="examples-block">
   <xsl:with-param name="where" select="." />
  </xsl:call-template>

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>
</xsl:template>


<!-- Error definition -->
<xsl:template match="error-definition">
  <section class='error-definition'>
          <xsl:attribute name="id">
           <xsl:text>error_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>

  <xsl:call-template name="definition-header"/>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <!-- huh ? this message should never come up, 'cos /any/ error might
      occur, so it's best to document 'em. But for consistencies sake... -->
   <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>

  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>

</xsl:template>


<!-- Service definition -->
<xsl:template match="service-definition">
  <section class='service-definition'>
          <xsl:attribute name="id">
           <xsl:text>service_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
   <xsl:call-template name='definition-header'/>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>

  <xsl:call-template name='definition-entry'/>
  <xsl:call-template name='definition-exit'/>

  <xsl:apply-templates select="use" />

  <xsl:call-template name="examples-block">
   <xsl:with-param name="where" select="." />
  </xsl:call-template>

  <xsl:apply-templates select="declaration" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>

</xsl:template>


<!-- Toolbox Method definition -->
<xsl:template match="tboxmethod-definition">
    <section class='tboxmethod-definition'>
          <xsl:attribute name="id">
           <xsl:text>tboxmethod_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
  <xsl:call-template name='definition-header'/>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>

  <xsl:call-template name='definition-entry'/>
  <xsl:call-template name='definition-exit'/>

  <xsl:apply-templates select="use" />

  <xsl:call-template name="examples-block">
   <xsl:with-param name="where" select="." />
  </xsl:call-template>

  <xsl:apply-templates select="declaration" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>

</xsl:template>

<!-- Upcall definition -->
<xsl:template match="upcall-definition">
  <section class='upcall-definition'>
          <xsl:attribute name="id">
           <xsl:text>upcall_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
   <xsl:call-template name='definition-header'/>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
   <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>

  <xsl:call-template name='definition-entry'/>
  <xsl:call-template name='definition-exit'/>

  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="declaration" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>

</xsl:template>

<xsl:template name="definition-internal">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defname" select="document('')//localdb:definition-titles[@type=$deftype]/@name" />
   <section class='definition definition-internal'>
 <p>This <xsl:value-of select="$defname" /> call is for internal
        use only. You must not use it in your own code.</p>
    </section>
</xsl:template>

<xsl:template match="use">
<section class='definition definition-use'>
 <xsl:apply-templates />
</section>
</xsl:template>

<!-- Helpers for the definition blocks which are common -->
<xsl:template name='definition-header'>
  <xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
  <xsl:variable name="defprefixname" select="document('')//localdb:definition-titles[@type=$deftype]/@prefix-definition" />
  <xsl:variable name="defprefixnumber" select="document('')//localdb:definition-titles[@type=$deftype]/@prefix-number" />
  <xsl:variable name="defnumberbase" select="document('')//localdb:definition-titles[@type=$deftype]/@number-base" />

  <div class='definition-header'>
   <span class='definition-title'>
    <xsl:if test="$defprefixname != ''">
     <span class='definition-name-prefix'><xsl:value-of select="$defprefixname"/></span>
    </xsl:if>
    <span class='definition-name'><xsl:value-of select="@name"/></span>

<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <span class='definition-reason'><xsl:value-of select="@reason"/></span>
    </xsl:if>
   </span>
   <xsl:if test="(@offset != '') or (@number != '')">
    <span class='definition-subtitle'>
     <span class='definition-number-prefix'><xsl:value-of select="$defprefixnumber"/></span>
     <span class='definition-number'>
      <xsl:choose>
       <xsl:when test="@offset != ''">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@offset-base"/>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$defnumberbase"/>
        <xsl:value-of select="@offset"/>
       </xsl:when>
       <xsl:otherwise>
        <xsl:if test="$defnumberbase != ''">
         <xsl:if test="$defprefixnumber != ''">
          <xsl:text> </xsl:text>
         </xsl:if>
         <xsl:value-of select="$defnumberbase"/>
        </xsl:if>
        <xsl:value-of select="@number"/>
       </xsl:otherwise>
      </xsl:choose>
     </span>
    </span>
   </xsl:if>
  </div>
  <xsl:if test="not(@internal) or @internal != 'yes'">
   <xsl:call-template name='definition-description'/>
  </xsl:if>
</xsl:template>

<xsl:template name='definition-description'>
 <div class='definition-description'>
  <xsl:value-of select="@description"/>
 </div>
</xsl:template>

<xsl:template name='definition-entry'>
  <section class='definition definition-entry'>
  <xsl:choose>
   <xsl:when test="count(entry/*)=0">
    <span class='definition-entry-none'>None</span>
   </xsl:when>

   <xsl:otherwise>
    <table>
    <xsl:apply-templates select="entry"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </section>
</xsl:template>

<xsl:template name='definition-exit'>
  <section class='definition definition-exit'>
  <xsl:choose>
   <xsl:when test="count(exit/*)=0">
    <span class='definition-exit-none'>None</span>
   </xsl:when>
   <xsl:otherwise>
    <table>
    <xsl:apply-templates select="exit"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </section>
</xsl:template>

<xsl:template name="definition-interrupts">
  <section class="definition definition-interrupts">
   <div class="definition-interrupts-irqs">
    Interrupts are <xsl:value-of select="@irqs" />
   </div>
   <div class="definition-interrupts-fiqs">
      Fast interrupts are <xsl:value-of select="@fiqs"/>
   </div>
  </section>
</xsl:template>

<xsl:template name="definition-processor">
  <section class="definition definition-processor">
    <div class="definition-processor-mode">
    Processor is in <xsl:value-of select="@processor-mode"/> mode
    </div>
  </section>
</xsl:template>

<xsl:template name="definition-reentrancy">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defName" select="document('')//localdb:definition-titles[@type=$deftype]/@Name" />
  <section class="definition definition-reentrancy">
  <div class="definition-reentrancy-mode">
  <xsl:choose>
    <xsl:when test='@re-entrant="yes"'><xsl:value-of select="$defName" /> is re-entrant</xsl:when>
    <xsl:when test='@re-entrant="undefined"'>Not defined</xsl:when>
    <xsl:when test='@re-entrant="no"'><xsl:value-of select="$defName" /> is not re-entrant</xsl:when>
    <xsl:otherwise><xsl:value-of select="@re-entrant"/></xsl:otherwise>
  </xsl:choose>
  </div>
  </section>
</xsl:template>

<xsl:template name='definition-syntax'>
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defprefix" select="document('')//localdb:definition-titles[@type=$deftype]/@prefix-name" />
<xsl:variable name="defseparator" select="document('')//localdb:definition-titles[@type=$deftype]/@separator" />
 <section class='definition definition-syntax'>
  <xsl:choose>
   <xsl:when test="count(syntax)=0">
    <div class='definition-syntax-line'>
     <xsl:value-of select="$defprefix"/><xsl:value-of select="@name"/>
    </div>
   </xsl:when>
   <xsl:otherwise>
    <xsl:for-each select="syntax">
     <div class='definition-syntax-line'>
      <xsl:value-of select="$defprefix"/><xsl:value-of select="../@name"/>
      <xsl:if test="count(*)!=0"><xsl:value-of select="$defseparator"/></xsl:if>
      <xsl:apply-templates select='.'/>
     </div>
    </xsl:for-each>
   </xsl:otherwise>
  </xsl:choose>
 </section>
</xsl:template>

<xsl:template name='definition-parameters'>
 <section class='definition definition-parameters'>
  <xsl:choose>
   <xsl:when test="count(parameter)=0">None</xsl:when>
   <xsl:otherwise>
    <table class='definition-parameters-list'>
    <xsl:for-each select="parameter">
     <tr class='definition-parameter'>
         <td>
          <xsl:variable name="param">
           <xsl:if test="@label">
            <xsl:value-of select="@label" />
            <xsl:text> </xsl:text>
           </xsl:if>
           <xsl:if test="@name">
            <i>&lt;<xsl:value-of select="@name" />&gt;</i>
           </xsl:if>
          </xsl:variable>
          <xsl:choose>
           <xsl:when test="not(@switch-alias)">
            <code>
             <xsl:if test="@switch">
              -<xsl:value-of select="@switch" />
              <xsl:text> </xsl:text>
             </xsl:if>
             <xsl:copy-of select="$param" />
            </code>
           </xsl:when>
           <xsl:otherwise>
            <xsl:if test="not(@switch)">
             <xsl:message>Parameter with switch-alias must be given a switch at
     <xsl:call-template name="describeposition" />.</xsl:message>
            </xsl:if>
            <table class='definition-parameter-aliases'>
             <tr><td>&#160;</td>
              <td>
               <code>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="@switch" />
                <xsl:text> </xsl:text>
                <xsl:copy-of select="$param" />
               </code>
              </td>
             </tr>
             <tr><td><i>or</i></td>
              <td>
               <code>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="@switch-alias" />
                <xsl:text> </xsl:text>
                <xsl:copy-of select="$param" />
               </code>
              </td>
             </tr>
            </table>
           </xsl:otherwise>
          </xsl:choose>
         </td>
         <td>-</td>
         <td><xsl:apply-templates /></td>
     </tr>
    </xsl:for-each>
    </table>
   </xsl:otherwise>
  </xsl:choose>
 </section>
</xsl:template>

<xsl:template name="examples-block">
 <xsl:param name="where" />
 <xsl:choose>
  <xsl:when test="count(example) > 0">
   <section class='definition definition-examples'>
    <xsl:for-each select="example">
     <xsl:apply-templates />
    </xsl:for-each>
   </section>
  </xsl:when>
 </xsl:choose>
</xsl:template>

<!-- Register -->
<xsl:template match="register-use">
<tr>
 <td class='register-use-register'>
  <xsl:choose>
   <xsl:when test="contains(@number, '-')">
    <span class='register-name register-range-start'>
     <xsl:text>R</xsl:text><xsl:value-of select="substring-before(@number, '-')"/>
    </span>
    <span class='register-range-divider'>
     <xsl:text>&#160;-&#160;</xsl:text>
    </span>
    <span class='register-name register-range-end'>
     <xsl:text>R</xsl:text><xsl:value-of select="substring-after(@number, '-')"/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <span class='register-name'>
     <xsl:text>R</xsl:text><xsl:value-of select="@number"/>
    </span>
   </xsl:otherwise>
  </xsl:choose>
 </td>

  <xsl:choose>
   <xsl:when test="@state='preserved'">
    <!-- preserved is used on output registers -->
    <td class='register-use-state register-use-preserved' colspan="2">preserved</td>
   </xsl:when>
   <xsl:when test="@state='corrupted'">
    <!-- corrupted is used on output registers -->
    <td class='register-use-state register-use-corrupted' colspan="2">corrupted</td>
   </xsl:when>
   <xsl:when test="@state='undefined'">
    <!-- undefined is used on input registers -->
    <td class='register-use-state register-use-undefined' colspan="2">undefined</td>
   </xsl:when>
   <xsl:otherwise>
    <td class='register-use-divider'>=</td>
    <td class='register-use-value'>
     <xsl:apply-templates/>
    </td>
   </xsl:otherwise>
  </xsl:choose>
</tr>
</xsl:template>

<!-- Processor flags, on exit from a routine -->
<xsl:template match="processor-flag">
<tr>
<xsl:choose>
 <xsl:when test="@state='content'">
  <td class='processor-flag-name'><xsl:value-of select="@name"/></td>
  <td class='processor-flag-value' colspan="2"><xsl:apply-templates/></td>
 </xsl:when>
 <xsl:otherwise>
  <td class='processor-flag-name'><xsl:value-of select="@name"/></td>
  <td class='processor-flag-state processor-flag-{@state}' colspan="2">
   <xsl:value-of select="@state"/>
   <xsl:text> </xsl:text>
   <xsl:apply-templates/>
  </td>
 </xsl:otherwise>
</xsl:choose>
</tr>
</xsl:template>


<!-- A bitfield-table turns into a regular XHTML table, with header -->
<xsl:template match="bitfield-table">
<table class='user-table bitfield-table'>
 <thead class='table-head'>
  <tr>
   <xsl:choose>
    <xsl:when test="count(*/@state)=0">
     <th class='table-number'>Bit</th>
     <xsl:if test="count(*/@name)>0">
      <th class='table-name'>Name</th>
     </xsl:if>
     <th class='table-value' colspan='2'>Meaning if set</th>
    </xsl:when>
    <xsl:otherwise>
     <th class='table-number'>Bit(s)</th>
     <xsl:if test="count(*/@name)>0">
      <th class='table-name'>Name</th>
     </xsl:if>
     <th class='table-value' colspan='2'>Meaning</th>
    </xsl:otherwise>
   </xsl:choose>
  </tr>
 </thead>
 <tbody class='table-body'>
  <xsl:apply-templates/>
 </tbody>
</table>
</xsl:template>

<!-- notice that we do some complex matching here to ensure that we put
     the set and clear bit values in what appears to be a sub-table,
     thus preventing the double use of the bit number in the heading -->
<xsl:template match="bit">
<!-- Note: preceding-sibling returns nodes going backward from the current node -->
<xsl:variable name="lastelement" select="preceding-sibling::bit[1]" />
<xsl:if test="not( ($lastelement/@number = @number) and
                   ($lastelement/@state != '') )">
 <!-- We only want to process the first of any sets of rows -->
 <tr>
  <td class='table-number'><xsl:value-of select="@number"/></td>
  <xsl:if test="count(../*/@name)>0">
   <td class='table-name'><xsl:value-of select="@name"/></td>
  </xsl:if>

  <xsl:choose>
   <xsl:when test="@state = 'reserved'">
    <td class='table-value' colspan='2'>
     <xsl:text>Reserved, must be zero</xsl:text>
    </td>
   </xsl:when>

   <xsl:when test="(@state = 'set') or (@state = 'clear')">
    <td class='table-value table-value-bitstate'>
     <xsl:choose>
      <xsl:when test="@state='set'"><xsl:text>Set:</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>Clear:</xsl:text></xsl:otherwise>
     </xsl:choose>
    </td>
    <td class='table-value table-value-bitmeaning'>
     <xsl:apply-templates/>
    </td>

    <xsl:variable name="nextelement" select="following-sibling::bit[position() = 1]" />
    <xsl:if test="($nextelement/@number = @number) and
                  ($nextelement/@state != '')">
     <tr>
      <td></td>
      <xsl:if test="count(../*/@name)>0">
       <td class='table-name'><xsl:value-of select="$nextelement/@name"/></td>
      </xsl:if>

      <td class='table-value table-value-bitstate'>
       <xsl:choose>
        <xsl:when test="$nextelement/@state='set'"><xsl:text>Set:</xsl:text></xsl:when>
        <xsl:otherwise><xsl:text>Clear:</xsl:text></xsl:otherwise>
       </xsl:choose>
      </td>
      <td class='table-value table-value-bitmeaning'>
       <xsl:apply-templates select="$nextelement/node()"/>
      </td>
     </tr>
    </xsl:if>
   </xsl:when>

   <xsl:otherwise>
    <td class='table-value' colspan='2'>
     <xsl:apply-templates/>
    </td>
   </xsl:otherwise>
  </xsl:choose>
 </tr>
</xsl:if>
</xsl:template>

<!-- A value table is just a table of values with headings -->
<xsl:template match="value-table">
<xsl:variable name="head-name">
  <xsl:choose>
    <xsl:when test="@head-name != ''"><xsl:value-of select="@head-name" /></xsl:when>
    <xsl:when test="count(value/@name)>0"><xsl:text>Name</xsl:text></xsl:when>
  </xsl:choose>
</xsl:variable>
<table class='user-table value-table'>
 <thead class='table-head'>
  <tr>
   <th class='table-number'><xsl:value-of select="@head-number" /></th>
   <xsl:if test="$head-name != ''">
    <th class='table-name'><xsl:value-of select="$head-name" /></th>
   </xsl:if>
   <th class='table-value'><xsl:value-of select="@head-value" /></th>
 </tr>
 </thead>
 <tbody class='table-body'>
  <xsl:apply-templates/>
 </tbody>
</table>
</xsl:template>

<xsl:template match="value">
<tr>
 <td class='table-number'><xsl:value-of select="@number"/></td>
 <xsl:if test="../*/@name != ''">
  <td class='table-name'><xsl:value-of select="@name"/></td>
 </xsl:if>
 <td class='table-value'>
  <xsl:choose>
   <xsl:when test="count(p) = 1">
    <!-- Botch to stop tables looking shite on most browsers -->
    <xsl:apply-templates select="p/*|p/text()"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates />
   </xsl:otherwise>
  </xsl:choose>
 </td>
</tr>
</xsl:template>

<!-- An offset table is similar to the value-table -->
<xsl:template match="offset-table">
<xsl:variable name="head-name">
  <xsl:choose>
    <xsl:when test="@head-name != ''"><xsl:value-of select="@head-name" /></xsl:when>
    <xsl:when test="count(offset/@name)>0"><xsl:text>Name</xsl:text></xsl:when>
  </xsl:choose>
</xsl:variable>
<table class='user-table offset-table'>
 <thead class='table-head'>
  <tr>
   <th class='table-number'><xsl:value-of select="@head-number" /></th>
   <xsl:if test="$head-name != ''">
    <th class='table-name'><xsl:value-of select="$head-name" /></th>
   </xsl:if>
   <th class='table-value'><xsl:value-of select="@head-value" /></th>
  </tr>
 </thead>
 <tbody class='table-body'>
  <xsl:apply-templates/>
 </tbody>
</table>
</xsl:template>

<xsl:template match="offset">
<tr>
 <td class='table-number'><xsl:value-of select="@number"/></td>
 <xsl:if test="../*/@name != ''">
  <td class='table-name'><xsl:value-of select="@name"/></td>
 </xsl:if>
 <td class='table-value'>
  <xsl:choose>
   <xsl:when test="@state='reserved'"><xsl:text>Reserved, must be zero</xsl:text></xsl:when>
   <xsl:when test="@state='undefined'"><xsl:text>Undefined</xsl:text></xsl:when>
   <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
 </xsl:choose>
 </td>
</tr>
</xsl:template>



<!-- An message table is similar to the offset-table -->
<xsl:template match="message-table">
<table class='user-table message-table'>
 <thead class='table-head'>
  <tr>
   <th class='table-number'>Offset</th>
   <xsl:if test="count(message/@name) > 0">
    <th class='table-name'>Name</th>
   </xsl:if>
   <th class='table-value'>Contents</th>
  </tr>
 </thead>
 <tbody class='table-body'>
  <xsl:apply-templates/>
 </tbody>
</table>
</xsl:template>

<xsl:template match="message">
<tr>
 <td class='table-number'>R1+<xsl:value-of select="@offset"/></td>
 <xsl:if test="../*/@name != ''">
  <td class='table-name'><xsl:value-of select="@name"/></td>
 </xsl:if>
 <td class='table-value'>
  <xsl:choose>
   <xsl:when test="@state='reserved'"><xsl:text>Reserved, must be zero</xsl:text></xsl:when>
   <xsl:when test="@state='undefined'"><xsl:text>Undefined</xsl:text></xsl:when>
   <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
 </xsl:choose>
 </td>
</tr>
</xsl:template>

<xsl:template name="describepositionhelper">
<xsl:param name = "where" />
<xsl:if test="name($where) != name(/)">
 <xsl:call-template name="describepositionhelper">
 <xsl:with-param name="where" select="$where/.." />
 </xsl:call-template>

 <xsl:text>/</xsl:text>

 <xsl:if test="$position-with-names = 'yes'">
  <xsl:text>&#10;   </xsl:text>
 </xsl:if>

 <xsl:value-of select="name($where)" />
 <xsl:choose>
  <xsl:when test="$position-with-names = 'yes'">
   <xsl:choose>
    <xsl:when test="$where/@title != ''">
     <xsl:text>[@title='</xsl:text>
     <xsl:value-of select="$where/@title" />
     <xsl:text>']</xsl:text>
    </xsl:when>
    <xsl:when test="$where/@name != ''">
     <xsl:text>[@name='</xsl:text>
     <xsl:value-of select="$where/@name" />
     <xsl:text>']</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:variable name="index" select="count($where/preceding-sibling::*) + 1"/>
     <xsl:if test="$index != 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>]</xsl:text>
     </xsl:if>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
   <xsl:variable name="index" select="count($where/preceding-sibling::*) + 1"/>
   <xsl:if test="$index != 1">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$index" />
    <xsl:text>]</xsl:text>
   </xsl:if>
  </xsl:otherwise>
 </xsl:choose>
</xsl:if>
</xsl:template>

<xsl:template match="text()" mode="describe" />

<xsl:template name="describeposition">
<xsl:call-template name="describepositionhelper">
<xsl:with-param name="where" select="." />
</xsl:call-template>
</xsl:template>

<!-- References -->
<xsl:template match="reference">
<xsl:variable name="reftype" select="@type"/>
<xsl:variable name="refname" select="@name"/>
<xsl:variable name="refreason" select="string(@reason)"/>
<xsl:variable name="link-content">
 <xsl:choose>
  <xsl:when test="(not(text()) and count(*) = 0) and @name">
   <xsl:value-of select="@name" />
   <xsl:if test="$refreason != ''">
    <xsl:text> </xsl:text>
    <xsl:value-of select="@reason" />
   </xsl:if>
  </xsl:when>

  <xsl:when test="(@type = 'link' or @type = 'document') and not(@name)">
   <xsl:value-of select="@href"/>
  </xsl:when>

  <xsl:otherwise>
   <xsl:apply-templates />
  </xsl:otherwise>
 </xsl:choose>
</xsl:variable>
<xsl:variable name="localdb" select="document('')//localdb:definition-titles[@type=$reftype]" />

<!-- Remember the destination of the link -->
<xsl:variable name="hrefto">
 <xsl:value-of select="string(@href)"/>
 <xsl:if test="@href and
               (substring(@href,1,1) != '?') and
               (substring(@href,1,1) != '#') and
               (not(contains(@href,':')))">
  <xsl:text>.html</xsl:text>
 </xsl:if>
 <xsl:if test="(@name) and (@type != 'document')">
  <xsl:text>#</xsl:text>
  <xsl:if test="@type">
   <xsl:value-of select="@type"/>
   <xsl:text>_</xsl:text>
  </xsl:if>
  <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
  <xsl:if test="@reason!=''">
   <xsl:text>-</xsl:text>
   <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
  </xsl:if>
 </xsl:if>
</xsl:variable>
<xsl:variable name="linknode">
<xsl:choose>
 <xsl:when test="$reftype='vdu' or $reftype='sysvar' or $reftype='service' or $reftype='swi' or $reftype='vector' or $reftype='upcall' or $reftype='entry' or $reftype='error' or $reftype='message' or $reftype='tboxmethod' or $reftype='tboxmessage' or $reftype='command'">
  <xsl:copy-of select="//*[local-name()=concat($reftype, '-definition') and
                           @name=$refname and
                           string(@reason)=$refreason]"/>
 </xsl:when>

 <xsl:when test="$reftype='section' or $reftype='subsection' or $reftype='subsubsection' or $reftype='category'">
  <xsl:copy-of select="//*[local-name()=$reftype and
                           @title=$refname]"/>
 </xsl:when>
</xsl:choose>
</xsl:variable>

<!-- remember the text of where we're going to -->
<xsl:variable name="linktext">
<xsl:choose>
 <!-- Definition references -->
 <xsl:when test="$reftype='vdu' or $reftype='sysvar' or $reftype='service' or $reftype='swi' or $reftype='vector' or $reftype='upcall' or $reftype='entry' or $reftype='error' or $reftype='message' or $reftype='tboxmethod' or $reftype='tboxmessage' or $reftype='command'">
  <xsl:if test="(not(@href)) and
                 not($linknode)">
   <xsl:message><xsl:value-of select="$localdb/@Name" /> definition for '<xsl:value-of select="$refname" />' not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="not(@href) and
                   (@use-description = 'yes') and
                   count(exslt:node-set($linknode)/*) = 0">
    <xsl:value-of select="exslt:node-set($linknode)/*/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$localdb/@prefix-name" />
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Section type reference -->
 <xsl:when test="$reftype='section' or $reftype='subsection' or $reftype='subsubsection' or $reftype='category'">
  <xsl:if test="not(@href) and
                count(exslt:node-set($linknode)/*) = 0">
   <xsl:message><xsl:value-of select="$localdb/@Name" /> for '<xsl:value-of select="$refname" />' not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>

 <!-- Documents -->
 <xsl:when test="@type='document'">
  <xsl:if test="(not(@href))">
   <xsl:message>Document for <xsl:value-of select="$refname" /> not supplied at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>

 <!-- Normal links -->
 <xsl:when test="@type='link'">
  <xsl:value-of select="$link-content" />
 </xsl:when>

 <!-- Anything else we don't understand -->
 <xsl:otherwise>
  <font size="+5" color="#DD0000"><xsl:value-of select="$link-content" /></font>
  <xsl:message>Reference type '<xsl:value-of select="@type" />' for <xsl:value-of select="$refname" /> is unknown at
   <xsl:call-template name="describeposition" />.</xsl:message>
 </xsl:otherwise>
</xsl:choose>
</xsl:variable>

<!-- Now write out the link -->
<xsl:choose>
 <xsl:when test="(substring(@href,1,1)!='?')">
  <a>
  <xsl:attribute name="class">
   <xsl:text>reference reference-</xsl:text><xsl:value-of select="@type" />
  </xsl:attribute>
  <xsl:attribute name="href">
   <xsl:copy-of select="$hrefto" />
  </xsl:attribute>
  <xsl:copy-of select="$linktext" />
  </a>
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="$linktext" />
   <xsl:variable name="complaint">Link for '<xsl:value-of select="translate($linktext,'&#10;',' ')"/>' has undefined destination</xsl:variable>
  <xsl:comment><xsl:value-of select="$complaint" /></xsl:comment>
  <xsl:message><xsl:value-of select="$complaint" /> at
   <xsl:call-template name="describeposition" />.</xsl:message>
 </xsl:otherwise>
</xsl:choose>

</xsl:template>

<!-- FixMe elements -->
<xsl:template match="fixme">
<span class='fixme'>
<xsl:choose>
 <xsl:when test="(text() != '') or (count(*) > 0)">
  <span class='fixme-label'>FIXME: </span>
  <span class='fixme-content'><xsl:apply-templates /></span>
 </xsl:when>
 <xsl:otherwise>
  <span class='fixme-label'>FIXME</span>
 </xsl:otherwise>
</xsl:choose>
</span>
</xsl:template>


<!-- List comes in two forms; ordered and unordered -->
<xsl:template match="list">
<xsl:choose>
 <xsl:when test="@type = 'ordered'">
  <ol class='list list-ordered'>
   <xsl:apply-templates />
  </ol>
 </xsl:when>

 <xsl:otherwise>
  <ul class='list list-unordered'>
   <xsl:apply-templates />
  </ul>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- Items in lists -->
<xsl:template match="item">
<li>
<xsl:choose>
 <xsl:when test="count(p) = 1 and count(p | br | image | bnf | list | extended-example | fixme | code | text()) = 1">
  <!-- Botch to stop tables looking shite on most browsers -->
  <xsl:apply-templates select="p/*|p/text()"/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates />
 </xsl:otherwise>
</xsl:choose>
</li>
</xsl:template>

<!-- Paragraphs are simple -->
<xsl:template match="p">
<xsl:choose>
    <!-- If we've only got an image inside us, don't format with a paragraph around it -->
    <xsl:when test="count(*) = 1 and image">
        <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
        <p><xsl:apply-templates /></p>
    </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- User replacement - something the user must replace with a value -->
<xsl:template match="userreplace">
<span class='userreplace'><xsl:apply-templates /></span>
</xsl:template>

<!-- User input - something the user could have typed -->
<xsl:template match="userinput">
<span class='userinput'><xsl:apply-templates /></span>
</xsl:template>

<!-- System output - something the system could have displayed -->
<xsl:template match="systemoutput">
<div class='systemoutput'><xsl:apply-templates /></div>
</xsl:template>

<!-- Menu option - an option that the user might chose for a menu -->
<xsl:template match="menuoption">
<span class='menuoption'><xsl:apply-templates /></span>
</xsl:template>

<!-- The collection of input device operations -->
<!-- FIXME: Enforce the keys before mouse? -->
<xsl:template match="input">
<span class='input'><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="key|mouse">
<kbd>
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="action" select="@action"/>
    <xsl:variable name="key-name" select="document('')//localdb:key-name[@aname=$name]"/>
    <xsl:variable name="input-action" select="document('')//localdb:input-action[@aname=$action]"/>

    <xsl:attribute name='class'>
        <xsl:value-of select="local-name(.)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="local-name(.)"/>
        <xsl:text>-action-</xsl:text>
        <xsl:value-of select="@action"/>
        <xsl:if test="@repeat != '1'">
            <xsl:text> </xsl:text>
            <xsl:value-of select="local-name(.)"/>
            <xsl:text>-repeat-</xsl:text>
            <xsl:value-of select="@repeat"/>
        </xsl:if>
        <xsl:if test="$key-name/@label">
            <xsl:text> </xsl:text>
            <xsl:value-of select="local-name(.)"/>
            <xsl:text>-name-</xsl:text>
            <xsl:value-of select="@name"/>
        </xsl:if>
    </xsl:attribute>

    <span>
        <xsl:attribute name='class'>
            <xsl:value-of select="local-name(.)"/>
            <xsl:text>-action </xsl:text>
            <xsl:value-of select="local-name(.)"/>
            <xsl:text>-action-</xsl:text>
            <xsl:value-of select="@action"/>
        </xsl:attribute>
        <xsl:attribute name='title'>
            <xsl:if test="$input-action/@prefix">
                <xsl:value-of select="$input-action/@prefix"/>
            </xsl:if>
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="$input-action/@prefix">
                <xsl:value-of select="$input-action/@prefix"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name='title' select="@action"/>
            </xsl:otherwise>
        </xsl:choose>
    </span>
    <xsl:if test="@repeat != '1'">
        <span>
            <xsl:attribute name='class'>
                <xsl:value-of select="local-name(.)"/>
                <xsl:text>-repeat </xsl:text>
                <xsl:value-of select="local-name(.)"/>
                <xsl:text>-repeat-</xsl:text>
                <xsl:value-of select="@repeat"/>
            </xsl:attribute>
        </span>
    </xsl:if>
    <span>
        <xsl:attribute name='class'>
            <xsl:value-of select="local-name(.)"/>
            <xsl:text>-name</xsl:text>
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="$key-name/@label">
                <xsl:value-of select="$key-name/@label"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@name"/>
            </xsl:otherwise>
        </xsl:choose>
    </span>
    <span>
        <xsl:attribute name='class'>
            <xsl:value-of select="local-name(.)"/>
            <xsl:text>-action-suffix </xsl:text>
            <xsl:value-of select="local-name(.)"/>
            <xsl:text>-action-suffix-</xsl:text>
            <xsl:value-of select="@action"/>
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="$input-action/@suffix">
                <xsl:value-of select="$input-action/@suffix"/>
            </xsl:when>
        </xsl:choose>
    </span>
</kbd>
</xsl:template>


<!-- Variable -->
<xsl:template match="variable">
<span class='variable'><xsl:apply-templates /></span>
</xsl:template>

<!-- Command example -->
<xsl:template match="command">
<span class='command'><xsl:apply-templates /></span>
</xsl:template>

<!-- Function-like routine -->
<xsl:template match="function">
<span class='function'><xsl:apply-templates /></span>
</xsl:template>

<!-- a filename -->
<xsl:template match="filename">
<span class='filename'><xsl:apply-templates /></span>
</xsl:template>

<!-- a system variable -->
<xsl:template match="sysvar">
<span class='sysvar'><xsl:apply-templates /></span>
</xsl:template>

<!-- User replacement -->
<xsl:template match="optional">
<xsl:text>[</xsl:text>
<xsl:for-each select="*">
<xsl:if test="(position()>1) and (../@alternates='true')">
 <xsl:text> | </xsl:text>
</xsl:if>
<xsl:apply-templates select="."/>
</xsl:for-each>
<xsl:text>]</xsl:text>
</xsl:template>

<!-- Command line switch -->
<xsl:template match="switch">
<span class='switch'>
    <span class='switch-leader'>-</span>
    <span class='switch-name'><xsl:value-of select="@name" /></span>
    <xsl:if test="(text() != '') or (count(*) > 0)">
        <xsl:text> </xsl:text>
        <span class='switch-parameter'><xsl:apply-templates /></span>
    </xsl:if>
</span>
</xsl:template>

<!-- Long example -->
<xsl:template match="extended-example">
<xsl:if test="@type='unknown'">
 <xsl:message>Code type 'unknown' should not be used at :
  <xsl:call-template name="describeposition" />.</xsl:message>
</xsl:if>

<pre>
 <xsl:attribute name='class'>
  <xsl:text>extended-example extended-example-</xsl:text>
  <xsl:value-of select='@type'/>
 </xsl:attribute>
<xsl:apply-templates />
</pre>
</xsl:template>

<!-- Code snippet -->
<xsl:template match="code">
<xsl:if test="@type='unknown'">
 <xsl:message>Code type 'unknown' should not be used at :
  <xsl:call-template name="describeposition" />.</xsl:message>
</xsl:if>

<code>
 <xsl:attribute name='class'>
  <xsl:text>code code-</xsl:text>
  <xsl:value-of select='@type'/>
 </xsl:attribute>
<xsl:apply-templates />
</code>
</xsl:template>

<!-- Stylistic changes -->
<xsl:template match="strong"><strong><xsl:apply-templates /></strong></xsl:template>
<xsl:template match="em"><em><xsl:apply-templates /></em></xsl:template>
<!-- I'm not at all sure I like the concept of having a break element -->
<xsl:template match="br">
    <xsl:text disable-output-escaping='yes'>&lt;br&gt;</xsl:text>
</xsl:template>

<!-- These are keepable, as they're required for expressing some maths -->
<xsl:template match="sup"><sup><xsl:apply-templates /></sup></xsl:template>
<xsl:template match="sub"><sub><xsl:apply-templates /></sub></xsl:template>

<!-- Document import -->
<xsl:template match="import">
<xsl:apply-templates select="saxon:evaluate(concat('document(@document)/',@path))" />
</xsl:template>

<!-- EMail -->
<xsl:template match="email">
<span class='email'>
<xsl:if test="@name != ''">
<span class='email-name'><xsl:value-of select="@name" /></span>
<xsl:text> </xsl:text>
</xsl:if>
<xsl:text>&lt;</xsl:text>
<span class='email-address'><a>
<xsl:attribute name="href">
<xsl:text>mailto:</xsl:text>
<xsl:value-of select="@address" />
</xsl:attribute>
<xsl:value-of select="@address" />
</a></span>
<xsl:text>&gt;</xsl:text>
</span>
</xsl:template>

<!-- Image -->
<xsl:template match="image">
<figure>
<xsl:choose>
 <xsl:when test="@type = 'png' or @type = 'gif' or @type = 'svg'">
    <img>
      <xsl:variable name="style">
       <xsl:if test="@width and @width != ''">
        <xsl:text>width: </xsl:text><xsl:value-of select="@width" /><xsl:text>; </xsl:text>
       </xsl:if>
       <xsl:if test="@height and @height != ''">
        <xsl:text>height: </xsl:text><xsl:value-of select="@height" /><xsl:text>; </xsl:text>
       </xsl:if>
       <xsl:value-of select="string(@href)"/>
      </xsl:variable>
     <xsl:attribute name="src"><xsl:value-of select="@src" /></xsl:attribute>
     <xsl:attribute name="style"><xsl:value-of select="$style" /></xsl:attribute>
     <xsl:attribute name="alt"><xsl:value-of select="@caption" /></xsl:attribute>
    </img>
  <xsl:apply-templates select="image"/>
 </xsl:when>

 <xsl:when test="@type = 'draw'">
  <!-- please note that this is /wrong/ -->
  <object type="application/drawfile" >
   <xsl:attribute name="data"><xsl:value-of select="@src" /></xsl:attribute>
   <xsl:attribute name="width"><xsl:value-of select="@width" /></xsl:attribute>
   <xsl:attribute name="height"><xsl:value-of select="@height" /></xsl:attribute>
   <xsl:attribute name="standby"><xsl:value-of select="@caption" /></xsl:attribute>
   <xsl:apply-templates select="image"/>
  </object>
 </xsl:when>

 <xsl:otherwise>
  <xsl:message>Image '<xsl:value-of select="@src" />' has an unknown type '<xsl:value-of select="@type" />'
</xsl:message>
  <xsl:apply-templates select="image"/>
 </xsl:otherwise>
</xsl:choose>

<xsl:if test="local-name(..) != 'image' and
              @caption != ''">
    <figcaption><xsl:value-of select="@caption" /></figcaption>
</xsl:if>
</figure>

</xsl:template>

<!-- Meta Data section -->
<xsl:template match="meta" mode="tail">
<footer>
 <section class='meta'>
  <h2 id="metadata">Document information</h2>
  <div class='meta'>
   <table>
    <xsl:if test="count(maintainer) &gt; 0">
     <tr class='maintainer'>
      <th>Maintainer(s):</th>
      <td class='maintainers'><xsl:apply-templates select="maintainer"/></td>
     </tr>
    </xsl:if>
    <xsl:if test="count(history) &gt; 0">
     <tr class='history'>
      <th>History:</th>
      <td class='history'><xsl:apply-templates select="history"/></td>
     </tr>
    </xsl:if>
    <xsl:if test="count(related) &gt; 0">
     <tr>
      <th class='related'>Related:</th>
      <td class='related'><xsl:apply-templates select="related" mode="meta" /></td>
     </tr>
    </xsl:if>
    <xsl:if test="count(disclaimer) &gt; 0">
     <tr class='disclaimer'>
      <th>Disclaimer:</th>
      <td class='disclaimer'>
       <xsl:apply-templates select="disclaimer"/>
      </td>
     </tr>
    </xsl:if>
   </table>
  </div>
 </section>
</footer>
</xsl:template>

<xsl:template match="history">
<table class='history'>
<tr>
 <th class='revision-number'>Revision</th>
 <th class='revision-date'>Date</th>
 <th class='revision-author'>Author</th>
 <th class='revision-detail'>Changes</th>
</tr>
<xsl:apply-templates />
</table>
</xsl:template>

<xsl:template match="revision">
<tr>
 <td class='revision-number'><xsl:value-of select="@number" /></td>
 <td class='revision-date'><xsl:value-of select="@date" /></td>
 <td class='revision-author'><xsl:value-of select="@author" /></td>
 <td class='revision-detail'>
  <xsl:if test="@title != ''">
   <h5 class='revision-title'> <xsl:value-of select="@title" /> </h5>
  </xsl:if>
  <xsl:if test="count(change) &gt; 0">
   <ul class='revision-changes'>
    <xsl:apply-templates />
   </ul>
  </xsl:if>
 </td>
</tr>
</xsl:template>

<xsl:template match="change">
<li class='revision-change'><xsl:apply-templates /></li>
</xsl:template>

</xsl:stylesheet>
