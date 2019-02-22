<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="1.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


   <!--KEYS AND FUNCTIONS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1"
                          select="1+    count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+   count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="Schematron Release Profile for Release Profile Deleted Rules (version 1.3.1) for the NewReleaseMessage."
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:text>© 2006-2015 Digital Data Exchange, LLC (DDEX)</svrl:text>
         <svrl:text>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If you wish to evaluate whether the standard meets your needs please have a look at the Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards. If you want to implement and use this DDEX standard, please take out an Implementation Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</svrl:text>
         <svrl:text>Failing a rule with a role of 'Fatal Error' means that the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Fatal Error' is the same as a 'Fatal Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</svrl:text>
         <svrl:text>Failing a rule a rule with a role of 'Error' means that the Conformance Tester must recommend to award a Partial Conformance Certificate or to downgrade a Conformance Certificate that has already been issued. However, if more than 2 rules (representing 50% of all rules with a role of 'Error' or 'Conditional Error') have been failed at least once, the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error' is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has  no means of asserting whether the condition expressed in the rule has been met.</svrl:text>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustContainImage</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustContainImage</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M5"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustContainFrontCoverImageAsSecondaryResource</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustContainFrontCoverImageAsSecondaryResource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustContainImageResourceGroup</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustContainImageResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AudioAlbumMusicOnly_MustContainImageResourceGroup</xsl:attribute>
            <xsl:attribute name="name">AudioAlbumMusicOnly_MustContainImageResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoSingle_MustContainImageResourceGroup</xsl:attribute>
            <xsl:attribute name="name">VideoSingle_MustContainImageResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LongformVideo_MustContainImageResourceGroup</xsl:attribute>
            <xsl:attribute name="name">LongformVideo_MustContainImageResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MixedMediaBundle_MustContainImageResourceGroup</xsl:attribute>
            <xsl:attribute name="name">MixedMediaBundle_MustContainImageResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DigitalClassicalAudioAlbum_MustContainImageResourceGroup</xsl:attribute>
            <xsl:attribute name="name">DigitalClassicalAudioAlbum_MustContainImageResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AudioAlbumMusicAndSpeech_MustContainImageResourceGroup</xsl:attribute>
            <xsl:attribute name="name">AudioAlbumMusicAndSpeech_MustContainImageResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoAlbum_MustContainImageResourceGroup</xsl:attribute>
            <xsl:attribute name="name">VideoAlbum_MustContainImageResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoAlbum_MustContainVideoResourceGroup</xsl:attribute>
            <xsl:attribute name="name">VideoAlbum_MustContainVideoResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoSingle_MustContainVideoResourceGroup</xsl:attribute>
            <xsl:attribute name="name">VideoSingle_MustContainVideoResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LongformVideo_MustContainVideoResourceGroup</xsl:attribute>
            <xsl:attribute name="name">LongformVideo_MustContainVideoResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustContainSoundRecordingResourceGroup</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustContainSoundRecordingResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AudioAlbumMusicOnly_MustContainSoundRecordingResourceGroup</xsl:attribute>
            <xsl:attribute name="name">AudioAlbumMusicOnly_MustContainSoundRecordingResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DigitalClassicalAudioAlbum_MustContainSoundRecordingResourceGroup</xsl:attribute>
            <xsl:attribute name="name">DigitalClassicalAudioAlbum_MustContainSoundRecordingResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AudioAlbumMusicAndSpeech_MustContainSoundRecordingResourceGroup</xsl:attribute>
            <xsl:attribute name="name">AudioAlbumMusicAndSpeech_MustContainSoundRecordingResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_VideoMustHaveReferenceTitle</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_VideoMustHaveReferenceTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MidiRingtone_VideoMustHaveReferenceTitle</xsl:attribute>
            <xsl:attribute name="name">MidiRingtone_VideoMustHaveReferenceTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoSingle_MustContainOneVideo</xsl:attribute>
            <xsl:attribute name="name">VideoSingle_MustContainOneVideo</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoSingle_MustContainOneVideoScreenCaptureAsSecondaryResource</xsl:attribute>
            <xsl:attribute name="name">VideoSingle_MustContainOneVideoScreenCaptureAsSecondaryResource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoSingle_MustContainResourceGroupContentItemVideoScreenCapture</xsl:attribute>
            <xsl:attribute name="name">VideoSingle_MustContainResourceGroupContentItemVideoScreenCapture</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MixedMediaBundle_MustContainTrackComponentRelease</xsl:attribute>
            <xsl:attribute name="name">MixedMediaBundle_MustContainTrackComponentRelease</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MixedMediaBundle_MustContainVideoOrSoundRecordingResourceGroup</xsl:attribute>
            <xsl:attribute name="name">MixedMediaBundle_MustContainVideoOrSoundRecordingResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Ringtone_MustContainVideoOrSoundRecordingResourceGroup</xsl:attribute>
            <xsl:attribute name="name">Ringtone_MustContainVideoOrSoundRecordingResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MidiRingtone_PrimaryVideoMustHaveISRC</xsl:attribute>
            <xsl:attribute name="name">MidiRingtone_PrimaryVideoMustHaveISRC</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MidiRingtone_MustContainMidiResourceGroup</xsl:attribute>
            <xsl:attribute name="name">MidiRingtone_MustContainMidiResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DigitalClassicalAudioAlbum_MustContainOneImage</xsl:attribute>
            <xsl:attribute name="name">DigitalClassicalAudioAlbum_MustContainOneImage</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">SingleResourceRelease_MustHaveGridOrISRC</xsl:attribute>
            <xsl:attribute name="name">SingleResourceRelease_MustHaveGridOrISRC</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron Release Profile for Release Profile Deleted Rules (version 1.3.1) for the NewReleaseMessage.</svrl:text>

   <!--PATTERN MultiProfile_MustContainImage-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ResourceList" priority="1000" mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ResourceList"/>

		    <!--ASSERT Error-->
      <xsl:choose>
         <xsl:when test="Image"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="Image">
               <xsl:attribute name="role">Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: #Release Profile Deleted Rules) A Release of this type must contain at least one Image (Release Profile 1.3.1, Clause 16711, Rule 2230-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustContainFrontCoverImageAsSecondaryResource-->


	  <!--RULE -->
   <xsl:template match="//ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"
                 priority="1000"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>

		    <!--ASSERT Error-->
      <xsl:choose>
         <xsl:when test="//ResourceList/Image[ImageType/text() = 'FrontCoverImage' and ResourceReference=current()/ReleaseResourceReference]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="//ResourceList/Image[ImageType/text() = 'FrontCoverImage' and ResourceReference=current()/ReleaseResourceReference]">
               <xsl:attribute name="role">Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: #Release Profile Deleted Rules) A Release of this type must contain at least one Image of type FrontCoverImage as a secondary Resource (Release Profile 1.3.1, Clause 16712, Rule 2231-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustContainImageResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"
                 priority="1000"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) A Release of this type must contain at least one ResourceGroupContentItem of type Image, marked as a SecondaryResource (Release Profile 1.3.1, Clause 16713, Rule 2232-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

   <!--PATTERN AudioAlbumMusicOnly_MustContainImageResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"
                 priority="1000"
                 mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) An Album must contain at least one ResourceGroupContentItem of type Image, marked as a SecondaryResource (Release Profile 1.3.1, Clause 16714, Rule 2233-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>

   <!--PATTERN VideoSingle_MustContainImageResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoSingle']"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoSingle']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) A Single must contain at least one ResourceGroupContentItem of type Image, marked as a SecondaryResource (Release Profile 1.3.1, Clause 16715, Rule 2234-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>

   <!--PATTERN LongformVideo_MustContainImageResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Longform Video must contain at least one ResourceGroupContentItem of type Image, marked as a SecondaryResource (Release Profile 1.3.1, Clause 16716, Rule 2235-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>

   <!--PATTERN MixedMediaBundle_MustContainImageResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Bundle']"
                 priority="1000"
                 mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Bundle']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) A Mixed Media Bundle must contain at least one ResourceGroupContentItem of type Image, marked as a SecondaryResource (Release Profile 1.3.1, Clause 16717, Rule 2236-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>

   <!--PATTERN DigitalClassicalAudioAlbum_MustContainImageResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'ClassicalAlbum']"
                 priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'ClassicalAlbum']"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Classical Album must contain at least one ResourceGroupContentItem of type Image, marked as a SecondaryResource (Release Profile 1.3.1, Clause 16718, Rule 2237-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>

   <!--PATTERN AudioAlbumMusicAndSpeech_MustContainImageResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) An Album must contain at least one ResourceGroupContentItem of type Image, marked as a SecondaryResource (Release Profile 1.3.1, Clause 16719, Rule 2238-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>

   <!--PATTERN VideoAlbum_MustContainImageResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoAlbum']"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoAlbum']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Image' and ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) A Video Album must contain at least one ResourceGroupContentItem of type Image, marked as a SecondaryResource (Release Profile 1.3.1, Clause 16720, Rule 2239-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>

   <!--PATTERN VideoAlbum_MustContainVideoResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoAlbum']"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoAlbum']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Video' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Video' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) A Video Album must contain at least one ResourceGroupContentItem of type Video, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16721, Rule 2240-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>

   <!--PATTERN VideoSingle_MustContainVideoResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoSingle']"
                 priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoSingle']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Video' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Video' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) A Video Single must contain at least one ResourceGroupContentItem of type Video, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16722, Rule 2241-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>

   <!--PATTERN LongformVideo_MustContainVideoResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Video' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Video' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Longform Video must contain at least one ResourceGroupContentItem of type Video, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16723, Rule 2242-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustContainSoundRecordingResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'SoundRecording' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'SoundRecording' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) A Release of this type must contain at least one ResourceGroupContentItem of type SoundRecording, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16724, Rule 2243-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

   <!--PATTERN AudioAlbumMusicOnly_MustContainSoundRecordingResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"
                 priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'SoundRecording' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'SoundRecording' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) An Album must contain at least one ResourceGroupContentItem of type SoundRecording, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16725, Rule 2244-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>

   <!--PATTERN DigitalClassicalAudioAlbum_MustContainSoundRecordingResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'ClassicalAlbum']"
                 priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'ClassicalAlbum']"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'SoundRecording' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'SoundRecording' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Classical Album must contain at least one ResourceGroupContentItem of type SoundRecording, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16726, Rule 2245-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>

   <!--PATTERN AudioAlbumMusicAndSpeech_MustContainSoundRecordingResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"
                 priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Single'] | *:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'Album']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'SoundRecording' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'SoundRecording' and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) An Album must contain at least one ResourceGroupContentItem of type SoundRecording, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16727, Rule 2246-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

   <!--PATTERN MultiProfile_VideoMustHaveReferenceTitle-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ResourceList/Video"
                 priority="1000"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ResourceList/Video"/>

		    <!--ASSERT Error-->
      <xsl:choose>
         <xsl:when test="count(ReferenceTitle[string-length(normalize-space(TitleText)) &gt; 0]) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(ReferenceTitle[string-length(normalize-space(TitleText)) &gt; 0]) = 1">
               <xsl:attribute name="role">Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Error: #Release Profile Deleted Rules) A Single ReferenceTitle must be provided for each Video (Release Profile 1.3.1, Clause 16728, Rule 2247-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>

   <!--PATTERN MidiRingtone_VideoMustHaveReferenceTitle-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ResourceList/Video"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ResourceList/Video"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="count(ReferenceTitle[string-length(normalize-space(TitleText)) &gt; 0]) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(ReferenceTitle[string-length(normalize-space(TitleText)) &gt; 0]) = 1">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) A Single ReferenceTitle must be provided for each Video (Release Profile 1.3.1, Clause 16729, Rule 2248-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>

   <!--PATTERN VideoSingle_MustContainOneVideo-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ResourceList" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ResourceList"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="count(Video) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(Video) = 1">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Video Single must contain one (and only one) Video (Release Profile 1.3.1, Clause 16730, Rule 2249-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>

   <!--PATTERN VideoSingle_MustContainOneVideoScreenCaptureAsSecondaryResource-->


	  <!--RULE -->
   <xsl:template match="//ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="count(//ResourceList/Image[ImageType/text() = 'VideoScreenCapture' and ResourceReference=current()/ReleaseResourceReference]) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(//ResourceList/Image[ImageType/text() = 'VideoScreenCapture' and ResourceReference=current()/ReleaseResourceReference]) = 1">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Release of this type must contain exactly one Image of type VideoScreenCapture as a secondary Resource (Release Profile 1.3.1, Clause 16731, Rule 2250-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>

   <!--PATTERN VideoSingle_MustContainResourceGroupContentItemVideoScreenCapture-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoSingle']"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType = 'VideoSingle']"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[ResourceType = 'Video' and LinkedReleaseResourceReference[@LinkDescription = 'VideoScreenCapture']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[ResourceType = 'Video' and LinkedReleaseResourceReference[@LinkDescription = 'VideoScreenCapture']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) An Single must contain at least one ResourceGroupContentItem of type Video, marked as a VideoScreenCapture (Release Profile 1.3.1, Clause 16732, Rule 2251-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>

   <!--PATTERN MixedMediaBundle_MustContainTrackComponentRelease-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList" priority="1000" mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="Release/ReleaseType[text() = 'TrackRelease'] | Release/ReleaseType[text() = 'VideoTrackRelease']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="Release/ReleaseType[text() = 'TrackRelease'] | Release/ReleaseType[text() = 'VideoTrackRelease']">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Mixed Media Bundle must contain at least one component release (TrackRelease or VideoTrackRelease) (Release Profile 1.3.1, Clause 16733, Rule 2252-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>

   <!--PATTERN MixedMediaBundle_MustContainVideoOrSoundRecordingResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[(ResourceType = 'Video' or ResourceType = 'SoundRecording') and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[(ResourceType = 'Video' or ResourceType = 'SoundRecording') and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Mixed Media Bundle must contain at least one ResourceGroupContentItem of type Video or SoundRecording, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16734, Rule 2253-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>

   <!--PATTERN Ringtone_MustContainVideoOrSoundRecordingResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[(ResourceType = 'Video' or ResourceType = 'SoundRecording') and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[(ResourceType = 'Video' or ResourceType = 'SoundRecording') and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Ringtone must contain at least one ResourceGroupContentItem of type Video or SoundRecording, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16735, Rule 2254-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>

   <!--PATTERN MidiRingtone_PrimaryVideoMustHaveISRC-->


	  <!--RULE -->
   <xsl:template match="//ResourceGroupContentItem[ResourceType = 'Video']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceGroupContentItem[ResourceType = 'Video']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="//ResourceReference[text() = current()]/../*/ISRC[string-length(normalize-space(text())) &gt; 0]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="//ResourceReference[text() = current()]/../*/ISRC[string-length(normalize-space(text())) &gt; 0]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Release Profile Deleted Rules) Primary Video Resources should be identified with an ISRC (Release Profile 1.3.1, Clause 16736, Rule 2255-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

   <!--PATTERN MidiRingtone_MustContainMidiResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroupContentItem[(ResourceType = 'Midi') and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroupContentItem[(ResourceType = 'Midi') and ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Ringtone must contain at least one ResourceGroupContentItem of type Midi, marked as a PrimaryResource (Release Profile 1.3.1, Clause 16737, Rule 2256-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

   <!--PATTERN DigitalClassicalAudioAlbum_MustContainOneImage-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ResourceList" priority="1000" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ResourceList"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="count(Image) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(Image) = 1">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) A Release of this type must contain one (and only one) Image (Release Profile 1.3.1, Clause 16738, Rule 2257-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

   <!--PATTERN SingleResourceRelease_MustHaveGridOrISRC-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType != 'TrackRelease' and ReleaseType != 'VideoTrackRelease']"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType != 'TrackRelease' and ReleaseType != 'VideoTrackRelease']"/>

		    <!--ASSERT Draft-->
      <xsl:choose>
         <xsl:when test="ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | ReleaseId/ISRC[string-length(normalize-space(text())) &gt; 0]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | ReleaseId/ISRC[string-length(normalize-space(text())) &gt; 0]">
               <xsl:attribute name="role">Draft</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Draft: #Release Profile Deleted Rules) The Release shall be identified by either a GRid or by an ISRC (Release Profile 1.3.1, Clause 16739, Rule 2258-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
</xsl:stylesheet>
