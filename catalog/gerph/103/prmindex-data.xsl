<?xml version="1.0" standalone="yes"?>

<!-- Data about elements in the documentation.

     For more details on this style sheet, contact gerph@gerph.org.
  -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:localdb="local-file-database"
                xmlns="http://gerph.org/dtd/prminxml-indexdata"
                exclude-result-prefixes="localdb">





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

<xsl:output method="xml" indent="yes"/>

<xsl:param name="base-dir" select="'.'"/>
<xsl:param name="output-dir" select="//dirs/@output" />
<xsl:param name="input-dir" select="//dirs/@input" />


<xsl:variable name="title-to-id-src">ABCDEFGHIJKLMNOPQRSTUVWXYZ ,$:()-*?</xsl:variable>
<xsl:variable name="title-to-id-map">abcdefghijklmnopqrstuvwxyz_-_-</xsl:variable>

<xsl:template match="/">
<indexed>
 <xsl:apply-templates select="//page" mode='index-data'/>
</indexed>
</xsl:template>

<xsl:template match="text()"/>


<xsl:template match="page" mode="index-data">
<xsl:variable name="href">
<xsl:apply-templates mode="dir" select=".."/>
<xsl:value-of select="@href"/>
</xsl:variable>

<!-- now any index links -->
<xsl:call-template name="chapter" mode='index'>
    <xsl:with-param name="document" select="document(concat($base-dir, '/', $input-dir, '/', $href,'.xml'))//chapter" />
    <xsl:with-param name="href" select="$href" />
    <xsl:with-param name="page" select="." />
</xsl:call-template>

</xsl:template>

<xsl:template name="chapter" mode="index">
<xsl:param name="document"/>
<xsl:param name="href"/>
<xsl:param name="page"/>


<xsl:if test="not($document)">
    <xsl:message>
        <xsl:text>Cannot read document '</xsl:text>
        <xsl:value-of select='$href'/>
        <xsl:text>'</xsl:text>
    </xsl:message>
</xsl:if>

<index-ref type="chapter" name="{$document/@title}" docref="{$href}"/>

<xsl:for-each select="$document//section|$document//subsection|$document//subsubsection|$document//category">
    <!-- FIXME -->
    <xsl:variable name="deftype" select="local-name(.)" />
    <index-ref type="{$deftype}" name="{@title}" docref="{$href}">
        <xsl:attribute name='anchorref'>
            <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
        </xsl:attribute>
    </index-ref>
</xsl:for-each>


<xsl:for-each select="$document//swi-definition|$document//vector-definition|$document//entry-definition|$document//service-definition|$document//upcall-definition|$document//command-definition|$document//sysvar-definition|$document//message-definition|$document//error-definition|$document//vdu-definition|$document//tboxmethod-definition|$document//tboxmessage-definition">
    <xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
    <xsl:variable name='definition' select="document('')//localdb:sections[@type=$deftype]"/>

    <xsl:if test="$definition">
        <index-ref type="{$deftype}" name="{@name}" description="{@description}" docref="{$href}">
            <xsl:if test="$definition/@number = 'yes'">
                <xsl:attribute name="number">
                    <xsl:value-of select="@number"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@reason and @reason != ''">
                <xsl:attribute name="reason">
                    <xsl:value-of select="@reason"/>
                </xsl:attribute>
                <xsl:if test="@reasonname and @reasonname != ''">
                    <xsl:attribute name="reasonname">
                        <xsl:value-of select="@reasonname"/>
                    </xsl:attribute>
                </xsl:if>
            </xsl:if>

            <xsl:attribute name='anchorref'>
                <xsl:value-of select="substring-before(local-name(.),'-')" />
                <xml:text>_</xml:text>
                <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
                <xsl:if test="@reason!=''">
                 <xsl:text>-</xsl:text>
                 <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
                </xsl:if>
            </xsl:attribute>
        </index-ref>
    </xsl:if>
</xsl:for-each>
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

</xsl:stylesheet>
