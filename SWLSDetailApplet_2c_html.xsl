<?xml version="1.0" encoding="utf-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" media-type="text/html"></xsl:output>

  <!--  ====================== Root Document Processing ======================== -->
  <xsl:template match="/">
    <xsl:apply-templates select="APPLICATION/SCREEN/VIEW/APPLET"></xsl:apply-templates>
  </xsl:template>

  <!--  ============================ View Processing =========================== -->
  <xsl:template match="APPLET">
    <html>
      <head>
        <meta http-equiv="cache-control" content="no-cache"></meta>
      </head>

      <body>
        <!-- Head: Title of Page-->
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

        <!--  APPLET TITLE Section -->
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#000066" width="100%" height="2"></td>
          </tr>
        </table>
        <table border="0" width="100%" cellspacing="0" cellpadding="3" bgcolor="#9999CC">
          <tr>
            <td height="25" align="left">
              <b>
                <font face="Arial" color="#FFFFFF" size="2">
                  <xsl:apply-templates select="CONTROL[@ID=1 or @ID=100]"></xsl:apply-templates>
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

        <!--  Applet Data Section -->
        <table border="0" width="100%"  cellspacing="0" cellpadding="3" bgcolor="#EEFFFF">
          <xsl:apply-templates select="CONTROL[@ID&gt;1 and @ID&lt;41 or @ID&gt;110 and @ID&lt;141]"></xsl:apply-templates>
        </table>

        <!--  Other links -->
        <table border="0" width="100%"  cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#000066" width="100%" height="1"></td>
          </tr>
        </table>
        <table border="0" width="100%"  cellspacing="0" cellpadding="3" bgcolor="#9999CC">
          <xsl:apply-templates select="CONTROL[@ID&gt;40 and @ID&lt;52]"></xsl:apply-templates>
        </table>
        <table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#9999CC">
          <tr>
            <td bgcolor="#333399" width="100%" height="2"></td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>

  <!--  This template renders all the controls in  detail view. Does not render controls in Forms -->
  <xsl:template match="CONTROL[@ID=1 or @ID=100]">
    <xsl:value-of select="text()"/>
  </xsl:template>

  <xsl:template match="CONTROL[@ID&gt;110 and @ID&lt;141]">
    <xsl:variable name ="dataId">
      <xsl:value-of select="@ID+-100"></xsl:value-of>
    </xsl:variable>
    <xsl:if test="following-sibling::CONTROL[1]/@ID!=$dataId">
      <tr>
        <td align="left" nowrap="nowarp">
          <font face="Arial" size="2">
            <xsl:value-of select="normalize-space(text())"/>
          </font>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template match="CONTROL[@ID&gt;1 and @ID&lt;41]">
    <xsl:if test="@ID&gt;1 and @ID&lt;11">
      <!-- for menu applet which uses Detail template -->
      <tr>
        <td align="left">
          <font face="Arial" size="2">
            <xsl:choose>
              <xsl:when test="@HTML_TYPE='Link'">
                <xsl:call-template name="build_link_or_home_button"></xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="normalize-space(text())"/>
              </xsl:otherwise>
            </xsl:choose>
          </font>
        </td>
      </tr>
    </xsl:if>

    <xsl:if test="@ID&gt;10 and @ID&lt;41">
      <xsl:variable name ="previousId">
        <xsl:value-of select="@ID+-1"></xsl:value-of>
      </xsl:variable>
      <xsl:variable name ="nextId">
        <xsl:value-of select="@ID+1"></xsl:value-of>
      </xsl:variable>
      <xsl:variable name ="labelId">
        <xsl:value-of select="@ID+100"></xsl:value-of>
      </xsl:variable>

      <xsl:if test="@HTML_TYPE='Text' or @HTML_TYPE='MakeCall' and @TYPE='TextBox' or @HTML_TYPE='CheckBox'">
        <xsl:variable name="value">
          <xsl:value-of select="normalize-space(text())"></xsl:value-of>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="string-length($value)>0">
            <xsl:if test="preceding-sibling::CONTROL[1]/@ID!=$previousId or preceding-sibling::CONTROL[1]/@HTML_TYPE!='Link'">
              <xsl:variable name="prevMethod">
                <xsl:value-of select="preceding-sibling::CONTROL[1]/ANCHOR/CMD/ARG[@NAME='M']"></xsl:value-of>
              </xsl:variable>
              <xsl:if test="not(contains($prevMethod,'Edit')) or preceding-sibling::CONTROL[1]/@ID!=$labelId">
                <tr>
                  <!--label-->
                  <td align="left" width="35%" nowrap="nowrap">
                    <font face="Arial" size="2">
                      <xsl:if test="preceding-sibling::CONTROL[1]/@ID=$labelId">
                        <xsl:value-of select="normalize-space(preceding-sibling::CONTROL[1]/@CAPTION)"></xsl:value-of>
                      </xsl:if>
                      <xsl:if test="preceding-sibling::CONTROL[1]/@ID!=$labelId">
                        <xsl:variable name="caption">
                          <xsl:value-of select="normalize-space(@CAPTION)"></xsl:value-of>
                        </xsl:variable>
                        <xsl:if test="string-length($caption)!=0">
                          <xsl:value-of select ="$caption"></xsl:value-of>
                          <xsl:if test="substring($caption,string-length($caption))!=':'">
                            <xsl:text>:</xsl:text>
                          </xsl:if>
                        </xsl:if>
                      </xsl:if>
                    </font>
                  </td>
                  <td align="left" width="65%">
                    <font face="Arial" size="2">
                      <xsl:if test="ANCHOR">
                        <xsl:call-template name="build_field_drilldown_link"></xsl:call-template>
                      </xsl:if>
                      <xsl:if test="not(ANCHOR)">
                        <xsl:value-of select="normalize-space(text())"></xsl:value-of>
                      </xsl:if>
                    </font>
                  </td>
                </tr>
              </xsl:if>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td align="left" nowrap="nowarp">
                <font face="Arial" size="2">
                  <xsl:variable name="caption">
                    <xsl:value-of select="normalize-space(@CAPTION)"></xsl:value-of>
                  </xsl:variable>
                  <xsl:if test="string-length($caption)!=0">
                    <xsl:value-of select ="$caption"></xsl:value-of>
                    <xsl:if test="substring($caption,string-length($caption))!=':'">
                      <xsl:text>:</xsl:text>
                    </xsl:if>
                  </xsl:if>
                </font>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <xsl:if test="@HTML_TYPE='Link'">
        <tr>
          <td align="left" nowrap="nowarp">
            <font face="Arial" size="2">
              <xsl:call-template name="build_link_or_home_button"></xsl:call-template>
            </font>
          </td>
          <xsl:variable name ="method">
            <xsl:value-of select="ANCHOR/CMD/ARG[@NAME='M']"> </xsl:value-of>
          </xsl:variable>
          <xsl:if test="contains($method,'Edit') and following-sibling::CONTROL[1]/@ID=$nextId 
                    and following-sibling::CONTROL[1]/@HTML_TYPE='Text'
                    or  following-sibling::CONTROL[1]/@HTML_TYPE='MakeCall'
                    and following-sibling::CONTROL[1]/@TYPE='TextBox'
                    or  following-sibling::CONTROL[1]/@HTML_TYPE='CheckBox'">
            <td align="left">
              <font face="Arial" size="2">
                <xsl:choose>
                  <xsl:when test="following-sibling::CONTROL[1]/ANCHOR">
                    <xsl:call-template name="build_next_link"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="normalize-space(following-sibling::CONTROL[1]/text())"/>
                  </xsl:otherwise>
                </xsl:choose>
              </font>
            </td>
          </xsl:if>
        </tr>
      </xsl:if>

      <xsl:if test="@HTML_TYPE='Label' and following-sibling::CONTROL[1]/@ID!=$nextId">
        <xsl:variable name="value">
          <xsl:value-of select="normalize-space(text())"></xsl:value-of>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($value)>0">
            <tr>
              <td align="left" nowrap="nowarp">
                <font face="Arial" size="2">
                  <xsl:value-of select="$value"/>
                </font>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td align="left" nowrap="nowarp">
                <font face="Arial" size="2">
                  <xsl:variable name="caption">
                    <xsl:value-of select="normalize-space(@CAPTION)"></xsl:value-of>
                  </xsl:variable>
                  <xsl:if test="string-length($caption)!=0">
                    <xsl:value-of select ="$caption"></xsl:value-of>
                    <xsl:if test="substring($caption,string-length($caption))!=':'">
                      <xsl:text>:</xsl:text>
                    </xsl:if>
                  </xsl:if>
                </font>
              </td>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="CONTROL[@ID&gt;40 and @ID&lt;52]">
    <xsl:variable name="thePosition">
      <xsl:value-of select="position()"></xsl:value-of>
    </xsl:variable>
    <xsl:if test="@NAME='Main Menu' or $thePosition mod 2 != 0">
      <tr>
        <td align="left" valign="top" nowrap="nowarp">
          <font face="Arial" size="2">
            <xsl:call-template name="build_link_or_home_button"></xsl:call-template>
          </font>
        </td>
        <td align="right" nowrap="nowarp">
          <font face="Arial" size="2">
            <xsl:choose>
              <xsl:when test="following-sibling::CONTROL[1]/@NAME!='Main Menu'">
                <xsl:call-template name="build_next_link"></xsl:call-template>
              </xsl:when>
              <xsl:when test="@NAME='Main Menu'">
                <!-- Thread Pick List -->
                <xsl:if test="//NAVIGATION_ELEMENTS/THREAD_BAR/THREAD">
                  <xsl:apply-templates select="//NAVIGATION_ELEMENTS/THREAD_BAR"></xsl:apply-templates>
                </xsl:if>
              </xsl:when>
            </xsl:choose>
          </font>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template name="build_next_link">
    <xsl:if test="following-sibling::CONTROL[1]/ANCHOR">
      <xsl:variable name="link">
        <xsl:apply-templates select="following-sibling::CONTROL[1]/ANCHOR"></xsl:apply-templates>
      </xsl:variable>
      <xsl:element name="A">
        <xsl:attribute name="HREF">
          <xsl:value-of select="$link"></xsl:value-of>
        </xsl:attribute>
        <xsl:if test="following-sibling::CONTROL[1]/@HTML_TYPE='Link'">
          <xsl:value-of select="normalize-space(following-sibling::CONTROL[1]/@CAPTION)"></xsl:value-of>
        </xsl:if>
        <xsl:if test="following-sibling::CONTROL[1]/@HTML_TYPE='Text'">
          <xsl:value-of select="normalize-space(following-sibling::CONTROL[1]/text())"></xsl:value-of>
        </xsl:if>
      </xsl:element>
      <br></br>
    </xsl:if>
  </xsl:template>

