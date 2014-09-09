<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes" media-type="text/html" omit-xml-declaration="no"
 doctype-public="-//WAPFORUM//DTD XHTML Mobile 1.0//EN"
 doctype-system="http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
</xsl:output>


<!--  Document Root  -->
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>
      <body>
        <xsl:apply-templates select="APPLICATION/FORM/ERROR"></xsl:apply-templates>
        <b>
          <xsl:value-of select="//PAGE_ITEM[@NAME='LoginTitle']/@CAPTION"></xsl:value-of>
        </b>
        <br></br>
        <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS"></xsl:apply-templates>
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
    <xsl:element name="form">
      <xsl:attribute name="method">
        <xsl:text>POST</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="action">
        <xsl:value-of select="normalize-space($formlink)"></xsl:value-of>
      </xsl:attribute>
      <xsl:for-each select="PAGE_ITEM">
        <xsl:choose>
          <xsl:when test="@NAME = 'UserNameLabel'">
            <xsl:value-of select="@CAPTION"></xsl:value-of>
            <br></br>
          </xsl:when>
          <xsl:when test="@NAME = '_SweUserName'">
            <xsl:element name="input">
              <xsl:attribute name="type">
                <xsl:text>text</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="name">
                <xsl:text>SWEUserName</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="size">
                <xsl:text>20</xsl:text>
              </xsl:attribute>
            </xsl:element>
            <br></br>
          </xsl:when>
          <xsl:when test="@NAME = 'PasswordLabel'">
            <xsl:value-of select="@CAPTION"></xsl:value-of>
            <br></br>
          </xsl:when>
          <xsl:when test="@NAME = '_SwePassword'">
            <xsl:element name="input">
              <xsl:attribute name="type">
                <xsl:value-of select="@TYPE"/>
              </xsl:attribute>
              <xsl:attribute name="name">
                <xsl:text>SWEPassword</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="size">
                <xsl:text>20</xsl:text>
              </xsl:attribute>
            </xsl:element>
            <br></br>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <xsl:element name="input">
        <xsl:attribute name="type">
          <xsl:text>hidden</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:text>SWECmd</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="value">
          <xsl:text>ExecuteLogin</xsl:text>
        </xsl:attribute>
      </xsl:element>
      <xsl:element name="input">
        <xsl:attribute name="type">
          <xsl:text>hidden</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:text>SWENeedContext</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="value">
          <xsl:text>false</xsl:text>
        </xsl:attribute>
      </xsl:element>
      <xsl:for-each select="PAGE_ITEM[@NAME='LoginButton']">
        <xsl:element name="input">
          <xsl:attribute name="type">
            <xsl:text>submit</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="@CAPTION"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="@NAME"></xsl:value-of>
          </xsl:attribute>
        </xsl:element>
      </xsl:for-each>
      <br></br>
    </xsl:element>
  </xsl:template>

  <xsl:template match="PAGE_ITEM">
    <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
  </xsl:template>

  <!--  ANCHOR Template  -->
  <xsl:template match="ANCHOR">
    <xsl:value-of select="@PATH"></xsl:value-of>
    <xsl:text>?</xsl:text>
  </xsl:template>

  <xsl:template match="CMD">
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="@VALUE"></xsl:value-of>
    <xsl:apply-templates select="ARG"></xsl:apply-templates>
  </xsl:template>

  <xsl:template match="ARG">
    <xsl:variable name="arg">
      <xsl:if test="string-length(normalize-space(.)) >0">
        <xsl:variable name="argstring" select="normalize-space()">
        </xsl:variable>
        <xsl:value-of select="$argstring"></xsl:value-of>
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