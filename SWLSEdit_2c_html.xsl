<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" media-type="text/html"></xsl:output>

  <!--  ====================== Root Document Processing ======================== -->
  <xsl:template match="/">
    <xsl:apply-templates select="//APPLET"></xsl:apply-templates>
  </xsl:template>

  <xsl:template match="APPLET">
    <html>
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>

      <body>
        <!-- Title Area 1 -->
        <table bgcolor="#333399" border="0"  width="100%" cellpadding="2" cellspacing="0">
          <tr>
            <td align="center" valine="middle" width="100%">
              <font face="Arial" color="#FFFFFF">
                <b>
                  <xsl:value-of select="//VIEW/@TITLE"/>
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

        <!--  Error message  -->
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

        <!-- APPLET TITLE Section: Area 2 -->
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#000066" width="100%" height="2"></td>
          </tr>
        </table>
        <table border="0" width="100%" cellspacing="0" cellpadding="3" bgcolor="#9999CC">
          <tr>
            <td align="left">
              <b>
                <font face="Arial" color="#FFFFFF" size="2">
                  <xsl:value-of select="normalize-space(CONTROL[@ID=1]/text())"/>
                </font>
              </b>
            </td>
          </tr>
        </table>
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#000066" width="100%" height="1"></td>
          </tr>
        </table>

        <!-- Data and Submit and Cancel Button -->
        <table border="0" width="100%"  cellspacing="0" cellpadding="0" bgcolor="#EEFFFF">
          <xsl:element name="Form">
            <xsl:attribute name="METHOD">
              <xsl:text>GET</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="ACTION">
              <xsl:value-of select="//APPLET/FORM/@ACTION"/>
            </xsl:attribute>
            <tr bgcolor="#EEFFFF" align="left" valign="middle">
              <xsl:apply-templates select="FORM/CONTROL[@ID&lt;40 and @ID mod 2!=0]"/>
            </tr>
            <tr>
              <td bgcolor="#000066" width="100%" colspan="2" height="1"></td>
            </tr>

            <!--Submit button-->
            <tr>
              <td bgcolor="#9999CC" colspan="2">
                <xsl:apply-templates select="FORM/CONTROL[@ID=41]"/>
              </td>
            </tr>
          </xsl:element>
        </table>

        <!--cancel button -->
        <xsl:if test="FORM/CONTROL[@ID=42]">
          <table border="0" width="100%"  cellspacing="0" cellpadding="0" bgcolor="#EEFFFF">
            <xsl:element name="Form">
              <xsl:attribute name="METHOD">
                <xsl:text>GET</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ACTION">
                <xsl:value-of select="//APPLET/FORM/@ACTION"/>
              </xsl:attribute>
              <tr>
                <td bgcolor="#9999CC">
                  <xsl:apply-templates select="FORM/CONTROL[@ID=42]"/>
                </td>
              </tr>
            </xsl:element>
          </table>
        </xsl:if>

        <table border="0" width="100%"  cellspacing="0" cellpadding="0" bgcolor="#EEFFFF">
          <tr>
            <td bgcolor="#000066" width="100%" height="2"></td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>

  <!--  ============================= FORM Processing ============================= -->
  <!--  Area 2-->
  <xsl:template match="FORM/CONTROL[@ID&lt;40 and @ID mod 2!=0]">
    <xsl:choose>

      <xsl:when test="@HTML_TYPE='Link'">
        <tr>
          <td align="left" valign="middle" nowrap="nowarp">
            <font face="Arial" size="2">
              <xsl:call-template name="build_simple_link"></xsl:call-template>
            </font>
          </td>
          <td>
            <font face="Arial" align="left" valign="middle" size="2">
                <!-- To fix the FR#12-1PKZDEN, - removed the call to 'normalize-space', so that it will not remove
                the Leading space in the Value-->
                <xsl:value-of select="following-sibling::CONTROL[1][@ID mod 2 != 0 and @HTML_TYPE='Text']/text()"/>
            </font>
          </td>
        </tr>
      </xsl:when>

      <xsl:when test="@FIELD">
        <tr>
          <td align="left" valign="middle" nowrap="nowarp">
            <font face="Arial" size="2">
              <xsl:value-of select="normalize-space(preceding-sibling::CONTROL[1][@ID mod 2=0]/text())"/>
            </font>
          </td>
          <td align="left" valign="middle">
            <font face="Arial" size="2">
              <xsl:choose>
                <xsl:when test="PICK_LIST">
                  <xsl:call-template name="build_picklist"></xsl:call-template>
                </xsl:when>
                
                <xsl:when test="@HTML_TYPE='CheckBox'">
                  <xsl:call-template name="build_checkbox"></xsl:call-template>
                </xsl:when>

                <xsl:when test="@NAME='Type'">
                </xsl:when>

                <xsl:when test="@HTML_TYPE='TextArea'">
                  <xsl:call-template name="build_textarea"></xsl:call-template>
                </xsl:when>

                <xsl:otherwise>
                  <xsl:call-template name="build_textbox"></xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </font>
          </td>
        </tr>
      </xsl:when>

      <!-- Special Case becase of tools configuration -->
      <xsl:when test="@HTML_TYPE='Text' and @TYPE='TextBox'">
        <font face="Arial" size="2">
          <xsl:value-of select="."></xsl:value-of>
        </font>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--submit and Cancel button-->
  <xsl:template match="FORM/CONTROL[@ID=41 or @ID=42]">
    <xsl:call-template name="form_buttons"></xsl:call-template>
    <xsl:variable name="sweformarg">
      <xsl:value-of select="@NAME"></xsl:value-of>
    </xsl:variable>
    <xsl:element name="Input">
      <xsl:attribute name="type">
        <xsl:text>hidden</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:text>SWEForm</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="Value">
        <xsl:value-of select="$sweformarg"></xsl:value-of>
      </xsl:attribute>
    </xsl:element>

    <xsl:element name="Input">
      <xsl:attribute name="Type">
        <xsl:text>submit</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="Value">
        <xsl:value-of select="@CAPTION"></xsl:value-of>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!--  create a Pick List for input  -->
  <xsl:template name="build_picklist">
    <xsl:variable name="selected">
      <xsl:value-of select="PICK_LIST/@VALUE"></xsl:value-of>
    </xsl:variable>
    <xsl:element name="Select">
      <xsl:attribute name="Name">
        <xsl:value-of select="@VARIABLE"></xsl:value-of>
      </xsl:attribute>
      <xsl:for-each select="PICK_LIST/OPTION">
        <xsl:element name="Option">
          <xsl:if test="@CAPTION=$selected">
            <xsl:attribute name="SELECTED"></xsl:attribute>
          </xsl:if>
          <xsl:value-of select="normalize-space()"></xsl:value-of>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <!-- Create a checkbox -->
  <xsl:template name="build_checkbox">
    <xsl:variable name="actualCheckBox">
      <xsl:text>chkbox</xsl:text>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@FIELD">
        <!-- hidden control -->
        <xsl:element name="input">
          <xsl:attribute name="type">
            <xsl:text>hidden</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="@VARIABLE"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="@VARIABLE"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="$actualCheckBox"/>
          </xsl:attribute>
        </xsl:element>
        <!-- actual checkbox -->
        <xsl:element name="input">
          <xsl:attribute name="type">
            <xsl:text>checkbox</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="$actualCheckBox"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="$actualCheckBox"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="checked">
            <xsl:text>checked</xsl:text>
          </xsl:attribute>
          <xsl:if test="@READ_ONLY = 'TRUE'">
           <xsl:attribute name="DISABLED">
           </xsl:attribute>
         </xsl:if>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space()"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>   

  <!--  Create an input text area box -->
  <xsl:template name="build_textarea">
    <xsl:element name="textarea">
      <xsl:attribute name="rows">
        <xsl:text>10</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="cols">
        <xsl:text>25</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="@VARIABLE"></xsl:value-of>
      </xsl:attribute>
      <xsl:if test="string-length(@MAX_LENGTH) >0">
        <xsl:attribute name="maxlength">
          <xsl:value-of select="@MAX_LENGTH"></xsl:value-of>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@READ_ONLY = 'TRUE'">
       <xsl:attribute name="readonly">
       </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="normalize-space()"></xsl:value-of>
    </xsl:element>
  </xsl:template>

  <!--  Create an input text box -->
  <xsl:template name="build_textbox">
    <xsl:element name="input">
      <xsl:attribute name="type">
        <xsl:text>text</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="name">
        <xsl:value-of select="@VARIABLE"></xsl:value-of>
      </xsl:attribute>
      <xsl:attribute name="Value">
        <xsl:value-of select="normalize-space()"></xsl:value-of>
      </xsl:attribute>
      <xsl:if test="string-length(@MAX_LENGTH) >0">
        <xsl:attribute name="maxlength">
          <xsl:value-of select="@MAX_LENGTH"></xsl:value-of>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="size">
        <xsl:text>15</xsl:text>
      </xsl:attribute>
     <xsl:if test="@READ_ONLY = 'TRUE'">
       <xsl:attribute name="readonly">
       </xsl:attribute>
     </xsl:if>
    </xsl:element>
  </xsl:template>

  <!--  template to create form buttons  -->
  <xsl:template name="form_buttons">
    <xsl:for-each select="ANCHOR">
      <xsl:for-each select="CMD">
        <xsl:element name="Input">
          <xsl:attribute name="type">
            <xsl:text>hidden</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="Name">
            <xsl:value-of select="@NAME"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="Value">
            <xsl:value-of select="@VALUE"></xsl:value-of>
          </xsl:attribute>
        </xsl:element>
        <xsl:for-each select="ARG">
          <xsl:element name="Input">
            <xsl:attribute name="type">
              <xsl:text>hidden</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="Name">
              <xsl:value-of select="@NAME"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="Value">
              <xsl:variable name="argstring">
                <xsl:if test="@NAME='Pu' or @NAME='R' or @NAME='Rs'">
                  <xsl:call-template name="ENCODE_ARG">
                    <xsl:with-param name="encode_string" select="normalize-space(.)"></xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="not (@NAME='Pu' or @NAME='R' or @NAME='Rs')">
                  <!--<xsl:value-of select="normalize-space(.)"></xsl:value-of>-->
                  <xsl:call-template name="RemoveLeadingTrailingSpaces">
                    <xsl:with-param name="initial_value" select="."></xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
              </xsl:variable>
              <xsl:value-of select="$argstring"></xsl:value-of>
              <!-- xsl:value-of select="normalize-space()"/ -->
            </xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="INFO">
        <xsl:element name="Input">
          <xsl:attribute name="type">
            <xsl:text>hidden</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="Name">
            <xsl:value-of select="@NAME"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="Value">
            <xsl:value-of select="normalize-space()"></xsl:value-of>
          </xsl:attribute>
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each>
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
  </xsl:template>

  <xsl:template name="ENCODE_ARG">
    <xsl:param name="encode_string"></xsl:param><!--  just return the value and stop  -->
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

  <xsl:template name="RemoveLeadingTrailingSpaces">
  <!-- To fix the FR#12-1PKZDEN, - Not removing the Leading space(#x20) in the Value-->
    <xsl:param name="initial_value"></xsl:param>
    <xsl:choose>
      <xsl:when test="starts-with($initial_value,'&#x9;') or starts-with($initial_value,'&#xA;') or starts-with($initial_value,'&#xD;')">
        <xsl:call-template name="RemoveLeadingTrailingSpaces">
          <xsl:with-param name="initial_value" select="substring($initial_value,2)"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="substring($initial_value,string-length($initial_value))='&#x9;' or substring($initial_value,string-length($initial_value))='&#xA;' or substring($initial_value,string-length($initial_value))='&#xD;' or substring($initial_value,string-length($initial_value))='&#x20;'">
        <xsl:call-template name="RemoveLeadingTrailingSpaces">
          <xsl:with-param name="initial_value" select="substring($initial_value,1,string-length($initial_value)-1)"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$initial_value"> </xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="INFO">
    <xsl:variable name="info">
      <xsl:if test="string-length(normalize-space(.)) >0"><!-- <xsl:value-of select="."/> -->
        <xsl:value-of select="normalize-space(.)"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$info"></xsl:value-of>
  </xsl:template>
</xsl:stylesheet>