<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes" media-type="text/html" omit-xml-declaration="no"
 doctype-public="-//WAPFORUM//DTD XHTML Mobile 1.0//EN"
 doctype-system="http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
</xsl:output>
  
<!--  This style sheet process the XML output for both the Splash screens and standard views -->
  <!--  ====================== Root Document Processing ======================== -->
  <!--  Document Root -->
  <xsl:template match="/">
    <xsl:apply-templates select="//APPLICATION/APPLET"></xsl:apply-templates>
  </xsl:template>

  <!--  ============================ View Processing =========================== -->
  <!--  List Base mode Template -->
  <xsl:template match="APPLET">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>
      <body><!--  Error message  -->
        <xsl:if test="string-length(//ERROR)>0">
          <xsl:value-of select="//ERROR"></xsl:value-of>
          <br></br>
        </xsl:if>
        <b><!--  Applet Title Label -->
          <xsl:value-of select="CONTROL[@ID='1']"></xsl:value-of>
        </b>
        <br></br><!--  === Search link ===  -->
        <xsl:apply-templates select="FORM/CONTROL[@ID=2 and @HTML_TYPE='Link']"></xsl:apply-templates>
        <!--  ===Separator Line ===  -->
        <xsl:text>- - - -</xsl:text>
        <br></br><!--  Display fields for list of records here -->
        <xsl:apply-templates select="//APPLICATION/APPLET/FORM/LIST"></xsl:apply-templates>
        <xsl:value-of select="@ROW_COUNTER"></xsl:value-of>
        <br></br><!--  New Record Link -->
        <xsl:apply-templates select="FORM/CONTROL[@ID=3 and @HTML_TYPE='Link']"></xsl:apply-templates>
        <!--   control link for New, Main Menu, etc..  -->
        <xsl:apply-templates select="CONTROL[@ID>40 and @HTML_TYPE='Link']"></xsl:apply-templates>
      </body>
    </html>
  </xsl:template>

  <!--  ======================================== Control and Link Processing ====================== -->
  <!--  Control Template  -->
  <xsl:template match="CONTROL">
    <xsl:call-template name="build_simple_link"></xsl:call-template>
  </xsl:template>
  <xsl:template name="build_simple_link">
    <xsl:variable name="initial_link">
      <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="link">
    <xsl:call-template name="EncodeURL">
      <xsl:with-param name="specialchar" select="$initial_link"></xsl:with-param>
    </xsl:call-template>
    </xsl:variable>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="$link"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="@CAPTION"></xsl:value-of>
    </xsl:element>
    <br></br>
  </xsl:template>

  <!--  ============================ List processing ========================== -->
  <!--  LIST Template  builds a list of records  -->
  <xsl:template match="LIST">
    <!--  get field name to be able to assign value to field variable  -->
    <xsl:variable name="field_name">
      <xsl:value-of select="RS_HEADER/METHOD[@NAME='PickRecord']/ANCHOR/CMD/ARG[@NAME='F']"></xsl:value-of>
    </xsl:variable>
    <xsl:variable name="pick_link">
      <xsl:apply-templates select="RS_HEADER/METHOD[@NAME='PickRecord']/ANCHOR"></xsl:apply-templates>
    </xsl:variable>
    <!--  Build PickRecord link without field variable and rowid ARG, they will be added in with real data in RS_DATA/ROW processing  -->
    <!--  loop through the rows in the RS_DATA element  -->
    <xsl:for-each select="RS_DATA/ROW">
    <!--  pickup the Row Id for the Row so we can rebuild the SWERowId URL parameter -->
      <xsl:variable name="rowid">
      <!-- <xsl:value-of select="@ROWID"/> -->
        <xsl:call-template name="ENCODE_ARG">
          <xsl:with-param name="encode_string" select="@ROWID"></xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <!--  TEST RN FOR DUPLICATE PICK  -->
      <xsl:variable name="rn">
        <xsl:value-of select="@RN"></xsl:value-of>
      </xsl:variable>
      <xsl:variable name="field_arg">
        <!-- need to output the value without striping spaces -->
        <xsl:variable name="field_value">
          <xsl:call-template name="RemoveLeadingTrailingWhiteSpaces">
            <xsl:with-param name="initial_value" select="text()"></xsl:with-param>
          </xsl:call-template>
        </xsl:variable> 
        <xsl:value-of select="concat('&amp;', normalize-space($field_name),'=',$field_value)"></xsl:value-of>
      </xsl:variable>
      <xsl:variable name="row_arg">
        <xsl:value-of select="concat('&amp;R=',normalize-space($rowid))"></xsl:value-of>
      </xsl:variable>
      <xsl:variable name="rn_arg">
        <xsl:value-of select="concat('&amp;RN=',normalize-space($rn))"></xsl:value-of>
      </xsl:variable>
      <xsl:variable name="invoke_method">
        <xsl:value-of select="normalize-space(../../RS_HEADER/METHOD[@NAME='PickRecord']/ANCHOR/CMD/ARG[@NAME='M'])"></xsl:value-of>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$invoke_method='AddRecord'"><!--  Association Applet  -->
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="concat(normalize-space($pick_link), $field_arg, $row_arg)"></xsl:value-of>
            </xsl:attribute>
            <xsl:value-of select="text()"></xsl:value-of>
            <br></br>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
        <!--  Pick applet  -->
          <xsl:element name="a">
            <xsl:attribute name="href">
              <xsl:value-of select="concat(normalize-space($pick_link), $field_arg, $rn_arg)"></xsl:value-of>
            </xsl:attribute>
            <xsl:value-of select="text()"></xsl:value-of>
            <br></br>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:for-each select="FIELD|CONTROL">
        <xsl:value-of select="."></xsl:value-of>
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
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="normalize-space($more_link)"></xsl:value-of>
        </xsl:attribute>
        <xsl:value-of select="$more_caption"></xsl:value-of>
      </xsl:element>
      <br></br>
    </xsl:if>
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
    <xsl:variable name="field_name">
      <xsl:value-of select="../ARG[@NAME='F']"></xsl:value-of>
    </xsl:variable>
    <xsl:variable name="arg">
      <xsl:if test="string-length(normalize-space()) >0">
        <xsl:variable name="argstring">
          <xsl:if test="@NAME='Pu' or @NAME='R' or @NAME='Rs'">
            <!--  replace + with %2B  -->
            <xsl:call-template name="ENCODE_ARG">
              <xsl:with-param name="encode_string" select="normalize-space()"></xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="not (@NAME='Pu' or @NAME='R' or @NAME='Rs')">
            <xsl:value-of select="normalize-space(.)"></xsl:value-of>
          </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$argstring"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <!--  do not render S_1_1_1_0 and R agrument for PickRecord method  -->
    <xsl:if test="not(../../../@NAME='PickRecord' and (normalize-space(@NAME)=normalize-space($field_name) or @NAME='R'))">
      <xsl:text>&amp;</xsl:text>
      <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$arg"></xsl:value-of>
    </xsl:if>
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


  <xsl:template name="RemoveLeadingTrailingWhiteSpaces">
    <xsl:param name="initial_value"></xsl:param>
    <xsl:choose>
     <!-- Keep leading spaces but remove other white spaces like tabs -->
     <xsl:when test="starts-with($initial_value,'&#x9;') or starts-with($initial_value,'&#xA;') or starts-with($initial_value,'&#xD;')">
       <xsl:call-template name="RemoveLeadingTrailingWhiteSpaces">
          <xsl:with-param name="initial_value" select="substring($initial_value,2)"> </xsl:with-param>
       </xsl:call-template>
     </xsl:when>
     <xsl:when test="substring($initial_value,string-length($initial_value))='&#x9;' or substring($initial_value,string-length($initial_value))='&#xA;' or substring($initial_value,string-length($initial_value))='&#xD;' or substring($initial_value,string-length($initial_value))='&#x20;'">
       <xsl:call-template name="RemoveLeadingTrailingWhiteSpaces">
          <xsl:with-param name="initial_value" select="substring($initial_value,1,string-length($initial_value)-1)"> </xsl:with-param>
       </xsl:call-template>
     </xsl:when>
     <xsl:otherwise>
       <xsl:call-template name="EncodeURL">
         <xsl:with-param name="specialchar" select="$initial_value"></xsl:with-param>
       </xsl:call-template>
     </xsl:otherwise>
   </xsl:choose>
  </xsl:template>

  <!-- need to encode special character # for the data that send back to server -->
  <xsl:template name="EncodeURL">
    <xsl:param name="specialchar"></xsl:param>
    <xsl:choose>
      <!--  recursive processing to handle more than one # -->
      <xsl:when test="contains($specialchar, '#')">
        <xsl:value-of select="substring-before($specialchar, '#')"></xsl:value-of>
        <!--  replace # with %23  -->
        <xsl:text>%23</xsl:text>
        <xsl:call-template name="EncodeURL">
          <xsl:with-param name="specialchar" select="substring-after($specialchar, '#')"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($specialchar, '&#x20;')">
        <xsl:value-of select="substring-before($specialchar, '&#x20;')"></xsl:value-of>
        <!--  replace # with %20  -->
        <xsl:text>%20</xsl:text>
        <xsl:call-template name="EncodeURL">
          <xsl:with-param name="specialchar" select="substring-after($specialchar, '&#x20;')"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$specialchar"></xsl:value-of>	
      </xsl:otherwise>
   </xsl:choose>
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
