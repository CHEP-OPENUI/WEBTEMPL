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
    <html>
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>

      <body>
        <!-- Applet Title -->
        <table bgcolor="#333399" border="0" width="100%" cellpadding="2" cellspacing="0">
          <tr>
            <td align="left" valine="middle">
              <img border="0" src="images/swls_globe.gif"></img>
            </td>

            <td align="center" valine="middle" width="100%">
              <font face="Arial" color="#FFFFFF">
                <b>
                  <xsl:apply-templates select="//APPLICATION/@NAME"/>
                </b>
              </font>
            </td>
          </tr>
        </table>

        <table border="0" width="100%" cellpadding="0" cellspacing="0">
          <tr>
            <td bgcolor="#FFFFFF" height="2"></td>
          </tr>
          <tr bgcolor="#999999">
            <td align="center" valine="middle" width="100%">
              <font face="Arial" color="#FFFFFF">
                <b>
                  <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='MainTitle']"></xsl:apply-templates>
                </b>
              </font>
            </td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" height="1"></td>
          </tr>
        </table>

        <!-- Apply template for each SCREEN_ BAR element in Document-->
        <xsl:apply-templates select="//APPLICATION/NAVIGATION_ELEMENTS/SCREEN_BAR"></xsl:apply-templates>

        <!-- Build Logout Link -->
        <table bgcolor="#9999CC" border="0" width="100%" cellspacing="0" cellpadding="0">
          <tr>
            <td bgcolor="#333399" width="100%" height="2"></td>
          </tr>
        </table>

        <table bgcolor="#9999CC" border="0" width="100%" cellspacing="0" cellpadding="3">

          <tr align="left" valign="middle">
            <td>
              <xsl:for-each select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='Logout']">
                <xsl:call-template name="build_home_button"></xsl:call-template>
              </xsl:for-each>
            </td>
          </tr>
<!--
          <tr align="left" valign="middle">
            <xsl:for-each select="APPLICATION/NAVIGATION_ELEMENTS/PAGE_ITEM[@NAME='Logout']">
              <xsl:variable name="urllink">
                <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
              </xsl:variable>
              <td align="left" valine="middle">
                <xsl:element name="A">
                  <xsl:attribute name="HREF">
                    <xsl:value-of select="$urllink"></xsl:value-of>
                  </xsl:attribute>
                  <img border="0" src="images/icon_logout_enabled.gif" alt="Logout" align="left" valine="middle" width="25" height="21"></img>
                </xsl:element>
              </td>
            </xsl:for-each>
          </tr>
