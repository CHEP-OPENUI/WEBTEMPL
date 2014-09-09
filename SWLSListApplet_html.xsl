<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" media-type="text/html"></xsl:output>

  <xsl:template match="/">
    <xsl:apply-templates select="//APPLICATION/SCREEN/VIEW/APPLET"></xsl:apply-templates>
  </xsl:template>

  <!--  ============================ View Processing =========================== -->
  <!--  List Base mode Template -->
  <xsl:template match="APPLET">
    <HTML>
      <HEADER>
        <META http-equiv="cache-control" content="no-cache"></META>
      </HEADER>

      <BODY>
        <!--   Error message  -->
        <xsl:if test="string-length(//ERROR)>0">
          <xsl:value-of select="//ERROR" />
          <br />
        </xsl:if>

        <b>
          <!--  Applet Title Label -->
          <xsl:value-of select="CONTROL[@ID='1']"></xsl:value-of>
          <!--  for calendar title  -->
          <xsl:value-of select="CALENDAR/@TITLE"></xsl:value-of>
        </b>
        <br></br>

        <!--  XML No Record found and other alerts  -->
        <xsl:if test="string-length(ALERT)>0 and @CLASS='CSSFrameCalRerouteBase'">
          <xsl:value-of select="ALERT"></xsl:value-of>
          <br></br>
        </xsl:if>

        <!--  Search and Title with data or other links  -->
        <xsl:apply-templates select="CONTROL[@ID=2 or @ID=3 or @ID=4 or @ID=5 or @ID=6 or @ID=7 or @ID=8 or @ID=9]"></xsl:apply-templates>

        <!--  Separator line  -->
        <xsl:apply-templates select="CONTROL[@ID=1000]"></xsl:apply-templates>

        <!--  Display fields for list of records here -->
        <xsl:apply-templates select="LIST"></xsl:apply-templates>

        <xsl:if test="string-length(@ROW_COUNTER)>0">
          <xsl:value-of select="@ROW_COUNTER"></xsl:value-of>
          <br></br>
        </xsl:if>

        <!--   control link for New, Main Menu, etc..  -->
        <xsl:apply-templates select="CONTROL[@ID>=40 and @HTML_TYPE='Link']"></xsl:apply-templates>
      </BODY>
    </HTML>
  </xsl:template>

  <!--  ======================================== Control and Link Processing ====================== -->
  <xsl:template match="CONTROL">
    <xsl:choose>
      <xsl:when test="@HTML_TYPE='Link'">
        <xsl:call-template name="build_simple_link"></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."></xsl:value-of>
        <br></br>
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
      <xsl:value-of select="@CAPTION"></xsl:value-of>
    </xsl:element>
    <br></br>
  </xsl:template>

  <!--  ============================ List processing ========================== -->
  <!--  LIST Template  builds a list of records  -->
  <xsl:template match="LIST">
    <!--  first get the URL from the RS_HEADER element -->
    <xsl:variable name="link">
      <xsl:apply-templates select="RS_HEADER/METHOD[@NAME='Drilldown']"></xsl:apply-templates>
    </xsl:variable>
    <!--  capture the URL before the SWERowId parameter -->
    <xsl:variable name="link-prefix">
      <xsl:value-of select="substring-before($link,'R=')"></xsl:value-of>
    </xsl:variable>
    <!--  capture the URL after the SWERowId parameter -->
    <xsl:variable name="link-suffix">
      <xsl:value-of select="substring-after($link,'R=')"></xsl:value-of>
    </xsl:variable>
    <!--  capture the field with the drilldown enabled - use later to build drilldown  -->
    <xsl:variable name="drilldowncontrol">
      <xsl:value-of select="RS_HEADER/METHOD[@NAME='Drilldown']/@FIELD"></xsl:value-of>
    </xsl:variable>

    <!--  loop through the rows in the RS_DATA element  -->
    <xsl:for-each select="RS_DATA/ROW">
      <!--  pickup the Row Id for the Row so we can rebuild the SWERowId URL parameter -->
      <xsl:variable name="rowid">
        <!-- <xsl:value-of select="@ROWID"/> -->
        <xsl:call-template name="ENCODE_ARG">
          <xsl:with-param name="encode_string" select="@ROWID"></xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <!--  loop through each field and control in the Row  -->
      <xsl:for-each select="FIELD|CONTROL">
        <xsl:choose>
          <!--  if the field is the drilldown field then create a link on the display data -->
          <xsl:when test="@NAME = $drilldowncontrol">
            <xsl:element name="A">
              <xsl:attribute name="HREF">
                <xsl:value-of select="concat(normalize-space($link-prefix),'R=',normalize-space($rowid),normalize-space($link-suffix))"></xsl:value-of>
                <xsl:text>&amp;F=</xsl:text>
                <xsl:value-of select="@VARIABLE"></xsl:value-of>
              </xsl:attribute>
              <xsl:value-of select="."></xsl:value-of>
            </xsl:element>
          </xsl:when>
          <!--  otherwise just display the data as is -->
          <xsl:otherwise>
            <xsl:value-of select="."></xsl:value-of>
          </xsl:otherwise>
        </xsl:choose>
        <!--  need a break if field is not empty  -->
        <xsl:variable name="empty_field">
          <xsl:value-of select="."></xsl:value-of>
        </xsl:variable>
        <xsl:if test="string-length($empty_field)!=0">
          <br></br>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>

    <!--  Show separator line only if has one or more record  -->
    <xsl:variable name="row_data">
      <xsl:value-of select="normalize-space(RS_DATA/ROW)"></xsl:value-of>
    </xsl:variable>
    <xsl:if test="string-length($row_data)>0">
      <xsl:text>- - - -</xsl:text>
      <br></br>
    </xsl:if>
    <!--  show More link only if there is next record set  -->
    <xsl:variable name="more_caption">
      <xsl:value-of select="normalize-space(RS_HEADER/METHOD[@NAME='GotoNextSet']/@CAPTION)"></xsl:value-of>
    </xsl:variable>
    <xsl:variable name="more_link">
      <xsl:apply-templates select="RS_HEADER/METHOD[@NAME='GotoNextSet']"></xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="string-length($more_link)>0">
      <xsl:element name="A">
        <xsl:attribute name="HREF">
          <xsl:value-of select="normalize-space($more_link)"></xsl:value-of>
        </xsl:attribute>
        <xsl:value-of select="$more_caption"></xsl:value-of>
      </xsl:element>
      <br></br>
    </xsl:if>
  </xsl:template>

  <!--  =========================== Anchor URL Processing =============================== -->
  <!--  THIS PART IS USED EVERYWHERE, WILL BE IN A SEPARATE FILE AND IMPORTED IN LATER === -->
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
        <xsl:variable name="argstring">
          <xsl:if test="@NAME='Pu' or @NAME='R' or @NAME='Rs'"><!--  replace + with %2B  -->
            <xsl:call-template name="ENCODE_ARG">
              <xsl:with-param name="encode_string" select="normalize-space(.)"></xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="not (@NAME='Pu' or @NAME='R' or @NAME='Rs')">
            <xsl:value-of select="normalize-space(.)"></xsl:value-of>
          </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$argstring"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$arg"></xsl:value-of>
    <!-- <xsl:text>&#38;</xsl:text> -->
    <!-- <xsl:value-of select="@NAME"/>=<xsl:value-of select="translate($arg,'&#x20;','+')'"/> -->
  </xsl:template>

  <xsl:template name="ENCODE_ARG">
    <xsl:param name="encode_string"></xsl:param>
    <!--  just return the value and stop  -->
    <xsl:if test="not (contains($encode_string, '+'))">
      <xsl:value-of select="$encode_string"></xsl:value-of>
    </xsl:if>
    <!--  recursive processing  -->
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
        <!-- <xsl:value-of select="."/> -->
        <xsl:value-of select="normalize-space(.)"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$info"></xsl:value-of>
  </xsl:template>
</xsl:stylesheet>