<!--
  <xsl:template name="build_area_3">
    <xsl:param name="lastId">40</xsl:param>
    <xsl:if test="CONTROL[@ID&gt;$lastId and @ID&lt;52">
      <tr>
        <td align="left">
          <font face="Arial" size="2">
            <xsl:call-template name="build_this_link">
              <xsl:with-param name="id">$lastId+1<xsl:with-param>
            </xsl:call-template>
          </font>
        </td>
        <td align="left">
          <font face="Arial" size="2">
            <xsl:if test
            <xsl:call-template name="build_next_link"></xsl:call-template>
          </font>
        </td>
      </tr>
    </xsl:if>
  </xsl:template> 
-->

  <xsl:template name="build_field_drilldown_link">
    <xsl:variable name="link">
      <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
    </xsl:variable>
    <xsl:element name="A">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$link"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="normalize-space(text())"></xsl:value-of>
    </xsl:element>
    <br></br>
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

  <!--  Thread Pick List  -->
  <xsl:template match="//NAVIGATION_ELEMENTS/THREAD_BAR">
    <xsl:element name="Form">
      <xsl:attribute name="METHOD">
        <xsl:text>POST</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="Name">
        <xsl:text>thread</xsl:text>
      </xsl:attribute>
      <xsl:variable name="separator">
        <xsl:text>:</xsl:text>
      </xsl:variable>
      <xsl:if test="THREAD/ANCHOR">
        <xsl:element name="Select">
          <xsl:attribute name="Name">
            <xsl:text>threadlink</xsl:text>
          </xsl:attribute>
          <xsl:for-each select="THREAD">
            <xsl:if test="ANCHOR">
              <xsl:element name="Option">
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
              </xsl:element>
            </xsl:if>
          </xsl:for-each>
        </xsl:element>

        <xsl:element name="Input">
          <xsl:attribute name="Type">
            <xsl:text>button</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="Value">
            <xsl:text>Go</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:text>document.location.href=document.thread.threadlink.options[document.thread.threadlink.selectedIndex].value</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template name="build_thread_link">
    <xsl:choose>
      <xsl:when test="ANCHOR">
        <xsl:variable name="link">
          <xsl:apply-templates select="ANCHOR"></xsl:apply-templates>
        </xsl:variable>
        <xsl:element name="A">
          <xsl:attribute name="HREF">
            <xsl:value-of select="$link"></xsl:value-of>
          </xsl:attribute>
          <xsl:value-of select="normalize-space(@TITLE)"></xsl:value-of>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space(@TITLE)"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
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