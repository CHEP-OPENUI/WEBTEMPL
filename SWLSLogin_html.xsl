<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" media-type="text/html"></xsl:output>

  <xsl:template match="/">
    <HTML>
      <HEADER>
        <META http-equiv="cache-control" content="no-cache"></META>
      </HEADER>
      <BODY>
        <xsl:apply-templates select="APPLICATION/FORM/ERROR"></xsl:apply-templates>
        <b>
          <xsl:value-of select="//PAGE_ITEM[@NAME='LoginTitle']/@CAPTION"></xsl:value-of>
        </b>
        <br></br>
        <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS"></xsl:apply-templates>
      </BODY>
    </HTML>
  </xsl:template>

  <!--  Login Error  -->
  <xsl:template match="ERROR">
    <xsl:value-of select="."></xsl:value-of>
    <br></br>
  </xsl:template>

  <!--  Navigation Element Template  -->
  <xsl:template match="NAVIGATION_ELEMENTS">
    <xsl:variable name="formlink">
      <!-- <xsl:apply-templates select="PAGE_ITEM[@NAME='LoginButton']"></xsl:apply-templates> -->
      <xsl:apply-templates select="PAGE_ITEM[@NAME='LoginButton']"></xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="Form">
      <xsl:attribute name="METHOD">
        <xsl:text>POST</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="ACTION">
        <xsl:value-of select="normalize-space($formlink)"></xsl:value-of>
        <!-- <xsl:text>/wpsales/start.swe?</xsl:text> -->
      </xsl:attribute>
      <xsl:for-each select="PAGE_ITEM">
        <xsl:choose>
          <xsl:when test="@NAME = 'UserNameLabel'">
            <!-- <xsl:when test="@NAME = 'UserNameLabel'"> -->
            <xsl:value-of select="@CAPTION"></xsl:value-of>
            <br></br>
          </xsl:when>
          <xsl:when test="@NAME = '_SweUserName'">
            <!-- <xsl:when test="@NAME = '_SweUserName'"> -->
            <xsl:element name="Input">
              <xsl:attribute name="type">
                <xsl:text>text</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="Name">
                <xsl:text>SWEUserName</xsl:text>
                <!-- <xsl:value-of select="@NAME"></xsl:value-of> -->
              </xsl:attribute>
              <xsl:attribute name="size">
                <xsl:text>20</xsl:text>
              </xsl:attribute>
            </xsl:element>
            <br></br>
          </xsl:when>
          <!-- <xsl:when test="@NAME = 'PasswordLabel'"> -->
          <xsl:when test="@NAME = 'PasswordLabel'">
            <xsl:value-of select="@CAPTION"></xsl:value-of>
            <br></br>
          </xsl:when>
          <!-- <xsl:when test="@NAME = '_SwePassword'"> -->
          <xsl:when test="@NAME = '_SwePassword'">
            <xsl:element name="Input">
              <xsl:attribute name="type">
                <!-- <xsl:text>text</xsl:text> -->
                <xsl:value-of select="@TYPE"/>
              </xsl:attribute>
              <xsl:attribute name="Name">
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
      <!-- <xsl:for-each select="PAGE_ITEM[@NAME='LoginButton']"> -->
      <xsl:for-each select="PAGE_ITEM[@NAME='LoginButton']">
        <xsl:element name="Input">
          <xsl:attribute name="Type">
            <xsl:text>submit</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="Value">
            <xsl:value-of select="@CAPTION"></xsl:value-of>
            <!-- <xsl:text>Submit</xsl:text> -->
          </xsl:attribute>
          <xsl:attribute name="Name">
            <xsl:value-of select="@NAME"></xsl:value-of>
            <!-- <xsl:text>Logon</xsl:text> -->
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
