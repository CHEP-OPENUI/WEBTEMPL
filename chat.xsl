<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" indent="yes"/> 
 <xsl:template match="transcript">
    <html>
<!--
		<head>
			<style type="text/css">
				message    			{color:black}
				url    					{color:blue}
				timestamp 			{color:blue}
				system-message {color:black}
			</style>
		</head>
-->		
		<body>
		   <xsl:apply-templates/>
	   </body>
    </html>
 </xsl:template>
 <xsl:template match="message">
	<xsl:if test="@from = 'agent'">
		<b style="font-family: Arial; font-size: 9pt; color: #0000FF">
			<xsl:text></xsl:text>
			<xsl:value-of select="@userName" />
		</b> 
		<span style="font-family: Arial; font-size: 9pt; color: #0000FF">
			<xsl:text></xsl:text>
			(<xsl:value-of select="@timestamp" />)
		</span>
		<br/>      
		<span style="font-family: Arial; font-size: 9pt; color: #000000">
		<xsl:text></xsl:text>
		<xsl:value-of select="." />
		</span>
		<br/>
		<br/>
	</xsl:if>
	<xsl:if test="@from = 'customer'">
		<b style="font-family: Arial; font-size: 9pt; color: #FF3300">
			<xsl:text></xsl:text>
			<xsl:value-of select="@userName" />
		</b> 
		<span style="font-family: Arial; font-size: 9pt; color: #FF3300">
			<xsl:text></xsl:text>
			(<xsl:value-of select="@timestamp" />)
		</span>
		<br/>      
		<span style="font-family: Arial; font-size: 9pt; color: #000000">
		<xsl:text></xsl:text>
		<xsl:value-of select="." />
		</span>
		<br/>
		<br/>
	</xsl:if>
 </xsl:template>

<xsl:template match="pushUrl">
     <b style="font-family: Arial; font-size: 9pt; color: #0000FF">
		 <xsl:text></xsl:text>
         <xsl:value-of select="@userName" />
     </b>        
     <span style="font-family: Arial; font-size: 9pt; color: #0000FF">
		 <xsl:text></xsl:text>
         (<xsl:value-of select="@timestamp" />)
     </span>
     <br/>      
     <span style="font-family: Arial; font-size: 9pt; color: #000000">
		 <u>
			 <xsl:text></xsl:text>
			 <xsl:value-of select="." />
		 </u>
     </span>
     <br/>
     <br/>
 </xsl:template>

 <xsl:template match="system-message">
     <b style="font-family: Arial; font-size: 9pt; color: #0000FF">
		 <xsl:text></xsl:text>
         System message 
     </b>        
     <span style="font-family: Arial; font-size: 9pt; color: #0000FF">
		 <xsl:text></xsl:text>
         (<xsl:value-of select="@timestamp" />)
     </span>
     <br/>      
     <span style="font-family: Arial; font-size: 9pt; color: #000000">
		 <xsl:text></xsl:text>
         <xsl:value-of select="." />
     </span>
     <br/>
     <br/>
 </xsl:template>

 
</xsl:stylesheet>
