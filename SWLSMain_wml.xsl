<?xml version="1.0" encoding="UTF-16" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/vnd.wap.wml" omit-xml-declaration="no" doctype-public="-//WAPFORUM//DTD WML 1.1//EN" doctype-system="http://www.wapforum.org/DTD/wml_1.1.xml"></xsl:output>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="APPLICATION/NAVIGATION_ELEMENTS/SCREEN_BAR">
        <xsl:call-template name="splash_screen"></xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="splash_screen">
    <wml>
      <head>
        <meta forua="true" http-equiv="cache-control" content="max-age=0"/>
      </head>

      <!-- This SplashMessage is only for the first logged in user to main menu layout -->
      <xsl:if test="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='SplashMessage']">
        <card id="splash" ontimer="#main">
          <timer value="20" />
          <p align="center">
            <b>
            <xsl:variable name="applicationName">
              <xsl:value-of select="APPLICATION/@NAME"></xsl:value-of>
            </xsl:variable>
            <xsl:value-of select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM/@CAPTION"></xsl:value-of>
            </b>
          </p>
        </card>
      </xsl:if>

      <card id="main" newcontext="true">
        <xsl:choose>
          <xsl:when test="string-length(APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='Logout'])>0">
            <xsl:element name="do">
              <xsl:attribute name="type">
                <xsl:text>options</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="label">
                <xsl:value-of select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='Logout']/@CAPTION"></xsl:value-of>
              </xsl:attribute>
              <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='Logout']"></xsl:apply-templates>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="do">
              <xsl:attribute name="type">
                <xsl:text>options</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="label">
                <xsl:text>EXIT</xsl:text>
              </xsl:attribute>
              <xsl:element name="go">
                <xsl:attribute name="href">
                  <xsl:text>start.swe?Nct=true&amp;C=Bye</xsl:text>
                </xsl:attribute>
              </xsl:element>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:element name="p">
          <xsl:attribute name="mode">
            <xsl:text>nowrap</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='MainTitle']"></xsl:apply-templates>
          <br></br>
          <xsl:apply-templates select="//APPLICATION/NAVIGATION_ELEMENTS/SCREEN_BAR"></xsl:apply-templates>
        </xsl:element>
      </card>
    </wml>
  </xsl:template>

  <xsl:template match="PAGE_ITEM">
    <xsl:choose>
      <xsl:when test="ANCHOR">
        <xsl:call-template name="build_simple_link"></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <b><xsl:value-of select="@CAPTION"></xsl:value-of></b>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="SCREEN_BAR">
    <xsl:for-each select="SCREEN_TAB">
      <xsl:variable name="linknumber">
        <xsl:number count="SCREEN_TAB"></xsl:number>
      </xsl:variable>

      <xsl:variable name="link">
        <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
      </xsl:variable>

      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="$link"></xsl:value-of>
        </xsl:attribute>
        <xsl:value-of select="$linknumber"></xsl:value-of>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="@CAPTION" disable-output-escaping="yes"></xsl:value-of>
      </xsl:element>
      <br></br>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="build_simple_link">
    <xsl:variable name="link">
      <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="go">
      <xsl:attribute name="href">
        <xsl:value-of select="$link"></xsl:value-of>
      </xsl:attribute>
    </xsl:element>
    <br></br>
  </xsl:template>

  <!--  =========================== Anchor URL Processing =============================== -->
  <xsl:template match="ANCHOR">
    <xsl:text>start.swe?Nct=true</xsl:text>
    <xsl:text>&amp;</xsl:text>
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

    <xsl:variable name="name">
      <xsl:value-of select="@NAME"></xsl:value-of>
    </xsl:variable>

    <xsl:if test="$name!='SWENeedContext'">
      <xsl:text>&amp;</xsl:text>
      <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$arg"></xsl:value-of>
    </xsl:if>
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
</xsl:stylesheet>
