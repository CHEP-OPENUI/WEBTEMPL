<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" media-type="text/html"></xsl:output>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="APPLICATION/NAVIGATION_ELEMENTS/SCREEN_BAR">
        <xsl:call-template name="splash_screen"></xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="splash_screen">
    <HTML>
      <HEADER>
        <META http-equiv="cache-control" content="no-cache"></META>
      </HEADER>

      <BODY>
        <!--  Main Menu title for Splash Screen (Add this control in Tools??) -->
        <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='MainTitle']"></xsl:apply-templates>
        <br></br>
        <!--  Apply template for each SCREEN_ BAR element in Document -->
        <xsl:apply-templates select="//APPLICATION/NAVIGATION_ELEMENTS/SCREEN_BAR"></xsl:apply-templates>
        <!--  Build Logout Link  -->
        <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='Logout']"></xsl:apply-templates>
      </BODY>
    </HTML>
  </xsl:template>

  <!--  Process the Page Items on Web Pages here -->
  <xsl:template match="PAGE_ITEM">
    <xsl:choose>
      <!--  Page Items with Links  -->
      <xsl:when test="ANCHOR">
        <xsl:call-template name="build_simple_link"></xsl:call-template>
      </xsl:when>
      <!--  labels  -->
      <xsl:otherwise>
        <b>
          <xsl:value-of select="@CAPTION"></xsl:value-of>
        </b>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  Screen Bar code for Splash Screen  -->
  <xsl:template match="SCREEN_BAR">
    <!--  Loop through each of the Screen tab elements to build Splash menu -->
    <xsl:for-each select="SCREEN_TAB">
      <!--  get Menu Link number for I-Mode AccessKey function -->
      <xsl:variable name="linknumber">
        <xsl:number count="SCREEN_TAB"></xsl:number>
      </xsl:variable>
      <!--  Build URL for Link -->
      <xsl:variable name="link">
        <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
      </xsl:variable>
      <xsl:element name="A">
        <xsl:attribute name="HREF">
          <xsl:value-of select="$link"></xsl:value-of>
        </xsl:attribute>
        <xsl:attribute name="accesskey">
          <xsl:value-of select="$linknumber"></xsl:value-of>
        </xsl:attribute>
        <xsl:value-of select="$linknumber"></xsl:value-of>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="@CAPTION" disable-output-escaping="yes"></xsl:value-of>
      </xsl:element>
      <br></br>
    </xsl:for-each>
    <br></br>
  </xsl:template>

  <xsl:template name="build_simple_link">
    <xsl:variable name="link">
      <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="A">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$link"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="@CAPTION"></xsl:value-of>
    </xsl:element>
    <br></br>
  </xsl:template>

  <!--  =========================== Anchor URL Processing =============================== -->
  <!--  ANCHOR Template  builds the URL for drilldowns and links  -->
  <xsl:template match="ANCHOR">
    <xsl:text>start.swe?</xsl:text>
    <xsl:apply-templates select="CMD|INFO"></xsl:apply-templates>
  </xsl:template>

  <xsl:template match="CMD">
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="@VALUE"></xsl:value-of>
    <xsl:apply-templates select="ARG"></xsl:apply-templates>
  </xsl:template>

  <xsl:template match="ARG">
    <xsl:variable name="arg">
      <xsl:if test="string-length(normalize-space(.)) >0">
        <xsl:variable name="argstring" select="normalize-space()"></xsl:variable>
        <xsl:value-of select="$argstring"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$arg"></xsl:value-of>
    <!-- <xsl:text>&#38;</xsl:text> -->
    <!-- <xsl:value-of select="@NAME"/>=<xsl:value-of select="translate($arg,'&#x20;','+')'"/> -->
  </xsl:template>

  <xsl:template match="INFO">
    <xsl:variable name="info">
      <xsl:if test="string-length(normalize-space(.)) >0"><!-- <xsl:value-of select="."/> -->
        <xsl:value-of select="normalize-space(.)"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$info"></xsl:value-of>
  </xsl:template>
</xsl:stylesheet>
