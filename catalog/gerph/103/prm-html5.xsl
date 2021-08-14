<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet for HTML.

     Converts XML descriptions to HTML.
     (c) Gerph, distribution unlimited.
     Version 1.03.

     Notes on use:

       if you use this stylesheet with an xml document, you may set a
       number of parameters to configure the page generation :

          create-contents : yes|no
                            Determines whether the contents part of the
                            page will be generated.
          create-body     : yes|no
                            Determines whether the main body of the page
                            will be generated.
          create-contents-target : yes|no
                            Determines whether the page is being
                            generated as part of a frameset; if set to
                            a target name, it is assumed that a frame
                            of that name exists and that the page
                            (target)-right.html lives there.
                            When used with prm-html-frameset.xsl, this
                            can be used to generate a frameset suitable
                            for use as a quick reference pair.
          position-with-names : yes|no
                            Determines whether a long description of the
                            path to areas with problems is given, or the
                            shorter index-based form.
  -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict"
                xmlns:localdb="local-file-database"
                xmlns:saxon = "http://icl.com/saxon">

<xsl:include href="http://gerph.org/dtd/bnf/100/html.xsl" />

<!-- 'singular' is used to prefix the *-definition element (only applied
     to certain elements at present).
     'prefix' is used on heading titles, syntaxes and references.
     'separator' is used when describing the syntax of the definition.
     'name' is used when describing what the definition is.
  -->
<localdb:definition-names type="swi" singular="SWI"             prefix="SWI "    name="SWI"/>
<localdb:definition-names type="vdu"                            prefix="VDU "    name="VDU code"         separator=","/>
<localdb:definition-names type="vector" singular="Vector"       prefix="Vector " name="vector"/>
<localdb:definition-names type="command"                        prefix="*"       name="* command" />
<localdb:definition-names type="entry" singular="Entry point"   prefix=""        name="entry-point " />
<localdb:definition-names type="sysvar"                         prefix=""        name="system variable " />
<localdb:definition-names type="service"                        prefix=""        name="service call" />
<localdb:definition-names type="upcall"                         prefix=""        name="upcall" />
<localdb:definition-names type="error"                          prefix=""        name="error message" />
<localdb:definition-names type="message"                        prefix=""        name="message" />
<localdb:definition-names type="tboxmessage"                    prefix=""        name="Toolbox message" />
<localdb:definition-names type="tboxmethod"                     prefix=""        name="Toolbox method" />

<xsl:output method="xml" indent="no" encoding="utf-8"/>

<xsl:variable name="title-to-id-src">ABCDEFGHIJKLMNOPQRSTUVWXYZ ,$:()-*?</xsl:variable>
<xsl:variable name="title-to-id-map">abcdefghijklmnopqrstuvwxyz_-_-</xsl:variable>
<xsl:param name="create-contents">yes</xsl:param>
<xsl:param name="create-body">yes</xsl:param>
<xsl:param name="create-contents-target"></xsl:param>
<xsl:param name="position-with-names">yes</xsl:param>

<xsl:param name="css-content" select="document('prm-css.xml')/css" />


<xsl:template match="/">
<html>
<xsl:comment>
  Auto-generated using XSLT stylesheet created by Gerph.

  This document was created with the HTML stylesheet updated 12 Aug 2021.
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
  <title>
  <xsl:value-of select="../@doc-group"/>
  <xsl:text> : </xsl:text>
  <xsl:value-of select="@title"/>
 </title>
 <style type='text/css'>
  <xsl:value-of disable-output-escaping='yes' select="$css-content"/>
 </style>
</head>

<body>

