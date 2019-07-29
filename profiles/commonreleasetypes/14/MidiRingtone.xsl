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
                              title="Schematron Release Profile for Midi Ringtone (version 1.4) for the&#xA;      NewReleaseMessage."
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:text>© 2006-2017 Digital Data Exchange, LLC (DDEX)</svrl:text>
         <svrl:text>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If
      you wish to evaluate whether the standard meets your needs please have a look at the
      Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards.
      If you want to implement and use this DDEX standard, please take out an Implementation
      Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</svrl:text>
         <svrl:text>Failing a rule with a role of 'Fatal Error' means that the Conformance Tester must recommend
      to not award a Conformance Certificate or to retract a Conformance Certificate if one has
      already been issued. Failing a rule with a role of 'Conditional Fatal Error' is the same as a
      'Fatal Error', however, the rule may be ignored if the Conformance Tester has no means of
      asserting whether the condition expressed in the rule has been met.</svrl:text>
         <svrl:text>Failing a rule a rule with a role of 'Error' means that the Conformance Tester must
      recommend to award a Partial Conformance Certificate or to downgrade a Conformance Certificate
      that has already been issued. However, if more than 1 rules (representing 50% of all rules
      with a role of 'Error' or 'Conditional Error') have been failed at least once, the Conformance
      Tester must recommend to not award a Conformance Certificate or to retract a Conformance
      Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error'
      is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no
      means of asserting whether the condition expressed in the rule has been met.</svrl:text>
         <svrl:text>The following Clauses from the Release Profile standard are NOT checked by this ISO
      Schematron file: 3.3.1(1), 3.3.1(7)-(8), 3.4, 4.1, 4.2, 4.3(11), 4.3(14), 4.3(15a), 4.3(16b),
      4.3(17), 4.3(19), 4.3(27)-(29), 4.3(37), 4.16(11)-(12), 4.7(11)-(12), 4.8(8), 4.8(9d),
      4.8(10f), 4.8(11)-(12), 4.10(9) and similar clauses, 4.10(10) and similar clauses, 4.14(8) and
      4.15(11).</svrl:text>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Ringtone_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">Ringtone_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_TrackReleaseMustNotContainManyResources</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_TrackReleaseMustNotContainManyResources</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MidiRingtone_MustContainRingtoneComponentRelease</xsl:attribute>
            <xsl:attribute name="name">MidiRingtone_MustContainRingtoneComponentRelease</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_DisplayArtistMustBeProvided</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_DisplayArtistMustBeProvided</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_DisplayArtistNamesMustBeDifferent</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_DisplayArtistNamesMustBeDifferent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MainReleaseMustHaveGridOrICPN</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MainReleaseMustHaveGridOrICPN</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Ringtone_MustContainReleaseFromRelease</xsl:attribute>
            <xsl:attribute name="name">Ringtone_MustContainReleaseFromRelease</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_SoundRecordingMustNotHaveDeprecatedFlags</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_SoundRecordingMustNotHaveDeprecatedFlags</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_LabelNameMustBeProvided2</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_LabelNameMustBeProvided2</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron Release Profile for Midi Ringtone (version 1.4) for the
      NewReleaseMessage.</svrl:text>

   <!--PATTERN Ringtone_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/Ringtone'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/Ringtone'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Midi Ringtone) The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/Ringtone' (Release Profile 1.4, Clause 3.2, Rule
            1364-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

   <!--PATTERN MultiProfile_TrackReleaseMustNotContainManyResources-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release[ReleaseType[text() = 'TrackRelease']]/ReleaseResourceReferenceList"
                 priority="1000"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType[text() = 'TrackRelease']]/ReleaseResourceReferenceList"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="count(ReleaseResourceReference) &gt; 1">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(ReleaseResourceReference) &gt; 1">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error:
            #Midi Ringtone) A Track Release must not contain more than one Resource (Release Profile
            1.4, Clause 3.1, Rule 1365-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

   <!--PATTERN MidiRingtone_MustContainRingtoneComponentRelease-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="Release/ReleaseType[text() = 'RingtoneRelease'] | Release/ReleaseType[text() = 'RingbackToneRelease']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="Release/ReleaseType[text() = 'RingtoneRelease'] | Release/ReleaseType[text() = 'RingbackToneRelease']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Midi Ringtone) A Ringtone must contain one
            RingtoneRelease or RingbackToneRelease (Release Profile 1.4, Clause 3.1, Rule
            1366-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

   <!--PATTERN MultiProfile_DisplayArtistMustBeProvided-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="ReleaseDetailsByTerritory/DisplayArtist"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ReleaseDetailsByTerritory/DisplayArtist">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error:
            #Midi Ringtone) At least one DisplayArtist shall be provided (Release Profile 1.4,
            Clause 4.3(12c)+4.3(15b), Rule 1367-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN MultiProfile_DisplayArtistNamesMustBeDifferent-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--REPORT Error-->
      <xsl:if test="ReleaseDetailsByTerritory/DisplayArtistName = ReleaseResourceReferenceList/descendant::DisplayArtistName">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="ReleaseDetailsByTerritory/DisplayArtistName = ReleaseResourceReferenceList/descendant::DisplayArtistName">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: #Midi Ringtone) DisplayArtistNames for Release and Resource must be
            different (Release Profile 1.4, Clause 4.3(16a), Rule 1368-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MainReleaseMustHaveGridOrICPN-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="Release[@IsMainRelease = 'true']/ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | Release[@IsMainRelease = 'true']/ReleaseId/ICPN[string-length(normalize-space(text())) &gt; 0]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="Release[@IsMainRelease = 'true']/ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | Release[@IsMainRelease = 'true']/ReleaseId/ICPN[string-length(normalize-space(text())) &gt; 0]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Midi Ringtone) The MainRelease shall be identified by
            either a GRid or by an ICPN (Release Profile 1.4, Clause 4.9(4), Rule
            1369-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN Ringtone_MustContainReleaseFromRelease-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::RelatedRelease[ReleaseRelationshipType = 'IsReleaseFromRelease']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::RelatedRelease[ReleaseRelationshipType = 'IsReleaseFromRelease']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Midi Ringtone) A Ringtone must contain a RelatedRelease
            of type IsReleaseFromRelease (Release Profile 1.4, Clause 4.9(9), Rule
            1372-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN MultiProfile_SoundRecordingMustNotHaveDeprecatedFlags-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ResourceList/SoundRecording"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ResourceList/SoundRecording"/>

		    <!--REPORT Information-->
      <xsl:if test="IsHiddenResource">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="IsHiddenResource">
            <xsl:attribute name="role">Information</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Information: #Midi Ringtone) No
            deprecated Flags (IsHiddenResource) must be provided for SoundRecordings (Release
            Profile 1.4, Clause 4.10(7h), Rule 1373-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Information-->
      <xsl:if test="IsBonusResource">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="IsBonusResource">
            <xsl:attribute name="role">Information</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Information: #Midi Ringtone) No
            deprecated Flags (IsBonusResource) must be provided for SoundRecordings (Release Profile
            1.4, Clause 4.10(7h), Rule 1373-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN MultiProfile_LabelNameMustBeProvided2-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="ReleaseDetailsByTerritory/LabelName"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ReleaseDetailsByTerritory/LabelName">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: #Midi
            Ringtone) A LabelName has to be specified for each Release (Release Profile 1.4,
            Clause 4.13(8), Rule 1374-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
</xsl:stylesheet>
