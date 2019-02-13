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
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:text>© 2006-2018 Digital Data Exchange, LLC (DDEX)</svrl:text>
         <svrl:text>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If you wish to evaluate whether the standard meets your needs please have a look at the Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards. If you want to implement and use this DDEX standard, please take out an Implementation Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</svrl:text>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ReleaseProfileVersionId_NewReleaseMessage</xsl:attribute>
            <xsl:attribute name="name">ReleaseProfileVersionId_NewReleaseMessage</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M2"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ReleaseProfileVariantVersionId_NewReleaseMessage</xsl:attribute>
            <xsl:attribute name="name">ReleaseProfileVariantVersionId_NewReleaseMessage</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M3"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AvsVersionId_NewReleaseMessage</xsl:attribute>
            <xsl:attribute name="name">AvsVersionId_NewReleaseMessage</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M4"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AvsVersionId_PurgeReleaseMessage</xsl:attribute>
            <xsl:attribute name="name">AvsVersionId_PurgeReleaseMessage</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M5"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_AdditionalTitle</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_AdditionalTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TitleType_AdditionalTitle</xsl:attribute>
            <xsl:attribute name="name">TitleType_AdditionalTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Reason_AvRating</xsl:attribute>
            <xsl:attribute name="name">Reason_AvRating</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_AvRating</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_AvRating</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_CLineWithDefault</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_CLineWithDefault</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_CourtesyLineWithDefault</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_CourtesyLineWithDefault</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoDefinitionType_DealTermsTechnicalInstantiation</xsl:attribute>
            <xsl:attribute name="name">VideoDefinitionType_DealTermsTechnicalInstantiation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CodingType_DealTermsTechnicalInstantiation</xsl:attribute>
            <xsl:attribute name="name">CodingType_DealTermsTechnicalInstantiation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_Deity</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_Deity</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_DescriptionWithTerritory</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_DescriptionWithTerritory</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">SubTitleType_DisplaySubTitle</xsl:attribute>
            <xsl:attribute name="name">SubTitleType_DisplaySubTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_DisplayTitle</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_DisplayTitle</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_DisplayTitleText</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_DisplayTitleText</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_EventDateTimeWithoutFlags</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_EventDateTimeWithoutFlags</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_EventDateWithDefault</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_EventDateWithDefault</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_EventDateWithoutFlags</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_EventDateWithoutFlags</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DataType_Fingerprint</xsl:attribute>
            <xsl:attribute name="name">DataType_Fingerprint</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_PartyNameWithTerritory</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_PartyNameWithTerritory</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ExpressionType_PreviewDetails</xsl:attribute>
            <xsl:attribute name="name">ExpressionType_PreviewDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PriceType_PriceInformationWithType</xsl:attribute>
            <xsl:attribute name="name">PriceType_PriceInformationWithType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_Raga</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_Raga</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ResourceRelationshipType_RelatedResource</xsl:attribute>
            <xsl:attribute name="name">ResourceRelationshipType_RelatedResource</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LabelType_ReleaseLabelReference</xsl:attribute>
            <xsl:attribute name="name">LabelType_ReleaseLabelReference</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_ReleaseLabelReference</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_ReleaseLabelReference</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsControllerRole_ResourceRightsController</xsl:attribute>
            <xsl:attribute name="name">RightsControllerRole_ResourceRightsController</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ResourceGroupType_ResourceSubGroup</xsl:attribute>
            <xsl:attribute name="name">ResourceGroupType_ResourceSubGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LanguageOfLyrics_SheetMusic</xsl:attribute>
            <xsl:attribute name="name">LanguageOfLyrics_SheetMusic</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CompositeMusicalWorkType_SoundRecording</xsl:attribute>
            <xsl:attribute name="name">CompositeMusicalWorkType_SoundRecording</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LanguageOfPerformance_SoundRecording</xsl:attribute>
            <xsl:attribute name="name">LanguageOfPerformance_SoundRecording</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AudioChannelConfiguration_SoundRecording</xsl:attribute>
            <xsl:attribute name="name">AudioChannelConfiguration_SoundRecording</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ExpressionType_SoundRecordingPreviewDetails</xsl:attribute>
            <xsl:attribute name="name">ExpressionType_SoundRecordingPreviewDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_SynopsisWithTerritory</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_SynopsisWithTerritory</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_Tala</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_Tala</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_TechnicalImageDetails</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_TechnicalImageDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_TechnicalSheetMusicDetails</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_TechnicalSheetMusicDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_TechnicalSoftwareDetails</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_TechnicalSoftwareDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_TechnicalSoundRecordingDetails</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_TechnicalSoundRecordingDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_TechnicalTextDetails</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_TechnicalTextDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoDefinitionType_TechnicalVideoDetails</xsl:attribute>
            <xsl:attribute name="name">VideoDefinitionType_TechnicalVideoDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_TechnicalVideoDetails</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_TechnicalVideoDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TitleType_Title</xsl:attribute>
            <xsl:attribute name="name">TitleType_Title</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CompositeMusicalWorkType_Video</xsl:attribute>
            <xsl:attribute name="name">CompositeMusicalWorkType_Video</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LanguageOfPerformance_Video</xsl:attribute>
            <xsl:attribute name="name">LanguageOfPerformance_Video</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LanguageOfDubbing_Video</xsl:attribute>
            <xsl:attribute name="name">LanguageOfDubbing_Video</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">SubTitleLanguage_Video</xsl:attribute>
            <xsl:attribute name="name">SubTitleLanguage_Video</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsControllerRole_WorkRightsController</xsl:attribute>
            <xsl:attribute name="name">RightsControllerRole_WorkRightsController</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsControllerType_WorkRightsController</xsl:attribute>
            <xsl:attribute name="name">RightsControllerType_WorkRightsController</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Type_Affiliation</xsl:attribute>
            <xsl:attribute name="name">Type_Affiliation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IdentifierType_AllTerritoryCode</xsl:attribute>
            <xsl:attribute name="name">IdentifierType_AllTerritoryCode</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AspectRatioType_AspectRatio</xsl:attribute>
            <xsl:attribute name="name">AspectRatioType_AspectRatio</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UnitOfMeasure_BitRate</xsl:attribute>
            <xsl:attribute name="name">UnitOfMeasure_BitRate</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Unit_ConditionForRightsClaimPolicy</xsl:attribute>
            <xsl:attribute name="name">Unit_ConditionForRightsClaimPolicy</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ReferenceCreation_ConditionForRightsClaimPolicy</xsl:attribute>
            <xsl:attribute name="name">ReferenceCreation_ConditionForRightsClaimPolicy</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RelationalRelator_ConditionForRightsClaimPolicy</xsl:attribute>
            <xsl:attribute name="name">RelationalRelator_ConditionForRightsClaimPolicy</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">IdentifierType_CurrentTerritoryCode</xsl:attribute>
            <xsl:attribute name="name">IdentifierType_CurrentTerritoryCode</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DataType_DetailedHashSum</xsl:attribute>
            <xsl:attribute name="name">DataType_DetailedHashSum</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_DisplayArtistNameWithDefault</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_DisplayArtistNameWithDefault</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_DisplayCredits</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_DisplayCredits</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_EventDate</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_EventDate</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TerritoryCode_EventDateTime</xsl:attribute>
            <xsl:attribute name="name">TerritoryCode_EventDateTime</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UnitOfMeasure_Extent</xsl:attribute>
            <xsl:attribute name="name">UnitOfMeasure_Extent</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_FirstPublicationDate</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_FirstPublicationDate</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UnitOfMeasure_FrameRate</xsl:attribute>
            <xsl:attribute name="name">UnitOfMeasure_FrameRate</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_FulfillmentDateWithTerritory</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_FulfillmentDateWithTerritory</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_GenreWithTerritory</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_GenreWithTerritory</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_KeywordsWithTerritory</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_KeywordsWithTerritory</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">LinkDescription_LinkedReleaseResourceReference</xsl:attribute>
            <xsl:attribute name="name">LinkDescription_LinkedReleaseResourceReference</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_MarketingComment</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_MarketingComment</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MessageControlType_MessageHeader</xsl:attribute>
            <xsl:attribute name="name">MessageControlType_MessageHeader</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M74"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PLineType_PLine</xsl:attribute>
            <xsl:attribute name="name">PLineType_PLine</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M75"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_PLineWithDefault</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_PLineWithDefault</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M76"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ApplicableTerritoryCode_ParentalWarningTypeWithTerritory</xsl:attribute>
            <xsl:attribute name="name">ApplicableTerritoryCode_ParentalWarningTypeWithTerritory</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M77"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CurrencyCode_Price</xsl:attribute>
            <xsl:attribute name="name">CurrencyCode_Price</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M78"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimPolicyType_RightsClaimPolicy</xsl:attribute>
            <xsl:attribute name="name">RightsClaimPolicyType_RightsClaimPolicy</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M79"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UnitOfMeasure_SamplingRate</xsl:attribute>
            <xsl:attribute name="name">UnitOfMeasure_SamplingRate</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M80"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UseType_DealTerms</xsl:attribute>
            <xsl:attribute name="name">UseType_DealTerms</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M81"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Role_AdministratingRecordCompanyWithReference</xsl:attribute>
            <xsl:attribute name="name">Role_AdministratingRecordCompanyWithReference</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M82"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Territory_WorkRightsController</xsl:attribute>
            <xsl:attribute name="name">Territory_WorkRightsController</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M83"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AudioCodecType_TechnicalSoundRecordingDetails</xsl:attribute>
            <xsl:attribute name="name">AudioCodecType_TechnicalSoundRecordingDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M84"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AudioCodecType_TechnicalVideoDetails</xsl:attribute>
            <xsl:attribute name="name">AudioCodecType_TechnicalVideoDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M85"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CarrierType_DealTerms</xsl:attribute>
            <xsl:attribute name="name">CarrierType_DealTerms</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M86"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CarrierType_ResourceGroup</xsl:attribute>
            <xsl:attribute name="name">CarrierType_ResourceGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M87"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CarrierType_ResourceSubGroup</xsl:attribute>
            <xsl:attribute name="name">CarrierType_ResourceSubGroup</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M88"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CommercialModelType_DealTerms</xsl:attribute>
            <xsl:attribute name="name">CommercialModelType_DealTerms</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M89"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ContainerFormat_TechnicalVideoDetails</xsl:attribute>
            <xsl:attribute name="name">ContainerFormat_TechnicalVideoDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M90"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Role_Contributor</xsl:attribute>
            <xsl:attribute name="name">Role_Contributor</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M91"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Role_DetailedResourceContributor</xsl:attribute>
            <xsl:attribute name="name">Role_DetailedResourceContributor</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M92"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ArtisticRole_DisplayArtist</xsl:attribute>
            <xsl:attribute name="name">ArtisticRole_DisplayArtist</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M93"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CueOrigin_DetailedCue</xsl:attribute>
            <xsl:attribute name="name">CueOrigin_DetailedCue</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M94"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CueSheetType_DetailedCueSheet</xsl:attribute>
            <xsl:attribute name="name">CueSheetType_DetailedCueSheet</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M95"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CueThemeType_DetailedCue</xsl:attribute>
            <xsl:attribute name="name">CueThemeType_DetailedCue</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M96"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CueUseType_DetailedCue</xsl:attribute>
            <xsl:attribute name="name">CueUseType_DetailedCue</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M97"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CueVisualPerceptionType_DetailedCue</xsl:attribute>
            <xsl:attribute name="name">CueVisualPerceptionType_DetailedCue</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M98"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">CueVocalType_DetailedCue</xsl:attribute>
            <xsl:attribute name="name">CueVocalType_DetailedCue</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M99"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TerritoryCode_DealTerms</xsl:attribute>
            <xsl:attribute name="name">TerritoryCode_DealTerms</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M100"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ExcludedTerritoryCode_DealTerms</xsl:attribute>
            <xsl:attribute name="name">ExcludedTerritoryCode_DealTerms</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M101"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TerritoryOfRightsDelegation_DelegatedUsageRights</xsl:attribute>
            <xsl:attribute name="name">TerritoryOfRightsDelegation_DelegatedUsageRights</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M102"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TerritoryCode_Affiliation</xsl:attribute>
            <xsl:attribute name="name">TerritoryCode_Affiliation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M103"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ExcludedTerritoryCode_Affiliation</xsl:attribute>
            <xsl:attribute name="name">ExcludedTerritoryCode_Affiliation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M104"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DisplayArtistRole_DisplayArtist</xsl:attribute>
            <xsl:attribute name="name">DisplayArtistRole_DisplayArtist</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M105"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ExternallyLinkedResourceType_ExternalResourceLink</xsl:attribute>
            <xsl:attribute name="name">ExternallyLinkedResourceType_ExternalResourceLink</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M106"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Algorithm_Fingerprint</xsl:attribute>
            <xsl:attribute name="name">Algorithm_Fingerprint</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M107"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Algorithm_DetailedHashSum</xsl:attribute>
            <xsl:attribute name="name">Algorithm_DetailedHashSum</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M108"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ImageCodecType_TechnicalImageDetails</xsl:attribute>
            <xsl:attribute name="name">ImageCodecType_TechnicalImageDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M109"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Type_Image</xsl:attribute>
            <xsl:attribute name="name">Type_Image</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M110"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InstrumentType_Contributor</xsl:attribute>
            <xsl:attribute name="name">InstrumentType_Contributor</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M111"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InstrumentType_DetailedResourceContributor</xsl:attribute>
            <xsl:attribute name="name">InstrumentType_DetailedResourceContributor</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M112"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">OperatingSystemType_TechnicalSoftwareDetails</xsl:attribute>
            <xsl:attribute name="name">OperatingSystemType_TechnicalSoftwareDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M113"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ParentalWarningType_Image</xsl:attribute>
            <xsl:attribute name="name">ParentalWarningType_Image</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M114"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ParentalWarningType_Release</xsl:attribute>
            <xsl:attribute name="name">ParentalWarningType_Release</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M115"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ParentalWarningType_SheetMusic</xsl:attribute>
            <xsl:attribute name="name">ParentalWarningType_SheetMusic</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M116"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ParentalWarningType_Software</xsl:attribute>
            <xsl:attribute name="name">ParentalWarningType_Software</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M117"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ParentalWarningType_SoundRecording</xsl:attribute>
            <xsl:attribute name="name">ParentalWarningType_SoundRecording</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M118"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ParentalWarningType_Text</xsl:attribute>
            <xsl:attribute name="name">ParentalWarningType_Text</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M119"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ParentalWarningType_Video</xsl:attribute>
            <xsl:attribute name="name">ParentalWarningType_Video</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M120"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PartyRelationshipType_RelatedParty</xsl:attribute>
            <xsl:attribute name="name">PartyRelationshipType_RelatedParty</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M121"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PriceCode_PriceInformationWithType</xsl:attribute>
            <xsl:attribute name="name">PriceCode_PriceInformationWithType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M122"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Purpose_ResourceContainedResourceReference</xsl:attribute>
            <xsl:attribute name="name">Purpose_ResourceContainedResourceReference</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M123"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Agency_AvRating</xsl:attribute>
            <xsl:attribute name="name">Agency_AvRating</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M124"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ReleaseRelationshipType_RelatedRelease</xsl:attribute>
            <xsl:attribute name="name">ReleaseRelationshipType_RelatedRelease</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M125"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">ReleaseType_Release</xsl:attribute>
            <xsl:attribute name="name">ReleaseType_Release</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M126"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">SheetMusicCodecType_TechnicalSheetMusicDetails</xsl:attribute>
            <xsl:attribute name="name">SheetMusicCodecType_TechnicalSheetMusicDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M127"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Type_SheetMusic</xsl:attribute>
            <xsl:attribute name="name">Type_SheetMusic</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M128"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsType_Affiliation</xsl:attribute>
            <xsl:attribute name="name">RightsType_Affiliation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M129"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Type_Software</xsl:attribute>
            <xsl:attribute name="name">Type_Software</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M130"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Type_SoundRecording</xsl:attribute>
            <xsl:attribute name="name">Type_SoundRecording</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M131"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TextCodecType_TechnicalTextDetails</xsl:attribute>
            <xsl:attribute name="name">TextCodecType_TechnicalTextDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M132"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Type_Text</xsl:attribute>
            <xsl:attribute name="name">Type_Text</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M133"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">UseType_DelegatedUsageRights</xsl:attribute>
            <xsl:attribute name="name">UseType_DelegatedUsageRights</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M134"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VersionType_Image</xsl:attribute>
            <xsl:attribute name="name">VersionType_Image</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M135"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VersionType_SheetMusic</xsl:attribute>
            <xsl:attribute name="name">VersionType_SheetMusic</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M136"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VersionType_Software</xsl:attribute>
            <xsl:attribute name="name">VersionType_Software</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M137"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VersionType_SoundRecording</xsl:attribute>
            <xsl:attribute name="name">VersionType_SoundRecording</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M138"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VersionType_Text</xsl:attribute>
            <xsl:attribute name="name">VersionType_Text</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M139"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VersionType_Video</xsl:attribute>
            <xsl:attribute name="name">VersionType_Video</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M140"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">VideoCodecType_TechnicalVideoDetails</xsl:attribute>
            <xsl:attribute name="name">VideoCodecType_TechnicalVideoDetails</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M141"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Type_Video</xsl:attribute>
            <xsl:attribute name="name">Type_Video</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M142"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


   <!--PATTERN ReleaseProfileVersionId_NewReleaseMessage-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[@ReleaseProfileVersionId]"
                 priority="1000"
                 mode="M2">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[@ReleaseProfileVersionId]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVersionId']/xs:restriction/xs:enumeration[@value=current()/@ReleaseProfileVersionId]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVersionId']/xs:restriction/xs:enumeration[@value=current()/@ReleaseProfileVersionId]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should conform to the allowed value set ReleaseProfileVersionId. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVersionId']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M2"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M2"/>
   <xsl:template match="@*|node()" priority="-2" mode="M2">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M2"/>
   </xsl:template>

   <!--PATTERN ReleaseProfileVariantVersionId_NewReleaseMessage-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[@ReleaseProfileVariantVersionId]"
                 priority="1000"
                 mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[@ReleaseProfileVariantVersionId]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVariantVersionId']/xs:restriction/xs:enumeration[@value=current()/@ReleaseProfileVariantVersionId]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVariantVersionId']/xs:restriction/xs:enumeration[@value=current()/@ReleaseProfileVariantVersionId]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVariantVersionId should conform to the allowed value set ReleaseProfileVariantVersionId. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVariantVersionId']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M3"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M3"/>
   <xsl:template match="@*|node()" priority="-2" mode="M3">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M3"/>
   </xsl:template>

   <!--PATTERN AvsVersionId_NewReleaseMessage-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[@AvsVersionId]"
                 priority="1000"
                 mode="M4">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[@AvsVersionId]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:restriction/xs:enumeration[@value=current()/@AvsVersionId]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:restriction/xs:enumeration[@value=current()/@AvsVersionId]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The AvsVersionId should conform to the allowed value set AvsVersionId. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M4"/>
   <xsl:template match="@*|node()" priority="-2" mode="M4">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M4"/>
   </xsl:template>

   <!--PATTERN AvsVersionId_PurgeReleaseMessage-->


	  <!--RULE -->
   <xsl:template match="*:PurgeReleaseMessage[@AvsVersionId]"
                 priority="1000"
                 mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:PurgeReleaseMessage[@AvsVersionId]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:restriction/xs:enumeration[@value=current()/@AvsVersionId]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:restriction/xs:enumeration[@value=current()/@AvsVersionId]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The AvsVersionId should conform to the allowed value set AvsVersionId. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_AdditionalTitle-->


	  <!--RULE -->
   <xsl:template match="//AdditionalTitle[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//AdditionalTitle[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>

   <!--PATTERN TitleType_AdditionalTitle-->


	  <!--RULE -->
   <xsl:template match="//AdditionalTitle[@TitleType]" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//AdditionalTitle[@TitleType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AdditionalTitleType']/xs:restriction/xs:enumeration[@value=current()/@TitleType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AdditionalTitleType']/xs:restriction/xs:enumeration[@value=current()/@TitleType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The TitleType should conform to the allowed value set AdditionalTitleType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AdditionalTitleType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>

   <!--PATTERN Reason_AvRating-->


	  <!--RULE -->
   <xsl:template match="//AvRating[Reason]" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//AvRating[Reason]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='RatingReason']/xs:restriction/xs:enumeration[@value=current()/Reason]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='RatingReason']/xs:restriction/xs:enumeration[@value=current()/Reason]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Reason should conform to the allowed value set RatingReason. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='RatingReason']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_AvRating-->


	  <!--RULE -->
   <xsl:template match="//AvRating[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//AvRating[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_CLineWithDefault-->


	  <!--RULE -->
   <xsl:template match="//CLineWithDefault[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//CLineWithDefault[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_CourtesyLineWithDefault-->


	  <!--RULE -->
   <xsl:template match="//CourtesyLineWithDefault[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//CourtesyLineWithDefault[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>

   <!--PATTERN VideoDefinitionType_DealTermsTechnicalInstantiation-->


	  <!--RULE -->
   <xsl:template match="//DealTermsTechnicalInstantiation[VideoDefinitionType]"
                 priority="1000"
                 mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DealTermsTechnicalInstantiation[VideoDefinitionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:restriction/xs:enumeration[@value=current()/VideoDefinitionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:restriction/xs:enumeration[@value=current()/VideoDefinitionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The VideoDefinitionType should conform to the allowed value set VideoDefinitionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>

   <!--PATTERN CodingType_DealTermsTechnicalInstantiation-->


	  <!--RULE -->
   <xsl:template match="//DealTermsTechnicalInstantiation[CodingType]"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DealTermsTechnicalInstantiation[CodingType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CodingType']/xs:restriction/xs:enumeration[@value=current()/CodingType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CodingType']/xs:restriction/xs:enumeration[@value=current()/CodingType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CodingType should conform to the allowed value set CodingType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CodingType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_Deity-->


	  <!--RULE -->
   <xsl:template match="//Deity[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Deity[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_DescriptionWithTerritory-->


	  <!--RULE -->
   <xsl:template match="//DescriptionWithTerritory[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DescriptionWithTerritory[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M15"/>
   </xsl:template>

   <!--PATTERN SubTitleType_DisplaySubTitle-->


	  <!--RULE -->
   <xsl:template match="//DisplaySubTitle[@SubTitleType]" priority="1000" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DisplaySubTitle[@SubTitleType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='SubTitleType']/xs:restriction/xs:enumeration[@value=current()/@SubTitleType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='SubTitleType']/xs:restriction/xs:enumeration[@value=current()/@SubTitleType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The SubTitleType should conform to the allowed value set SubTitleType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='SubTitleType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M16"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_DisplayTitle-->


	  <!--RULE -->
   <xsl:template match="//DisplayTitle[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DisplayTitle[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M17"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_DisplayTitleText-->


	  <!--RULE -->
   <xsl:template match="//DisplayTitleText[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DisplayTitleText[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M18"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_EventDateTimeWithoutFlags-->


	  <!--RULE -->
   <xsl:template match="//EventDateTimeWithoutFlags[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//EventDateTimeWithoutFlags[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M19"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_EventDateWithDefault-->


	  <!--RULE -->
   <xsl:template match="//EventDateWithDefault[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//EventDateWithDefault[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M20"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_EventDateWithoutFlags-->


	  <!--RULE -->
   <xsl:template match="//EventDateWithoutFlags[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//EventDateWithoutFlags[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M21"/>
   </xsl:template>

   <!--PATTERN DataType_Fingerprint-->


	  <!--RULE -->
   <xsl:template match="//Fingerprint[DataType]" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Fingerprint[DataType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:restriction/xs:enumeration[@value=current()/DataType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:restriction/xs:enumeration[@value=current()/DataType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The DataType should conform to the allowed value set BinaryDataType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M22"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_PartyNameWithTerritory-->


	  <!--RULE -->
   <xsl:template match="//PartyNameWithTerritory[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//PartyNameWithTerritory[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M23"/>
   </xsl:template>

   <!--PATTERN ExpressionType_PreviewDetails-->


	  <!--RULE -->
   <xsl:template match="//PreviewDetails[ExpressionType]" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//PreviewDetails[ExpressionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:restriction/xs:enumeration[@value=current()/ExpressionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:restriction/xs:enumeration[@value=current()/ExpressionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ExpressionType should conform to the allowed value set ExpressionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M24"/>
   </xsl:template>

   <!--PATTERN PriceType_PriceInformationWithType-->


	  <!--RULE -->
   <xsl:template match="//PriceInformationWithType[@PriceType]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//PriceInformationWithType[@PriceType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='PriceInformationType']/xs:restriction/xs:enumeration[@value=current()/@PriceType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='PriceInformationType']/xs:restriction/xs:enumeration[@value=current()/@PriceType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The PriceType should conform to the allowed value set PriceInformationType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='PriceInformationType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M25"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_Raga-->


	  <!--RULE -->
   <xsl:template match="//Raga[@ApplicableTerritoryCode]" priority="1000" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Raga[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M26"/>
   </xsl:template>

   <!--PATTERN ResourceRelationshipType_RelatedResource-->


	  <!--RULE -->
   <xsl:template match="//RelatedResource[ResourceRelationshipType]"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//RelatedResource[ResourceRelationshipType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ResourceRelationshipType']/xs:restriction/xs:enumeration[@value=current()/ResourceRelationshipType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ResourceRelationshipType']/xs:restriction/xs:enumeration[@value=current()/ResourceRelationshipType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ResourceRelationshipType should conform to the allowed value set ResourceRelationshipType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ResourceRelationshipType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M27"/>
   </xsl:template>

   <!--PATTERN LabelType_ReleaseLabelReference-->


	  <!--RULE -->
   <xsl:template match="//ReleaseLabelReference[@LabelType]"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ReleaseLabelReference[@LabelType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='LabelType']/xs:restriction/xs:enumeration[@value=current()/@LabelType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='LabelType']/xs:restriction/xs:enumeration[@value=current()/@LabelType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The LabelType should conform to the allowed value set LabelType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='LabelType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M28"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_ReleaseLabelReference-->


	  <!--RULE -->
   <xsl:template match="//ReleaseLabelReference[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ReleaseLabelReference[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M29"/>
   </xsl:template>

   <!--PATTERN RightsControllerRole_ResourceRightsController-->


	  <!--RULE -->
   <xsl:template match="//ResourceRightsController[RightsControllerRole]"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceRightsController[RightsControllerRole]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:restriction/xs:enumeration[@value=current()/RightsControllerRole]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:restriction/xs:enumeration[@value=current()/RightsControllerRole]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The RightsControllerRole should conform to the allowed value set RightsControllerRole. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M30"/>
   </xsl:template>

   <!--PATTERN ResourceGroupType_ResourceSubGroup-->


	  <!--RULE -->
   <xsl:template match="//ResourceSubGroup[@ResourceGroupType]"
                 priority="1000"
                 mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceSubGroup[@ResourceGroupType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ResourceGroupType']/xs:restriction/xs:enumeration[@value=current()/@ResourceGroupType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ResourceGroupType']/xs:restriction/xs:enumeration[@value=current()/@ResourceGroupType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ResourceGroupType should conform to the allowed value set ResourceGroupType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ResourceGroupType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M31"/>
   </xsl:template>

   <!--PATTERN LanguageOfLyrics_SheetMusic-->


	  <!--RULE -->
   <xsl:template match="//SheetMusic[LanguageOfLyrics]" priority="1000" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SheetMusic[LanguageOfLyrics]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfLyrics]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfLyrics]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The LanguageOfLyrics should conform to the allowed value set IsoLanguageCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M32"/>
   </xsl:template>

   <!--PATTERN CompositeMusicalWorkType_SoundRecording-->


	  <!--RULE -->
   <xsl:template match="//SoundRecording[CompositeMusicalWorkType]"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SoundRecording[CompositeMusicalWorkType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:restriction/xs:enumeration[@value=current()/CompositeMusicalWorkType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:restriction/xs:enumeration[@value=current()/CompositeMusicalWorkType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CompositeMusicalWorkType should conform to the allowed value set CompositeMusicalWorkType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M33"/>
   </xsl:template>

   <!--PATTERN LanguageOfPerformance_SoundRecording-->


	  <!--RULE -->
   <xsl:template match="//SoundRecording[LanguageOfPerformance]"
                 priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SoundRecording[LanguageOfPerformance]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfPerformance]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfPerformance]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The LanguageOfPerformance should conform to the allowed value set IsoLanguageCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M34"/>
   </xsl:template>

   <!--PATTERN AudioChannelConfiguration_SoundRecording-->


	  <!--RULE -->
   <xsl:template match="//SoundRecording[AudioChannelConfiguration]"
                 priority="1000"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SoundRecording[AudioChannelConfiguration]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='RecordingMode']/xs:restriction/xs:enumeration[@value=current()/AudioChannelConfiguration]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='RecordingMode']/xs:restriction/xs:enumeration[@value=current()/AudioChannelConfiguration]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The AudioChannelConfiguration should conform to the allowed value set RecordingMode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='RecordingMode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M35"/>
   </xsl:template>

   <!--PATTERN ExpressionType_SoundRecordingPreviewDetails-->


	  <!--RULE -->
   <xsl:template match="//SoundRecordingPreviewDetails[ExpressionType]"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SoundRecordingPreviewDetails[ExpressionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:restriction/xs:enumeration[@value=current()/ExpressionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:restriction/xs:enumeration[@value=current()/ExpressionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ExpressionType should conform to the allowed value set ExpressionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M36"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_SynopsisWithTerritory-->


	  <!--RULE -->
   <xsl:template match="//SynopsisWithTerritory[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SynopsisWithTerritory[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M37"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_Tala-->


	  <!--RULE -->
   <xsl:template match="//Tala[@ApplicableTerritoryCode]" priority="1000" mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Tala[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M38"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_TechnicalImageDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalImageDetails[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalImageDetails[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M39"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_TechnicalSheetMusicDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalSheetMusicDetails[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalSheetMusicDetails[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M40"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_TechnicalSoftwareDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalSoftwareDetails[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalSoftwareDetails[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M41"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_TechnicalSoundRecordingDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalSoundRecordingDetails[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalSoundRecordingDetails[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M42"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_TechnicalTextDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalTextDetails[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalTextDetails[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M43"/>
   </xsl:template>

   <!--PATTERN VideoDefinitionType_TechnicalVideoDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalVideoDetails[VideoDefinitionType]"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalVideoDetails[VideoDefinitionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:restriction/xs:enumeration[@value=current()/VideoDefinitionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:restriction/xs:enumeration[@value=current()/VideoDefinitionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The VideoDefinitionType should conform to the allowed value set VideoDefinitionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_TechnicalVideoDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalVideoDetails[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalVideoDetails[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>

   <!--PATTERN TitleType_Title-->


	  <!--RULE -->
   <xsl:template match="//Title[@TitleType]" priority="1000" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Title[@TitleType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='TitleType']/xs:restriction/xs:enumeration[@value=current()/@TitleType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='TitleType']/xs:restriction/xs:enumeration[@value=current()/@TitleType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The TitleType should conform to the allowed value set TitleType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='TitleType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M46"/>
   </xsl:template>

   <!--PATTERN CompositeMusicalWorkType_Video-->


	  <!--RULE -->
   <xsl:template match="//Video[CompositeMusicalWorkType]"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Video[CompositeMusicalWorkType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:restriction/xs:enumeration[@value=current()/CompositeMusicalWorkType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:restriction/xs:enumeration[@value=current()/CompositeMusicalWorkType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CompositeMusicalWorkType should conform to the allowed value set CompositeMusicalWorkType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M47"/>
   </xsl:template>

   <!--PATTERN LanguageOfPerformance_Video-->


	  <!--RULE -->
   <xsl:template match="//Video[LanguageOfPerformance]" priority="1000" mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Video[LanguageOfPerformance]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfPerformance]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfPerformance]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The LanguageOfPerformance should conform to the allowed value set IsoLanguageCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M48"/>
   </xsl:template>

   <!--PATTERN LanguageOfDubbing_Video-->


	  <!--RULE -->
   <xsl:template match="//Video[LanguageOfDubbing]" priority="1000" mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Video[LanguageOfDubbing]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfDubbing]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfDubbing]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The LanguageOfDubbing should conform to the allowed value set IsoLanguageCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M49"/>
   </xsl:template>

   <!--PATTERN SubTitleLanguage_Video-->


	  <!--RULE -->
   <xsl:template match="//Video[SubTitleLanguage]" priority="1000" mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Video[SubTitleLanguage]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/SubTitleLanguage]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/SubTitleLanguage]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The SubTitleLanguage should conform to the allowed value set IsoLanguageCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M50"/>
   </xsl:template>

   <!--PATTERN RightsControllerRole_WorkRightsController-->


	  <!--RULE -->
   <xsl:template match="//WorkRightsController[RightsControllerRole]"
                 priority="1000"
                 mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//WorkRightsController[RightsControllerRole]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:restriction/xs:enumeration[@value=current()/RightsControllerRole]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:restriction/xs:enumeration[@value=current()/RightsControllerRole]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The RightsControllerRole should conform to the allowed value set RightsControllerRole. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M51"/>
   </xsl:template>

   <!--PATTERN RightsControllerType_WorkRightsController-->


	  <!--RULE -->
   <xsl:template match="//WorkRightsController[RightsControllerType]"
                 priority="1000"
                 mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//WorkRightsController[RightsControllerType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='RightsControllerType']/xs:restriction/xs:enumeration[@value=current()/RightsControllerType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='RightsControllerType']/xs:restriction/xs:enumeration[@value=current()/RightsControllerType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The RightsControllerType should conform to the allowed value set RightsControllerType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='RightsControllerType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M52"/>
   </xsl:template>

   <!--PATTERN Type_Affiliation-->


	  <!--RULE -->
   <xsl:template match="//Affiliation[Type]" priority="1000" mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Affiliation[Type]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AffiliationType']/xs:restriction/xs:enumeration[@value=current()/Type]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AffiliationType']/xs:restriction/xs:enumeration[@value=current()/Type]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Type should conform to the allowed value set AffiliationType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AffiliationType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M53"/>
   </xsl:template>

   <!--PATTERN IdentifierType_AllTerritoryCode-->


	  <!--RULE -->
   <xsl:template match="//AllTerritoryCode[@IdentifierType]"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//AllTerritoryCode[@IdentifierType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='TerritoryCodeTypeIncludingDeprecatedCodes']/xs:restriction/xs:enumeration[@value=current()/@IdentifierType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='TerritoryCodeTypeIncludingDeprecatedCodes']/xs:restriction/xs:enumeration[@value=current()/@IdentifierType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The IdentifierType should conform to the allowed value set TerritoryCodeTypeIncludingDeprecatedCodes. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='TerritoryCodeTypeIncludingDeprecatedCodes']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M54"/>
   </xsl:template>

   <!--PATTERN AspectRatioType_AspectRatio-->


	  <!--RULE -->
   <xsl:template match="//AspectRatio[@AspectRatioType]" priority="1000" mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//AspectRatio[@AspectRatioType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AspectRatioType']/xs:restriction/xs:enumeration[@value=current()/@AspectRatioType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AspectRatioType']/xs:restriction/xs:enumeration[@value=current()/@AspectRatioType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The AspectRatioType should conform to the allowed value set AspectRatioType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AspectRatioType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M55"/>
   </xsl:template>

   <!--PATTERN UnitOfMeasure_BitRate-->


	  <!--RULE -->
   <xsl:template match="//BitRate[@UnitOfMeasure]" priority="1000" mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//BitRate[@UnitOfMeasure]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='UnitOfBitRate']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='UnitOfBitRate']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UnitOfMeasure should conform to the allowed value set UnitOfBitRate. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfBitRate']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M56"/>
   </xsl:template>

   <!--PATTERN Unit_ConditionForRightsClaimPolicy-->


	  <!--RULE -->
   <xsl:template match="//ConditionForRightsClaimPolicy[Unit]"
                 priority="1000"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ConditionForRightsClaimPolicy[Unit]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='UnitOfConditionValue']/xs:restriction/xs:enumeration[@value=current()/Unit]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='UnitOfConditionValue']/xs:restriction/xs:enumeration[@value=current()/Unit]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Unit should conform to the allowed value set UnitOfConditionValue. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfConditionValue']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M57"/>
   </xsl:template>

   <!--PATTERN ReferenceCreation_ConditionForRightsClaimPolicy-->


	  <!--RULE -->
   <xsl:template match="//ConditionForRightsClaimPolicy[ReferenceCreation]"
                 priority="1000"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ConditionForRightsClaimPolicy[ReferenceCreation]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ReferenceCreation']/xs:restriction/xs:enumeration[@value=current()/ReferenceCreation]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ReferenceCreation']/xs:restriction/xs:enumeration[@value=current()/ReferenceCreation]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReferenceCreation should conform to the allowed value set ReferenceCreation. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ReferenceCreation']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M58"/>
   </xsl:template>

   <!--PATTERN RelationalRelator_ConditionForRightsClaimPolicy-->


	  <!--RULE -->
   <xsl:template match="//ConditionForRightsClaimPolicy[RelationalRelator]"
                 priority="1000"
                 mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ConditionForRightsClaimPolicy[RelationalRelator]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='RelationalRelator']/xs:restriction/xs:enumeration[@value=current()/RelationalRelator]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='RelationalRelator']/xs:restriction/xs:enumeration[@value=current()/RelationalRelator]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The RelationalRelator should conform to the allowed value set RelationalRelator. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='RelationalRelator']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M59"/>
   </xsl:template>

   <!--PATTERN IdentifierType_CurrentTerritoryCode-->


	  <!--RULE -->
   <xsl:template match="//CurrentTerritoryCode[@IdentifierType]"
                 priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//CurrentTerritoryCode[@IdentifierType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='TerritoryCodeType']/xs:restriction/xs:enumeration[@value=current()/@IdentifierType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='TerritoryCodeType']/xs:restriction/xs:enumeration[@value=current()/@IdentifierType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The IdentifierType should conform to the allowed value set TerritoryCodeType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='TerritoryCodeType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M60"/>
   </xsl:template>

   <!--PATTERN DataType_DetailedHashSum-->


	  <!--RULE -->
   <xsl:template match="//DetailedHashSum[DataType]" priority="1000" mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedHashSum[DataType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:restriction/xs:enumeration[@value=current()/DataType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:restriction/xs:enumeration[@value=current()/DataType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The DataType should conform to the allowed value set BinaryDataType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M61"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_DisplayArtistNameWithDefault-->


	  <!--RULE -->
   <xsl:template match="//DisplayArtistNameWithDefault[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DisplayArtistNameWithDefault[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M62"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_DisplayCredits-->


	  <!--RULE -->
   <xsl:template match="//DisplayCredits[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DisplayCredits[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M63"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_EventDate-->


	  <!--RULE -->
   <xsl:template match="//EventDate[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//EventDate[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M64"/>
   </xsl:template>

   <!--PATTERN TerritoryCode_EventDateTime-->


	  <!--RULE -->
   <xsl:template match="//EventDateTime[@TerritoryCode]" priority="1000" mode="M65">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//EventDateTime[@TerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@TerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@TerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The TerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M65"/>
   </xsl:template>

   <!--PATTERN UnitOfMeasure_Extent-->


	  <!--RULE -->
   <xsl:template match="//Extent[@UnitOfMeasure]" priority="1000" mode="M66">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Extent[@UnitOfMeasure]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='UnitOfExtent']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='UnitOfExtent']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UnitOfMeasure should conform to the allowed value set UnitOfExtent. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfExtent']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M66"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_FirstPublicationDate-->


	  <!--RULE -->
   <xsl:template match="//FirstPublicationDate[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M67">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//FirstPublicationDate[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M67"/>
   </xsl:template>

   <!--PATTERN UnitOfMeasure_FrameRate-->


	  <!--RULE -->
   <xsl:template match="//FrameRate[@UnitOfMeasure]" priority="1000" mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//FrameRate[@UnitOfMeasure]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='UnitOfFrameRate']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='UnitOfFrameRate']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UnitOfMeasure should conform to the allowed value set UnitOfFrameRate. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfFrameRate']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M68"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_FulfillmentDateWithTerritory-->


	  <!--RULE -->
   <xsl:template match="//FulfillmentDateWithTerritory[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M69">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//FulfillmentDateWithTerritory[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M69"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_GenreWithTerritory-->


	  <!--RULE -->
   <xsl:template match="//GenreWithTerritory[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//GenreWithTerritory[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M70"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_KeywordsWithTerritory-->


	  <!--RULE -->
   <xsl:template match="//KeywordsWithTerritory[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//KeywordsWithTerritory[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M71"/>
   </xsl:template>

   <!--PATTERN LinkDescription_LinkedReleaseResourceReference-->


	  <!--RULE -->
   <xsl:template match="//LinkedReleaseResourceReference[@LinkDescription]"
                 priority="1000"
                 mode="M72">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//LinkedReleaseResourceReference[@LinkDescription]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='LinkDescription']/xs:restriction/xs:enumeration[@value=current()/@LinkDescription]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='LinkDescription']/xs:restriction/xs:enumeration[@value=current()/@LinkDescription]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The LinkDescription should conform to the allowed value set LinkDescription. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='LinkDescription']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M72"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_MarketingComment-->


	  <!--RULE -->
   <xsl:template match="//MarketingComment[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//MarketingComment[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M73"/>
   </xsl:template>

   <!--PATTERN MessageControlType_MessageHeader-->


	  <!--RULE -->
   <xsl:template match="//MessageHeader[MessageControlType]"
                 priority="1000"
                 mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//MessageHeader[MessageControlType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='MessageControlType']/xs:restriction/xs:enumeration[@value=current()/MessageControlType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='MessageControlType']/xs:restriction/xs:enumeration[@value=current()/MessageControlType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The MessageControlType should conform to the allowed value set MessageControlType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='MessageControlType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M74"/>
   </xsl:template>

   <!--PATTERN PLineType_PLine-->


	  <!--RULE -->
   <xsl:template match="//PLine[@PLineType]" priority="1000" mode="M75">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//PLine[@PLineType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='PLineType']/xs:restriction/xs:enumeration[@value=current()/@PLineType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='PLineType']/xs:restriction/xs:enumeration[@value=current()/@PLineType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The PLineType should conform to the allowed value set PLineType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='PLineType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M75"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_PLineWithDefault-->


	  <!--RULE -->
   <xsl:template match="//PLineWithDefault[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//PLineWithDefault[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M76"/>
   </xsl:template>

   <!--PATTERN ApplicableTerritoryCode_ParentalWarningTypeWithTerritory-->


	  <!--RULE -->
   <xsl:template match="//ParentalWarningTypeWithTerritory[@ApplicableTerritoryCode]"
                 priority="1000"
                 mode="M77">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ParentalWarningTypeWithTerritory[@ApplicableTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M77"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M77"/>
   </xsl:template>

   <!--PATTERN CurrencyCode_Price-->


	  <!--RULE -->
   <xsl:template match="//Price[@CurrencyCode]" priority="1000" mode="M78">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Price[@CurrencyCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrencyCode']/xs:restriction/xs:enumeration[@value=current()/@CurrencyCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrencyCode']/xs:restriction/xs:enumeration[@value=current()/@CurrencyCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CurrencyCode should conform to the allowed value set CurrencyCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrencyCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M78"/>
   </xsl:template>

   <!--PATTERN RightsClaimPolicyType_RightsClaimPolicy-->


	  <!--RULE -->
   <xsl:template match="//RightsClaimPolicy[RightsClaimPolicyType]"
                 priority="1000"
                 mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//RightsClaimPolicy[RightsClaimPolicyType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='RightsClaimPolicyType']/xs:restriction/xs:enumeration[@value=current()/RightsClaimPolicyType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='RightsClaimPolicyType']/xs:restriction/xs:enumeration[@value=current()/RightsClaimPolicyType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The RightsClaimPolicyType should conform to the allowed value set RightsClaimPolicyType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='RightsClaimPolicyType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M79"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M79"/>
   </xsl:template>

   <!--PATTERN UnitOfMeasure_SamplingRate-->


	  <!--RULE -->
   <xsl:template match="//SamplingRate[@UnitOfMeasure]" priority="1000" mode="M80">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SamplingRate[@UnitOfMeasure]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='UnitOfFrequency']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='UnitOfFrequency']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UnitOfMeasure should conform to the allowed value set UnitOfFrequency. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfFrequency']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M80"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M80"/>
   </xsl:template>

   <!--PATTERN UseType_DealTerms-->


	  <!--RULE -->
   <xsl:template match="//DealTerms[UseType]" priority="1000" mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//DealTerms[UseType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='UseType']/xs:restriction/xs:enumeration[@value=current()/UseType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='UseType']/xs:restriction/xs:enumeration[@value=current()/UseType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should conform to the allowed value set UseType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='UseType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M81"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M81"/>
   </xsl:template>

   <!--PATTERN Role_AdministratingRecordCompanyWithReference-->


	  <!--RULE -->
   <xsl:template match="//AdministratingRecordCompanyWithReference[Role]"
                 priority="1000"
                 mode="M82">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//AdministratingRecordCompanyWithReference[Role]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AdministratingRecordCompanyRole']/xs:restriction/xs:enumeration[@value=current()/Role]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AdministratingRecordCompanyRole']/xs:restriction/xs:enumeration[@value=current()/Role]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Role should conform to the allowed value set AdministratingRecordCompanyRole. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AdministratingRecordCompanyRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M82"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M82"/>
   <xsl:template match="@*|node()" priority="-2" mode="M82">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M82"/>
   </xsl:template>

   <!--PATTERN Territory_WorkRightsController-->


	  <!--RULE -->
   <xsl:template match="//WorkRightsController[Territory]"
                 priority="1000"
                 mode="M83">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//WorkRightsController[Territory]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/Territory]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/Territory]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Territory should conform to the allowed value set AllTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M83"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M83"/>
   <xsl:template match="@*|node()" priority="-2" mode="M83">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M83"/>
   </xsl:template>

   <!--PATTERN AudioCodecType_TechnicalSoundRecordingDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalSoundRecordingDetails[AudioCodecType]"
                 priority="1000"
                 mode="M84">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalSoundRecordingDetails[AudioCodecType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:restriction/xs:enumeration[@value=current()/AudioCodecType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:restriction/xs:enumeration[@value=current()/AudioCodecType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The AudioCodecType should conform to the allowed value set AudioCodecType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M84"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M84"/>
   <xsl:template match="@*|node()" priority="-2" mode="M84">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M84"/>
   </xsl:template>

   <!--PATTERN AudioCodecType_TechnicalVideoDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalVideoDetails[AudioCodecType]"
                 priority="1000"
                 mode="M85">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalVideoDetails[AudioCodecType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:restriction/xs:enumeration[@value=current()/AudioCodecType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:restriction/xs:enumeration[@value=current()/AudioCodecType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The AudioCodecType should conform to the allowed value set AudioCodecType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M85"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M85"/>
   </xsl:template>

   <!--PATTERN CarrierType_DealTerms-->


	  <!--RULE -->
   <xsl:template match="//DealTerms[CarrierType]" priority="1000" mode="M86">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DealTerms[CarrierType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:restriction/xs:enumeration[@value=current()/CarrierType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:restriction/xs:enumeration[@value=current()/CarrierType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CarrierType should conform to the allowed value set CarrierType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M86"/>
   </xsl:template>

   <!--PATTERN CarrierType_ResourceGroup-->


	  <!--RULE -->
   <xsl:template match="//ResourceGroup[CarrierType]" priority="1000" mode="M87">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceGroup[CarrierType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:restriction/xs:enumeration[@value=current()/CarrierType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:restriction/xs:enumeration[@value=current()/CarrierType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CarrierType should conform to the allowed value set CarrierType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M87"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M87"/>
   </xsl:template>

   <!--PATTERN CarrierType_ResourceSubGroup-->


	  <!--RULE -->
   <xsl:template match="//ResourceSubGroup[CarrierType]" priority="1000" mode="M88">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceSubGroup[CarrierType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:restriction/xs:enumeration[@value=current()/CarrierType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:restriction/xs:enumeration[@value=current()/CarrierType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CarrierType should conform to the allowed value set CarrierType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M88"/>
   </xsl:template>

   <!--PATTERN CommercialModelType_DealTerms-->


	  <!--RULE -->
   <xsl:template match="//DealTerms[CommercialModelType]" priority="1000" mode="M89">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DealTerms[CommercialModelType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CommercialModelType']/xs:restriction/xs:enumeration[@value=current()/CommercialModelType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CommercialModelType']/xs:restriction/xs:enumeration[@value=current()/CommercialModelType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should conform to the allowed value set CommercialModelType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CommercialModelType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M89"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M89"/>
   <xsl:template match="@*|node()" priority="-2" mode="M89">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M89"/>
   </xsl:template>

   <!--PATTERN ContainerFormat_TechnicalVideoDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalVideoDetails[ContainerFormat]"
                 priority="1000"
                 mode="M90">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalVideoDetails[ContainerFormat]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ContainerFormat']/xs:restriction/xs:enumeration[@value=current()/ContainerFormat]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ContainerFormat']/xs:restriction/xs:enumeration[@value=current()/ContainerFormat]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ContainerFormat should conform to the allowed value set ContainerFormat. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ContainerFormat']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M90"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M90"/>
   <xsl:template match="@*|node()" priority="-2" mode="M90">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M90"/>
   </xsl:template>

   <!--PATTERN Role_Contributor-->


	  <!--RULE -->
   <xsl:template match="//Contributor[Role]" priority="1000" mode="M91">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Contributor[Role]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:restriction/xs:enumeration[@value=current()/Role]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:restriction/xs:enumeration[@value=current()/Role]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Role should conform to the allowed value set ContributorRole. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M91"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M91"/>
   <xsl:template match="@*|node()" priority="-2" mode="M91">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M91"/>
   </xsl:template>

   <!--PATTERN Role_DetailedResourceContributor-->


	  <!--RULE -->
   <xsl:template match="//DetailedResourceContributor[Role]"
                 priority="1000"
                 mode="M92">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedResourceContributor[Role]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:restriction/xs:enumeration[@value=current()/Role]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:restriction/xs:enumeration[@value=current()/Role]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Role should conform to the allowed value set ContributorRole. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M92"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M92"/>
   <xsl:template match="@*|node()" priority="-2" mode="M92">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M92"/>
   </xsl:template>

   <!--PATTERN ArtisticRole_DisplayArtist-->


	  <!--RULE -->
   <xsl:template match="//DisplayArtist[ArtisticRole]" priority="1000" mode="M93">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DisplayArtist[ArtisticRole]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:restriction/xs:enumeration[@value=current()/ArtisticRole]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:restriction/xs:enumeration[@value=current()/ArtisticRole]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ArtisticRole should conform to the allowed value set ContributorRole. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M93"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M93"/>
   <xsl:template match="@*|node()" priority="-2" mode="M93">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M93"/>
   </xsl:template>

   <!--PATTERN CueOrigin_DetailedCue-->


	  <!--RULE -->
   <xsl:template match="//DetailedCue[CueOrigin]" priority="1000" mode="M94">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedCue[CueOrigin]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CueOrigin']/xs:restriction/xs:enumeration[@value=current()/CueOrigin]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CueOrigin']/xs:restriction/xs:enumeration[@value=current()/CueOrigin]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CueOrigin should conform to the allowed value set CueOrigin. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CueOrigin']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M94"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M94"/>
   <xsl:template match="@*|node()" priority="-2" mode="M94">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M94"/>
   </xsl:template>

   <!--PATTERN CueSheetType_DetailedCueSheet-->


	  <!--RULE -->
   <xsl:template match="//DetailedCueSheet[CueSheetType]" priority="1000" mode="M95">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedCueSheet[CueSheetType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CueSheetType']/xs:restriction/xs:enumeration[@value=current()/CueSheetType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CueSheetType']/xs:restriction/xs:enumeration[@value=current()/CueSheetType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CueSheetType should conform to the allowed value set CueSheetType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CueSheetType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M95"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M95"/>
   <xsl:template match="@*|node()" priority="-2" mode="M95">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M95"/>
   </xsl:template>

   <!--PATTERN CueThemeType_DetailedCue-->


	  <!--RULE -->
   <xsl:template match="//DetailedCue[CueThemeType]" priority="1000" mode="M96">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedCue[CueThemeType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ThemeType']/xs:restriction/xs:enumeration[@value=current()/CueThemeType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ThemeType']/xs:restriction/xs:enumeration[@value=current()/CueThemeType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CueThemeType should conform to the allowed value set ThemeType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ThemeType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M96"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M96"/>
   <xsl:template match="@*|node()" priority="-2" mode="M96">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M96"/>
   </xsl:template>

   <!--PATTERN CueUseType_DetailedCue-->


	  <!--RULE -->
   <xsl:template match="//DetailedCue[CueUseType]" priority="1000" mode="M97">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedCue[CueUseType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CueUseType']/xs:restriction/xs:enumeration[@value=current()/CueUseType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CueUseType']/xs:restriction/xs:enumeration[@value=current()/CueUseType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CueUseType should conform to the allowed value set CueUseType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CueUseType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M97"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M97"/>
   <xsl:template match="@*|node()" priority="-2" mode="M97">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M97"/>
   </xsl:template>

   <!--PATTERN CueVisualPerceptionType_DetailedCue-->


	  <!--RULE -->
   <xsl:template match="//DetailedCue[CueVisualPerceptionType]"
                 priority="1000"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedCue[CueVisualPerceptionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VisualPerceptionType']/xs:restriction/xs:enumeration[@value=current()/CueVisualPerceptionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VisualPerceptionType']/xs:restriction/xs:enumeration[@value=current()/CueVisualPerceptionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CueVisualPerceptionType should conform to the allowed value set VisualPerceptionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VisualPerceptionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M98"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M98"/>
   <xsl:template match="@*|node()" priority="-2" mode="M98">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M98"/>
   </xsl:template>

   <!--PATTERN CueVocalType_DetailedCue-->


	  <!--RULE -->
   <xsl:template match="//DetailedCue[CueVocalType]" priority="1000" mode="M99">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedCue[CueVocalType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VocalType']/xs:restriction/xs:enumeration[@value=current()/CueVocalType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VocalType']/xs:restriction/xs:enumeration[@value=current()/CueVocalType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CueVocalType should conform to the allowed value set VocalType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VocalType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M99"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M99"/>
   <xsl:template match="@*|node()" priority="-2" mode="M99">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M99"/>
   </xsl:template>

   <!--PATTERN TerritoryCode_DealTerms-->


	  <!--RULE -->
   <xsl:template match="//DealTerms[TerritoryCode]" priority="1000" mode="M100">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DealTerms[TerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/TerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/TerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The TerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M100"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M100"/>
   <xsl:template match="@*|node()" priority="-2" mode="M100">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M100"/>
   </xsl:template>

   <!--PATTERN ExcludedTerritoryCode_DealTerms-->


	  <!--RULE -->
   <xsl:template match="//DealTerms[ExcludedTerritoryCode]"
                 priority="1000"
                 mode="M101">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DealTerms[ExcludedTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/ExcludedTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/ExcludedTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ExcludedTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M101"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M101"/>
   <xsl:template match="@*|node()" priority="-2" mode="M101">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M101"/>
   </xsl:template>

   <!--PATTERN TerritoryOfRightsDelegation_DelegatedUsageRights-->


	  <!--RULE -->
   <xsl:template match="//DelegatedUsageRights[TerritoryOfRightsDelegation]"
                 priority="1000"
                 mode="M102">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DelegatedUsageRights[TerritoryOfRightsDelegation]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/TerritoryOfRightsDelegation]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/TerritoryOfRightsDelegation]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The TerritoryOfRightsDelegation should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M102"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M102"/>
   <xsl:template match="@*|node()" priority="-2" mode="M102">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M102"/>
   </xsl:template>

   <!--PATTERN TerritoryCode_Affiliation-->


	  <!--RULE -->
   <xsl:template match="//Affiliation[TerritoryCode]" priority="1000" mode="M103">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Affiliation[TerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/TerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/TerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The TerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M103"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M103"/>
   <xsl:template match="@*|node()" priority="-2" mode="M103">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M103"/>
   </xsl:template>

   <!--PATTERN ExcludedTerritoryCode_Affiliation-->


	  <!--RULE -->
   <xsl:template match="//Affiliation[ExcludedTerritoryCode]"
                 priority="1000"
                 mode="M104">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Affiliation[ExcludedTerritoryCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/ExcludedTerritoryCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/ExcludedTerritoryCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ExcludedTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M104"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M104"/>
   <xsl:template match="@*|node()" priority="-2" mode="M104">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M104"/>
   </xsl:template>

   <!--PATTERN DisplayArtistRole_DisplayArtist-->


	  <!--RULE -->
   <xsl:template match="//DisplayArtist[DisplayArtistRole]"
                 priority="1000"
                 mode="M105">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DisplayArtist[DisplayArtistRole]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='DisplayArtistRole']/xs:restriction/xs:enumeration[@value=current()/DisplayArtistRole]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='DisplayArtistRole']/xs:restriction/xs:enumeration[@value=current()/DisplayArtistRole]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The DisplayArtistRole should conform to the allowed value set DisplayArtistRole. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='DisplayArtistRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M105"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M105"/>
   <xsl:template match="@*|node()" priority="-2" mode="M105">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M105"/>
   </xsl:template>

   <!--PATTERN ExternallyLinkedResourceType_ExternalResourceLink-->


	  <!--RULE -->
   <xsl:template match="//ExternalResourceLink[ExternallyLinkedResourceType]"
                 priority="1000"
                 mode="M106">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ExternalResourceLink[ExternallyLinkedResourceType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ExternallyLinkedResourceType']/xs:restriction/xs:enumeration[@value=current()/ExternallyLinkedResourceType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ExternallyLinkedResourceType']/xs:restriction/xs:enumeration[@value=current()/ExternallyLinkedResourceType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ExternallyLinkedResourceType should conform to the allowed value set ExternallyLinkedResourceType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ExternallyLinkedResourceType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M106"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M106"/>
   <xsl:template match="@*|node()" priority="-2" mode="M106">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M106"/>
   </xsl:template>

   <!--PATTERN Algorithm_Fingerprint-->


	  <!--RULE -->
   <xsl:template match="//Fingerprint[Algorithm]" priority="1000" mode="M107">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Fingerprint[Algorithm]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='FingerprintAlgorithmType']/xs:restriction/xs:enumeration[@value=current()/Algorithm]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='FingerprintAlgorithmType']/xs:restriction/xs:enumeration[@value=current()/Algorithm]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Algorithm should conform to the allowed value set FingerprintAlgorithmType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='FingerprintAlgorithmType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M107"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M107"/>
   <xsl:template match="@*|node()" priority="-2" mode="M107">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M107"/>
   </xsl:template>

   <!--PATTERN Algorithm_DetailedHashSum-->


	  <!--RULE -->
   <xsl:template match="//DetailedHashSum[Algorithm]" priority="1000" mode="M108">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedHashSum[Algorithm]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='HashSumAlgorithmType']/xs:restriction/xs:enumeration[@value=current()/Algorithm]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='HashSumAlgorithmType']/xs:restriction/xs:enumeration[@value=current()/Algorithm]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Algorithm should conform to the allowed value set HashSumAlgorithmType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='HashSumAlgorithmType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M108"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M108"/>
   <xsl:template match="@*|node()" priority="-2" mode="M108">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M108"/>
   </xsl:template>

   <!--PATTERN ImageCodecType_TechnicalImageDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalImageDetails[ImageCodecType]"
                 priority="1000"
                 mode="M109">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalImageDetails[ImageCodecType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ImageCodecType']/xs:restriction/xs:enumeration[@value=current()/ImageCodecType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ImageCodecType']/xs:restriction/xs:enumeration[@value=current()/ImageCodecType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ImageCodecType should conform to the allowed value set ImageCodecType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ImageCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M109"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M109"/>
   <xsl:template match="@*|node()" priority="-2" mode="M109">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M109"/>
   </xsl:template>

   <!--PATTERN Type_Image-->


	  <!--RULE -->
   <xsl:template match="//Image[Type]" priority="1000" mode="M110">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Image[Type]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ImageType']/xs:restriction/xs:enumeration[@value=current()/Type]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ImageType']/xs:restriction/xs:enumeration[@value=current()/Type]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Type should conform to the allowed value set ImageType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ImageType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M110"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M110"/>
   <xsl:template match="@*|node()" priority="-2" mode="M110">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M110"/>
   </xsl:template>

   <!--PATTERN InstrumentType_Contributor-->


	  <!--RULE -->
   <xsl:template match="//Contributor[InstrumentType]" priority="1000" mode="M111">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Contributor[InstrumentType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:restriction/xs:enumeration[@value=current()/InstrumentType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:restriction/xs:enumeration[@value=current()/InstrumentType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The InstrumentType should conform to the allowed value set InstrumentType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M111"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M111"/>
   <xsl:template match="@*|node()" priority="-2" mode="M111">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M111"/>
   </xsl:template>

   <!--PATTERN InstrumentType_DetailedResourceContributor-->


	  <!--RULE -->
   <xsl:template match="//DetailedResourceContributor[InstrumentType]"
                 priority="1000"
                 mode="M112">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DetailedResourceContributor[InstrumentType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:restriction/xs:enumeration[@value=current()/InstrumentType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:restriction/xs:enumeration[@value=current()/InstrumentType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The InstrumentType should conform to the allowed value set InstrumentType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M112"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M112"/>
   <xsl:template match="@*|node()" priority="-2" mode="M112">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M112"/>
   </xsl:template>

   <!--PATTERN OperatingSystemType_TechnicalSoftwareDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalSoftwareDetails[OperatingSystemType]"
                 priority="1000"
                 mode="M113">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalSoftwareDetails[OperatingSystemType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='OperatingSystemType']/xs:restriction/xs:enumeration[@value=current()/OperatingSystemType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='OperatingSystemType']/xs:restriction/xs:enumeration[@value=current()/OperatingSystemType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The OperatingSystemType should conform to the allowed value set OperatingSystemType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='OperatingSystemType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M113"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M113"/>
   <xsl:template match="@*|node()" priority="-2" mode="M113">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M113"/>
   </xsl:template>

   <!--PATTERN ParentalWarningType_Image-->


	  <!--RULE -->
   <xsl:template match="//Image[ParentalWarningType]" priority="1000" mode="M114">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Image[ParentalWarningType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M114"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M114"/>
   <xsl:template match="@*|node()" priority="-2" mode="M114">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M114"/>
   </xsl:template>

   <!--PATTERN ParentalWarningType_Release-->


	  <!--RULE -->
   <xsl:template match="//Release[ParentalWarningType]" priority="1000" mode="M115">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Release[ParentalWarningType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M115"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M115"/>
   <xsl:template match="@*|node()" priority="-2" mode="M115">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M115"/>
   </xsl:template>

   <!--PATTERN ParentalWarningType_SheetMusic-->


	  <!--RULE -->
   <xsl:template match="//SheetMusic[ParentalWarningType]"
                 priority="1000"
                 mode="M116">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SheetMusic[ParentalWarningType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M116"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M116"/>
   <xsl:template match="@*|node()" priority="-2" mode="M116">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M116"/>
   </xsl:template>

   <!--PATTERN ParentalWarningType_Software-->


	  <!--RULE -->
   <xsl:template match="//Software[ParentalWarningType]" priority="1000" mode="M117">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Software[ParentalWarningType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M117"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M117"/>
   <xsl:template match="@*|node()" priority="-2" mode="M117">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M117"/>
   </xsl:template>

   <!--PATTERN ParentalWarningType_SoundRecording-->


	  <!--RULE -->
   <xsl:template match="//SoundRecording[ParentalWarningType]"
                 priority="1000"
                 mode="M118">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SoundRecording[ParentalWarningType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M118"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M118"/>
   <xsl:template match="@*|node()" priority="-2" mode="M118">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M118"/>
   </xsl:template>

   <!--PATTERN ParentalWarningType_Text-->


	  <!--RULE -->
   <xsl:template match="//Text[ParentalWarningType]" priority="1000" mode="M119">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Text[ParentalWarningType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M119"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M119"/>
   <xsl:template match="@*|node()" priority="-2" mode="M119">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M119"/>
   </xsl:template>

   <!--PATTERN ParentalWarningType_Video-->


	  <!--RULE -->
   <xsl:template match="//Video[ParentalWarningType]" priority="1000" mode="M120">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Video[ParentalWarningType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M120"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M120"/>
   <xsl:template match="@*|node()" priority="-2" mode="M120">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M120"/>
   </xsl:template>

   <!--PATTERN PartyRelationshipType_RelatedParty-->


	  <!--RULE -->
   <xsl:template match="//RelatedParty[PartyRelationshipType]"
                 priority="1000"
                 mode="M121">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//RelatedParty[PartyRelationshipType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='PartyRelationshipType']/xs:restriction/xs:enumeration[@value=current()/PartyRelationshipType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='PartyRelationshipType']/xs:restriction/xs:enumeration[@value=current()/PartyRelationshipType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The PartyRelationshipType should conform to the allowed value set PartyRelationshipType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='PartyRelationshipType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M121"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M121"/>
   <xsl:template match="@*|node()" priority="-2" mode="M121">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M121"/>
   </xsl:template>

   <!--PATTERN PriceCode_PriceInformationWithType-->


	  <!--RULE -->
   <xsl:template match="//PriceInformationWithType[PriceCode]"
                 priority="1000"
                 mode="M122">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//PriceInformationWithType[PriceCode]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='PriceType']/xs:restriction/xs:enumeration[@value=current()/PriceCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='PriceType']/xs:restriction/xs:enumeration[@value=current()/PriceCode]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The PriceCode should conform to the allowed value set PriceType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='PriceType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M122"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M122"/>
   <xsl:template match="@*|node()" priority="-2" mode="M122">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M122"/>
   </xsl:template>

   <!--PATTERN Purpose_ResourceContainedResourceReference-->


	  <!--RULE -->
   <xsl:template match="//ResourceContainedResourceReference[Purpose]"
                 priority="1000"
                 mode="M123">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//ResourceContainedResourceReference[Purpose]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='Purpose']/xs:restriction/xs:enumeration[@value=current()/Purpose]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='Purpose']/xs:restriction/xs:enumeration[@value=current()/Purpose]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Purpose should conform to the allowed value set Purpose. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='Purpose']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M123"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M123"/>
   <xsl:template match="@*|node()" priority="-2" mode="M123">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M123"/>
   </xsl:template>

   <!--PATTERN Agency_AvRating-->


	  <!--RULE -->
   <xsl:template match="//AvRating[Agency]" priority="1000" mode="M124">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//AvRating[Agency]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='RatingAgency']/xs:restriction/xs:enumeration[@value=current()/Agency]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='RatingAgency']/xs:restriction/xs:enumeration[@value=current()/Agency]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Agency should conform to the allowed value set RatingAgency. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='RatingAgency']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M124"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M124"/>
   <xsl:template match="@*|node()" priority="-2" mode="M124">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M124"/>
   </xsl:template>

   <!--PATTERN ReleaseRelationshipType_RelatedRelease-->


	  <!--RULE -->
   <xsl:template match="//RelatedRelease[ReleaseRelationshipType]"
                 priority="1000"
                 mode="M125">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//RelatedRelease[ReleaseRelationshipType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ReleaseRelationshipType']/xs:restriction/xs:enumeration[@value=current()/ReleaseRelationshipType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ReleaseRelationshipType']/xs:restriction/xs:enumeration[@value=current()/ReleaseRelationshipType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseRelationshipType should conform to the allowed value set ReleaseRelationshipType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ReleaseRelationshipType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M125"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M125"/>
   <xsl:template match="@*|node()" priority="-2" mode="M125">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M125"/>
   </xsl:template>

   <!--PATTERN ReleaseType_Release-->


	  <!--RULE -->
   <xsl:template match="//Release[ReleaseType]" priority="1000" mode="M126">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Release[ReleaseType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='ReleaseType_ERN4']/xs:restriction/xs:enumeration[@value=current()/ReleaseType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='ReleaseType_ERN4']/xs:restriction/xs:enumeration[@value=current()/ReleaseType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseType should conform to the allowed value set ReleaseType_ERN4. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='ReleaseType_ERN4']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M126"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M126"/>
   <xsl:template match="@*|node()" priority="-2" mode="M126">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M126"/>
   </xsl:template>

   <!--PATTERN SheetMusicCodecType_TechnicalSheetMusicDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalSheetMusicDetails[SheetMusicCodecType]"
                 priority="1000"
                 mode="M127">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalSheetMusicDetails[SheetMusicCodecType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='SheetMusicCodecType']/xs:restriction/xs:enumeration[@value=current()/SheetMusicCodecType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='SheetMusicCodecType']/xs:restriction/xs:enumeration[@value=current()/SheetMusicCodecType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The SheetMusicCodecType should conform to the allowed value set SheetMusicCodecType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='SheetMusicCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M127"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M127"/>
   <xsl:template match="@*|node()" priority="-2" mode="M127">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M127"/>
   </xsl:template>

   <!--PATTERN Type_SheetMusic-->


	  <!--RULE -->
   <xsl:template match="//SheetMusic[Type]" priority="1000" mode="M128">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//SheetMusic[Type]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='SheetMusicType']/xs:restriction/xs:enumeration[@value=current()/Type]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='SheetMusicType']/xs:restriction/xs:enumeration[@value=current()/Type]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Type should conform to the allowed value set SheetMusicType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='SheetMusicType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M128"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M128"/>
   <xsl:template match="@*|node()" priority="-2" mode="M128">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M128"/>
   </xsl:template>

   <!--PATTERN RightsType_Affiliation-->


	  <!--RULE -->
   <xsl:template match="//Affiliation[RightsType]" priority="1000" mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Affiliation[RightsType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='RightsCoverage']/xs:restriction/xs:enumeration[@value=current()/RightsType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='RightsCoverage']/xs:restriction/xs:enumeration[@value=current()/RightsType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The RightsType should conform to the allowed value set RightsCoverage. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='RightsCoverage']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M129"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M129"/>
   <xsl:template match="@*|node()" priority="-2" mode="M129">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M129"/>
   </xsl:template>

   <!--PATTERN Type_Software-->


	  <!--RULE -->
   <xsl:template match="//Software[Type]" priority="1000" mode="M130">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Software[Type]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='SoftwareType']/xs:restriction/xs:enumeration[@value=current()/Type]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='SoftwareType']/xs:restriction/xs:enumeration[@value=current()/Type]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Type should conform to the allowed value set SoftwareType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='SoftwareType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M130"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M130"/>
   <xsl:template match="@*|node()" priority="-2" mode="M130">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M130"/>
   </xsl:template>

   <!--PATTERN Type_SoundRecording-->


	  <!--RULE -->
   <xsl:template match="//SoundRecording[Type]" priority="1000" mode="M131">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SoundRecording[Type]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='SoundRecordingType']/xs:restriction/xs:enumeration[@value=current()/Type]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='SoundRecordingType']/xs:restriction/xs:enumeration[@value=current()/Type]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Type should conform to the allowed value set SoundRecordingType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='SoundRecordingType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M131"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M131"/>
   <xsl:template match="@*|node()" priority="-2" mode="M131">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M131"/>
   </xsl:template>

   <!--PATTERN TextCodecType_TechnicalTextDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalTextDetails[TextCodecType]"
                 priority="1000"
                 mode="M132">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalTextDetails[TextCodecType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='TextCodecType']/xs:restriction/xs:enumeration[@value=current()/TextCodecType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='TextCodecType']/xs:restriction/xs:enumeration[@value=current()/TextCodecType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The TextCodecType should conform to the allowed value set TextCodecType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='TextCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M132"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M132"/>
   <xsl:template match="@*|node()" priority="-2" mode="M132">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M132"/>
   </xsl:template>

   <!--PATTERN Type_Text-->


	  <!--RULE -->
   <xsl:template match="//Text[Type]" priority="1000" mode="M133">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Text[Type]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='TextType']/xs:restriction/xs:enumeration[@value=current()/Type]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='TextType']/xs:restriction/xs:enumeration[@value=current()/Type]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Type should conform to the allowed value set TextType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='TextType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M133"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M133"/>
   <xsl:template match="@*|node()" priority="-2" mode="M133">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M133"/>
   </xsl:template>

   <!--PATTERN UseType_DelegatedUsageRights-->


	  <!--RULE -->
   <xsl:template match="//DelegatedUsageRights[UseType]" priority="1000" mode="M134">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//DelegatedUsageRights[UseType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='UseType']/xs:restriction/xs:enumeration[@value=current()/UseType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='UseType']/xs:restriction/xs:enumeration[@value=current()/UseType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should conform to the allowed value set UseType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='UseType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M134"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M134"/>
   <xsl:template match="@*|node()" priority="-2" mode="M134">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M134"/>
   </xsl:template>

   <!--PATTERN VersionType_Image-->


	  <!--RULE -->
   <xsl:template match="//Image[VersionType]" priority="1000" mode="M135">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Image[VersionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M135"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M135"/>
   <xsl:template match="@*|node()" priority="-2" mode="M135">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M135"/>
   </xsl:template>

   <!--PATTERN VersionType_SheetMusic-->


	  <!--RULE -->
   <xsl:template match="//SheetMusic[VersionType]" priority="1000" mode="M136">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SheetMusic[VersionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M136"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M136"/>
   <xsl:template match="@*|node()" priority="-2" mode="M136">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M136"/>
   </xsl:template>

   <!--PATTERN VersionType_Software-->


	  <!--RULE -->
   <xsl:template match="//Software[VersionType]" priority="1000" mode="M137">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//Software[VersionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M137"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M137"/>
   <xsl:template match="@*|node()" priority="-2" mode="M137">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M137"/>
   </xsl:template>

   <!--PATTERN VersionType_SoundRecording-->


	  <!--RULE -->
   <xsl:template match="//SoundRecording[VersionType]" priority="1000" mode="M138">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//SoundRecording[VersionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M138"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M138"/>
   <xsl:template match="@*|node()" priority="-2" mode="M138">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M138"/>
   </xsl:template>

   <!--PATTERN VersionType_Text-->


	  <!--RULE -->
   <xsl:template match="//Text[VersionType]" priority="1000" mode="M139">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Text[VersionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M139"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M139"/>
   <xsl:template match="@*|node()" priority="-2" mode="M139">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M139"/>
   </xsl:template>

   <!--PATTERN VersionType_Video-->


	  <!--RULE -->
   <xsl:template match="//Video[VersionType]" priority="1000" mode="M140">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Video[VersionType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M140"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M140"/>
   <xsl:template match="@*|node()" priority="-2" mode="M140">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M140"/>
   </xsl:template>

   <!--PATTERN VideoCodecType_TechnicalVideoDetails-->


	  <!--RULE -->
   <xsl:template match="//TechnicalVideoDetails[VideoCodecType]"
                 priority="1000"
                 mode="M141">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TechnicalVideoDetails[VideoCodecType]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VideoCodecType']/xs:restriction/xs:enumeration[@value=current()/VideoCodecType]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VideoCodecType']/xs:restriction/xs:enumeration[@value=current()/VideoCodecType]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The VideoCodecType should conform to the allowed value set VideoCodecType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VideoCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M141"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M141"/>
   <xsl:template match="@*|node()" priority="-2" mode="M141">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M141"/>
   </xsl:template>

   <!--PATTERN Type_Video-->


	  <!--RULE -->
   <xsl:template match="//Video[Type]" priority="1000" mode="M142">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//Video[Type]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="document('avs.xml')//xs:simpleType[@name='VideoType']/xs:restriction/xs:enumeration[@value=current()/Type]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="document('avs.xml')//xs:simpleType[@name='VideoType']/xs:restriction/xs:enumeration[@value=current()/Type]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The Type should conform to the allowed value set VideoType. The allowed values are<xsl:text/>
                  <xsl:value-of select="document('avs.xml')//xs:simpleType[@name='VideoType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M142"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M142"/>
   <xsl:template match="@*|node()" priority="-2" mode="M142">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M142"/>
   </xsl:template>
</xsl:stylesheet>
