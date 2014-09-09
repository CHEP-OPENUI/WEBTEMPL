<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" media-type="text/html"></xsl:output>

  <!--  ====================== Root Document Processing ======================== -->
  <xsl:template match="/">
    <xsl:apply-templates select="//APPLICATION/APPLET"></xsl:apply-templates>
  </xsl:template>

  <!--  ============================ View Processing =========================== -->
  <xsl:template match="APPLET">
    <html>
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>

      <body>
        <!-- APPLET TITLE,  Search  in Table 1 -->
        <!-- Head: Title of Page -->
        <table bgcolor="#333399" border="0"  width="100%" cellpadding="2" cellspacing="0">
          <tr>
            <td align="center" valine="middle" width="100%">
              <font face="Arial" color="#FFFFFF">
                <b>
                  <xsl:value-of select="CONTROL[@ID='1']"/>
                </b>
              </font>
            </td>
          </tr>
        </table>
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#999999">
          <tr>
            <td bgcolor="#FFFFFF" width="100%" height="1"></td>
          </tr>
        </table>

        <!-- Error message -->
        <xsl:if test="string-length(//ERROR)>0">
          <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
            <tr>
              <td bgcolor="#000066" width="100%" height="2"></td>
            </tr>
          </table>
          <table border="0" width="100%" cellspacing="0" cellpadding="3" bgcolor="#FFFF77">
            <tr>
             <td bgcolor="#FFFF77">
               <font face="Arial" color="#000000">
                 <xsl:value-of select="//ERROR"></xsl:value-of>
                 <br></br>
               </font>
              </td>
            </tr>
          </table>
        </xsl:if>

        <!-- Tool bar and List of Data in Table 2 -->
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#000066" width="100%" height="2"></td>
          </tr>
        </table>

        <table border="0" width="100%" cellspacing="0" cellpadding="3" bgcolor="#9999CC">
          <td>
            <table align="left" border="0" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
              <tr>
                <td align="left">
                  <xsl:apply-templates select="FORM/CONTROL[@ID=2 and @HTML_TYPE='Link']"></xsl:apply-templates>
                </td>
              </tr>
            </table>
          </td>
          <td>
            <table align="right" border="0" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
              <tr>
                <td align="right" colspan="3">
                  <!-- previous link-->
                  <xsl:call-template name="build_previous_link"/>
                  <xsl:if test="string-length(@ROW_COUNTER)>0">
                    <font face="Arial" size="2" color="#FFFFFF">
                      <xsl:value-of select="@ROW_COUNTER"></xsl:value-of>
                    </font>
                  </xsl:if>
                  <xsl:call-template name="build_more_link"/>
                </td>
              </tr>
            </table>
          </td>
        </table>

        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#000066" width="100%" height="1"></td>
          </tr>
        </table>

        <!--  Display fields for list of records here in table 2-->
        <table border="0" width="100%" cellspacing="0" cellpadding="3" bgcolor="#EEFFFF">
          <xsl:apply-templates select="FORM/LIST"></xsl:apply-templates>
        </table>


        <!--   Other links in Table 3-->
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#333399" width="100%" height="1"></td>
          </tr>
        </table>
        <table border="0" width="100%" cellspacing="0" cellpadding="3" bgcolor="#9999CC">
          <tr>
            <td>
              <xsl:apply-templates select="CONTROL[@ID>=41 and @HTML_TYPE='Link']" />
            </td>
          </tr>
        </table>
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#333399" width="100%" height="2"></td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>


  <!--  ======================================== Control and Link Processing ====================== -->
  <!--  Control Template  -->
  <xsl:template match="CONTROL">
    <xsl:choose>
      <xsl:when test="normalize-space(ANCHOR/CMD/ARG[@NAME='M']/text())='NewQuery'">
        <xsl:call-template name="build_image_link">
          <xsl:with-param name="fileName">images/icon_search.gif</xsl:with-param>
          <xsl:with-param name="alt">Search</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="build_link_or_home_button"></xsl:call-template>
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

  <xsl:template name="build_image_link">
    <xsl:param name="fileName"/>
    <xsl:param name="alt"/>
    <xsl:variable name="link">
      <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="A">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$link"></xsl:value-of>
      </xsl:attribute>
      <img border="0" src="{$fileName}" alt="{$alt}"></img>
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
      <tr>
        <td>
          <font face="Arial" size="2">
            <xsl:choose>
              <xsl:when test="$invoke_method='AddRecord'"><!--  Association Applet  -->
                <xsl:element name="A">
                  <xsl:attribute name="HREF">
                    <xsl:value-of select="concat(normalize-space($pick_link), $field_arg, $row_arg)"></xsl:value-of>
                  </xsl:attribute>
                  <xsl:value-of select="text()"></xsl:value-of>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise><!--  Pick applet  -->
                <xsl:element name="A">
                  <xsl:attribute name="HREF">
                    <xsl:value-of select="concat(normalize-space($pick_link), $field_arg, $rn_arg)"></xsl:value-of>
                  </xsl:attribute>
                  <xsl:value-of select="text()"></xsl:value-of>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </font>
        </td>
        <xsl:for-each select="FIELD|CONTROL">
          <td>
            <font face="Arial" size="2">
              <xsl:value-of select="."></xsl:value-of>
            </font>
          </td>
        </xsl:for-each>
      </tr>
    </xsl:for-each>

<!--  show More link only if there is next record set  
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
-->
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
          <xsl:if test="@NAME='Pu' or @NAME='R' or @NAME='Rs'"><!--  replace + with %2B  -->
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
    </xsl:if><!--  recursive processing  -->
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

  <xsl:template name="build_previous_link">
    <xsl:for-each select="FORM/LIST/RS_HEADER/METHOD">
      <xsl:if test="normalize-space(ANCHOR/CMD/ARG[@NAME='M']/text())='GotoPreviousSet'">
        <xsl:variable name="caption">
          <xsl:value-of select="normalize-space(@CAPTION)"/>
         </xsl:variable>
        <xsl:element name="a">
	  <xsl:attribute name="href">
            <xsl:apply-templates select="ANCHOR"/>
	  </xsl:attribute>
	  <img  border="0" align="bottom" src="images/message_bar_prv_.gif" alt="{$caption}"></img>
        </xsl:element>
      </xsl:if>
   </xsl:for-each>
  </xsl:template> 

  <xsl:template name="build_more_link">
    <xsl:for-each select="FORM/LIST/RS_HEADER/METHOD">
      <xsl:if test="normalize-space(ANCHOR/CMD/ARG[@NAME='M']/text())='GotoNextSet' or 
                      normalize-space(ANCHOR/CMD/ARG[@NAME='M']/text())='FindBranch'">
        <xsl:variable name="caption">
          <xsl:value-of select="normalize-space(@CAPTION)"/>
        </xsl:variable>
        <xsl:element name="a">
	  <xsl:attribute name="href">
	    <xsl:apply-templates select="ANCHOR"/>
	  </xsl:attribute>
	  <img  border="0" align="bottom" src="images/message_bar_nxt_.gif" alt="{$caption}"></img>
	</xsl:element>
      </xsl:if>
    </xsl:for-each>
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
