<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output  indent="yes" media-type="text/vnd.wap.wml" omit-xml-declaration="no" doctype-public="-//WAPFORUM//DTD WML 1.1//EN" doctype-system="http://www.wapforum.org/DTD/wml_1.1.xml"></xsl:output>

  <!--  This style sheet process the XML output for both the Splash screens and standard views -->
  <xsl:template match="/">
    <wml>
      <head>
        <meta forua="true" http-equiv="cache-control" content="max-age=0"></meta>
      </head>

      <template>
        <do type="prev" label="Back">
          <prev/>
        </do>
      </template>

      <card id="view">
        <onevent type="onenterbackward">
          <prev/>
        </onevent>
        <p>
          <xsl:apply-templates select="//APPLET/ERROR"></xsl:apply-templates>
          <xsl:apply-templates select="//APPLET"></xsl:apply-templates>
        </p>
      </card>
    </wml>
  </xsl:template>

  <!-- Error Message -->
  <xsl:template match="ERROR">
    <xsl:if test="string-length(normalize-space(.))>0">
      <xsl:call-template name="wmlEncode">
        <xsl:with-param name="initValue" select="normalize-space(.)"/>
      </xsl:call-template>
      <br></br>
    </xsl:if>
  </xsl:template>

  <xsl:template match="APPLET">
    <!--  Title  -->
    <b>
      <xsl:value-of select="CONTROL/."></xsl:value-of>
    </b>
    <br></br>
    <xsl:apply-templates select="FORM"></xsl:apply-templates>
  </xsl:template>

  <!--  ============================= FORM Processing ============================= -->
  <xsl:template match="FORM">
    <xsl:for-each select="CONTROL">
      <xsl:choose>
        <xsl:when test="@HTML_TYPE='MakeCall' or @HTML_TYPE='CheckBox'">
          <xsl:call-template name="build_textbox"></xsl:call-template>
        </xsl:when>
        <xsl:when test="@HTML_TYPE='Label' or @HTML_TYPE='FieldLabel'">
          <xsl:call-template name="wmlEncode">
            <xsl:with-param name="initValue" select="normalize-space(.)"/>
          </xsl:call-template>
          <br></br>
        </xsl:when>
        <xsl:when test="@HTML_TYPE='Field'">
          <xsl:choose>
            <xsl:when test="PICK_LIST">
              <xsl:call-template name="build_picklist"></xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="build_textbox"></xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="@HTML_TYPE='TextArea'">
          <xsl:if test="@VARIABLE">
            <xsl:call-template name="build_bigger_textbox"></xsl:call-template>
          </xsl:if>
        </xsl:when>
        <xsl:when test="@HTML_TYPE='Text'">
          <xsl:choose>
            <xsl:when test="@TYPE='Label'">
              <xsl:call-template name="wmlEncode">
                <xsl:with-param name="initValue" select="normalize-space(.)"/>
              </xsl:call-template>
              <br></br>
            </xsl:when>
            <xsl:when test="@TYPE='TextBox'">
              <xsl:choose>
                <xsl:when test="PICK_LIST">
                  <xsl:call-template name="build_picklist"></xsl:call-template>
                </xsl:when>
                <xsl:when test="@VARIABLE">
                  <xsl:call-template name="build_textbox"></xsl:call-template>
                </xsl:when><!--  labels and no text controls -->
                <xsl:otherwise>
                  <xsl:call-template name="wmlEncode">
                    <xsl:with-param name="initValue" select="normalize-space(.)"/>
                  </xsl:call-template>
                  <br></br>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="@VARIABLE">
              <xsl:choose>
                <xsl:when test="PICK_LIST">
                  <xsl:call-template name="build_picklist"></xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="build_textbox"></xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="build_textbox"></xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="@HTML_TYPE='Link'">
          <!--  Build  Submit link and other links  -->
          <xsl:choose>
            <xsl:when test="@ID='41'">
              <xsl:call-template name="build_submit_link"></xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="build_simple_link"></xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!--  create a Pick List for input  -->
  <xsl:template name="build_picklist">
    <xsl:variable name="selected">
      <xsl:call-template name="wmlEncode">
        <xsl:with-param name="initValue" select="normalize-space(PICK_LIST/@VALUE)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@FIELD">
        <xsl:element name="select">
          <xsl:attribute name="name">
            <xsl:value-of select="@VARIABLE"></xsl:value-of>
          </xsl:attribute>
          <xsl:if test="string-length($selected)&gt;0">
            <xsl:attribute name="value">
              <xsl:value-of select="$selected"></xsl:value-of>
            </xsl:attribute>
          </xsl:if>
          <xsl:for-each select="PICK_LIST/OPTION">
            <xsl:variable name="option">
              <xsl:call-template name="wmlEncode">
                <xsl:with-param name="initValue" select="normalize-space(@CAPTION)"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:element name="option">
              <xsl:attribute name="value">
                <xsl:value-of select="$option"/>
              </xsl:attribute>
              <xsl:value-of select="$option"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$selected"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  Create an input text box -->
  <xsl:template name="build_textbox">
    <xsl:choose>
      <xsl:when test="@FIELD">
        <xsl:element name="input">
          <xsl:attribute name="name">
            <xsl:value-of select="@VARIABLE"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:call-template name="wmlEncode">
              <xsl:with-param name="initValue" select="normalize-space(.)"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:if test="string-length(@MAX_LENGTH) >0">
            <xsl:attribute name="maxlength">
              <xsl:value-of select="@MAX_LENGTH"></xsl:value-of>
            </xsl:attribute>
          </xsl:if>
          <xsl:attribute name="emptyok">
            <xsl:text>true</xsl:text>
          </xsl:attribute>
          <xsl:if test="@ATTR">
            <xsl:variable name="attr">
              <xsl:value-of select="@ATTR"/>
            </xsl:variable>
            <xsl:if test="starts-with($attr,'format')">
              <xsl:variable name="format">
                <xsl:call-template name="remove_quote">
                  <xsl:with-param name="quotedFormat" select="substring-after($attr,'=')"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:attribute name="format">
                <xsl:value-of select="$format"></xsl:value-of>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="wmlEncode">
          <xsl:with-param name="initValue" select="normalize-space(.)"/>
        </xsl:call-template>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- display a bigger textbox for textarea in WML -->
  <!-- the size has to be hardcoded. It is set to 50 considering the device display size -->
  <!-- this size can be changed in the following code if 50 is not proper for your browser-->
  <xsl:template name="build_bigger_textbox">
    <xsl:choose>
      <xsl:when test="@FIELD">
        <xsl:element name="input">
          <xsl:attribute name="name">
            <xsl:value-of select="@VARIABLE"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:call-template name="wmlEncode">
              <xsl:with-param name="initValue" select="normalize-space(.)"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="size">
            <xsl:value-of select="50"/>
          </xsl:attribute>
          <xsl:if test="string-length(@MAX_LENGTH) >0">
            <xsl:attribute name="maxlength">
              <xsl:value-of select="@MAX_LENGTH"></xsl:value-of>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="@ATTR">
            <xsl:variable name="attr">
              <xsl:value-of select="@ATTR"/>
            </xsl:variable>
            <xsl:if test="starts-with($attr,'format')">
              <xsl:variable name="format">
                <xsl:call-template name="remove_quote">
                  <xsl:with-param name="quotedFormat" select="substring-after($attr,'=')"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:attribute name="format">
                <xsl:value-of select="$format"></xsl:value-of>
              </xsl:attribute>
            </xsl:if>
          </xsl:if>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="wmlEncode">
          <xsl:with-param name="initValue" select="normalize-space(.)"/>
        </xsl:call-template>
        <br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  template to create Submit link  -->
  <xsl:template name="build_submit_link">
    <xsl:variable name="link">
      <xsl:apply-templates select="ANCHOR">
        <xsl:with-param name="bKeepSpaces" select="true"/>
      </xsl:apply-templates>
      <xsl:call-template name="add_variables"></xsl:call-template>
    </xsl:variable>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="normalize-space($link)"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="@CAPTION"></xsl:value-of>
    </xsl:element>
    <br></br>
  </xsl:template>

  <xsl:template match="FIELD">
    <xsl:text>&amp;</xsl:text>
    <xsl:variable name="fieldName">
      <xsl:value-of select="@VARIABLE"/>
    </xsl:variable>
    <xsl:variable name="value">
      <xsl:choose>
        <xsl:when test="string-length(normalize-space(.))>0">
          <xsl:call-template name="RemoveLeadingTrailingSpaces">
            <xsl:with-param name="initial_value" select="."></xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('$','(',$fieldName,':escape)')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$fieldName"/>=<xsl:value-of select="$value"/>
  </xsl:template>

  <xsl:template name="add_variables">
    <xsl:for-each select="//FORM/CONTROL">
      <xsl:if test="@VARIABLE">
        <xsl:text>&amp;</xsl:text>
        <xsl:variable name="fieldName">
          <xsl:value-of select="@VARIABLE"/>
        </xsl:variable>
        <xsl:variable name="value">
          <xsl:value-of select="concat('$(',$fieldName,':escape)')"/>
        </xsl:variable>
        <xsl:value-of select="$fieldName"/>=<xsl:value-of select="$value"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="remove_quote">
    <xsl:param name="quotedFormat"></xsl:param>
    <xsl:choose>
      <xsl:when test="starts-with($quotedFormat,'&quot;')">
        <xsl:call-template name="remove_quote">
          <xsl:with-param name="quotedFormat" select="substring($quotedFormat,2)"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="substring($quotedFormat,string-length($quotedFormat))='&quot;'">
        <xsl:call-template name="remove_quote">
          <xsl:with-param name="quotedFormat" select="substring($quotedFormat,1,string-length($quotedFormat)-1)"/> 
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$quotedFormat"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="wmlEncode">
    <xsl:param name="initValue"></xsl:param>
    <xsl:choose>
      <xsl:when test="contains($initValue, '$')">
        <xsl:value-of select="substring-before($initValue, '$')"></xsl:value-of>
        <xsl:text>$$</xsl:text>
        <xsl:call-template name="wmlEncode">
          <xsl:with-param name="initValue" select="substring-after($initValue, '$')"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$initValue"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- build simple link -->
  <xsl:template name="build_simple_link">
    <xsl:variable name="link">
      <xsl:apply-templates select="ANCHOR">
        <xsl:with-param name="bKeepSpaces" select="false"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="normalize-space($link)"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="@CAPTION"></xsl:value-of>
    </xsl:element>
    <br></br>
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

  <xsl:template match="INFO">
    <xsl:variable name="info">
      <xsl:if test="string-length(normalize-space(.)) >0"> 
        <xsl:value-of select="normalize-space(.)"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$info"></xsl:value-of>
  </xsl:template>

  <xsl:template match="ARG">
    <xsl:param name="bKeepSpaces"></xsl:param>
    <xsl:variable name="arg">
      <xsl:if test="string-length(normalize-space(.)) >0">
        <xsl:variable name="argstring">
          <xsl:if test="@NAME='Pu' or @NAME='R' or @NAME='Rs'">
            <!--  replace + with %2B and replace = with %3d -->
            <xsl:call-template name="ENCODE_ARG">
              <xsl:with-param name="encode_string" select="normalize-space(.)"></xsl:with-param>
            </xsl:call-template>
          </xsl:if>
          <xsl:if test="not (@NAME='Pu' or @NAME='R' or @NAME='Rs')">
            <xsl:if test="$bKeepSpaces">
              <xsl:call-template name="RemoveLeadingTrailingSpaces">
                <xsl:with-param name="initial_value" select="."></xsl:with-param>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="not($bKeepSpaces)">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:if>
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="encodedArg">
          <xsl:call-template name="EncodeURL">
            <xsl:with-param name="initialArg" select="$argstring"></xsl:with-param>
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$encodedArg"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$arg"></xsl:value-of>
  </xsl:template>

  <!-- need to encode special characters for the data that send back to server -->
  <xsl:template name="EncodeURL">
    <xsl:param name="initialArg"></xsl:param>
    <xsl:choose>
      <!--  recursive processing to handle more than one # -->
      <xsl:when test="contains($initialArg, '#')">
        <xsl:value-of select="substring-before($initialArg, '#')"></xsl:value-of>
        <!--  replace # with %23  -->
        <xsl:text>%23</xsl:text>
        <xsl:call-template name="EncodeURL">
          <xsl:with-param name="initialArg" select="substring-after($initialArg, '#')"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($initialArg, '&#x20;')">
        <xsl:value-of select="substring-before($initialArg, '&#x20;')"></xsl:value-of>
        <!--  replace # with %20  -->
        <xsl:text>%20</xsl:text>
        <xsl:call-template name="EncodeURL">
          <xsl:with-param name="initialArg" select="substring-after($initialArg, '&#x20;')"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$initialArg"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="ENCODE_ARG">
    <xsl:param name="encode_string"></xsl:param>
    <xsl:choose>
      <xsl:when test="contains($encode_string, '+')">
        <xsl:value-of select="substring-before($encode_string, '+')"></xsl:value-of>
        <xsl:text>%2B</xsl:text><!--  replace + with %2B  -->
        <xsl:call-template name="ENCODE_ARG">
          <xsl:with-param name="encode_string" select="substring-after($encode_string, '+')"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($encode_string, '=')">
        <xsl:value-of select="substring-before($encode_string, '=')"></xsl:value-of>
        <xsl:text>%3d</xsl:text><!--  replace = with %3d  -->
        <xsl:call-template name="ENCODE_ARG">
          <xsl:with-param name="encode_string" select="substring-after($encode_string, '=')"></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$encode_string"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="RemoveLeadingTrailingSpaces">
    <xsl:param name="initial_value"></xsl:param>
    <xsl:choose>
      <xsl:when test="starts-with($initial_value,'&#x9;') or starts-with($initial_value,'&#xA;') or starts-with($initial_value,'&#xD;') or starts-with($initial_value,'&#x20;')">
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
        <xsl:value-of select="$initial_value"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>