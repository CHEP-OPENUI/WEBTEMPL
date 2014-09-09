<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" media-type="text/html"></xsl:output>
  <!--  This style sheet process the XML output for both the Splash screens and standard views -->
  <!--  ====================== Root Document Processing ======================== -->
  <!--  Document Root -->
  <xsl:template match="/">
    <xsl:apply-templates select="//APPLET"></xsl:apply-templates>
  </xsl:template>
  <!--  Edit Mode Style Template  -->
  <xsl:template match="APPLET">
    <HTML>
      <HEADER>
        <META http-equiv="cache-control" content="no-cache"></META>
      </HEADER>
      <BODY>
        <!--  Error message  -->
        <xsl:if test="string-length(ERROR)>0">
          <b><xsl:value-of select="ERROR"></xsl:value-of></b>
          <br></br>
        </xsl:if>
        <!--  Title  -->
              <b><xsl:value-of select="CONTROL/."></xsl:value-of></b>
            
        <!-- form -->
           
          <xsl:apply-templates select="FORM"></xsl:apply-templates>
       
      </BODY>
    </HTML>
  </xsl:template>
  <!--  ============================= FORM Processing ============================= -->
  <!--  Form Template  -->
  <xsl:template match="FORM">
    <xsl:element name="Form">
      <xsl:attribute name="METHOD">
        <xsl:text>POST</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="ACTION">
        <xsl:value-of select="//APPLET/FORM/@ACTION"></xsl:value-of>
      </xsl:attribute>
      <xsl:for-each select="CONTROL">
       <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="CONTROL">  
    <xsl:choose>
      <xsl:when test="@HTML_TYPE='Password'">
        <xsl:call-template name="build_textbox"/>
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
            <xsl:value-of select="."></xsl:value-of>
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
      </xsl:when><!--  Button controls  -->
      <xsl:when test="@HTML_TYPE='Link'"><!--  Build form button for Submit and Cancel, build link otherwise  -->
        <xsl:choose>
          <xsl:when test="@ID='41' or @ID='42'">
            <xsl:call-template name="form_buttons"></xsl:call-template><!--  add SWEForm tag -->
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
          </xsl:when>
          <!--  All other edit, pick, etc.  -->
          <xsl:otherwise>
            <xsl:call-template name="build_simple_link"></xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <!--  create a Pick List for input  -->
  <xsl:template name="build_picklist">
    <xsl:variable name="selected">
      <xsl:value-of select="PICK_LIST/@VALUE"></xsl:value-of>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@FIELD">
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
      </xsl:when>
     <xsl:otherwise>
        <xsl:value-of select="$selected"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
    <br></br>
  </xsl:template><!--  Create an input text box -->
  <xsl:template name="build_textbox">
    <xsl:choose>
      <xsl:when test="@FIELD">
        <xsl:element name="Input">
          <xsl:attribute name="type">
            <xsl:text>password</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="Name">
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
        </xsl:element>
      </xsl:when>
      <xsl:when test="@HTML_TYPE='Password'">
        <xsl:element name="Input">
	  <xsl:attribute name="type">
	    <xsl:text>password</xsl:text>
	  </xsl:attribute>
	  <xsl:attribute name="Name">
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
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
    <br></br>
  </xsl:template><!--  template to create form buttons  -->
  <xsl:template name="form_buttons">
    <xsl:for-each select="ANCHOR">
      <xsl:for-each select="CMD"><!--  Add invoke method tag here -->
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
                <xsl:if test="@NAME='Pu' or @NAME='R' or @NAME='Rs'"><!--  replace + with %2B  -->
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
              <xsl:value-of select="$argstring"></xsl:value-of><!-- xsl:value-of select="normalize-space()"/ -->
            </xsl:attribute>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>
      <xsl:for-each select="INFO"><!--  Add invoke method tag here -->
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
      <xsl:value-of select="@CAPTION"></xsl:value-of>
    </xsl:element>
    <br></br>
  </xsl:template><!--  =========================== Anchor URL Processing =============================== --><!--  THIS PART IS USED EVERYWHERE, WILL BE IN A SEPARATE FILE AND IMPORTED IN LATER === --><!--  ANCHOR Template  builds the URL for drilldowns and links  -->
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
</xsl:if><!--  recursive processing  -->
<xsl:if test="contains($encode_string, '+')">
<xsl:value-of select="substring-before($encode_string, '+')"></xsl:value-of>
<xsl:text>%2B</xsl:text><!--  replace + with %2B  -->
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
<xsl:if test="string-length(normalize-space(.)) >0"><!-- <xsl:value-of select="."/> -->
<xsl:value-of select="normalize-space(.)"></xsl:value-of>
</xsl:if>
</xsl:variable>
   <xsl:text>&amp;</xsl:text>
   <xsl:value-of select="@NAME"></xsl:value-of>=<xsl:value-of select="$info"></xsl:value-of>
</xsl:template>
</xsl:stylesheet>