<?xml version="1.0" encoding="UTF-16" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/vnd.wap.wml" omit-xml-declaration="no" doctype-public="-//WAPFORUM//DTD WML 1.1//EN" doctype-system="http://www.wapforum.org/DTD/wml_1.1.xml"></xsl:output>

  <xsl:template match="/">
    <wml>
      <head>
        <meta forua="true" http-equiv="cache-control" content="max-age=0"/>
      </head>

      <template>
        <do type="prev" label="Back">
          <prev/>
        </do>
      </template>

      <card id="error" newcontext="true">
        <p>
          <xsl:value-of select="APPLICATION/ERROR/."></xsl:value-of>
          <br></br>

          <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='Main Menu']"></xsl:apply-templates>
          <br></br>

          <xsl:if test="//NAVIGATION_ELEMENTS/THREAD_BAR/THREAD">
            <xsl:apply-templates select="//NAVIGATION_ELEMENTS/THREAD_BAR"></xsl:apply-templates>
          </xsl:if>
        </p>
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
    <xsl:variable name="separator">
      <xsl:text>:</xsl:text>
    </xsl:variable>
    <xsl:if test="THREAD/ANCHOR">
      <xsl:element name="select">
        <xsl:attribute name="name">
          <xsl:text>threadlink</xsl:text>
        </xsl:attribute>
        <xsl:for-each select="THREAD">
          <xsl:if test="ANCHOR">
            <xsl:element name="option">
              <xsl:variable name="link">
                <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
              </xsl:variable>
              <xsl:attribute name="value">
                <xsl:value-of select="normalize-space($link)"></xsl:value-of>
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
              <xsl:element name="onevent">
                <xsl:attribute name="type">
                  <xsl:text>onpick</xsl:text>
                </xsl:attribute>
                <xsl:element name="go">
                  <xsl:attribute name="href">
                    <xsl:value-of select="normalize-space($link)"></xsl:value-of>
                  </xsl:attribute>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:if>
        </xsl:for-each>
      </xsl:element>
    </xsl:if>
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