<header>
<h1 class='chapter-title'><xsl:value-of select="@title"/></h1>

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
       <xsl:value-of select="document('')//localdb:definition-names[@type=$deftype]/@prefix" />
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
    <h4 class='subsection'>
          <xsl:attribute name="id">
           <xsl:text>subsection_</xsl:text>
           <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@title" />
         </h4>
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
<h5>
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
    <div class='definition-title'>
          <xsl:text>*</xsl:text><xsl:value-of select="@name"/>
    </div>

  <xsl:call-template name="definition-description"/>

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
        <div class='definition-title'>
          <span class='definition-name'><xsl:text>VDU </xsl:text><xsl:value-of select="@name"/></span>
        </div>

  <xsl:call-template name="definition-description"/>

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
  <xsl:text>None</xsl:text>
 </xsl:when>

 <xsl:otherwise>
  <xsl:for-each select="reference[@type='document'] | reference[@type='link']">
   <xsl:apply-templates select="." />
   <br />
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
<xsl:choose>
 <xsl:when test="count(*) = 0">
  <section class='definition definition-related-apis'>
      None
  </section>
 </xsl:when>

 <xsl:otherwise>
  <xsl:if test="count(reference[@type='command']) > 0">
   <section class='definition definition-related-commands'>
   <xsl:for-each select="reference[@type='command']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='swi']) > 0">
   <section class='definition definition-related-swis'>
   <xsl:for-each select="reference[@type='swi']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='service']) > 0">
   <section class='definition definition-related-services'>
   <xsl:for-each select="reference[@type='service']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='tboxmethod']) > 0">
   <section class='definition definition-related-tboxmethods'>
   <xsl:for-each select="reference[@type='tboxmethod']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='tboxmessage']) > 0">
   <section class='definition definition-related-tboxmessages'>
   <xsl:for-each select="reference[@type='tboxmessage']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='vector']) > 0">
   <section class='definition definition-related-vectors'>
   <xsl:for-each select="reference[@type='vector']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='upcall']) > 0">
   <section class='definition definition-related-upcalls'>
   <xsl:for-each select="reference[@type='upcall']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='error']) > 0">
   <section class='definition definition-related-errors'>
   <xsl:for-each select="reference[@type='error']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='sysvar']) > 0">
   <section class='definition definition-related-sysvars'>
   <xsl:for-each select="reference[@type='sysvar']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='entry']) > 0">
   <section class='definition definition-related-entries'>
   <xsl:for-each select="reference[@type='entry']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='message']) > 0">
   <section class='definition definition-messages'>
   <xsl:for-each select="reference[@type='message']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>

  <xsl:if test="count(reference[@type='vdu']) > 0">
   <section class='definition definition-vdus'>
   <xsl:for-each select="reference[@type='vdu']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </section>
  </xsl:if>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- SWI definition -->
<!-- A SWI definition can have an offset defined, instead of a number, which is used for those cases
     where multiple provides all use the same interface. For example FileCore modules or DCI drivers.
 -->
<xsl:template match="swi-definition|vector-definition">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defsingular" select="document('')//localdb:definition-names[@type=$deftype]/@singular" />
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
          <div class='definition-title'>
            <span class='definition-name'>
                <xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
            </span>
    <span class='definition-number'>
     <xsl:value-of select="$defsingular" />
     <xsl:choose>
      <xsl:when test="@offset != ''">
       <xsl:text> </xsl:text>
       <xsl:value-of select="@offset-base"/>
       <xsl:text>+&amp;</xsl:text>
       <xsl:value-of select="@offset"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text> &amp;</xsl:text>
       <xsl:value-of select="@number"/>
      </xsl:otherwise>
     </xsl:choose>
<!--     <xsl:if test="@reason != ''"> -->
<!--      <xsl:text> reason </xsl:text> -->
<!--      <xsl:value-of select="@reason"/> -->
<!--     </xsl:if> -->
     </span>
          </div>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="definition-description"/>

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
          <div class='definition-title'>
          <span class='definition-name'>
          <xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </span>
    <xsl:if test="@number != ''">
     <span class='definition-number'>
     <xsl:value-of select="@number"/>
<!--      <xsl:if test="@reason != ''"> -->
<!--       <xsl:text> reason </xsl:text> -->
<!--       <xsl:value-of select="@reason"/> -->
<!--      </xsl:if> -->
    </span>
    </xsl:if>
     </div>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="definition-description"/>

  <xsl:call-template name='definition-entry'/>
  <xsl:call-template name='definition-exit'/>

  <xsl:call-template name='definition-interrupts'/>
  <xsl:call-template name='definition-processor'/>
  <xsl:call-template name='definition-reentrancy'/>

  <xsl:apply-templates select="use" />

  <xsl:call-template name="examples-block">
   <xsl:with-param name="where" select="." />
  </xsl:call-template>

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>

</xsl:template>


