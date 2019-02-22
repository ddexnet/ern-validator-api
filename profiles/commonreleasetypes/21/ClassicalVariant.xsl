<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
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
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
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
                              title="Schematron Release Profile for Classical Variant (version 2.1) for the NewReleaseMessage."
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:text>© 2006-2018 Digital Data Exchange, LLC (DDEX)</svrl:text>
         <svrl:text>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If you wish to evaluate whether the standard meets your needs please have a look at the Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards. If you want to implement and use this DDEX standard, please take out an Implementation Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</svrl:text>
         <svrl:text>Failing a rule with a role of 'Fatal Error' means that the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Fatal Error' is the same as a 'Fatal Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</svrl:text>
         <svrl:text>Failing a rule a rule with a role of 'Error' means that the Conformance Tester must recommend to award a Partial Conformance Certificate or to downgrade a Conformance Certificate that has already been issued. However, if more than 1 rules (representing 50% of all rules with a role of 'Error') have been failed at least once, the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error' is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</svrl:text>
         <svrl:text>The following Clauses from the Release Profile standard are NOT checked by this ISO Schematron file: 5.1.1 (partly), 5.3.1.1(1-3, 7.1, 7.3, 9), 5.3.1.2(2.1, 3-4, 5.1), 5.3.1.3(4-5), 5.3.1.4(3-5, 8), 5.3.3.1-2, 5.3.3.4, 5.4.1(4.1), 5.4.3(5), 5.4.4(3, 5), 5.5.1(2), 5.5.2(2.4, 3.5-3.7), 5.6(1, 3). This file also does not check any rules specified in the ERN Message Suite Standard (Version 4.1) specifications, sections 6.4 and 6.5, except for 6.4.8-10</svrl:text>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_ReleaseProfileVariantVersionId</xsl:attribute>
            <xsl:attribute name="name">Classical_ReleaseProfileVariantVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_ResourceGroupType</xsl:attribute>
            <xsl:attribute name="name">Classical_ResourceGroupType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_MustContainMusicalWorkSoundRecording</xsl:attribute>
            <xsl:attribute name="name">Classical_MustContainMusicalWorkSoundRecording</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_MustContainResourceGroup</xsl:attribute>
            <xsl:attribute name="name">Classical_MustContainResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_MustContainResourceGroupContentItems</xsl:attribute>
            <xsl:attribute name="name">Classical_MustContainResourceGroupContentItems</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_ResourceGroupsMustBeNested</xsl:attribute>
            <xsl:attribute name="name">Classical_ResourceGroupsMustBeNested</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_MustContainFormalTitle</xsl:attribute>
            <xsl:attribute name="name">Classical_MustContainFormalTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_MayContainGroupingTitle</xsl:attribute>
            <xsl:attribute name="name">Classical_MayContainGroupingTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_MustContainDisplayTitle</xsl:attribute>
            <xsl:attribute name="name">Classical_MustContainDisplayTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Classical_MayContainFormalTitle</xsl:attribute>
            <xsl:attribute name="name">Classical_MayContainFormalTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron Release Profile for Classical Variant (version 2.1) for the NewReleaseMessage.</svrl:text>

   <!--PATTERN Classical_ReleaseProfileVariantVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVariantVersionId = 'Classical' or @ReleaseProfileVariantVersionId = 'BoxedSet Classical' or @ReleaseProfileVariantVersionId = 'Classical BoxedSet'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVariantVersionId = 'Classical' or @ReleaseProfileVariantVersionId = 'BoxedSet Classical' or @ReleaseProfileVariantVersionId = 'Classical BoxedSet'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error (Classical Variant): The ReleaseProfileVariantVersionId should conform to clause 5.2.2 (Release Profile 2.1, Clause 5.2.2, Rule 1547-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

   <!--PATTERN Classical_ResourceGroupType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[@ReleaseProfileVariantVersionId = 'Classical']/ReleaseList/Release/ResourceGroup/ResourceGroup"
                 priority="1000"
                 mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[@ReleaseProfileVariantVersionId = 'Classical']/ReleaseList/Release/ResourceGroup/ResourceGroup"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ResourceGroupType = 'Component' or @ResourceGroupType = 'Side' or @ResourceGroupType = 'MultiWorkPart'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ResourceGroupType = 'Component' or @ResourceGroupType = 'Side' or @ResourceGroupType = 'MultiWorkPart'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error (Classical Variant): For a Release of this type, second-level ResourceGroups shall have a ResourceGroupType of either Side, Component or MultiWorkPart (Release Profile 2.1, Clause 5.3.1.2(5.2), Rule 1548-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

   <!--PATTERN Classical_MustContainMusicalWorkSoundRecording-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ResourceList" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ResourceList"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="SoundRecording/Type[text() = 'MusicalWorkSoundRecording']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="SoundRecording/Type[text() = 'MusicalWorkSoundRecording']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error (Classical Variant): A Release of this type must contain SoundRecordings of type MusicalWorkSoundRecording (Release Profile 2.1, Clause 5.5.2(1), Rule 1549-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

   <!--PATTERN Classical_MustContainResourceGroup-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ReleaseList/Release"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ReleaseList/Release"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="descendant::ResourceGroup[@ResourceGroupType='MultiWorkPart']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::ResourceGroup[@ResourceGroupType='MultiWorkPart']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error (Classical Variant): A Release of this type must contain at least one ResourceGroup of type MultiWorkPart (Release Profile 2.1, Clause 5.5.2(2.1), Rule 1550-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN Classical_MustContainResourceGroupContentItems-->


	  <!--RULE -->
   <xsl:template match="//ResourceGroup[@ResourceGroupType='MultiWorkPart']"
                 priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceGroup[@ResourceGroupType='MultiWorkPart']"/>

		    <!--ASSERT Conditional Fatal Error-->
      <xsl:choose>
         <xsl:when test="count(ResourceGroupContentItem) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(ResourceGroupContentItem) &gt; 1">
               <xsl:attribute name="role">Conditional Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Conditional Fatal Error (Classical Variant): A Release of this type must contain at least two ResourceGroupContentItems in each ResourceGroup of type MultiWorkPart (Release Profile 2.1, Clause 5.5.2(2.2), Rule 1551-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN Classical_ResourceGroupsMustBeNested-->


	  <!--RULE -->
   <xsl:template match="//ResourceGroup" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//ResourceGroup"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="ResourceGroup[@ResourceGroupType='MultiWorkPart'] and ResourceGroup[@ResourceGroupType!='MultiWorkPart']">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="ResourceGroup[@ResourceGroupType='MultiWorkPart'] and ResourceGroup[@ResourceGroupType!='MultiWorkPart']">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error (Classical Variant):  (Release Profile 2.1, Clause 5.5.2(2.5), Rule 1552-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN Classical_MustContainFormalTitle-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ResourceList/*[ResourceReference = //ResourceGroup[ResourceGroupType='MultiWorkPart']/ResourceGroupContentItem/ReleaseResourceReference]"
                 priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ResourceList/*[ResourceReference = //ResourceGroup[ResourceGroupType='MultiWorkPart']/ResourceGroupContentItem/ReleaseResourceReference]"/>

		    <!--ASSERT Warning-->
      <xsl:choose>
         <xsl:when test="AdditionalTitle[@TitleType='FormalTitle']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="AdditionalTitle[@TitleType='FormalTitle']">
               <xsl:attribute name="role">Warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Warning (Classical Variant): A Resource in a Release of this type must contain an AdditionalTitle of type FormalTitle (Release Profile 2.1, Clause 5.5.2(3.1), Rule 1553-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN Classical_MayContainGroupingTitle-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/ResourceList/*[ResourceReference = //ResourceGroup[ResourceGroupType='MultiWorkPart']/ResourceGroupContentItem/ReleaseResourceReference]"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/ResourceList/*[ResourceReference = //ResourceGroup[ResourceGroupType='MultiWorkPart']/ResourceGroupContentItem/ReleaseResourceReference]"/>

		    <!--ASSERT Warning-->
      <xsl:choose>
         <xsl:when test="AdditionalTitle[@TitleType='GroupingTitle']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="AdditionalTitle[@TitleType='GroupingTitle']">
               <xsl:attribute name="role">Warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Warning (Classical Variant): A Resource in a Release of this type may contain an AdditionalTitle of type GroupingTitle (Release Profile 2.1, Clause 5.5.2(3.2), Rule 1554-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN Classical_MustContainDisplayTitle-->


	  <!--RULE -->
   <xsl:template match="//ResourceGroup[ResourceGroupType='MultiWorkPart' and count(ResourceGroupContentItem) &gt; 1]"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceGroup[ResourceGroupType='MultiWorkPart' and count(ResourceGroupContentItem) &gt; 1]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DisplayTitle or DisplayTitleText"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DisplayTitle or DisplayTitleText">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error (Classical Variant): A ResourceGroup in a Release of this type must contain a DisplayTitle and/or a DisplayTitleText (Release Profile 2.1, Clause 5.5.2(3.3), Rule 1555-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN Classical_MayContainFormalTitle-->


	  <!--RULE -->
   <xsl:template match="//ResourceGroup[ResourceGroupType='MultiWorkPart' and count(ResourceGroupContentItem) &gt; 1]"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceGroup[ResourceGroupType='MultiWorkPart' and count(ResourceGroupContentItem) &gt; 1]"/>

		    <!--ASSERT Warning-->
      <xsl:choose>
         <xsl:when test="AdditionalTitle[@TitleType='FormalTitle']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="AdditionalTitle[@TitleType='FormalTitle']">
               <xsl:attribute name="role">Warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Warning (Classical Variant): A ResourceGroup in a Release of this type shall contain an AdditionalTitle of type FormalTitle (Release Profile 2.1, Clause 5.5.2(3.4), Rule 1556-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
</xsl:stylesheet>
