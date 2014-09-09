<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" media-type="text/html"></xsl:output>

  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>

      <body>
        <table bgcolor="#333399" border="0" width="100%" cellpadding="2" cellspacing="1">
          <tr>
            <td width="100%" align="center" bgcolor="#FFFFFF">
              <img border="0" src="images/logo77.gif"></img>
            </td>
          </tr>
        </table>

        <table bgcolor="#333399" border="0" width="100%" height="120" cellpadding="2" cellspacing="1">
          <tr>
            <td height="115" width="100%" align="center" valign="middle" background="images/globe77_d.gif">
              <font face="Arial" color="#FFFFFF" align="center">
                <xsl:apply-templates select="APPLICATION/FORM/ERROR"></xsl:apply-templates>
              </font>
              <br/>
              <font face="Arial" color="#FFFFFF" align = "center" size="5">
                <b>
                  <xsl:variable name="loginTitle">
                    <xsl:value-of select="normalize-space(//APPLICATION/@NAME)"></xsl:value-of>
                  </xsl:variable>
                  <xsl:value-of select="$loginTitle"></xsl:value-of>
                </b>
              </font>
            </td>
          </tr>
        </table>

        <table border="0" width="100%" cellpadding="0" cellspacing="0">
          <tr>
            <td bgcolor="#FFFFFF" height="2"></td>
          </tr>
          <tr>
            <td bgcolor="#99CC22" height="8"></td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF" height="2"></td>
          </tr>
        </table>

        <table bgcolor="#6699CC" border="0" width="100%" cellpadding="2" cellspacing="1">
          <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS"></xsl:apply-templates>
        </table>

      </body>
    </html>
  </xsl:template>

  <!--  Login Error  -->
  <xsl:template match="ERROR">
    <xsl:value-of select="."></xsl:value-of>
    <br></br>
  </xsl:template>

  <!--  Navigation Element Template  -->
  <xsl:template match="NAVIGATION_ELEMENTS">
    <xsl:variable name="formlink">
      <xsl:apply-templates select="PAGE_ITEM[@NAME='LoginButton']"></xsl:apply-templates>
    </xsl:variable>

    <xsl:element name="Form">
      <xsl:attribute name="METHOD">
        <xsl:text>POST</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="ACTION">
        <xsl:value-of select="normalize-space($formlink)"></xsl:value-of>
      </xsl:attribute>

      <tr>
        <td>
          <table bgcolor="#6699CC" border="0" width="85%" cellpadding="0" cellspacing="0">
            <tr>
              <td align="right" valign="middle">
                <xsl:if test="PAGE_ITEM[@NAME='UserNameLabel']">
                  <xsl:apply-templates select="PAGE_ITEM[@NAME='UserNameLabel']"></xsl:apply-templates>
                </xsl:if>
              </td>

              <td align="left" valign="middle">
                <xsl:if test="PAGE_ITEM[@NAME = '_SweUserName']">
                  <xsl:apply-templates select="PAGE_ITEM[@NAME = '_SweUserName']"></xsl:apply-templates>
                </xsl:if>
              </td>
            </tr>

            <tr>
              <td align="right" valign="middle">
                <xsl:if test="PAGE_ITEM[@NAME=@NAME = 'PasswordLabel']">
                  <xsl:apply-templates select="PAGE_ITEM[@NAME = 'PasswordLabel']"></xsl:apply-templates>
                </xsl:if>
              </td>

              <td align="left" valign="middle">
                <xsl:if test="PAGE_ITEM[@NAME = '_SwePassword']">
                  <xsl:apply-templates select="PAGE_ITEM[@NAME = '_SwePassword']"></xsl:apply-templates>
                </xsl:if>
              </td>
            </tr>
          </table>
        </td>

        <td align="left" valign="middle" width="15%">
          <xsl:for-each select="PAGE_ITEM[@NAME='LoginButton']">
            <input type="image" src="images/login77_d.gif"></input>
          </xsl:for-each>
        </td>

      </tr>

      <xsl:element name="Input">
        <xsl:attribute name="Type">
          <xsl:text>hidden</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="Name">
          <xsl:text>SWECmd</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="Value">
          <xsl:text>ExecuteLogin</xsl:text>
        </xsl:attribute>
      </xsl:element>

      <xsl:element name="Input">
        <xsl:attribute name="Type">
          <xsl:text>hidden</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="Name">
          <xsl:text>SWENeedContext</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="Value">
          <xsl:text>false</xsl:text>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match = "PAGE_ITEM">
    <xsl:if test="@NAME = 'UserNameLabel'">
      <font face="Arial" color="#FFFFFF" size="1">
        <xsl:value-of select = "@CAPTION"></xsl:value-of>
      </font>
    </xsl:if>

    <xsl:if test="@NAME = '_SweUserName'">
      <xsl:element name = "Input">
        <xsl:attribute name="type">
          <xsl:text>text</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="Name">
          <xsl:text>SWEUserName</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="size">
          <xsl:text>13</xsl:text>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>

    <xsl:if test="@NAME = 'PasswordLabel'">
      <font face="Arial" color="#FFFFFF" size="1">
        <xsl:value-of select="@CAPTION"></xsl:value-of>
      </font>
    </xsl:if>

    <xsl:if test="@NAME = '_SwePassword'">
      <xsl:element name="Input">
        <xsl:attribute name="type">
          <xsl:value-of select="@TYPE"/>
        </xsl:attribute>
        <xsl:attribute name="Name">
          <xsl:text>SWEPassword</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="size">
          <xsl:text>13</xsl:text>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>

    <xsl:if test="@NAME = 'LoginButton'">
      <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
    </xsl:if>

  </xsl:template>

  <!-- ============================== ANCHOR Template ==============================-->
  <xsl:template match="ANCHOR">
    <xsl:value-of select="@PATH"></xsl:value-of>
    <xsl:text>?</xsl:text>
    <!-- <xsl:apply-templates select="CMD|INFO"></xsl:apply-templates> -->
  </xsl:template>

  <xsl:template match="CMD">
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="@VALUE"></xsl:value-of>
    <xsl:apply-templates select="ARG"></xsl:apply-templates>
  </xsl:template>

  <xsl:template match="ARG">
    <xsl:variable name="arg">
      <xsl:if test="string-length(normalize-space(.)) >0">
        <xsl:variable name="argstring" select="normalize-space()"></xsl:variable>
        <!-- <xsl:value-of select="."></xsl:value-of> -->
        <xsl:value-of select="$argstring"></xsl:value-of>
        <!-- <xsl:value-of select="."></xsl:value-of> -->
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$arg"></xsl:value-of>
  </xsl:template>

  <xsl:template match="INFO">
    <xsl:variable name="info">
      <xsl:if test="string-length(normalize-space(.)) >0">
        <xsl:value-of select="."></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$info"></xsl:value-of>
  </xsl:template>
</xsl:stylesheet>