-->
        </table>

        <table bgcolor="#9999CC" border="0" width="100%" cellspacing="0" cellpadding="0">
          <tr>
            <td bgcolor="#333399" width="100%" height="2"></td>
          </tr>
        </table>

      </body>
    </html>
  </xsl:template >

  <!--  Process the Page Items on Web Pages here -->
  <xsl:template match="PAGE_ITEM">
    <xsl:choose>
      <xsl:when test="ANCHOR">
        <xsl:call-template name="build_simple_link"></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <b>
          <xsl:value-of select="@CAPTION"></xsl:value-of>
        </b>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Screen Bar code for Splash Screen -->
  <xsl:template match="SCREEN_BAR">
    <xsl:variable name="SWLSAppName">
      <xsl:value-of select="//APPLICATION/@NAME"/>
    </xsl:variable>

    <table border="1" align="center" valine="middle" width="100%" cellspacing="2" cellpadding="6">
      <tr>
        <xsl:for-each select="SCREEN_TAB">
          <xsl:variable name="linknumber">
            <xsl:number count="SCREEN_TAB"></xsl:number>
          </xsl:variable>
          <xsl:if test="$linknumber=1">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>
            <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
              <xsl:element name="A">
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$urllink"></xsl:value-of>
                </xsl:attribute>
                  <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
              </xsl:element>
            </td>
          </xsl:if>

          <xsl:if test="$linknumber=2">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>
            <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
              <xsl:element name="A">
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$urllink"></xsl:value-of>
                </xsl:attribute>
                <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
              </xsl:element>
            </td>
          </xsl:if>
        </xsl:for-each>
      </tr>

      <tr>
        <xsl:for-each select="SCREEN_TAB">
          <xsl:variable name="linknumber">
            <xsl:number count="SCREEN_TAB"></xsl:number>
          </xsl:variable>
          <xsl:if test="$linknumber=3">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>
            <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
              <xsl:element name="A">
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$urllink"></xsl:value-of>
                </xsl:attribute>
                <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
              </xsl:element>
            </td>
          </xsl:if>

          <xsl:if test="$linknumber=4">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>
            <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
              <xsl:element name="A">
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$urllink"></xsl:value-of>
                </xsl:attribute>
                <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
              </xsl:element>
            </td>
          </xsl:if>
        </xsl:for-each>
      </tr>

      <tr>
        <xsl:for-each select="SCREEN_TAB">
          <xsl:variable name="linknumber">
            <xsl:number count="SCREEN_TAB"></xsl:number>
          </xsl:variable>
          <xsl:if test="$linknumber=5">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="contains(normalize-space($SWLSAppName),normalize-space('LEAVING FOR FUTURE USE'))">
                <td bgcolor="#99BBEE" width="100%" align="center" valine="middle" colspan="2">
                  <xsl:element name="A">
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$urllink"></xsl:value-of>
                    </xsl:attribute>
                    <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
                  </xsl:element>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
                  <xsl:element name="A">
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$urllink"></xsl:value-of>
                    </xsl:attribute>
                    <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
                  </xsl:element>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>

          <xsl:if test="$linknumber=6">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>
            <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
              <xsl:element name="A">
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$urllink"></xsl:value-of>
                </xsl:attribute>
                <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
              </xsl:element>
            </td>
          </xsl:if>
        </xsl:for-each>
      </tr>

      <tr>
        <xsl:for-each select="SCREEN_TAB">
          <xsl:variable name="linknumber">
            <xsl:number count="SCREEN_TAB"></xsl:number>
          </xsl:variable>
          <xsl:if test="$linknumber=7">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="contains(normalize-space($SWLSAppName),normalize-space('LEAVING FOR FUTURE USE'))">
                <td bgcolor="#99BBEE" width="100%" align="center" valine="middle" colspan="2">
                  <xsl:element name="A">
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$urllink"></xsl:value-of>
                    </xsl:attribute>
                    <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
                  </xsl:element>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
                  <xsl:element name="A">
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$urllink"></xsl:value-of>
                    </xsl:attribute>
                    <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
                  </xsl:element>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>

          <xsl:if test="$linknumber=8">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>

            <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
              <xsl:element name="A">
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$urllink"></xsl:value-of>
                </xsl:attribute>
                <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
              </xsl:element>
            </td>
          </xsl:if>
        </xsl:for-each>
</tr>
      <tr>
        <xsl:for-each select="SCREEN_TAB">
          <xsl:variable name="linknumber">
            <xsl:number count="SCREEN_TAB"></xsl:number>
          </xsl:variable>
          <xsl:if test="$linknumber=9">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="contains(normalize-space($SWLSAppName),normalize-space('Sales'))">
                <td bgcolor="#99BBEE" width="100%" align="center" valine="middle" colspan="2">
                  <xsl:element name="A">
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$urllink"></xsl:value-of>
                    </xsl:attribute>
                    <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
                  </xsl:element>
                </td>
              </xsl:when>
              <xsl:otherwise>
                <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
                  <xsl:element name="A">
                    <xsl:attribute name="HREF">
                      <xsl:value-of select="$urllink"></xsl:value-of>
                    </xsl:attribute>
                    <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
                  </xsl:element>
                </td>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>

          <xsl:if test="$linknumber=10">
            <xsl:variable name="urllink">
              <xsl:apply-templates select ="ANCHOR"></xsl:apply-templates>
            </xsl:variable>

            <td bgcolor="#99BBEE" width="50%" align="center" valine="middle">
              <xsl:element name="A">
                <xsl:attribute name="HREF">
                  <xsl:value-of select="$urllink"></xsl:value-of>
                </xsl:attribute>
                <font face="Arial" size="2"><xsl:value-of select="@CAPTION"></xsl:value-of></font>
              </xsl:element>
            </td>
          </xsl:if>        
        </xsl:for-each>
      </tr>

    </table>
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
</xsl:stylesheet>