<!-- Wimp Message definition -->
<xsl:template match="message-definition|tboxmessage-definition">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defsingular" select="document('')//localdb:definition-names[@type=$deftype]/@singular" />
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
          <div class='definition-title'>
            <span class="definition-name">
          <xsl:choose>
           <xsl:when test="$deftype = 'message'">
            <xsl:text>Message_</xsl:text><xsl:value-of select="@name"/>
           </xsl:when>
           <xsl:when test="$deftype = 'tboxmessage'">
            <xsl:value-of select="@name"/>
           </xsl:when>
          </xsl:choose>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </span>
    <span class="definition-number">&amp;<xsl:value-of select="@number"/></span>
    </div>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="definition-description"/>

  <section class='definition definition-message'>
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
  </section>

  <xsl:if test="$deftype = 'message'">
   <!-- Source and destination only apply to messages -->
   <xsl:if test="@source!=''">
    <section class='definition definition-message-source'>
    <xsl:choose>
     <xsl:when test="@source='*'">Any application</xsl:when>
     <xsl:otherwise><xsl:value-of select="@source" /></xsl:otherwise>
    </xsl:choose>
    </section>
   </xsl:if>

   <xsl:if test="@destination!=''">
    <section class='definition definition-message-destination'>
    <xsl:choose>
     <xsl:when test="@destination='*'">Any application</xsl:when>
     <xsl:otherwise><xsl:value-of select="@destination" /></xsl:otherwise>
    </xsl:choose>
    </section>
   </xsl:if>

   <section class='definition definition-message-delivery'>
   <xsl:choose>
    <xsl:when test="@broadcast='never'">Message must be sent directly to task</xsl:when>
    <xsl:when test="@broadcast='may'">Message may sent directly to task, or by broadcast (destination 0)</xsl:when>
    <xsl:when test="@broadcast='must'">Message must be broadcast (destination 0)</xsl:when>
    <xsl:otherwise>
     <xsl:message>Message 'broadcast' type not understood at
   <xsl:call-template name="describeposition" />.</xsl:message>
    </xsl:otherwise>
   </xsl:choose>
   <br />

   <xsl:choose>
    <xsl:when test="@recorded='never'">Message may only be sent normally (reason code 17)</xsl:when>
    <xsl:when test="@recorded='may'">Message may sent recorded delivery (reason code 18) or normally (reason code 17)</xsl:when>
    <xsl:when test="@recorded='must'">Message must be sent recorded delivery (reason code 18)</xsl:when>
    <xsl:otherwise>
     <xsl:message>Message 'recorded' type not understood at
   <xsl:call-template name="describeposition" />.</xsl:message>
    </xsl:otherwise>
   </xsl:choose>
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
        <div class='definition-title'>
          <span class='definition-name'><xsl:value-of select="@name"/></span>
        </div>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name="definition-internal"/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="definition-description"/>

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
        <div class='definition-title'>
          <span class='definition-name'><xsl:text>Error_</xsl:text><xsl:value-of select="@name"/></span>
          <span class='definition-number'>Error &amp;<xsl:value-of select="@number"/></span>
        </div>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <!-- huh ? this message should never come up, 'cos /any/ error might
      occur, so it's best to document 'em. But for consistencies sake... -->
   <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="definition-description"/>

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
    <div class='definition-title'>
        <span class='definition-name'>
          <xsl:text>Service_</xsl:text><xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <span class='definition-reason'>
     <xsl:value-of select="@reason"/>
     </span>
    </xsl:if>
    </span>

    <span class='definition-number'>Service &amp;<xsl:value-of select="@number"/>
<!--     <xsl:if test="@reason != ''"> -->
<!--      <xsl:text> reason </xsl:text> -->
<!--      <xsl:value-of select="@reason"/> -->
<!--     </xsl:if> -->
    </span>
    </div>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="definition-description"/>

  <xsl:call-template name='definition-entry'/>
  <xsl:call-template name='definition-exit'/>

  <xsl:apply-templates select="use" />

  <xsl:call-template name="examples-block">
   <xsl:with-param name="where" select="." />
  </xsl:call-template>

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
          <div class='definition-title'>
            <span class='definition-name'>
          <xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </span>
    <span class='definition-number'>Method &amp;<xsl:value-of select="@number"/>
