<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" media-type="text/html"></xsl:output>

  <!-- This style sheet process the XML output for both the Splash screens and standard views-->
  <!-- ====================== Root Document Processing ========================-->
  <!-- Document Root-->
  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>

      <body>
        <!-- Head: Title of Page-->
        <table bgcolor="#333399" border="0" width="100%" cellpadding="2" cellspacing="0">
          <tr>
            <td align="center" valine="middle" width="100%">
              <font face="Arial" color="#FFFFFF">
                <b>
                  <xsl:apply-templates select="//APPLICATION/@NAME"/>
                </b>
              </font>
            </td>
          </tr>
        </table>

        <!-- Body: Error Message Body -->
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
          <tr>
            <td bgcolor="#FFFFFF" width="100%" height="1"></td>
          </tr>
        </table>
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#000066" width="100%" height="2"></td>
          </tr>
        </table>
        <table border="0" width="100%"  cellspacing="0" cellpadding="3" bgcolor="#FFFF77">
          <tr>
            <td>
              <font face="Arial" color="#000000"> 
                <xsl:value-of select="normalize-space(APPLICATION/ERROR/.)"/>
              </font>
            </td>  
          </tr>
        </table>


        <!-- Tail: Home Link -->
        <table border="0" width="100%"  cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#000066" width="100%" height="1"></td>
          </tr>
        </table>

        <table border="0" width="100%"  cellspacing="0" cellpadding="3" bgcolor="#9999CC">
          <tr>
            <td align="left" valign="top">
              <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='Main Menu']"></xsl:apply-templates>
            </td>
            <!-- Thread Pick List -->
            <xsl:if test="//NAVIGATION_ELEMENTS/THREAD_BAR/THREAD">
              <td align="right">
                <xsl:apply-templates select="//NAVIGATION_ELEMENTS/THREAD_BAR"></xsl:apply-templates>
              </td>
            </xsl:if>
          </tr>
        </table>

        <table border="0" width="100%"  cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#000066" width="100%" height="2"></td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>

  <!-- Process the Page Items on Web Pages here-->
  <xsl:template match="PAGE_ITEM">
    <xsl:choose>
      <xsl:when test="ANCHOR">
        <xsl:call-template name="build_link_or_home_button"></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <b>
          <xsl:value-of select="@CAPTION"></xsl:value-of>
        </b>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="build_link_or_home_button">
    <xsl:choose>
      <xsl:when test="@NAME='Main Menu'">
        <xsl:call-template name="build_home_button"></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="build_simple_link"></xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="build_simple_link">
    <xsl:variable name="link">
      <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="A">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$link"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="normalize-space(@CAPTION)"></xsl:value-of>
    </xsl:element>
  </xsl:template>

  <xsl:template name="build_home_button">
    <xsl:variable name="link">
      <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="preLink">
      <xsl:text>document.location.href='</xsl:text>
    </xsl:variable>
    <xsl:variable name="postLink">
      <xsl:text>'</xsl:text>
    </xsl:variable>
    <xsl:element name="Input">
      <xsl:attribute name="Type">
        <xsl:text>button</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="Value">
        <xsl:value-of select="@CAPTION"></xsl:value-of>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:value-of select="@NAME"></xsl:value-of>
      </xsl:attribute>
      <xsl:attribute name="onclick">
        <xsl:value-of select="concat(normalize-space($preLink), normalize-space($link), normalize-space($postLink))"></xsl:value-of>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!--  Thread Pick List  -->
  <xsl:template match="//NAVIGATION_ELEMENTS/THREAD_BAR">
    <xsl:element name="Form">
      <xsl:attribute name="METHOD">
        <xsl:text>POST</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:text>thread</xsl:text>
      </xsl:attribute>
      <xsl:variable name="separator">
        <xsl:text>:</xsl:text>
      </xsl:variable>
      <xsl:if test="THREAD/ANCHOR">
        <xsl:element name="Select">
          <xsl:attribute name="Name">
            <xsl:text>threadlink</xsl:text>
          </xsl:attribute>
          <xsl:for-each select="THREAD">
            <xsl:if test="ANCHOR">
              <xsl:element name="Option">
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
                  <xsl:when test="string-length($threadTitle)>15">
                    <xsl:variable name="subThreadTitle">
                      <xsl:value-of select="substring($threadTitle,1,15)"></xsl:value-of>
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
            <xsl:text>button</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="Value">
            <xsl:text>Go</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:text>document.location.href=document.thread.threadlink.options[document.thread.threadlink.selectedIndex].value</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template name="build_thread_link">
    <xsl:choose>
      <xsl:when test="ANCHOR">
        <xsl:variable name="link">
          <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
        </xsl:variable>
        <xsl:element name="A">
          <xsl:attribute name="HREF">
            <xsl:value-of select="$link"></xsl:value-of>
          </xsl:attribute>
          <xsl:value-of select="normalize-space(@TITLE)"></xsl:value-of>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(@TITLE)"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- =========================== Anchor URL Processing ===============================-->
  <!-- ANCHOR Template  builds the URL for drilldowns and links -->
  <xsl:template match="ANCHOR">
    <xsl:text>start.swe?</xsl:text>
      <xsl:apply-templates select="CMD|INFO"/>
  </xsl:template>

  <xsl:template match="CMD">
    <xsl:value-of select="@NAME"/>=<xsl:value-of select="@VALUE"/>
    <xsl:apply-templates select="ARG"/>
  </xsl:template>

  <xsl:template match="ARG">
    <xsl:variable name="arg">
      <xsl:if test="string-length(normalize-space(.)) >0">
        <xsl:variable name="argstring" select="normalize-space()"/>
        <xsl:value-of select="$argstring"/>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$arg"></xsl:value-of>
  </xsl:template>

  <xsl:template match="INFO">
    <xsl:variable name="info">
      <xsl:if test="string-length(normalize-space(.)) >0">
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"/>=<xsl:value-of select="$info"/>
  </xsl:template>
</xsl:stylesheet>

