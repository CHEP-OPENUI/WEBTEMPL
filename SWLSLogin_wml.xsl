<?xml version="1.0" encoding="UTF-16" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/vnd.wap.wml" omit-xml-declaration="no" doctype-public="-//WAPFORUM//DTD WML 1.1//EN" doctype-system="http://www.wapforum.org/DTD/wml_1.1.xml"></xsl:output>
  <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

  <!--  Document Root  -->
  <xsl:template match="/">
    <wml>
      <head>
        <meta forua="true" http-equiv="cache-control" content="max-age=0"/>
      </head>

      <card id="login" newcontext="true">
        <p>
          <xsl:apply-templates select="APPLICATION/FORM/ERROR"></xsl:apply-templates>
          <b>
            <xsl:value-of select="//PAGE_ITEM[@NAME='LoginTitle']/@CAPTION"></xsl:value-of>
          </b>
          <br></br>
          <xsl:apply-templates select="APPLICATION/NAVIGATION_ELEMENTS"></xsl:apply-templates>
        </p>
      </card>
    </wml>
  </xsl:template>

  <!--  Login Error  -->
  <xsl:template match="ERROR">
    <xsl:value-of select="normalize-space(.)"></xsl:value-of>
    <br></br>
  </xsl:template>
  <!--  Navigation Element Template  -->
  <xsl:template match="NAVIGATION_ELEMENTS">

    <xsl:for-each select="PAGE_ITEM">
      <xsl:choose>
        <xsl:when test="@NAME = 'UserNameLabel'">
          <xsl:value-of select="@CAPTION"></xsl:value-of>
        </xsl:when>
        <xsl:when test="@NAME = '_SweUserName'">
          <xsl:element name="input">
            <xsl:attribute name="type">
              <xsl:text>text</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:text>Usr</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:text></xsl:text>
            </xsl:attribute>
            <xsl:attribute name="emptyok">
              <xsl:text>true</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>

        <xsl:when test="@NAME = 'PasswordLabel'">
          <xsl:value-of select="@CAPTION"></xsl:value-of>
        </xsl:when>
        <xsl:when test="@NAME = '_SwePassword'">
          <xsl:element name="input">
            <xsl:attribute name="type">
              <xsl:value-of select="translate(@TYPE,$ucletters,$lcletters)"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:text>Pw</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:text></xsl:text>
            </xsl:attribute>
            <xsl:attribute name="emptyok">
              <xsl:text>true</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>

    <xsl:variable name="submitlink">
      <xsl:apply-templates select="PAGE_ITEM[@NAME='LoginButton']"></xsl:apply-templates>
    </xsl:variable>

    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="normalize-space($submitlink)"></xsl:value-of>
      </xsl:attribute>
      <xsl:text>Submit</xsl:text>
    </xsl:element>

    <xsl:for-each select="PAGE_ITEM[@NAME='LoginButton']">
      <xsl:element name="do">
        <xsl:attribute name="type">
          <xsl:text>accept</xsl:text>
        </xsl:attribute>

        <xsl:attribute name="label">
          <xsl:text>Submit</xsl:text>
        </xsl:attribute>

        <xsl:element name="go">
          <xsl:attribute name="method">
            <xsl:text>post</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:text>start.swe</xsl:text>
          </xsl:attribute>

          <xsl:element name="postfield">
            <xsl:attribute name="name">
              <xsl:text>Cnt</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:text>1</xsl:text>
            </xsl:attribute>
          </xsl:element>

          <xsl:element name="postfield">
            <xsl:attribute name="name">
              <xsl:text>Usr</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:text>$(Usr:noesc)</xsl:text>
            </xsl:attribute>
          </xsl:element>

          <xsl:element name="postfield">
            <xsl:attribute name="name">
              <xsl:text>Pw</xsl:text>
           </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:text>$(Pw:noesc)</xsl:text>
            </xsl:attribute>
          </xsl:element>

          <xsl:element name="postfield">
            <xsl:attribute name="name">
              <xsl:text>Nct</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:text>true</xsl:text>
            </xsl:attribute>
          </xsl:element>

          <xsl:element name="postfield">
            <xsl:attribute name="name">
              <xsl:value-of select="ANCHOR/CMD/@NAME"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="ANCHOR/CMD/@VALUE"></xsl:value-of>
            </xsl:attribute>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
    <br></br>
  </xsl:template>

  <xsl:template match="PAGE_ITEM">
    <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
  </xsl:template>

  <!--  =========================== Anchor URL Processing =============================== -->
  <xsl:template match="ANCHOR">
    <xsl:text>start.swe?</xsl:text>
    <xsl:apply-templates select="CMD"></xsl:apply-templates>
  </xsl:template>

  <xsl:template match="CMD">
    <xsl:text>Cnt=1</xsl:text>
    <xsl:text>&amp;</xsl:text>
    <xsl:text>Usr=$(Usr:escape)</xsl:text>
    <xsl:text>&amp;</xsl:text>
    <xsl:text>Pw=$(Pw:escape)</xsl:text>
    <xsl:text>&amp;</xsl:text>
    <xsl:text>Nct=true</xsl:text>
    <xsl:text>&amp;</xsl:text>
    <xsl:apply-templates select="INFO"></xsl:apply-templates>
	<xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="@VALUE"></xsl:value-of>
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