<!--     <xsl:if test="@reason != ''"> -->
<!--      <xsl:text> reason </xsl:text> -->
<!--      <xsl:value-of select="@reason"/> -->
<!--     </xsl:if> -->
    </span>
    </div>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
  <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="definition-description"/>

  <xsl:call-template name='definition-entry'/>
  <xsl:call-template name='definition-exit'/>

  <xsl:apply-templates select="use" />

  <xsl:call-template name="examples-block">
   <xsl:with-param name="where" select="." />
  </xsl:call-template>

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
    <div class='definition-title'>
     <span class='definition-name'>
          <xsl:text>UpCall_</xsl:text><xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </span>
    <span class='definition-number'>UpCall &amp;<xsl:value-of select="@number"/>
<!--     <xsl:if test="@reason != ''"> -->
<!--      <xsl:text> reason </xsl:text> -->
<!--      <xsl:value-of select="@reason"/> -->
<!--     </xsl:if> -->
    </span>
    </div>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
   <xsl:call-template name='definition-internal'/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name='definition-description'/>

  <xsl:call-template name='definition-entry'/>
  <xsl:call-template name='definition-exit'/>

  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>
</section>

</xsl:template>

<xsl:template name="definition-internal">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defname" select="document('')//localdb:definition-names[@type=$deftype]/@name" />
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

<xsl:template name='definition-description'>
 <div class='definition-description'>
  <xsl:value-of select="@description"/>
 </div>
</xsl:template>

<xsl:template name='definition-entry'>
  <section class='definition definition-entry'>
  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
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
   <xsl:when test="count(entry/*)=0">None</xsl:when>
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
    Processor is in <xsl:value-of select="@processor-mode"/> mode
  </section>
</xsl:template>

<xsl:template name="definition-reentrancy">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defsingular" select="document('')//localdb:definition-names[@type=$deftype]/@singular" />
  <section class="definition definition-reentrancy">
  <xsl:choose>
    <xsl:when test='@re-entrant="yes"'><xsl:value-of select="$defsingular" /> is re-entrant</xsl:when>
    <xsl:when test='@re-entrant="undefined"'>Not defined</xsl:when>
    <xsl:when test='@re-entrant="no"'><xsl:value-of select="$defsingular" /> is not re-entrant</xsl:when>
    <xsl:otherwise><xsl:value-of select="@re-entrant"/></xsl:otherwise>
  </xsl:choose>
  </section>
</xsl:template>

