<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" media-type="text/html" omit-xml-declaration="no"
   doctype-public="-//WAPFORUM//DTD XHTML Mobile 1.0//EN"
   doctype-system="http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
  </xsl:output>

  <!--  ====================== Root Document Processing ======================== -->
  <xsl:template match="/">
    <xsl:apply-templates select="//APPLET"></xsl:apply-templates>
  </xsl:template>

  <xsl:template match="APPLET">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>

      <body>
        <!--  Error message  -->
        <xsl:if test="string-length(ERROR)>0">
          <xsl:value-of select="ERROR"></xsl:value-of>
          <br></br>
        </xsl:if>

        <!--  Title  -->
        <b>
          <xsl:value-of select="CONTROL/."></xsl:value-of>
        </b>
        <br></br>
        <xsl:apply-templates select="FORM"></xsl:apply-templates>
      </body>
    </html>
  </xsl:template>

  <!--  ============================= FORM Processing ============================= -->
  <xsl:template match="FORM">
    <xsl:element name="form">
      <xsl:attribute name="method">
        <xsl:text>GET</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="ACTION">
        <xsl:value-of select="//APPLET/FORM/@ACTION"></xsl:value-of>
      </xsl:attribute>
      <xsl:for-each select="CONTROL">
        <xsl:choose>
          <xsl:when test="@HTML_TYPE='CheckBox'">
            <xsl:call-template name="build_checkbox"></xsl:call-template>
          </xsl:when>
          <xsl:when test="@HTML_TYPE='TextArea'">
	    <xsl:call-template name="build_textarea"></xsl:call-template>
          </xsl:when>
          <xsl:when test="@HTML_TYPE='MakeCall'">
            <xsl:call-template name="build_textbox"></xsl:call-template>
          </xsl:when>
          <xsl:when test="@HTML_TYPE='Label' or @HTML_TYPE='FieldLabel'">
            <xsl:value-of select="."></xsl:value-of>
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
          <xsl:when test="@HTML_TYPE='Text'">
            <xsl:choose>
              <xsl:when test="@TYPE='Label'">
                <xsl:value-of select="normalize-space(.)"></xsl:value-of>
                <br></br>
              </xsl:when>
              <xsl:when test="@TYPE='TextBox'">
                <xsl:choose>
                  <xsl:when test="PICK_LIST">
                    <xsl:call-template name="build_picklist"></xsl:call-template>
                  </xsl:when>
                  <xsl:when test="@VARIABLE">
                    <xsl:call-template name="build_textbox"></xsl:call-template>
                  </xsl:when>
                  <!--  labels and no text controls -->
                  <xsl:otherwise>
                    <xsl:value-of select="."></xsl:value-of>
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
            <!--  Build form button for Submit and Cancel, build link otherwise  -->
            <xsl:choose>
              <xsl:when test="@ID='41' or @ID='42'">
                <xsl:call-template name="form_buttons"></xsl:call-template>
                <!--  add SWEForm tag -->
                <xsl:variable name="sweformarg">
                  <xsl:value-of select="@NAME"></xsl:value-of>
                </xsl:variable>
                <xsl:element name="input">
                  <xsl:attribute name="type">
                    <xsl:text>hidden</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="name">
                    <xsl:text>SWEForm</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="id">
                    <xsl:text>SWEForm</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="$sweformarg"></xsl:value-of>
                  </xsl:attribute>
                </xsl:element>
                <xsl:element name="input">
                  <xsl:attribute name="Type">
                    <xsl:text>submit</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="@CAPTION"></xsl:value-of>
                  </xsl:attribute>
                </xsl:element>
              </xsl:when>
              <!--  All other edit, pick, etc.  -->
              <xsl:otherwise>
                <xsl:call-template name="build_simple_link"></xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!--  create a Pick List for input  -->
  <xsl:template name="build_picklist">
    <xsl:variable name="selected">
      <xsl:value-of select="PICK_LIST/@VALUE"></xsl:value-of>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@FIELD">
        <xsl:element name="select">
          <xsl:attribute name="Name">
            <xsl:value-of select="@VARIABLE"></xsl:value-of>
          </xsl:attribute>
          <xsl:for-each select="PICK_LIST/OPTION">
            <xsl:element name="option">
              <xsl:if test="@CAPTION=$selected">
                <xsl:attribute name="selected">
                  <xsl:text>selected</xsl:text>
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="normalize-space()"></xsl:value-of>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$selected"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
    <br></br>
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
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
    <br></br>
  </xsl:template>

  <!--  Create an input text box -->
  <xsl:template name="build_textbox">
    <xsl:choose>
      <xsl:when test="@FIELD">
        <xsl:element name="input">
          <xsl:attribute name="type">
            <xsl:text>text</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="@VARIABLE"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="@VARIABLE"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="normalize-space()"></xsl:value-of>
          </xsl:attribute>
          <xsl:if test="string-length(@MAX_LENGTH) >0">
            <xsl:attribute name="maxlength">
              <xsl:value-of select="@MAX_LENGTH"></xsl:value-of>
            </xsl:attribute>
          </xsl:if>
          <!-- set the initial textbox size to 15.  Change this size if it is not proper for your device -->
          <xsl:attribute name="size">
            <xsl:text>15</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
    <br></br>
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
      <xsl:value-of select="normalize-space()"></xsl:value-of>
    </xsl:element>
    <br></br>
  </xsl:template>

  <!--  template to create form buttons  -->
  <xsl:template name="form_buttons">
    <xsl:for-each select="ANCHOR">
      <xsl:for-each select="CMD">
        <xsl:element name="input">
          <xsl:attribute name="type">
            <xsl:text>hidden</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="@NAME"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="@NAME"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="@VALUE"></xsl:value-of>
          </xsl:attribute>
        </xsl:element>
        <xsl:for-each select="ARG">
          <xsl:element name="input">
            <xsl:attribute name="type">
              <xsl:text>hidden</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="@NAME"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="id">
              <xsl:value-of select="@NAME"></xsl:value-of>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:variable name="argstring">
                <xsl:if test="@NAME='Pu' or @NAME='R' or @NAME='Rs'">
                  <!--  replace + with %2B  -->
                  <xsl:call-template name="ENCODE_ARG">
                    <xsl:with-param name="encode_string" select="normalize-space(.)"></xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="not (@NAME='Pu' or @NAME='R' or @NAME='Rs')">   
                  <xsl:call-template name="RemoveLeadingTrailingSpaces">
                    <xsl:with-param name="initial_value" select="."></xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
              </xsl:variable>
              <xsl:value-of select="$argstring"></xsl:value-of>
            </xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="INFO">
        <xsl:element name="input">
          <xsl:attribute name="type">
            <xsl:text>hidden</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="@NAME"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="id">
            <xsl:value-of select="@NAME"></xsl:value-of>
          </xsl:attribute>
          <xsl:attribute name="value">
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
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="$link"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="@CAPTION"></xsl:value-of>
    </xsl:element>
    <br></br>
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
        <xsl:value-of select="$argstring"></xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:text>&amp;</xsl:text>
    <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$arg"></xsl:value-of>
  </xsl:template>

  <xsl:template name="ENCODE_ARG">
    <xsl:param name="encode_string"></xsl:param>
    <xsl:if test="not (contains($encode_string, '+'))">
      <xsl:value-of select="$encode_string"></xsl:value-of>
    </xsl:if>
    <!--  recursive processing  -->
    <xsl:if test="contains($encode_string, '+')">
      <xsl:value-of select="substring-before($encode_string, '+')"></xsl:value-of>
      <xsl:text>%2B</xsl:text>
      <!--  replace + with %2B  -->
      <xsl:call-template name="ENCODE_ARG">
        <xsl:with-param name="encode_string" select="substring-after($encode_string, '+')"></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="RemoveLeadingTrailingSpaces">
    <xsl:param name="initial_value"></xsl:param>
    <xsl:choose>
      <xsl:when test="starts-with($initial_value,'&#x9;') or starts-with($initial_value,'&#xA;') or starts-with($initial_value,'&#xD;') or starts-with($initial_value,'&#x20;')">
        <xsl:call-template name="RemoveLeadingTrailingSpaces">
          <xsl:with-param name="initial_value" select="substring($initial_value,2)"> </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="substring($initial_value,string-length($initial_value))='&#x9;' or substring($initial_value,string-length($initial_value))='&#xA;' or substring($initial_value,string-length($initial_value))='&#xD;' or substring($initial_value,string-length($initial_value))='&#x20;'">
        <xsl:call-template name="RemoveLeadingTrailingSpaces">
          <xsl:with-param name="initial_value" select="substring($initial_value,1,string-length($initial_value)-1)"> </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$initial_value"> </xsl:value-of>
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
