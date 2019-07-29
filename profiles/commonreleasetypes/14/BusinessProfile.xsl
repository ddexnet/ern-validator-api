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
                              title="Schematron Business Profile for (version 1.4) for the NewReleaseMessage."
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
      that has already been issued. However, if more than 40 rules (representing 50% of all rules
      with a role of 'Error' or 'Conditional Error') have been failed at least once, the Conformance
      Tester must recommend to not award a Conformance Certificate or to retract a Conformance
      Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error'
      is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no
      means of asserting whether the condition expressed in the rule has been met.</svrl:text>
         <svrl:text>The following Clauses from the Business Profile standard are NOT checked by this ISO
      Schematron file: 4.2(1), 4.2(4)-(5), 4.3.1, 4.3.2(11), 4.4, 4.5, 4.6(1)-(2), (4),
      4.7.1(1)-(2), (5), 4.7.3, 4.7.4(1a), (1b), (2a), (2b), 4.7.5, 4.7.6, 4.7.7 and 4.8.</svrl:text>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_PreviewDateShouldBeBeforeStartDate</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_PreviewDateShouldBeBeforeStartDate</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_BusinessProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_BusinessProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MessageSchemaVersionId</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MessageSchemaVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_TerritoryTIS</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_TerritoryTIS</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainComment</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainComment</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainLanguageAndScriptCode</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainLanguageAndScriptCode</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainCatalogTransfer</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainCatalogTransfer</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainBulkOrderWholesalePricePerUnit</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainBulkOrderWholesalePricePerUnit</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainRelatedReleaseOfferSet</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainRelatedReleaseOfferSet</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainCarrierType</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainCarrierType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainPhysicalReturns</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainPhysicalReturns</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainNumberOfProductsPerCarton</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainNumberOfProductsPerCarton</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainResourceUsage</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainResourceUsage</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_GenericUseType</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_GenericUseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_SpecificUseType</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_SpecificUseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">GenericDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">NonProtectedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">AdSupportedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedAdSupportedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedAdSupportedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedAdSupportedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">NonProtectedAdSupportedDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TetheredDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">TetheredDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedTetheredDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">AdSupportedTetheredDownloadService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">KioskService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">KioskService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RingtonesAndMobileService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">RingtonesAndMobileService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimsOnUserGeneratedContent_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">RightsClaimsOnUserGeneratedContent_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PurchaseAsPhysicalProduct_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">PurchaseAsPhysicalProduct_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PurchaseAsPhysicalProduct_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">PurchaseAsPhysicalProduct_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_UseType2</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_UseType2</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_UseType2</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_UseType2</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_ConsumerRentalPeriod</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_UseType2</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_UseType2</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_NoGenericBusinessProfile</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_NoGenericBusinessProfile</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_NoGenericBusinessProfile</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_NoGenericBusinessProfile</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_NoGenericBusinessProfile</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_NoGenericBusinessProfile</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_NoGenericBusinessProfile</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_NoGenericBusinessProfile</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_MustNotContainPriceInformation</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_MustNotContainPriceInformation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_NoGenericBusinessProfile</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_NoGenericBusinessProfile</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">KioskService_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">KioskService_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RingtonesAndMobileService_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">RingtonesAndMobileService_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RingtonesAndMobileService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">RingtonesAndMobileService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimsOnUserGeneratedContent_RightsClaimPolicy2</xsl:attribute>
            <xsl:attribute name="name">RightsClaimsOnUserGeneratedContent_RightsClaimPolicy2</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimsOnUserGeneratedContent_WebPolicy</xsl:attribute>
            <xsl:attribute name="name">RightsClaimsOnUserGeneratedContent_WebPolicy</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimsOnUserGeneratedContent_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">RightsClaimsOnUserGeneratedContent_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PurchaseAsPhysicalProduct_CarrierType</xsl:attribute>
            <xsl:attribute name="name">PurchaseAsPhysicalProduct_CarrierType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M74"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M75"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M76"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M77"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_MustNotContainDates</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M78"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_ReleaseProfileVersionId</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M79"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_MustNotContainPriceInformation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M80"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainPriceType</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainPriceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M81"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainEffectiveDate</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainEffectiveDate</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M82"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainAllDealsCancelled</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainAllDealsCancelled</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M83"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainUpdateIndicator</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainUpdateIndicator</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M84"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">MultiProfile_MustNotContainTakeDown</xsl:attribute>
            <xsl:attribute name="name">MultiProfile_MustNotContainTakeDown</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M85"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericDownloadService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">GenericDownloadService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M86"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericDownloadService_UseType</xsl:attribute>
            <xsl:attribute name="name">GenericDownloadService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M87"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">GenericDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M88"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">GenericDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M89"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericDownloadService_Categories</xsl:attribute>
            <xsl:attribute name="name">GenericDownloadService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M90"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M91"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedDownloadService_UseType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedDownloadService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M92"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedDownloadService_DrmEnforcementType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedDownloadService_DrmEnforcementType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M93"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M94"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M95"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedDownloadService_Categories</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedDownloadService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M96"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M97"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedDownloadService_UseType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedDownloadService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M98"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedDownloadService_DrmEnforcementType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedDownloadService_DrmEnforcementType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M99"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M100"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M101"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedDownloadService_Categories</xsl:attribute>
            <xsl:attribute name="name">NonProtectedDownloadService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M102"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">AdSupportedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M103"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedDownloadService_UseType</xsl:attribute>
            <xsl:attribute name="name">AdSupportedDownloadService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M104"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">AdSupportedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M105"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">AdSupportedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M106"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedDownloadService_Categories</xsl:attribute>
            <xsl:attribute name="name">AdSupportedDownloadService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M107"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedAdSupportedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedAdSupportedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M108"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedAdSupportedDownloadService_UseType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedAdSupportedDownloadService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M109"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedAdSupportedDownloadService_DrmEnforcementType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedAdSupportedDownloadService_DrmEnforcementType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M110"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedAdSupportedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedAdSupportedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M111"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedAdSupportedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedAdSupportedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M112"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">DRMProtectedAdSupportedDownloadService_Categories</xsl:attribute>
            <xsl:attribute name="name">DRMProtectedAdSupportedDownloadService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M113"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedAdSupportedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedAdSupportedDownloadService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M114"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedAdSupportedDownloadService_UseType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedAdSupportedDownloadService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M115"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedAdSupportedDownloadService_DrmEnforcementType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedAdSupportedDownloadService_DrmEnforcementType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M116"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedAdSupportedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedAdSupportedDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M117"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedAdSupportedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">NonProtectedAdSupportedDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M118"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonProtectedAdSupportedDownloadService_Categories</xsl:attribute>
            <xsl:attribute name="name">NonProtectedAdSupportedDownloadService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M119"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TetheredDownloadService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">TetheredDownloadService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M120"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TetheredDownloadService_UseType</xsl:attribute>
            <xsl:attribute name="name">TetheredDownloadService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M121"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TetheredDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">TetheredDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M122"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TetheredDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">TetheredDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M123"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">TetheredDownloadService_Categories</xsl:attribute>
            <xsl:attribute name="name">TetheredDownloadService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M124"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedTetheredDownloadService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">AdSupportedTetheredDownloadService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M125"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedTetheredDownloadService_UseType</xsl:attribute>
            <xsl:attribute name="name">AdSupportedTetheredDownloadService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M126"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedTetheredDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">AdSupportedTetheredDownloadService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M127"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedTetheredDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">AdSupportedTetheredDownloadService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M128"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AdSupportedTetheredDownloadService_Categories</xsl:attribute>
            <xsl:attribute name="name">AdSupportedTetheredDownloadService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M129"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M130"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_UseType</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M131"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M132"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M133"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveSubscriptionStreamingService_Categories</xsl:attribute>
            <xsl:attribute name="name">InteractiveSubscriptionStreamingService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M134"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M135"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_UseType</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M136"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M137"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M138"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">InteractiveAdSupportedStreamingService_Categories</xsl:attribute>
            <xsl:attribute name="name">InteractiveAdSupportedStreamingService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M139"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M140"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_UseType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M141"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M142"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M143"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingService_Categories</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M144"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M145"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_UseType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M146"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M147"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M148"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveSubscriptionStreamingServiceOnDevice_Categories</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveSubscriptionStreamingServiceOnDevice_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M149"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M150"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_UseType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M151"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M152"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M153"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">NonInteractiveAdSupportedStreamingService_Categories</xsl:attribute>
            <xsl:attribute name="name">NonInteractiveAdSupportedStreamingService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M154"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">KioskService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">KioskService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M155"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">KioskService_UseType</xsl:attribute>
            <xsl:attribute name="name">KioskService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M156"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">KioskService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">KioskService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M157"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">KioskService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">KioskService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M158"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">KioskService_Categories</xsl:attribute>
            <xsl:attribute name="name">KioskService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M159"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RingtonesAndMobileService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">RingtonesAndMobileService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M160"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RingtonesAndMobileService_UseType</xsl:attribute>
            <xsl:attribute name="name">RingtonesAndMobileService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M161"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RingtonesAndMobileService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">RingtonesAndMobileService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M162"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RingtonesAndMobileService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">RingtonesAndMobileService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M163"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RingtonesAndMobileService_Categories</xsl:attribute>
            <xsl:attribute name="name">RingtonesAndMobileService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M164"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimsOnUserGeneratedContent_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">RightsClaimsOnUserGeneratedContent_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M165"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimsOnUserGeneratedContent_UseType</xsl:attribute>
            <xsl:attribute name="name">RightsClaimsOnUserGeneratedContent_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M166"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimsOnUserGeneratedContent_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">RightsClaimsOnUserGeneratedContent_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M167"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimsOnUserGeneratedContent_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">RightsClaimsOnUserGeneratedContent_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M168"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">RightsClaimsOnUserGeneratedContent_Categories</xsl:attribute>
            <xsl:attribute name="name">RightsClaimsOnUserGeneratedContent_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M169"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PurchaseAsPhysicalProduct_UseType</xsl:attribute>
            <xsl:attribute name="name">PurchaseAsPhysicalProduct_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M170"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PurchaseAsPhysicalProduct_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">PurchaseAsPhysicalProduct_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M171"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PurchaseAsPhysicalProduct_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">PurchaseAsPhysicalProduct_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M172"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">PurchaseAsPhysicalProduct_Categories</xsl:attribute>
            <xsl:attribute name="name">PurchaseAsPhysicalProduct_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M173"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M174"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_UseType</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M175"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M176"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M177"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericAdSupportedStreamingService_Categories</xsl:attribute>
            <xsl:attribute name="name">GenericAdSupportedStreamingService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M178"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M179"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_UseType</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M180"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M181"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M182"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericSubscriptionStreamingService_Categories</xsl:attribute>
            <xsl:attribute name="name">GenericSubscriptionStreamingService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M183"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_CommercialModelType</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_CommercialModelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M184"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_UseType</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_UseType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M185"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_UserInterfaceType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M186"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_DistributionChannelType</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M187"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">GenericPayAsYouGoStreamingService_Categories</xsl:attribute>
            <xsl:attribute name="name">GenericPayAsYouGoStreamingService_Categories</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M188"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron Business Profile for (version 1.4) for the NewReleaseMessage.</svrl:text>

   <!--PATTERN MultiProfile_PreviewDateShouldBeBeforeStartDate-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"
                 priority="1000"
                 mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','') or translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','') or translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: A ReleaseDisplayStartDate may not be later than the
            StartDate of the Deal.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Fatal Error-->
      <xsl:if test="TrackListingPreviewStartDate &gt; ../../EffectiveDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="TrackListingPreviewStartDate &gt; ../../EffectiveDate">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: A TrackListingPreviewStartDate may not be later than the StartDate of the
            Deal.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Fatal Error-->
      <xsl:if test="ClipPreviewStartDate &gt; ../../EffectiveDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="ClipPreviewStartDate &gt; ../../EffectiveDate">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal
            Error: A ClipPreviewStartDate may not be later than the StartDate of the
            Deal.</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Fatal Error-->
      <xsl:if test="CoverArtPreviewStartDate &gt; ../../EffectiveDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="CoverArtPreviewStartDate &gt; ../../EffectiveDate">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal
            Error: A CoverArtPreviewStartDate may not be later than the StartDate of the
            Deal.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>

   <!--PATTERN MultiProfile_BusinessProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Information-->
      <xsl:if test="some $x in tokenize(@BusinessProfileVersionId, '\s+') satisfies not(contains('CommonDealTypes/14/GenericDownloadService CommonDealTypes/14/DRMProtectedDownloadService CommonDealTypes/14/NonProtectedDownloadService CommonDealTypes/14/AdSupportedDownloadService CommonDealTypes/14/DRMProtectedAdSupportedDownloadService CommonDealTypes/14/NonProtectedAdSupportedDownloadService CommonDealTypes/14/TetheredDownloadService CommonDealTypes/14/AdSupportedTetheredDownloadService CommonDealTypes/14/InteractiveSubscriptionStreamingService CommonDealTypes/14/InteractiveAdSupportedStreamingService CommonDealTypes/14/NonInteractiveSubscriptionStreamingService CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice CommonDealTypes/14/NonInteractiveAdSupportedStreamingService CommonDealTypes/14/KioskService CommonDealTypes/14/RingtonesAndMobileService CommonDealTypes/14/RightsClaimsOnUserGeneratedContent CommonDealTypes/14/PurchaseAsPhysicalProduct CommonDealTypes/14/GenericAdSupportedStreamingService CommonDealTypes/14/GenericSubscriptionStreamingService  CommonDealTypes/14/GenericPayAsYouGoStreamingService',$x))">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="some $x in tokenize(@BusinessProfileVersionId, '\s+') satisfies not(contains('CommonDealTypes/14/GenericDownloadService CommonDealTypes/14/DRMProtectedDownloadService CommonDealTypes/14/NonProtectedDownloadService CommonDealTypes/14/AdSupportedDownloadService CommonDealTypes/14/DRMProtectedAdSupportedDownloadService CommonDealTypes/14/NonProtectedAdSupportedDownloadService CommonDealTypes/14/TetheredDownloadService CommonDealTypes/14/AdSupportedTetheredDownloadService CommonDealTypes/14/InteractiveSubscriptionStreamingService CommonDealTypes/14/InteractiveAdSupportedStreamingService CommonDealTypes/14/NonInteractiveSubscriptionStreamingService CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice CommonDealTypes/14/NonInteractiveAdSupportedStreamingService CommonDealTypes/14/KioskService CommonDealTypes/14/RingtonesAndMobileService CommonDealTypes/14/RightsClaimsOnUserGeneratedContent CommonDealTypes/14/PurchaseAsPhysicalProduct CommonDealTypes/14/GenericAdSupportedStreamingService CommonDealTypes/14/GenericSubscriptionStreamingService CommonDealTypes/14/GenericPayAsYouGoStreamingService',$x))">
            <xsl:attribute name="role">Information</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Information: The BusinessProfileVersionId should only contain values
            specified in the standard (Business Profile 1.4, Clause 4.1, Rule 2260-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MessageSchemaVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--ASSERT Information-->
      <xsl:choose>
         <xsl:when test="substring(@MessageSchemaVersionId, 1, 4) = 'ern/' and number(substring(@MessageSchemaVersionId, 5,2)) &gt;= 38"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring(@MessageSchemaVersionId, 1, 4) = 'ern/' and number(substring(@MessageSchemaVersionId, 5,2)) &gt;= 38">
               <xsl:attribute name="role">Information</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Information: The MessageSchemaVersionId should be at least 3.8
            (Business Profile 1.4, Clause 4.1, Rule 2261-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT Information-->
      <xsl:choose>
         <xsl:when test="@MessageSchemaVersionId = 'ern/38Draft'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@MessageSchemaVersionId = 'ern/38Draft'">
               <xsl:attribute name="role">Information</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Information:
            You are not using the latest XSD supported by this Schematron file (Business Profile
            1.4, Clause 4.1, Rule 2261-2).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>

   <!--PATTERN MultiProfile_TerritoryTIS-->


	  <!--RULE -->
   <xsl:template match="//TerritoryCode | //ExcludedTerritoryCode"
                 priority="1000"
                 mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="//TerritoryCode | //ExcludedTerritoryCode"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="substring(@IdentifierType, 1, 3) = 'TIS'">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="substring(@IdentifierType, 1, 3) = 'TIS'">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: A
            TerritoryCode of type 'TIS' must not be used (Business Profile 1.4, Clause 4.2(2), Rule
            2262-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainComment-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/MessageHeader"
                 priority="1000"
                 mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/MessageHeader"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="//Comment">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//Comment">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: No Comment shall be provided in
            the MessageHeader (Business Profile 1.4, Clause 4.2(3), Rule 2263-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainLanguageAndScriptCode-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal"
                 priority="1000"
                 mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="descendant::*/@LanguageAndScriptCode">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="descendant::*/@LanguageAndScriptCode">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The
            use of LanguageAndScriptCode is discouraged (Business Profile 1.4, Clause 4.3.2(1), Rule
            2264-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainCatalogTransfer-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Conditional Fatal Error-->
      <xsl:if test="CatalogTransfer">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="CatalogTransfer">
            <xsl:attribute name="role">Conditional Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Conditional Fatal Error:
            The use of CatalogTransfer is discouraged (Business Profile 1.4, Clause 4.3.2(2), Rule
            2265-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainBulkOrderWholesalePricePerUnit-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation"
                 priority="1000"
                 mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation"/>

		    <!--REPORT Error-->
      <xsl:if test="BulkOrderWholesalePricePerUnit">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="BulkOrderWholesalePricePerUnit">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of
            BulkOrderWholesalePricePerUnit is discouraged (Business Profile 1.4, Clause 4.3.2(4),
            Rule 2266-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainRelatedReleaseOfferSet-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="RelatedReleaseOfferSet">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="RelatedReleaseOfferSet">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The use of
            RelatedReleaseOfferSet is discouraged (Business Profile 1.4, Clause 4.3.2(5), Rule
            2267-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainCarrierType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct'))]"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct'))]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="//CarrierType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//CarrierType">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The use of CarrierType is
            discouraged except for PurchaseAsPhysicalProduct (Business Profile 1.4, Clause 4.3.2(6),
            Rule 2268-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainPhysicalReturns-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"
                 priority="1000"
                 mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="PhysicalReturns">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="PhysicalReturns">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The use of PhysicalReturns
            is discouraged (Business Profile 1.4, Clause 4.3.2(7), Rule 2269-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainNumberOfProductsPerCarton-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"
                 priority="1000"
                 mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="NumberOfProductsPerCarton">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="NumberOfProductsPerCarton">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The use of
            NumberOfProductsPerCarton is discouraged (Business Profile 1.4, Clause 4.3.2(8), Rule
            2270-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainResourceUsage-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="ResourceUsage">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ResourceUsage">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The use of ResourceUsage is
            discouraged (Business Profile 1.4, Clause 4.3.2(10), Rule 2271-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN MultiProfile_GenericUseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal"
                 priority="1000"
                 mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="//Usage[UseType='Stream']/UseType[matches(text(),'.Stream')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="//Usage[UseType='Stream']/UseType[matches(text(),'.Stream')]">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The combination of generic and specific UseTypes is not
            permitted (Business Profile 1.4, Clause 4.3.2(12), Rule 2272-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Fatal Error-->
      <xsl:if test="//Usage[UseType='Download']/UseType[matches(text(),'.Download')]">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="//Usage[UseType='Download']/UseType[matches(text(),'.Download')]">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The combination of generic and specific UseTypes is not
            permitted (Business Profile 1.4, Clause 4.3.2(12), Rule 2272-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN MultiProfile_SpecificUseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal"
                 priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="//Usage[UseType='InteractiveStream' and UseType='NonInteractiveStream' and UseType='ContentInfluencedStream' and UseType='OnDemandStream' and UseType='TimeInfluencedStream']">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="//Usage[UseType='InteractiveStream' and UseType='NonInteractiveStream' and UseType='ContentInfluencedStream' and UseType='OnDemandStream' and UseType='TimeInfluencedStream']">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The use of all specific UseTypes is not permitted
            (Business Profile 1.4, Clause 4.3.2(13), Rule 2273-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Fatal Error-->
      <xsl:if test="//Usage[UseType='ConditionalDownload' and UseType='KioskDownload' and UseType='PermanentDownload' and UseType='TetheredDownload']">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="//Usage[UseType='ConditionalDownload' and UseType='KioskDownload' and UseType='PermanentDownload' and UseType='TetheredDownload']">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The use of all specific UseTypes is not permitted
            (Business Profile 1.4, Clause 4.3.2(13), Rule 2273-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN GenericDownloadService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.3(5), Rule 2274-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN DRMProtectedDownloadService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.4(5), Rule 2275-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN NonProtectedDownloadService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.5(5), Rule 2276-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN AdSupportedDownloadService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.6(5), Rule 2277-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN DRMProtectedAdSupportedDownloadService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.7(5), Rule 2278-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN NonProtectedAdSupportedDownloadService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.8(5), Rule 2279-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN TetheredDownloadService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.9(5), Rule 2280-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN AdSupportedTetheredDownloadService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.10(5), Rule 2281-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.11(5), Rule 2282-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.12(5), Rule 2283-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.13(5), Rule 2284-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.14(5), Rule 2285-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.15(5), Rule 2286-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>

   <!--PATTERN KioskService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.16(4), Rule 2287-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>

   <!--PATTERN RingtonesAndMobileService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.17(5), Rule 2288-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>

   <!--PATTERN RightsClaimsOnUserGeneratedContent_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.18(7), Rule 2289-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>

   <!--PATTERN PurchaseAsPhysicalProduct_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"
                 priority="1000"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: No CommercialModelType should be specified for this Profile (Business
            Profile 1.4, Clause 4.3.19(4), Rule 2290-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>

   <!--PATTERN PurchaseAsPhysicalProduct_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.19(7), Rule 2291-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.20(5), Rule 2292-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_UseType2-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Narrowcast' or text() = 'NonInteractiveStream' or text() = 'OnDemandStream' or text() = 'TimeInfluencedStream' or text() = 'Webcast']">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Narrowcast' or text() = 'NonInteractiveStream' or text() = 'OnDemandStream' or text() = 'TimeInfluencedStream' or text() = 'Webcast']">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The UseType should not be a detailed streaming service
            for this Profile (Business Profile 1.4, Clause 4.3.20(8), Rule 2293-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.21(5), Rule 2294-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_UseType2-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Narrowcast' or text() = 'NonInteractiveStream' or text() = 'OnDemandStream' or text() = 'TimeInfluencedStream' or text() = 'Webcast']">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Narrowcast' or text() = 'NonInteractiveStream' or text() = 'OnDemandStream' or text() = 'TimeInfluencedStream' or text() = 'Webcast']">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The UseType should not be a detailed streaming service
            for this Profile (Business Profile 1.4, Clause 4.3.21(8), Rule 2295-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_ConsumerRentalPeriod-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.22(5), Rule 2296-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_UseType2-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Narrowcast' or text() = 'NonInteractiveStream' or text() = 'OnDemandStream' or text() = 'TimeInfluencedStream' or text() = 'Webcast']">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Narrowcast' or text() = 'NonInteractiveStream' or text() = 'OnDemandStream' or text() = 'TimeInfluencedStream' or text() = 'Webcast']">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: The UseType should not be a detailed streaming service
            for this Profile (Business Profile 1.4, Clause 4.3.22(8), Rule 2297-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.11(6), Rule 2298-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.11(6), Rule 2298-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/AudioSingle' (Business Profile 1.4, Clause 4.3.11(7),
            Rule 2299-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_NoGenericBusinessProfile-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.11(8), Rule
            2300-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_MustNotContainPriceInformation-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.11(9), Rule
            2301-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.12(6), Rule 2302-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.12(6), Rule 2302-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/AudioSingle' (Business Profile 1.4, Clause 4.3.12(7),
            Rule 2303-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_NoGenericBusinessProfile-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.12(8), Rule
            2304-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_MustNotContainPriceInformation-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.12(9), Rule
            2305-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"
                 priority="1000"
                 mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.13(6), Rule 2306-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.13(6), Rule 2306-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/AudioSingle' (Business Profile 1.4, Clause 4.3.13(7),
            Rule 2307-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_NoGenericBusinessProfile-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"
                 priority="1000"
                 mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.13(8), Rule
            2308-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_MustNotContainPriceInformation-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"
                 priority="1000"
                 mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.13(9), Rule
            2309-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"
                 priority="1000"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.14(6), Rule 2310-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.14(6), Rule 2310-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"
                 priority="1000"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/AudioSingle' (Business Profile 1.4, Clause 4.3.14(7),
            Rule 2311-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_NoGenericBusinessProfile-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"
                 priority="1000"
                 mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.14(8), Rule
            2312-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_MustNotContainPriceInformation-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"
                 priority="1000"
                 mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.14(9), Rule
            2313-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.15(6), Rule 2314-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.15(6), Rule 2314-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/AudioSingle' (Business Profile 1.4, Clause 4.3.15(7),
            Rule 2315-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_NoGenericBusinessProfile-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.15(8), Rule
            2316-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_MustNotContainPriceInformation-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.15(9), Rule
            2317-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>

   <!--PATTERN KioskService_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"
                 priority="1000"
                 mode="M65">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.16(5), Rule 2318-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.16(5), Rule 2318-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>

   <!--PATTERN RingtonesAndMobileService_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"
                 priority="1000"
                 mode="M66">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.17(6), Rule 2319-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.17(6), Rule 2319-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>

   <!--PATTERN RingtonesAndMobileService_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"
                 priority="1000"
                 mode="M67">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"/>

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
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/Ringtone' (Business Profile 1.4, Clause 4.3.17(7), Rule
            2320-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>

   <!--PATTERN RightsClaimsOnUserGeneratedContent_RightsClaimPolicy2-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/RightsClaimPolicy"
                 priority="1000"
                 mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/RightsClaimPolicy"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent' if a RightsClaimPolicy is
            provided (Business Profile 1.4, Clause 4.3.18(3), Rule 2321-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>

   <!--PATTERN RightsClaimsOnUserGeneratedContent_WebPolicy-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/WebPolicy"
                 priority="1000"
                 mode="M69">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/WebPolicy"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent' if a WebPolicy is provided
            (Business Profile 1.4, Clause 4.3.18(4), Rule 2322-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>

   <!--PATTERN RightsClaimsOnUserGeneratedContent_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"
                 priority="1000"
                 mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.18(8), Rule 2323-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.18(8), Rule 2323-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>

   <!--PATTERN PurchaseAsPhysicalProduct_CarrierType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains (@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"
                 priority="1000"
                 mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains (@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="//CarrierType"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//CarrierType">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: A CarrierType shall be
            specified for this Profile (Business Profile 1.4, Clause 4.3.19(3), Rule
            2324-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M72">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.20(6), Rule 2325-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.20(6), Rule 2325-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/AudioSingle' (Business Profile 1.4, Clause 4.3.20(7),
            Rule 2326-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_MustNotContainPriceInformation-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.20(9), Rule
            2327-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M75">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.21(6), Rule 2328-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.21(6), Rule 2328-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/AudioSingle' (Business Profile 1.4, Clause 4.3.21(7),
            Rule 2329-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_MustNotContainPriceInformation-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M77">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.21(9), Rule
            2330-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_MustNotContainDates-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"
                 priority="1000"
                 mode="M78">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.22(6), Rule 2331-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.22(6), Rule 2331-2).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_ReleaseProfileVersionId-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"
                 priority="1000"
                 mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/AudioSingle' (Business Profile 1.4, Clause 4.3.22(7),
            Rule 2332-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_MustNotContainPriceInformation-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"
                 priority="1000"
                 mode="M80">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.22(9), Rule
            2333-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainPriceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation[BulkOrderWholesalePricePerUnit] | *:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation[WholesalePricePerUnit]"
                 priority="1000"
                 mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation[BulkOrderWholesalePricePerUnit] | *:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation[WholesalePricePerUnit]"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="PriceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="PriceType">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: WholesalePricePerUnit and
            BulkOrderWholesalePricePerUnit may not be combined with a PriceType (Business Profile
            1.4, Clause 4.6(3), Rule 2334-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainEffectiveDate-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal"
                 priority="1000"
                 mode="M82">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="EffectiveDate">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="EffectiveDate">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: An EffectiveDate must not be
            specified (Business Profile 1.4, Clause 4.7.1(3), Rule 2335-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M82"/>
   <xsl:template match="@*|node()" priority="-2" mode="M82">
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainAllDealsCancelled-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"
                 priority="1000"
                 mode="M83">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="AllDealsCancelled">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="AllDealsCancelled">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: AllDealsCancelled must
            not be specified (Business Profile 1.4, Clause 4.7.1(4)+4.7.4(1c)+4.7.4(2c), Rule
            2336-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M83"/>
   <xsl:template match="@*|node()" priority="-2" mode="M83">
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainUpdateIndicator-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage" priority="1000" mode="M84">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*:NewReleaseMessage"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="UpdateIndicator">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="UpdateIndicator">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: UpdateIndicator shall not
            be used (Business Profile 1.4, Clause 4.7.2, Rule 2337-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M84"/>
   <xsl:template match="@*|node()" priority="-2" mode="M84">
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>

   <!--PATTERN MultiProfile_MustNotContainTakeDown-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"
                 priority="1000"
                 mode="M85">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms"/>

		    <!--REPORT Fatal Error-->
      <xsl:if test="TakeDown">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="TakeDown">
            <xsl:attribute name="role">Fatal Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Fatal Error: TakeDown must not be specified
            (Business Profile 1.4, Clause 4.7.4(1c)+4.7.4(2c), Rule 2338-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>

   <!--PATTERN GenericDownloadService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]"
                 priority="1000"
                 mode="M86">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(1), Rule 2339-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>

   <!--PATTERN GenericDownloadService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]"
                 priority="1000"
                 mode="M87">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(1), Rule 2340-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>

   <!--PATTERN GenericDownloadService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]"
                 priority="1000"
                 mode="M88">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(1), Rule 2341-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>

   <!--PATTERN GenericDownloadService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]"
                 priority="1000"
                 mode="M89">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(1), Rule 2342-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M89"/>
   <xsl:template match="@*|node()" priority="-2" mode="M89">
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>

   <!--PATTERN GenericDownloadService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() != 'DrmEnforced']][Usage/TechnicalInstantiation/DrmEnforcementType[text() != 'NotDrmEnforced']]"
                 priority="1000"
                 mode="M90">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() != 'DrmEnforced']][Usage/TechnicalInstantiation/DrmEnforcementType[text() != 'NotDrmEnforced']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/GenericDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(1), Rule 2343-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M90"/>
   <xsl:template match="@*|node()" priority="-2" mode="M90">
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>

   <!--PATTERN DRMProtectedDownloadService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"
                 priority="1000"
                 mode="M91">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(2), Rule 2344-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M91"/>
   <xsl:template match="@*|node()" priority="-2" mode="M91">
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>

   <!--PATTERN DRMProtectedDownloadService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"
                 priority="1000"
                 mode="M92">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(2), Rule 2345-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M92"/>
   <xsl:template match="@*|node()" priority="-2" mode="M92">
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>

   <!--PATTERN DRMProtectedDownloadService_DrmEnforcementType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"
                 priority="1000"
                 mode="M93">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The DrmEnforcementType should be DrmEnforced for this
            Profile (Business Profile 1.4, Clause 3(2), Rule 2346-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M93"/>
   <xsl:template match="@*|node()" priority="-2" mode="M93">
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>

   <!--PATTERN DRMProtectedDownloadService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"
                 priority="1000"
                 mode="M94">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(2), Rule 2347-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M94"/>
   <xsl:template match="@*|node()" priority="-2" mode="M94">
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>

   <!--PATTERN DRMProtectedDownloadService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"
                 priority="1000"
                 mode="M95">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(2), Rule 2348-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M95"/>
   <xsl:template match="@*|node()" priority="-2" mode="M95">
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>

   <!--PATTERN DRMProtectedDownloadService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']]"
                 priority="1000"
                 mode="M96">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/DRMProtectedDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(2), Rule 2349-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M96"/>
   <xsl:template match="@*|node()" priority="-2" mode="M96">
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>

   <!--PATTERN NonProtectedDownloadService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"
                 priority="1000"
                 mode="M97">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(3), Rule 2350-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M97"/>
   <xsl:template match="@*|node()" priority="-2" mode="M97">
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>

   <!--PATTERN NonProtectedDownloadService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"
                 priority="1000"
                 mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(3), Rule 2351-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M98"/>
   <xsl:template match="@*|node()" priority="-2" mode="M98">
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>

   <!--PATTERN NonProtectedDownloadService_DrmEnforcementType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"
                 priority="1000"
                 mode="M99">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The DrmEnforcementType should be NotDrmEnforced for this
            Profile (Business Profile 1.4, Clause 3(3), Rule 2352-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M99"/>
   <xsl:template match="@*|node()" priority="-2" mode="M99">
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>

   <!--PATTERN NonProtectedDownloadService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"
                 priority="1000"
                 mode="M100">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(3), Rule 2353-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M100"/>
   <xsl:template match="@*|node()" priority="-2" mode="M100">
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>

   <!--PATTERN NonProtectedDownloadService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"
                 priority="1000"
                 mode="M101">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(3), Rule 2354-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M101"/>
   <xsl:template match="@*|node()" priority="-2" mode="M101">
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>

   <!--PATTERN NonProtectedDownloadService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']]"
                 priority="1000"
                 mode="M102">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonProtectedDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(3), Rule 2355-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M102"/>
   <xsl:template match="@*|node()" priority="-2" mode="M102">
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>

   <!--PATTERN AdSupportedDownloadService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]"
                 priority="1000"
                 mode="M103">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(4), Rule
            2356-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M103"/>
   <xsl:template match="@*|node()" priority="-2" mode="M103">
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>

   <!--PATTERN AdSupportedDownloadService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]"
                 priority="1000"
                 mode="M104">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(4), Rule 2357-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M104"/>
   <xsl:template match="@*|node()" priority="-2" mode="M104">
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>

   <!--PATTERN AdSupportedDownloadService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]"
                 priority="1000"
                 mode="M105">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(4), Rule 2358-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M105"/>
   <xsl:template match="@*|node()" priority="-2" mode="M105">
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>

   <!--PATTERN AdSupportedDownloadService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]"
                 priority="1000"
                 mode="M106">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(4), Rule 2359-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M106"/>
   <xsl:template match="@*|node()" priority="-2" mode="M106">
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>

   <!--PATTERN AdSupportedDownloadService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() != 'DrmEnforced' and text() != 'NotDrmEnforced']]"
                 priority="1000"
                 mode="M107">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() != 'DrmEnforced' and text() != 'NotDrmEnforced']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/AdSupportedDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(4), Rule 2360-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M107"/>
   <xsl:template match="@*|node()" priority="-2" mode="M107">
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>

   <!--PATTERN DRMProtectedAdSupportedDownloadService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M108">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(5), Rule
            2361-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M108"/>
   <xsl:template match="@*|node()" priority="-2" mode="M108">
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>

   <!--PATTERN DRMProtectedAdSupportedDownloadService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M109">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(5), Rule 2362-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M109"/>
   <xsl:template match="@*|node()" priority="-2" mode="M109">
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>

   <!--PATTERN DRMProtectedAdSupportedDownloadService_DrmEnforcementType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M110">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The DrmEnforcementType should be DrmEnforced for this
            Profile (Business Profile 1.4, Clause 3(5), Rule 2363-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M110"/>
   <xsl:template match="@*|node()" priority="-2" mode="M110">
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>

   <!--PATTERN DRMProtectedAdSupportedDownloadService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M111">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(5), Rule 2364-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M111"/>
   <xsl:template match="@*|node()" priority="-2" mode="M111">
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>

   <!--PATTERN DRMProtectedAdSupportedDownloadService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M112">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(5), Rule 2365-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M112"/>
   <xsl:template match="@*|node()" priority="-2" mode="M112">
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>

   <!--PATTERN DRMProtectedAdSupportedDownloadService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']]"
                 priority="1000"
                 mode="M113">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService' for this combination of
            categories (Business Profile 1.4, Clause 3(5), Rule 2366-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M113"/>
   <xsl:template match="@*|node()" priority="-2" mode="M113">
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>

   <!--PATTERN NonProtectedAdSupportedDownloadService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M114">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(6), Rule
            2367-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M114"/>
   <xsl:template match="@*|node()" priority="-2" mode="M114">
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>

   <!--PATTERN NonProtectedAdSupportedDownloadService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M115">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(6), Rule 2368-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M115"/>
   <xsl:template match="@*|node()" priority="-2" mode="M115">
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>

   <!--PATTERN NonProtectedAdSupportedDownloadService_DrmEnforcementType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M116">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The DrmEnforcementType should be NotDrmEnforced for this
            Profile (Business Profile 1.4, Clause 3(6), Rule 2369-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M116"/>
   <xsl:template match="@*|node()" priority="-2" mode="M116">
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>

   <!--PATTERN NonProtectedAdSupportedDownloadService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M117">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(6), Rule 2370-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M117"/>
   <xsl:template match="@*|node()" priority="-2" mode="M117">
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>

   <!--PATTERN NonProtectedAdSupportedDownloadService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"
                 priority="1000"
                 mode="M118">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(6), Rule 2371-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M118"/>
   <xsl:template match="@*|node()" priority="-2" mode="M118">
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>

   <!--PATTERN NonProtectedAdSupportedDownloadService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']]"
                 priority="1000"
                 mode="M119">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonProtectedAdSupportedDownloadService' for this combination of
            categories (Business Profile 1.4, Clause 3(6), Rule 2372-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M119"/>
   <xsl:template match="@*|node()" priority="-2" mode="M119">
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>

   <!--PATTERN TetheredDownloadService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]"
                 priority="1000"
                 mode="M120">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be SubscriptionModel for
            this Profile (Business Profile 1.4, Clause 3(7), Rule 2373-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M120"/>
   <xsl:template match="@*|node()" priority="-2" mode="M120">
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>

   <!--PATTERN TetheredDownloadService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]"
                 priority="1000"
                 mode="M121">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'ConditionalDownload']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'ConditionalDownload']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be ConditionalDownload for this
            Profile (Business Profile 1.4, Clause 3(7), Rule 2374-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M121"/>
   <xsl:template match="@*|node()" priority="-2" mode="M121">
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>

   <!--PATTERN TetheredDownloadService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]"
                 priority="1000"
                 mode="M122">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(7), Rule 2375-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M122"/>
   <xsl:template match="@*|node()" priority="-2" mode="M122">
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>

   <!--PATTERN TetheredDownloadService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]"
                 priority="1000"
                 mode="M123">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(7), Rule 2376-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M123"/>
   <xsl:template match="@*|node()" priority="-2" mode="M123">
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>

   <!--PATTERN TetheredDownloadService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'ConditionalDownload']]"
                 priority="1000"
                 mode="M124">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'ConditionalDownload']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/TetheredDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(7), Rule 2377-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M124"/>
   <xsl:template match="@*|node()" priority="-2" mode="M124">
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>

   <!--PATTERN AdSupportedTetheredDownloadService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]"
                 priority="1000"
                 mode="M125">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(8), Rule
            2378-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M125"/>
   <xsl:template match="@*|node()" priority="-2" mode="M125">
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>

   <!--PATTERN AdSupportedTetheredDownloadService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]"
                 priority="1000"
                 mode="M126">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'ConditionalDownload']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'ConditionalDownload']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be ConditionalDownload for this
            Profile (Business Profile 1.4, Clause 3(8), Rule 2379-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M126"/>
   <xsl:template match="@*|node()" priority="-2" mode="M126">
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>

   <!--PATTERN AdSupportedTetheredDownloadService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]"
                 priority="1000"
                 mode="M127">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(8), Rule 2380-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M127"/>
   <xsl:template match="@*|node()" priority="-2" mode="M127">
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>

   <!--PATTERN AdSupportedTetheredDownloadService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]"
                 priority="1000"
                 mode="M128">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(8), Rule 2381-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M128"/>
   <xsl:template match="@*|node()" priority="-2" mode="M128">
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>

   <!--PATTERN AdSupportedTetheredDownloadService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'ConditionalDownload']]"
                 priority="1000"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'ConditionalDownload']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/AdSupportedTetheredDownloadService' for this combination of
            categories (Business Profile 1.4, Clause 3(8), Rule 2382-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M129"/>
   <xsl:template match="@*|node()" priority="-2" mode="M129">
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M130">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be SubscriptionModel for
            this Profile (Business Profile 1.4, Clause 3(9), Rule 2383-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M130"/>
   <xsl:template match="@*|node()" priority="-2" mode="M130">
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M131">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'OnDemandStream']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'OnDemandStream']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be OnDemandStream for this Profile
            (Business Profile 1.4, Clause 3(9), Rule 2384-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M131"/>
   <xsl:template match="@*|node()" priority="-2" mode="M131">
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M132">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(9), Rule 2385-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M132"/>
   <xsl:template match="@*|node()" priority="-2" mode="M132">
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M133">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(9), Rule 2386-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M133"/>
   <xsl:template match="@*|node()" priority="-2" mode="M133">
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>

   <!--PATTERN InteractiveSubscriptionStreamingService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'OnDemandStream']]"
                 priority="1000"
                 mode="M134">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'OnDemandStream']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/InteractiveSubscriptionStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(9), Rule 2387-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M134"/>
   <xsl:template match="@*|node()" priority="-2" mode="M134">
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M135">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(10), Rule
            2388-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M135"/>
   <xsl:template match="@*|node()" priority="-2" mode="M135">
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M136">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'OnDemandStream']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'OnDemandStream']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be OnDemandStream for this Profile
            (Business Profile 1.4, Clause 3(10), Rule 2389-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M136"/>
   <xsl:template match="@*|node()" priority="-2" mode="M136">
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M137">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(10), Rule 2390-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M137"/>
   <xsl:template match="@*|node()" priority="-2" mode="M137">
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M138">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(10), Rule 2391-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M138"/>
   <xsl:template match="@*|node()" priority="-2" mode="M138">
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>

   <!--PATTERN InteractiveAdSupportedStreamingService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertismentSupportedModel']][Usage/UseType[text() = 'OnDemandStream']]"
                 priority="1000"
                 mode="M139">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertismentSupportedModel']][Usage/UseType[text() = 'OnDemandStream']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/InteractiveAdSupportedStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(10), Rule 2392-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M139"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M139"/>
   <xsl:template match="@*|node()" priority="-2" mode="M139">
      <xsl:apply-templates select="*" mode="M139"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"
                 priority="1000"
                 mode="M140">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be SubscriptionModel for
            this Profile (Business Profile 1.4, Clause 3(11), Rule 2393-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M140"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M140"/>
   <xsl:template match="@*|node()" priority="-2" mode="M140">
      <xsl:apply-templates select="*" mode="M140"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"
                 priority="1000"
                 mode="M141">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'NonInteractiveStream']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'NonInteractiveStream']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be NonInteractiveStream for this
            Profile (Business Profile 1.4, Clause 3(11), Rule 2394-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M141"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M141"/>
   <xsl:template match="@*|node()" priority="-2" mode="M141">
      <xsl:apply-templates select="*" mode="M141"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"
                 priority="1000"
                 mode="M142">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(11), Rule 2395-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M142"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M142"/>
   <xsl:template match="@*|node()" priority="-2" mode="M142">
      <xsl:apply-templates select="*" mode="M142"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"
                 priority="1000"
                 mode="M143">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService') and not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice'))]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(11), Rule 2396-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M143"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M143"/>
   <xsl:template match="@*|node()" priority="-2" mode="M143">
      <xsl:apply-templates select="*" mode="M143"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'NonInteractiveStream']]"
                 priority="1000"
                 mode="M144">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'NonInteractiveStream']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(/*:NewReleaseMessage/@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(/*:NewReleaseMessage/@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(11), Rule 2397-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M144"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M144"/>
   <xsl:template match="@*|node()" priority="-2" mode="M144">
      <xsl:apply-templates select="*" mode="M144"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"
                 priority="1000"
                 mode="M145">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'DeviceFeeModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'DeviceFeeModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be DeviceFeeModel for
            this Profile (Business Profile 1.4, Clause 3(12), Rule 2398-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M145"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M145"/>
   <xsl:template match="@*|node()" priority="-2" mode="M145">
      <xsl:apply-templates select="*" mode="M145"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"
                 priority="1000"
                 mode="M146">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'NonInteractiveStream']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'NonInteractiveStream']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be NonInteractiveStream for this
            Profile (Business Profile 1.4, Clause 3(12), Rule 2399-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M146"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M146"/>
   <xsl:template match="@*|node()" priority="-2" mode="M146">
      <xsl:apply-templates select="*" mode="M146"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"
                 priority="1000"
                 mode="M147">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(12), Rule 2400-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M147"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M147"/>
   <xsl:template match="@*|node()" priority="-2" mode="M147">
      <xsl:apply-templates select="*" mode="M147"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"
                 priority="1000"
                 mode="M148">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(12), Rule 2401-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M148"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M148"/>
   <xsl:template match="@*|node()" priority="-2" mode="M148">
      <xsl:apply-templates select="*" mode="M148"/>
   </xsl:template>

   <!--PATTERN NonInteractiveSubscriptionStreamingServiceOnDevice_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'DeviceFeeModel']][Usage/UseType[text() = 'NonInteractiveStream']]"
                 priority="1000"
                 mode="M149">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'DeviceFeeModel']][Usage/UseType[text() = 'NonInteractiveStream']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice' for this
            combination of categories (Business Profile 1.4, Clause 3(12), Rule 2402-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M149"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M149"/>
   <xsl:template match="@*|node()" priority="-2" mode="M149">
      <xsl:apply-templates select="*" mode="M149"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M150">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(13), Rule
            2403-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M150"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M150"/>
   <xsl:template match="@*|node()" priority="-2" mode="M150">
      <xsl:apply-templates select="*" mode="M150"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M151">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'NonInteractiveStream']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'NonInteractiveStream']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be NonInteractiveStream for this
            Profile (Business Profile 1.4, Clause 3(13), Rule 2404-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M151"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M151"/>
   <xsl:template match="@*|node()" priority="-2" mode="M151">
      <xsl:apply-templates select="*" mode="M151"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M152">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(13), Rule 2405-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M152"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M152"/>
   <xsl:template match="@*|node()" priority="-2" mode="M152">
      <xsl:apply-templates select="*" mode="M152"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M153">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(13), Rule 2406-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M153"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M153"/>
   <xsl:template match="@*|node()" priority="-2" mode="M153">
      <xsl:apply-templates select="*" mode="M153"/>
   </xsl:template>

   <!--PATTERN NonInteractiveAdSupportedStreamingService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertismentSupportedModel']][Usage/UseType[text() = 'NonInteractiveStream']]"
                 priority="1000"
                 mode="M154">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertismentSupportedModel']][Usage/UseType[text() = 'NonInteractiveStream']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(13), Rule 2407-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M154"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M154"/>
   <xsl:template match="@*|node()" priority="-2" mode="M154">
      <xsl:apply-templates select="*" mode="M154"/>
   </xsl:template>

   <!--PATTERN KioskService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"
                 priority="1000"
                 mode="M155">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(14), Rule 2408-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M155"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M155"/>
   <xsl:template match="@*|node()" priority="-2" mode="M155">
      <xsl:apply-templates select="*" mode="M155"/>
   </xsl:template>

   <!--PATTERN KioskService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"
                 priority="1000"
                 mode="M156">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(14), Rule 2409-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M156"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M156"/>
   <xsl:template match="@*|node()" priority="-2" mode="M156">
      <xsl:apply-templates select="*" mode="M156"/>
   </xsl:template>

   <!--PATTERN KioskService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"
                 priority="1000"
                 mode="M157">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType[text() = 'Kiosk']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType[text() = 'Kiosk']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UserInterfaceType should be Kiosk for this Profile
            (Business Profile 1.4, Clause 3(14), Rule 2410-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M157"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M157"/>
   <xsl:template match="@*|node()" priority="-2" mode="M157">
      <xsl:apply-templates select="*" mode="M157"/>
   </xsl:template>

   <!--PATTERN KioskService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"
                 priority="1000"
                 mode="M158">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(14), Rule 2411-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M158"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M158"/>
   <xsl:template match="@*|node()" priority="-2" mode="M158">
      <xsl:apply-templates select="*" mode="M158"/>
   </xsl:template>

   <!--PATTERN KioskService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDonwload']][Usage/UserInterfaceType[text() = 'Kiosk']]"
                 priority="1000"
                 mode="M159">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDonwload']][Usage/UserInterfaceType[text() = 'Kiosk']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/KioskService' for this combination of categories (Business Profile
            1.4, Clause 3(14), Rule 2412-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M159"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M159"/>
   <xsl:template match="@*|node()" priority="-2" mode="M159">
      <xsl:apply-templates select="*" mode="M159"/>
   </xsl:template>

   <!--PATTERN RingtonesAndMobileService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"
                 priority="1000"
                 mode="M160">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(15), Rule 2413-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M160"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M160"/>
   <xsl:template match="@*|node()" priority="-2" mode="M160">
      <xsl:apply-templates select="*" mode="M160"/>
   </xsl:template>

   <!--PATTERN RingtonesAndMobileService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"
                 priority="1000"
                 mode="M161">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[starts-with(text(),'UseAs')][ends-with(text(),'one')]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[starts-with(text(),'UseAs')][ends-with(text(),'one')]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be UseAsRingtone, UseAsRingbackTone
            or UseAsAlertTone for this Profile (Business Profile 1.4, Clause 3(15), Rule
            2414-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M161"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M161"/>
   <xsl:template match="@*|node()" priority="-2" mode="M161">
      <xsl:apply-templates select="*" mode="M161"/>
   </xsl:template>

   <!--PATTERN RingtonesAndMobileService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"
                 priority="1000"
                 mode="M162">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(15), Rule 2415-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M162"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M162"/>
   <xsl:template match="@*|node()" priority="-2" mode="M162">
      <xsl:apply-templates select="*" mode="M162"/>
   </xsl:template>

   <!--PATTERN RingtonesAndMobileService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"
                 priority="1000"
                 mode="M163">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(15), Rule 2416-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M163"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M163"/>
   <xsl:template match="@*|node()" priority="-2" mode="M163">
      <xsl:apply-templates select="*" mode="M163"/>
   </xsl:template>

   <!--PATTERN RingtonesAndMobileService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[starts-with(text(),'UseAs')][ends-with(text(),'one')]]"
                 priority="1000"
                 mode="M164">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[starts-with(text(),'UseAs')][ends-with(text(),'one')]]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/RingtonesAndMobileService' for this combination of categories
            (Business Profile 1.4, Clause 3(15), Rule 2417-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M164"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M164"/>
   <xsl:template match="@*|node()" priority="-2" mode="M164">
      <xsl:apply-templates select="*" mode="M164"/>
   </xsl:template>

   <!--PATTERN RightsClaimsOnUserGeneratedContent_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"
                 priority="1000"
                 mode="M165">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'RightsClaimModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'RightsClaimModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be RightsClaimModel for
            this Profile (Business Profile 1.4, Clause 3(16), Rule 2418-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M165"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M165"/>
   <xsl:template match="@*|node()" priority="-2" mode="M165">
      <xsl:apply-templates select="*" mode="M165"/>
   </xsl:template>

   <!--PATTERN RightsClaimsOnUserGeneratedContent_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"
                 priority="1000"
                 mode="M166">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[starts-with(text(),'UserMakeAvailable')]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[starts-with(text(),'UserMakeAvailable')]">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be UserMakeAvailableLabelProvided or
            UserMakeAvailableUserProvided for this Profile (Business Profile 1.4, Clause 3(16), Rule
            2419-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M166"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M166"/>
   <xsl:template match="@*|node()" priority="-2" mode="M166">
      <xsl:apply-templates select="*" mode="M166"/>
   </xsl:template>

   <!--PATTERN RightsClaimsOnUserGeneratedContent_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"
                 priority="1000"
                 mode="M167">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(16), Rule 2420-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M167"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M167"/>
   <xsl:template match="@*|node()" priority="-2" mode="M167">
      <xsl:apply-templates select="*" mode="M167"/>
   </xsl:template>

   <!--PATTERN RightsClaimsOnUserGeneratedContent_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"
                 priority="1000"
                 mode="M168">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(16), Rule 2421-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M168"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M168"/>
   <xsl:template match="@*|node()" priority="-2" mode="M168">
      <xsl:apply-templates select="*" mode="M168"/>
   </xsl:template>

   <!--PATTERN RightsClaimsOnUserGeneratedContent_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'RightsClaimModel']][Usage/UseType[starts-with(text(),'UserMakeAvailable')]]"
                 priority="1000"
                 mode="M169">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'RightsClaimModel']][Usage/UseType[starts-with(text(),'UserMakeAvailable')]]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent' for this combination of
            categories (Business Profile 1.4, Clause 3(16), Rule 2422-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M169"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M169"/>
   <xsl:template match="@*|node()" priority="-2" mode="M169">
      <xsl:apply-templates select="*" mode="M169"/>
   </xsl:template>

   <!--PATTERN PurchaseAsPhysicalProduct_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"
                 priority="1000"
                 mode="M170">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PurchaseAsPhysicalProduct']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PurchaseAsPhysicalProduct']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be PurchaseAsPhysicalProduct for this
            Profile (Business Profile 1.4, Clause 3(17), Rule 2423-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M170"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M170"/>
   <xsl:template match="@*|node()" priority="-2" mode="M170">
      <xsl:apply-templates select="*" mode="M170"/>
   </xsl:template>

   <!--PATTERN PurchaseAsPhysicalProduct_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"
                 priority="1000"
                 mode="M171">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(17), Rule 2424-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M171"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M171"/>
   <xsl:template match="@*|node()" priority="-2" mode="M171">
      <xsl:apply-templates select="*" mode="M171"/>
   </xsl:template>

   <!--PATTERN PurchaseAsPhysicalProduct_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"
                 priority="1000"
                 mode="M172">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(17), Rule 2425-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M172"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M172"/>
   <xsl:template match="@*|node()" priority="-2" mode="M172">
      <xsl:apply-templates select="*" mode="M172"/>
   </xsl:template>

   <!--PATTERN PurchaseAsPhysicalProduct_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PurchaseAsPhysicalProduct']"
                 priority="1000"
                 mode="M173">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PurchaseAsPhysicalProduct']"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/PurchaseAsPhysicalProduct' for this combination of categories
            (Business Profile 1.4, Clause 3(17), Rule 2426-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M173"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M173"/>
   <xsl:template match="@*|node()" priority="-2" mode="M173">
      <xsl:apply-templates select="*" mode="M173"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M174">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(18), Rule
            2427-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M174"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M174"/>
   <xsl:template match="@*|node()" priority="-2" mode="M174">
      <xsl:apply-templates select="*" mode="M174"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M175">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Stream']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Stream']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be Stream for this Profile (Business
            Profile 1.4, Clause 3(18), Rule 2428-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M175"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M175"/>
   <xsl:template match="@*|node()" priority="-2" mode="M175">
      <xsl:apply-templates select="*" mode="M175"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M176">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(18), Rule 2429-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M176"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M176"/>
   <xsl:template match="@*|node()" priority="-2" mode="M176">
      <xsl:apply-templates select="*" mode="M176"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"
                 priority="1000"
                 mode="M177">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(18), Rule 2430-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M177"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M177"/>
   <xsl:template match="@*|node()" priority="-2" mode="M177">
      <xsl:apply-templates select="*" mode="M177"/>
   </xsl:template>

   <!--PATTERN GenericAdSupportedStreamingService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertismentSupportedModel']][Usage/UseType[text() = 'Stream']]"
                 priority="1000"
                 mode="M178">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertismentSupportedModel']][Usage/UseType[text() = 'Stream']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/GenericAdSupportedStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(18), Rule 2431-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M178"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M178"/>
   <xsl:template match="@*|node()" priority="-2" mode="M178">
      <xsl:apply-templates select="*" mode="M178"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M179">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be SubscriptionModel for
            this Profile (Business Profile 1.4, Clause 3(19), Rule 2432-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M179"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M179"/>
   <xsl:template match="@*|node()" priority="-2" mode="M179">
      <xsl:apply-templates select="*" mode="M179"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M180">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Stream']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Stream']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be Stream for this Profile (Business
            Profile 1.4, Clause 3(19), Rule 2433-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M180"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M180"/>
   <xsl:template match="@*|node()" priority="-2" mode="M180">
      <xsl:apply-templates select="*" mode="M180"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M181">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(19), Rule 2434-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M181"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M181"/>
   <xsl:template match="@*|node()" priority="-2" mode="M181">
      <xsl:apply-templates select="*" mode="M181"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"
                 priority="1000"
                 mode="M182">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(19), Rule 2435-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M182"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M182"/>
   <xsl:template match="@*|node()" priority="-2" mode="M182">
      <xsl:apply-templates select="*" mode="M182"/>
   </xsl:template>

   <!--PATTERN GenericSubscriptionStreamingService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'Stream']]"
                 priority="1000"
                 mode="M183">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'Stream']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/GenericSubscriptionStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(19), Rule 2436-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M183"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M183"/>
   <xsl:template match="@*|node()" priority="-2" mode="M183">
      <xsl:apply-templates select="*" mode="M183"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_CommercialModelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"
                 priority="1000"
                 mode="M184">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(20), Rule 2437-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M184"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M184"/>
   <xsl:template match="@*|node()" priority="-2" mode="M184">
      <xsl:apply-templates select="*" mode="M184"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_UseType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"
                 priority="1000"
                 mode="M185">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Stream']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Stream']">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The UseType should be Stream for this Profile (Business
            Profile 1.4, Clause 3(20), Rule 2438-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M185"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M185"/>
   <xsl:template match="@*|node()" priority="-2" mode="M185">
      <xsl:apply-templates select="*" mode="M185"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_UserInterfaceType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"
                 priority="1000"
                 mode="M186">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(20), Rule 2439-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M186"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M186"/>
   <xsl:template match="@*|node()" priority="-2" mode="M186">
      <xsl:apply-templates select="*" mode="M186"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_DistributionChannelType-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"
                 priority="1000"
                 mode="M187">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]"/>

		    <!--REPORT Error-->
      <xsl:if test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType">
            <xsl:attribute name="role">Error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(20), Rule 2440-1).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M187"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M187"/>
   <xsl:template match="@*|node()" priority="-2" mode="M187">
      <xsl:apply-templates select="*" mode="M187"/>
   </xsl:template>

   <!--PATTERN GenericPayAsYouGoStreamingService_Categories-->


	  <!--RULE -->
   <xsl:template match="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'Stream']]"
                 priority="1000"
                 mode="M188">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'Stream']]"/>

		    <!--ASSERT Fatal Error-->
      <xsl:choose>
         <xsl:when test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')">
               <xsl:attribute name="role">Fatal Error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/GenericPayAsYouGoStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(20), Rule 2441-1).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M188"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M188"/>
   <xsl:template match="@*|node()" priority="-2" mode="M188">
      <xsl:apply-templates select="*" mode="M188"/>
   </xsl:template>
</xsl:stylesheet>