<xsl:template name='definition-syntax'>
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defprefix" select="document('')//localdb:definition-names[@type=$deftype]/@prefix" />
<xsl:variable name="defseparator" select="document('')//localdb:definition-names[@type=$deftype]/@separator" />
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
    <table summary="Command parameters" border="0">
    <xsl:for-each select="parameter">
     <tr><td valign="top">
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
            <table summary="Switch aliases">
             <tr><td>&#160;</td>
              <td valign="top" align="left">
               <code>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="@switch" />
                <xsl:text> </xsl:text>
                <xsl:copy-of select="$param" />
               </code>
              </td>
             </tr>
             <tr><td><i>or</i></td>
              <td valign="top" align="left">
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
         <td valign="top">-</td>
         <td valign="top"><xsl:apply-templates /></td>
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
 <td valign="top" align="right">R<xsl:value-of select="@number"/></td>
  <xsl:choose>
   <xsl:when test="@state='preserved'">
    <!-- preserved is used on output registers -->
    <td valign="top" align="left" colspan="2">preserved</td>
   </xsl:when>
   <xsl:when test="@state='corrupted'">
    <!-- corrupted is used on output registers -->
    <td valign="top" align="left" colspan="2">corrupted</td>
   </xsl:when>
   <xsl:when test="@state='undefined'">
    <!-- undefined is used on input registers -->
    <td valign="top" align="left" colspan="2">undefined</td>
   </xsl:when>
   <xsl:otherwise>
    <td valign="top">=</td>
    <td valign="top" align="left">
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
  <td valign="top" align="right"><xsl:value-of select="@name"/></td>
  <td valign="top" align="left" colspan="2"><xsl:apply-templates/></td>
 </xsl:when>
 <xsl:otherwise>
  <td valign="top" align="right"><xsl:value-of select="@name"/></td>
  <td valign="top" align="left" colspan="2">
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
<table summary="A bitfield" border="0">
 <tr>
 <xsl:choose>
  <xsl:when test="count(*/@state)=0">
   <th align="right" valign="bottom">Bit</th>
   <xsl:if test="count(*/@name)>0">
    <th align="left" valign="bottom">Name</th>
   </xsl:if>
   <th align="left" valign="bottom">Meaning if set</th>
  </xsl:when>
  <xsl:otherwise>
   <th align="right" valign="bottom">Bit(s)</th>
   <xsl:if test="count(*/@name)>0">
    <th align="left" valign="bottom">Name</th>
   </xsl:if>
   <th align="left" valign="bottom">Meaning</th>
  </xsl:otherwise>
 </xsl:choose>
 </tr>
 <xsl:apply-templates/>
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
  <td valign="top" align="right"><xsl:value-of select="@number"/></td>
  <xsl:if test="count(../*/@name)>0">
   <td valign="top"><xsl:value-of select="@name"/></td>
  </xsl:if>

  <xsl:choose>
   <xsl:when test="@state = 'reserved'">
    <td valign="top" align="left" colspan="2">
     <xsl:text>Reserved, must be zero</xsl:text>
    </td>
   </xsl:when>

   <xsl:when test="(@state = 'set') or (@state = 'clear')">
    <td valign="top" align="right">
     <xsl:choose>
      <xsl:when test="@state='set'"><xsl:text>Set:</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>Clear:</xsl:text></xsl:otherwise>
     </xsl:choose>
    </td>
    <td valign="top" align="left">
     <xsl:apply-templates/>
    </td>

    <xsl:variable name="nextelement" select="following-sibling::bit[position() = 1]" />
    <xsl:if test="($nextelement/@number = @number) and
                  ($nextelement/@state != '')">
     <tr>
      <td></td>
      <xsl:if test="count(../*/@name)>0">
       <td valign="top"><xsl:value-of select="$nextelement/@name"/></td>
      </xsl:if>

      <td valign="top" align="right">
       <xsl:choose>
        <xsl:when test="$nextelement/@state='set'"><xsl:text>Set:</xsl:text></xsl:when>
        <xsl:otherwise><xsl:text>Clear:</xsl:text></xsl:otherwise>
       </xsl:choose>
      </td>
      <td valign="top" align="left">
       <xsl:apply-templates select="$nextelement/node()"/>
      </td>
     </tr>
    </xsl:if>
   </xsl:when>

   <xsl:otherwise>
    <td valign="top" align="left" colspan="2">
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
<table summary="Opaque table of values" border="0">
 <tr>
  <th align="right" valign="bottom"><xsl:value-of select="@head-number" /></th>
  <xsl:if test="$head-name != ''">
   <th align="left" valign="bottom"><xsl:value-of select="$head-name" /></th>
  </xsl:if>
  <th align="left" valign="bottom"><xsl:value-of select="@head-value" /></th>
 </tr>
 <xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="value">
<tr>
 <td valign="top" align="right"><xsl:value-of select="@number"/></td>
 <xsl:if test="../*/@name != ''">
  <td valign="top" align="left"><xsl:value-of select="@name"/></td>
 </xsl:if>
 <td valign="top" align="left">
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
<table summary="Opaque table of offset/contents" border="0">
 <tr>
  <th align="right" valign="bottom"><xsl:value-of select="@head-number" /></th>
  <xsl:if test="$head-name != ''">
   <th align="left" valign="bottom"><xsl:value-of select="$head-name" /></th>
  </xsl:if>
  <th align="left" valign="bottom"><xsl:value-of select="@head-value" /></th>
 </tr>
 <xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="offset">
<tr>
 <td valign="top" align="right">+<xsl:value-of select="@number"/></td>
 <xsl:if test="../*/@name != ''">
  <td valign="top" align="left"><xsl:value-of select="@name"/></td>
 </xsl:if>
 <td valign="top" align="left"><xsl:apply-templates/></td>
</tr>
</xsl:template>



<!-- An message table is similar to the offset-table -->
<xsl:template match="message-table">
<table summary="Opaque table for a wimp message block" border="0">
 <tr>
  <th align="right" valign="bottom">Offset</th>
  <xsl:if test="count(message/@name) > 0">
   <th align="left" valign="bottom">Name</th>
  </xsl:if>
  <th align="left" valign="bottom">Contents</th>
 </tr>
 <xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="message">
<tr>
 <td valign="top" align="right">R1+<xsl:value-of select="@offset"/></td>
 <xsl:if test="../*/@name != ''">
  <td valign="top" align="left"><xsl:value-of select="@name"/></td>
 </xsl:if>
 <td valign="top" align="left"><xsl:apply-templates/></td>
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

