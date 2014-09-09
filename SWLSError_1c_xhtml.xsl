<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" omit-xml-declaration="no"
   doctype-public="-//WAPFORUM//DTD XHTML Mobile 1.0//EN"
   doctype-system="http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
  </xsl:output>

  <!--  This style sheet process the XML output for both the Splash screens and standard views -->
  <!--  ====================== Root Document Processing ======================== -->
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>

      <body>
        <xsl:value-of select="APPLICATION/ERROR/."></xsl:value-of>
        <br></br>

        <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='Main Menu']"></xsl:apply-templates>
        <br></br>

        <xsl:if test="//NAVIGATION_ELEMENTS/THREAD_BAR/THREAD">
          <xsl:apply-templates select="//NAVIGATION_ELEMENTS/THREAD_BAR"></xsl:apply-templates>
        </xsl:if>

      </body>
    </html>
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

  <xsl:template name="build_simple_link">
    <xsl:variable name="link">
      <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="$link"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="@CAPTION"></xsl:value-of>
    </xsl:element>
    <br></br>
  </xsl:template>

  <!--  Thread Pick List  -->
  <xsl:template match="//NAVIGATION_ELEMENTS/THREAD_BAR">
    <xsl:element name="form">
      <xsl:variable name="action_path">
        <xsl:if test="THREAD/ANCHOR">
          <xsl:value-of select="THREAD/ANCHOR/@PATH"></xsl:value-of>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="separator">
        <xsl:text>:</xsl:text>
      </xsl:variable>
      <xsl:attribute name="method">
        <xsl:text>post</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="action">
        <xsl:value-of select="$action_path"></xsl:value-of>
      </xsl:attribute>
      <xsl:if test="THREAD/ANCHOR">
        <xsl:for-each select="THREAD[1]">
          <xsl:if test="ANCHOR">
            <xsl:call-template name="thread_hidden_button"></xsl:call-template>
          </xsl:if>
        </xsl:for-each>
        <xsl:element name="select">
          <xsl:attribute name="Name">
            <xsl:text>SWEBMC</xsl:text>
          </xsl:attribute>
          <xsl:for-each select="THREAD">
            <xsl:if test="ANCHOR">
              <xsl:element name="option">
                <xsl:variable name="BMNumber">
                  <xsl:for-each select="ANCHOR/INFO">
                    <xsl:if test="@NAME='SWEBMC'">
                      <xsl:value-of select="normalize-space()"></xsl:value-of>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:attribute name="value">
                  <xsl:value-of select="normalize-space($BMNumber)"></xsl:value-of>
                </xsl:attribute>
                <xsl:variable name="threadTitle">
                  <xsl:value-of select="normalize-space(text())"></xsl:value-of>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="string-length($threadTitle)>13">
                    <xsl:variable name="subThreadTitle">
                      <xsl:value-of select="substring($threadTitle,1,13)"></xsl:value-of>
                    </xsl:variable>
                    <xsl:value-of select="concat(normalize-space(@TITLE),normalize-space($separator),normalize-space($subThreadTitle))"></xsl:value-of>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat(normalize-space(@TITLE),normalize-space($separator),normalize-space($threadTitle))"></xsl:value-of>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:element>
            </xsl:if>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="Input">
          <xsl:attribute name="Type">
            <xsl:text>submit</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="Value">
            <xsl:text>Go</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template name="thread_hidden_button">
    <xsl:for-each select="ANCHOR">
      <xsl:for-each select="CMD">
        <xsl:element name="input">
          <xsl:attribute name="type">
            <xsl:text>hidden</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="@NAME"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="@NAME"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="@VALUE"></xsl:value-of>
          </xsl:attribute>
        </xsl:element>
        <xsl:for-each select="ARG">
          <xsl:element name="input">
            <xsl:attribute name="type">
              <xsl:text>hidden</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="@NAME"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="@NAME"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:variable name="argstring">
                <xsl:if test="@NAME='Pu' or @NAME='R' or @NAME='Rs'">
                  <xsl:call-template name="ENCODE_ARG">
                    <xsl:with-param name="encode_string" select="normalize-space(.)"></xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="not (@NAME='Pu' or @NAME='R' or @NAME='Rs')">
                  <xsl:value-of select="normalize-space(.)"> </xsl:value-of>
                </xsl:if>
              </xsl:variable>
              <xsl:value-of select="$argstring"></xsl:value-of>
            </xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="INFO">
        <xsl:if test="@NAME != 'SWEBMC'">
          <xsl:element name="input">
            <xsl:attribute name="type">
              <xsl:text>hidden</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="@NAME"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="@NAME"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="normalize-space()"></xsl:value-of>
            </xsl:attribute>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
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
  </xsl:template>

  <xsl:template match="INFO">
    <xsl:variable name="info">
      <xsl:if test="string-length(normalize-space(.)) >0">
        <xsl:value-of select="normalize-space(.)"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$info"></xsl:value-of>
  </xsl:template>

  <xsl:template name="ENCODE_ARG">
    <xsl:param name="encode_string"></xsl:param>
    <xsl:if test="not (contains($encode_string, '+'))">
      <xsl:value-of select="$encode_string"></xsl:value-of>
    </xsl:if>
    <!--  recursive processing  -->
    <xsl:if test="contains($encode_string, '+')">
      <xsl:value-of select="substring-before($encode_string, '+')"></xsl:value-of>
      <xsl:text>%2B</xsl:text>
      <!--  replace + with %2B  -->
      <xsl:call-template name="ENCODE_ARG">
        <xsl:with-param name="encode_string" select="substring-after($encode_string, '+')"></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
