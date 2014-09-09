<?xml version="1.0" encoding="UTF-16" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/vnd.wap.wml" omit-xml-declaration="no" doctype-public="-//WAPFORUM//DTD WML 1.1//EN" doctype-system="http://www.wapforum.org/DTD/wml_1.1.xml"></xsl:output>

  <xsl:template match="/">
    <xsl:apply-templates select="//APPLICATION/SCREEN/VIEW/APPLET"></xsl:apply-templates>
  </xsl:template>

  <xsl:template match="APPLET">
    <wml>
      <head>
        <meta forua="true" http-equiv="cache-control" content="max-age=0"/>
      </head>

      <template>
        <do type="prev" label="Back">
          <prev/>
        </do>
      </template>

      <card id="view">
        <p>
          <xsl:if test="string-length(//ERROR)>0">
            <xsl:value-of select="//ERROR" />
            <br></br>
          </xsl:if>

          <b>
            <xsl:value-of select="CONTROL[@ID='1']"></xsl:value-of>
            <xsl:value-of select="CALENDAR/@TITLE"></xsl:value-of>
          </b>
          <br></br>

          <xsl:if test="string-length(ALERT)>0 and @CLASS='CSSFrameCalRerouteBase'">
            <xsl:value-of select="ALERT"></xsl:value-of>
            <br></br>
          </xsl:if>

          <xsl:apply-templates select="CONTROL[@ID=2 or @ID=3 or @ID=4 or @ID=5 or @ID=6 or @ID=7 or @ID=8 or @ID=9]"></xsl:apply-templates>
          <xsl:apply-templates select="CONTROL[@ID=1000]"></xsl:apply-templates>
          <xsl:apply-templates select="LIST"></xsl:apply-templates>

          <xsl:if test="string-length(@ROW_COUNTER)>0">
            <xsl:value-of select="@ROW_COUNTER"></xsl:value-of>
            <br></br>
          </xsl:if>

          <xsl:apply-templates select="CONTROL[@ID>=40 and @HTML_TYPE='Link']"></xsl:apply-templates>
          <br></br>
          
          <xsl:if test="//NAVIGATION_ELEMENTS/THREAD_BAR/THREAD">
            <xsl:apply-templates select="//NAVIGATION_ELEMENTS/THREAD_BAR"></xsl:apply-templates>
          </xsl:if>
        </p>
      </card>
    </wml>
  </xsl:template>

  <xsl:template match="CONTROL">
    <xsl:choose>
      <xsl:when test="@HTML_TYPE='Link'">
        <xsl:call-template name="build_simple_link"></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(.)"></xsl:value-of>
        <br></br>
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

  <xsl:template match="LIST">
    <xsl:variable name="link">
      <xsl:apply-templates select="RS_HEADER/METHOD[@NAME='Drilldown'][1]"></xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="link-prefix">
      <xsl:value-of select="substring-before($link,'R=')"></xsl:value-of>
    </xsl:variable>
    <xsl:variable name="link-suffix">
      <xsl:value-of select="substring-after($link,'R=')"></xsl:value-of>
    </xsl:variable>

    <xsl:for-each select="RS_DATA/ROW">
      <xsl:variable name="rowid">
        <xsl:call-template name="ENCODE_ARG">
          <xsl:with-param name="encode_string" select="@ROWID"></xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:for-each select="FIELD|CONTROL">
        <xsl:if test="string-length(normalize-space(text()))>0">
          <xsl:choose>
            <xsl:when test="//APPLICATION/SCREEN/VIEW/APPLET/LIST/RS_HEADER/METHOD[@NAME='Drilldown']/@FIELD=@NAME">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:value-of select="concat(normalize-space($link-prefix),'R=',normalize-space($rowid),normalize-space($link-suffix))"></xsl:value-of>
                  <xsl:text>&amp;F=</xsl:text>
                  <xsl:value-of select="@VARIABLE"></xsl:value-of>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
              </xsl:element>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="normalize-space(.)"></xsl:value-of>
            </xsl:otherwise>
          </xsl:choose>
          <br></br>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>

    <xsl:variable name="row_data">
      <xsl:value-of select="normalize-space(RS_DATA/ROW)"></xsl:value-of>
    </xsl:variable>
    <xsl:if test="string-length($row_data)>0">
      <xsl:text>- - - -</xsl:text>
      <br></br>
    </xsl:if>

    <xsl:variable name="more_caption">
      <xsl:value-of select="normalize-space(RS_HEADER/METHOD[@NAME='GotoNextSet']/@CAPTION)"></xsl:value-of>
    </xsl:variable>
    <xsl:variable name="more_link">
      <xsl:apply-templates select="RS_HEADER/METHOD[@NAME='GotoNextSet']"></xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="string-length($more_link)>0">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="normalize-space($more_link)"></xsl:value-of>
        </xsl:attribute>
        <xsl:value-of select="$more_caption"></xsl:value-of>
      </xsl:element>
      <br></br>
    </xsl:if>
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
        <xsl:variable name="argstring">
          <xsl:if test="@NAME='Pu' or @NAME='R' or @NAME='Rs'">
            <!--  replace + with %2B  -->
            <xsl:call-template name="ENCODE_ARG">
              <xsl:with-param name="encode_string" select="normalize-space(.)"></xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="not (@NAME='Pu' or @NAME='R' or @NAME='Rs')">
            <xsl:value-of select="normalize-space(.)"></xsl:value-of>
          </xsl:if>
        </xsl:variable>
        <xsl:value-of select="normalize-space($argstring)"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="normalize-space(@NAME)"></xsl:value-of>=<xsl:value-of select="normalize-space($arg)"></xsl:value-of>
  </xsl:template>

  <xsl:template name="ENCODE_ARG">
    <xsl:param name="encode_string"></xsl:param>
    <xsl:if test="not (contains($encode_string, '+'))">
      <xsl:value-of select="$encode_string"></xsl:value-of>
    </xsl:if>
    <xsl:if test="contains($encode_string, '+')">
      <xsl:value-of select="substring-before($encode_string, '+')"></xsl:value-of>
      <xsl:text>%2B</xsl:text><!--  replace + with %2B  -->
      <xsl:call-template name="ENCODE_ARG">
        <xsl:with-param name="encode_string" select="substring-after($encode_string, '+')"></xsl:with-param>
      </xsl:call-template>
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