<!-- remember the text of where we're going to -->
<xsl:variable name="linktext">
<xsl:choose>
 <!-- SWI reference -->
 <xsl:when test="@type='swi'">
  <xsl:if test="(not(@href)) and
                 not (//swi-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>SWI definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="not(@href) and
                   (@use-description = 'yes') and
                   (//swi-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//swi-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Entry-point reference -->
 <xsl:when test="@type='entry'">
  <xsl:if test="not(@href) and
                 not (//entry-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Entry-point definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//entry-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//entry-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Command reference -->
 <xsl:when test="@type='command'">
  <xsl:if test="(not(@href)) and
                 not (//command-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Command definition for *<xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//command-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//command-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>*</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- VDU reference -->
 <xsl:when test="@type='vdu'">
  <xsl:if test="(not(@href)) and
                 not (//vdu-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>VDU definition for VDU <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//vdu-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//vdu-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>VDU </xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Message reference -->
 <xsl:when test="@type='message'">
  <xsl:if test="(not(@href)) and
                 not (//message-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Message definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//message-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//message-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>Message_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Error reference -->
 <xsl:when test="@type='error'">
  <xsl:if test="(not(@href)) and
                 not (//error-definition[@name=$refname])">
   <xsl:message>Error definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//error-definition[@name=$refname])">
    <xsl:value-of select="//error-definition[@name=$refname]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>Error_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Service reference -->
 <xsl:when test="@type='service'">
  <xsl:if test="(not(@href)) and
                 not (//service-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Service definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//service-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//service-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>Service_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Toolbox method reference -->
 <xsl:when test="@type='tboxmethod'">
  <xsl:if test="(not(@href)) and
                 not (//tboxmethod-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Toolbox Method definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//tboxmethod-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//tboxmethod-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Toolbox message reference -->
 <xsl:when test="@type='tboxmessage'">
  <xsl:if test="(not(@href)) and
                 not (//tboxmessage-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Toolbox Message definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//tboxmessage-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//tboxmessage-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- UpCall reference -->
 <xsl:when test="@type='upcall'">
  <xsl:if test="(not(@href)) and
                 not (//upcall-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>UpCall definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//upcall-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//upcall-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>UpCall_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Vector reference -->
 <xsl:when test="@type='vector'">
  <xsl:if test="(not(@href)) and
                 not (//vector-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Vector definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//vector-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//vector-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- SysVar reference -->
 <xsl:when test="@type='sysvar'">
<!--   <tt> -->
  <xsl:if test="(not(@href)) and
                 not (//sysvar-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>SystemVariable definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//sysvar-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//sysvar-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
<!--   </tt> -->
 </xsl:when>

 <!-- Section type reference -->
<!--  There must be an easier way to do this ? -->
 <xsl:when test="@type='section'">
  <xsl:if test="(not(@href)) and
                 not (//section[@title=$refname])">
   <xsl:message>Section for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>
 <xsl:when test="@type='subsection'">
  <xsl:if test="(not(@href)) and
                 not (//subsection[@title=$refname])">
   <xsl:message>SubSection for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>
 <xsl:when test="@type='subsubsection'">
  <xsl:if test="(not(@href)) and
                 not (//subsubsection[@title=$refname])">
   <xsl:message>SubSubSection for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>
 <xsl:when test="@type='category'">
  <xsl:if test="(not(@href)) and
                 not (//category[@title=$refname])">
   <xsl:message>Category for <xsl:value-of select="$refname" /> not found at
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
<font color="#DD0000">
<xsl:choose>
 <xsl:when test="(text() != '') or (count(*) > 0)">
  <strong>FIXME:</strong> <xsl:apply-templates />
 </xsl:when>
 <xsl:otherwise>
  <strong>FIXME</strong>
 </xsl:otherwise>
</xsl:choose>
</font>
</xsl:template>


<!-- List comes in two forms; ordered and unordered -->
<xsl:template match="list">
<xsl:choose>
 <xsl:when test="@type = 'ordered'">
  <ol>
   <xsl:apply-templates />
  </ol>
 </xsl:when>

 <xsl:otherwise>
  <ul>
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
<p><xsl:apply-templates /></p>
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
<br /><tt><xsl:apply-templates /></tt>
</xsl:template>

<!-- Menu option - an option that the user might chose for a menu -->
<xsl:template match="menuoption">
<em><xsl:apply-templates /></em>
</xsl:template>

<!-- Variable -->
<xsl:template match="variable">
<tt><xsl:apply-templates /></tt>
</xsl:template>

<!-- Command example -->
<xsl:template match="command">
<code><xsl:apply-templates /></code>
</xsl:template>

<!-- Function-like routine -->
<xsl:template match="function">
<code><xsl:apply-templates /></code>
</xsl:template>

<!-- a filename -->
<xsl:template match="filename">
<code><xsl:apply-templates /></code>
</xsl:template>

<!-- a system variable -->
<xsl:template match="sysvar">
<code><xsl:apply-templates /></code>
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
<xsl:text>-</xsl:text><xsl:value-of select="@name" />
<xsl:if test="(text() != '') or (count(*) > 0)">
 <xsl:text> </xsl:text>
 <xsl:apply-templates />
</xsl:if>
</xsl:template>

<!-- Long example -->
<xsl:template match="extended-example">
<xsl:if test="@type='unknown'">
 <xsl:message>Code type 'unknown' should not be used at :
  <xsl:call-template name="describeposition" />.</xsl:message>
</xsl:if>

<pre>
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
<xsl:apply-templates />
</code>
</xsl:template>

<!-- Stylistic changes -->
<!-- These should really be removed ASAP and replaced with more content-based
     elements, such as warning, important or note -->
<xsl:template match="strong">
<strong><xsl:apply-templates /></strong>
</xsl:template>
<xsl:template match="sup"><sup><xsl:apply-templates /></sup></xsl:template>
<xsl:template match="sub"><sub><xsl:apply-templates /></sub></xsl:template>
<xsl:template match="em"><em><xsl:apply-templates /></em></xsl:template>
<!-- I'm not at all sure I like the concept of having a break element -->
<xsl:template match="br"><br /></xsl:template>

<!-- Document import -->
<xsl:template match="import">
<xsl:apply-templates select="saxon:evaluate(concat('document(@document)/',@path))" />
</xsl:template>

<!-- EMail -->
<xsl:template match="email">
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
</xsl:template>

<!-- Image -->
<xsl:template match="image">
<xsl:if test="local-name(..) != 'image'">
 <p align="center" />
</xsl:if>
<xsl:choose>
 <xsl:when test="@type = 'png' or @type = 'svg'">
  <img align="center">
    <xsl:variable name="style">
     <xsl:if test="@width != ''">
      <xsl:text>width: </xsl:text><xsl:value-of select="@width" /><xsl:text>; </xsl:text>
     </xsl:if>
     <xsl:if test="@height != ''">
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
 <br />
 <em><xsl:value-of select="@caption" /></em>
</xsl:if>

</xsl:template>

<!-- Meta Data section -->
<xsl:template match="meta" mode="tail">
<footer>
 <section class='meta'>
  <h2 name="metadata" id="metadata">Document information</h2>
  <table class='meta' summary="Meta information table">
   <xsl:if test="count(maintainer) &gt; 0">
    <tr class='maintainer'>
     <th align="right" valign="top">Maintainer(s):</th>
     <td><xsl:apply-templates select="maintainer"/></td>
    </tr>
   </xsl:if>
   <xsl:if test="count(history) &gt; 0">
    <tr class='history'>
     <th>History:</th>
     <td><xsl:apply-templates select="history"/></td>
    </tr>
   </xsl:if>
   <xsl:if test="count(related) &gt; 0">
    <tr>
     <th class='related'>Related:</th>
     <td><xsl:apply-templates select="related" mode="meta" /></td>
    </tr>
   </xsl:if>
   <xsl:if test="count(disclaimer) &gt; 0">
    <tr class='disclaimer'>
     <th>Disclaimer:</th>
     <td>
      <xsl:apply-templates select="disclaimer"/>
     </td>
    </tr>
   </xsl:if>
  </table>
  </section>
 </footer>
</xsl:template>

<xsl:template match="history">
<table border="0" summary="Document history">
<tr>
 <th>Revision</th>
 <th>Date</th>
 <th>Author</th>
 <th>Changes</th>
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
   <ul>
    <xsl:apply-templates />
   </ul>
  </xsl:if>
 </td>
</tr>
</xsl:template>

<xsl:template match="change">
<li><xsl:apply-templates /></li>
</xsl:template>

</xsl:stylesheet>
