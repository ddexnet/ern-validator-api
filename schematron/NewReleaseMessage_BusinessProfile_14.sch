<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <!--
          This Schematron rule set requires XPath2. 
          This can be enforced by, for instance, adding an attribute into the above s:schema tag 
          (queryBinding="xslt2") or by instructing the processor for running the Schematron
          rule to use XPath2 in any other way.
                    -->
   <s:title>Schematron Business Profile for (version 1.4) for the NewReleaseMessage.</s:title>
   <s:p>© 2006-2017 Digital Data Exchange, LLC (DDEX)</s:p>
   <s:p>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If
      you wish to evaluate whether the standard meets your needs please have a look at the
      Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards.
      If you want to implement and use this DDEX standard, please take out an Implementation
      Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</s:p>
   <s:p>Failing a rule with a role of 'Fatal Error' means that the Conformance Tester must recommend
      to not award a Conformance Certificate or to retract a Conformance Certificate if one has
      already been issued. Failing a rule with a role of 'Conditional Fatal Error' is the same as a
      'Fatal Error', however, the rule may be ignored if the Conformance Tester has no means of
      asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>Failing a rule a rule with a role of 'Error' means that the Conformance Tester must
      recommend to award a Partial Conformance Certificate or to downgrade a Conformance Certificate
      that has already been issued. However, if more than 40 rules (representing 50% of all rules
      with a role of 'Error' or 'Conditional Error') have been failed at least once, the Conformance
      Tester must recommend to not award a Conformance Certificate or to retract a Conformance
      Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error'
      is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no
      means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>The following Clauses from the Business Profile standard are NOT checked by this ISO
      Schematron file: 4.2(1), 4.2(4)-(5), 4.3.1, 4.3.2(11), 4.4, 4.5, 4.6(1)-(2), (4),
      4.7.1(1)-(2), (5), 4.7.3, 4.7.4(1a), (1b), (2a), (2b), 4.7.5, 4.7.6, 4.7.7 and 4.8.</s:p>

   <s:pattern id="MultiProfile_PreviewDateShouldBeBeforeStartDate">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms">
         <s:report
            test="translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','') or translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
            role="Fatal Error">Fatal Error: A ReleaseDisplayStartDate may not be later than the
            StartDate of the Deal.</s:report>
         <s:report test="TrackListingPreviewStartDate &gt; ../../EffectiveDate" role="Fatal Error"
            >Fatal Error: A TrackListingPreviewStartDate may not be later than the StartDate of the
            Deal.</s:report>
         <s:report test="ClipPreviewStartDate &gt; ../../EffectiveDate" role="Fatal Error">Fatal
            Error: A ClipPreviewStartDate may not be later than the StartDate of the
            Deal.</s:report>
         <s:report test="CoverArtPreviewStartDate &gt; ../../EffectiveDate" role="Fatal Error">Fatal
            Error: A CoverArtPreviewStartDate may not be later than the StartDate of the
            Deal.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_BusinessProfileVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:report
            test="some $x in tokenize(@BusinessProfileVersionId, '\s+') satisfies not(contains('CommonDealTypes/14/GenericDownloadService CommonDealTypes/14/DRMProtectedDownloadService CommonDealTypes/14/NonProtectedDownloadService CommonDealTypes/14/AdSupportedDownloadService CommonDealTypes/14/DRMProtectedAdSupportedDownloadService CommonDealTypes/14/NonProtectedAdSupportedDownloadService CommonDealTypes/14/TetheredDownloadService CommonDealTypes/14/AdSupportedTetheredDownloadService CommonDealTypes/14/InteractiveSubscriptionStreamingService CommonDealTypes/14/InteractiveAdSupportedStreamingService CommonDealTypes/14/NonInteractiveSubscriptionStreamingService CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice CommonDealTypes/14/NonInteractiveAdSupportedStreamingService CommonDealTypes/14/KioskService CommonDealTypes/14/RingtonesAndMobileService CommonDealTypes/14/RightsClaimsOnUserGeneratedContent CommonDealTypes/14/PurchaseAsPhysicalProduct CommonDealTypes/14/GenericAdSupportedStreamingService CommonDealTypes/14/GenericSubscriptionStreamingService  CommonDealTypes/14/GenericPayAsYouGoStreamingService',$x))"
            role="Information">Information: The BusinessProfileVersionId should only contain values
            specified in the standard (Business Profile 1.4, Clause 4.1, Rule 2260-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MessageSchemaVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert
            test="substring(@MessageSchemaVersionId, 1, 4) = 'ern/' and number(substring(@MessageSchemaVersionId, 5,2)) &gt;= 39"
            role="Information">Information: The MessageSchemaVersionId should be at least 3.9
            (Business Profile 1.4, Clause 4.1, Rule 2261-1).</s:assert>
         <s:assert test="@MessageSchemaVersionId = 'ern/39Draft'" role="Information">Information:
            You are not using the latest XSD supported by this Schematron file (Business Profile
            1.4, Clause 4.1, Rule 2261-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_TerritoryTIS">
      <s:rule context="//TerritoryCode | //ExcludedTerritoryCode">
         <s:report test="substring(@IdentifierType, 1, 3) = 'TIS'" role="Fatal Error">Fatal Error: A
            TerritoryCode of type 'TIS' must not be used (Business Profile 1.4, Clause 4.2(2), Rule
            2262-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainComment">
      <s:rule context="*:NewReleaseMessage/MessageHeader">
         <s:report test="//Comment" role="Fatal Error">Fatal Error: No Comment shall be provided in
            the MessageHeader (Business Profile 1.4, Clause 4.2(3), Rule 2263-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainLanguageAndScriptCode">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal">
         <s:report test="descendant::*/@LanguageAndScriptCode" role="Fatal Error">Fatal Error: The
            use of LanguageAndScriptCode is discouraged (Business Profile 1.4, Clause 4.3.2(1), Rule
            2264-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainCatalogTransfer">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="CatalogTransfer" role="Conditional Fatal Error">Conditional Fatal Error:
            The use of CatalogTransfer is discouraged (Business Profile 1.4, Clause 4.3.2(2), Rule
            2265-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainBulkOrderWholesalePricePerUnit">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation">
         <s:report test="BulkOrderWholesalePricePerUnit" role="Error">Error: The use of
            BulkOrderWholesalePricePerUnit is discouraged (Business Profile 1.4, Clause 4.3.2(4),
            Rule 2266-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainRelatedReleaseOfferSet">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms">
         <s:report test="RelatedReleaseOfferSet" role="Fatal Error">Fatal Error: The use of
            RelatedReleaseOfferSet is discouraged (Business Profile 1.4, Clause 4.3.2(5), Rule
            2267-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainCarrierType">
      <s:rule
         context="*:NewReleaseMessage[not(contains (@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct'))]">
         <s:report test="//CarrierType" role="Fatal Error">Fatal Error: The use of CarrierType is
            discouraged except for PurchaseAsPhysicalProduct (Business Profile 1.4, Clause 4.3.2(6),
            Rule 2268-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainPhysicalReturns">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms">
         <s:report test="PhysicalReturns" role="Fatal Error">Fatal Error: The use of PhysicalReturns
            is discouraged (Business Profile 1.4, Clause 4.3.2(7), Rule 2269-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainNumberOfProductsPerCarton">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms">
         <s:report test="NumberOfProductsPerCarton" role="Fatal Error">Fatal Error: The use of
            NumberOfProductsPerCarton is discouraged (Business Profile 1.4, Clause 4.3.2(8), Rule
            2270-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainResourceUsage">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal">
         <s:report test="ResourceUsage" role="Fatal Error">Fatal Error: The use of ResourceUsage is
            discouraged (Business Profile 1.4, Clause 4.3.2(10), Rule 2271-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_GenericUseType">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal">
         <s:report test="//Usage[UseType='Stream']/UseType[matches(text(),'.Stream')]"
            role="Fatal Error">Fatal Error: The combination of generic and specific UseTypes is not
            permitted (Business Profile 1.4, Clause 4.3.2(12), Rule 2272-1).</s:report>
         <s:report test="//Usage[UseType='Download']/UseType[matches(text(),'.Download')]"
            role="Fatal Error">Fatal Error: The combination of generic and specific UseTypes is not
            permitted (Business Profile 1.4, Clause 4.3.2(12), Rule 2272-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SpecificUseType">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal">
         <s:report
            test="//Usage[UseType='InteractiveStream' and UseType='NonInteractiveStream' and UseType='ContentInfluencedStream' and UseType='OnDemandStream' and UseType='TimeInfluencedStream']"
            role="Fatal Error">Fatal Error: The use of all specific UseTypes is not permitted
            (Business Profile 1.4, Clause 4.3.2(13), Rule 2273-1).</s:report>
         <s:report
            test="//Usage[UseType='ConditionalDownload' and UseType='KioskDownload' and UseType='PermanentDownload' and UseType='TetheredDownload']"
            role="Fatal Error">Fatal Error: The use of all specific UseTypes is not permitted
            (Business Profile 1.4, Clause 4.3.2(13), Rule 2273-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericDownloadService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.3(5), Rule 2274-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedDownloadService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.4(5), Rule 2275-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedDownloadService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.5(5), Rule 2276-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedDownloadService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.6(5), Rule 2277-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedAdSupportedDownloadService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.7(5), Rule 2278-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedAdSupportedDownloadService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.8(5), Rule 2279-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="TetheredDownloadService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.9(5), Rule 2280-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedTetheredDownloadService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.10(5), Rule 2281-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.11(5), Rule 2282-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.12(5), Rule 2283-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.13(5), Rule 2284-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.14(5), Rule 2285-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.15(5), Rule 2286-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="KioskService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.16(4), Rule 2287-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="RingtonesAndMobileService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.17(5), Rule 2288-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="RightsClaimsOnUserGeneratedContent_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.18(7), Rule 2289-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="PurchaseAsPhysicalProduct_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType" role="Fatal Error"
            >Fatal Error: No CommercialModelType should be specified for this Profile (Business
            Profile 1.4, Clause 4.3.19(4), Rule 2290-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="PurchaseAsPhysicalProduct_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.19(7), Rule 2291-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.20(5), Rule 2292-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_UseType2">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Narrowcast' or text() = 'NonInteractiveStream' or text() = 'OnDemandStream' or text() = 'TimeInfluencedStream' or text() = 'Webcast']"
            role="Fatal Error">Fatal Error: The UseType should not be a detailed streaming service
            for this Profile (Business Profile 1.4, Clause 4.3.20(8), Rule 2293-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.21(5), Rule 2294-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_UseType2">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Narrowcast' or text() = 'NonInteractiveStream' or text() = 'OnDemandStream' or text() = 'TimeInfluencedStream' or text() = 'Webcast']"
            role="Fatal Error">Fatal Error: The UseType should not be a detailed streaming service
            for this Profile (Business Profile 1.4, Clause 4.3.21(8), Rule 2295-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_ConsumerRentalPeriod">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/ConsumerRentalPeriod" role="Error"
            >Error: The ConsumerRentalPeriod should not be used (Business Profile 1.4, Clause
            4.3.22(5), Rule 2296-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_UseType2">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Narrowcast' or text() = 'NonInteractiveStream' or text() = 'OnDemandStream' or text() = 'TimeInfluencedStream' or text() = 'Webcast']"
            role="Fatal Error">Fatal Error: The UseType should not be a detailed streaming service
            for this Profile (Business Profile 1.4, Clause 4.3.22(8), Rule 2297-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.11(6), Rule 2298-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.11(6), Rule 2298-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_ReleaseProfileVersionId">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioSingle'"
            role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14//14//14/AudioSingle' (Business Profile 1.4, Clause 4.3.11(7),
            Rule 2299-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_NoGenericBusinessProfile">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]">
         <s:report test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')"
            role="Fatal Error">Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.11(8), Rule
            2300-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_MustNotContainPriceInformation">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation" role="Error">Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.11(9), Rule
            2301-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.12(6), Rule 2302-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.12(6), Rule 2302-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_ReleaseProfileVersionId">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14//14//14/AudioSingle'"
            role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14//14//14/AudioSingle' (Business Profile 1.4, Clause 4.3.12(7),
            Rule 2303-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_NoGenericBusinessProfile">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]">
         <s:report test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')"
            role="Fatal Error">Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.12(8), Rule
            2304-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_MustNotContainPriceInformation">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation" role="Error">Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.12(9), Rule
            2305-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.13(6), Rule 2306-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.13(6), Rule 2306-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_ReleaseProfileVersionId">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')]">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14//14//14/AudioSingle'"
            role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14//14//14/AudioSingle' (Business Profile 1.4, Clause 4.3.13(7),
            Rule 2307-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_NoGenericBusinessProfile">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')]">
         <s:report test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')"
            role="Fatal Error">Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.13(8), Rule
            2308-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_MustNotContainPriceInformation">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation" role="Error">Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.13(9), Rule
            2309-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.14(6), Rule 2310-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.14(6), Rule 2310-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_ReleaseProfileVersionId">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14//14//14/AudioSingle'"
            role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14//14//14/AudioSingle' (Business Profile 1.4, Clause 4.3.14(7),
            Rule 2311-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_NoGenericBusinessProfile">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]">
         <s:report test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')"
            role="Fatal Error">Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.14(8), Rule
            2312-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_MustNotContainPriceInformation">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation" role="Error">Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.14(9), Rule
            2313-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.15(6), Rule 2314-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.15(6), Rule 2314-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_ReleaseProfileVersionId">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14//14//14/AudioSingle'"
            role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14//14//14/AudioSingle' (Business Profile 1.4, Clause 4.3.15(7),
            Rule 2315-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_NoGenericBusinessProfile">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]">
         <s:report test="contains(@BusinessProfileVersionId, 'CommonDealTypes/14/Generic')"
            role="Fatal Error">Fatal Error: This specific Profile may not be combined with a generic
            Profile 'CommonDealTypes/14/Generic' (Business Profile 1.4, Clause 4.3.15(8), Rule
            2316-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_MustNotContainPriceInformation">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation" role="Error">Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.15(9), Rule
            2317-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="KioskService_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.16(5), Rule 2318-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.16(5), Rule 2318-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="RingtonesAndMobileService_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.17(6), Rule 2319-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.17(6), Rule 2319-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="RingtonesAndMobileService_ReleaseProfileVersionId">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14//14//14/Ringtone'"
            role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14//14//14/Ringtone' (Business Profile 1.4, Clause 4.3.17(7), Rule
            2320-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="RightsClaimsOnUserGeneratedContent_RightsClaimPolicy2">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/RightsClaimPolicy">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent' if a RightsClaimPolicy is
            provided (Business Profile 1.4, Clause 4.3.18(3), Rule 2321-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="RightsClaimsOnUserGeneratedContent_WebPolicy">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/WebPolicy">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent' if a WebPolicy is provided
            (Business Profile 1.4, Clause 4.3.18(4), Rule 2322-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="RightsClaimsOnUserGeneratedContent_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.18(8), Rule 2323-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.18(8), Rule 2323-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="PurchaseAsPhysicalProduct_CarrierType">
      <s:rule
         context="*:NewReleaseMessage[contains (@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]">
         <s:assert test="//CarrierType" role="Fatal Error">Fatal Error: A CarrierType shall be
            specified for this Profile (Business Profile 1.4, Clause 4.3.19(3), Rule
            2324-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.20(6), Rule 2325-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.20(6), Rule 2325-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_ReleaseProfileVersionId">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14//14//14/AudioSingle'"
            role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14//14//14/AudioSingle' (Business Profile 1.4, Clause 4.3.20(7),
            Rule 2326-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_MustNotContainPriceInformation">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation" role="Error">Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.20(9), Rule
            2327-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.21(6), Rule 2328-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.21(6), Rule 2328-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_ReleaseProfileVersionId">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14//14//14/AudioSingle'"
            role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14//14//14/AudioSingle' (Business Profile 1.4, Clause 4.3.21(7),
            Rule 2329-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_MustNotContainPriceInformation">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation" role="Error">Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.21(9), Rule
            2330-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_MustNotContainDates">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]">
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderReleaseDateTime"
            role="Error">Error: The use of PreOrderReleaseDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.22(6), Rule 2331-1).</s:report>
         <s:report
            test="DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate | DealList/ReleaseDeal/Deal/DealTerms/PreOrderPreviewDate"
            role="Error">Error: The use of PreOrderPreviewDate(Time) is discouraged (Business
            Profile 1.4, Clause 4.3.22(6), Rule 2331-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_ReleaseProfileVersionId">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14//14//14/AudioSingle'"
            role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14//14//14/AudioSingle' (Business Profile 1.4, Clause 4.3.22(7),
            Rule 2332-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_MustNotContainPriceInformation">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/PriceInformation" role="Error">Error:
            The use of PriceInformation is discouraged (Business Profile 1.4, Clause 4.3.22(9), Rule
            2333-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainPriceType">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation[BulkOrderWholesalePricePerUnit] | *:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation[WholesalePricePerUnit]">
         <s:report test="PriceType" role="Fatal Error">Fatal Error: WholesalePricePerUnit and
            BulkOrderWholesalePricePerUnit may not be combined with a PriceType (Business Profile
            1.4, Clause 4.6(3), Rule 2334-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainEffectiveDate">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal">
         <s:report test="EffectiveDate" role="Fatal Error">Fatal Error: An EffectiveDate must not be
            specified (Business Profile 1.4, Clause 4.7.1(3), Rule 2335-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainAllDealsCancelled">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms">
         <s:report test="AllDealsCancelled" role="Fatal Error">Fatal Error: AllDealsCancelled must
            not be specified (Business Profile 1.4, Clause 4.7.1(4)+4.7.4(1c)+4.7.4(2c), Rule
            2336-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainUpdateIndicator">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="UpdateIndicator" role="Fatal Error">Fatal Error: UpdateIndicator shall not
            be used (Business Profile 1.4, Clause 4.7.2, Rule 2337-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainTakeDown">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms">
         <s:report test="TakeDown" role="Fatal Error">Fatal Error: TakeDown must not be specified
            (Business Profile 1.4, Clause 4.7.4(1c)+4.7.4(2c), Rule 2338-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericDownloadService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(1), Rule 2339-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericDownloadService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"
            role="Fatal Error">Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(1), Rule 2340-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericDownloadService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(1), Rule 2341-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericDownloadService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(1), Rule 2342-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericDownloadService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() != 'DrmEnforced']][Usage/TechnicalInstantiation/DrmEnforcementType[text() != 'NotDrmEnforced']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericDownloadService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/GenericDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(1), Rule 2343-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedDownloadService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(2), Rule 2344-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedDownloadService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"
            role="Fatal Error">Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(2), Rule 2345-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedDownloadService_DrmEnforcementType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']"
            role="Fatal Error">Fatal Error: The DrmEnforcementType should be DrmEnforced for this
            Profile (Business Profile 1.4, Clause 3(2), Rule 2346-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedDownloadService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(2), Rule 2347-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedDownloadService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(2), Rule 2348-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedDownloadService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedDownloadService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/DRMProtectedDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(2), Rule 2349-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedDownloadService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(3), Rule 2350-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedDownloadService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"
            role="Fatal Error">Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(3), Rule 2351-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedDownloadService_DrmEnforcementType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']"
            role="Fatal Error">Fatal Error: The DrmEnforcementType should be NotDrmEnforced for this
            Profile (Business Profile 1.4, Clause 3(3), Rule 2352-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedDownloadService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(3), Rule 2353-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedDownloadService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(3), Rule 2354-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedDownloadService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedDownloadService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonProtectedDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(3), Rule 2355-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedDownloadService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(4), Rule
            2356-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedDownloadService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"
            role="Fatal Error">Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(4), Rule 2357-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedDownloadService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(4), Rule 2358-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedDownloadService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(4), Rule 2359-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedDownloadService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'PermanentDownload']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedDownloadService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/AdSupportedDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(4), Rule 2360-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedAdSupportedDownloadService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(5), Rule
            2361-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedAdSupportedDownloadService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"
            role="Fatal Error">Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(5), Rule 2362-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedAdSupportedDownloadService_DrmEnforcementType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']"
            role="Fatal Error">Fatal Error: The DrmEnforcementType should be DrmEnforced for this
            Profile (Business Profile 1.4, Clause 3(5), Rule 2363-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedAdSupportedDownloadService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(5), Rule 2364-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedAdSupportedDownloadService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(5), Rule 2365-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="DRMProtectedAdSupportedDownloadService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'DrmEnforced']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/DRMProtectedAdSupportedDownloadService' for this combination of
            categories (Business Profile 1.4, Clause 3(5), Rule 2366-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedAdSupportedDownloadService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(6), Rule
            2367-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedAdSupportedDownloadService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"
            role="Fatal Error">Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(6), Rule 2368-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedAdSupportedDownloadService_DrmEnforcementType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']"
            role="Fatal Error">Fatal Error: The DrmEnforcementType should be NotDrmEnforced for this
            Profile (Business Profile 1.4, Clause 3(6), Rule 2369-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedAdSupportedDownloadService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(6), Rule 2370-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedAdSupportedDownloadService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(6), Rule 2371-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonProtectedAdSupportedDownloadService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'PermanentDownload']][Usage/TechnicalInstantiation/DrmEnforcementType[text() = 'NotDrmEnforced']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonProtectedAdSupportedDownloadService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonProtectedAdSupportedDownloadService' for this combination of
            categories (Business Profile 1.4, Clause 3(6), Rule 2372-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="TetheredDownloadService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be SubscriptionModel for
            this Profile (Business Profile 1.4, Clause 3(7), Rule 2373-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="TetheredDownloadService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'ConditionalDownload']"
            role="Fatal Error">Fatal Error: The UseType should be ConditionalDownload for this
            Profile (Business Profile 1.4, Clause 3(7), Rule 2374-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="TetheredDownloadService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(7), Rule 2375-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="TetheredDownloadService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(7), Rule 2376-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="TetheredDownloadService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'ConditionalDownload']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/TetheredDownloadService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/TetheredDownloadService' for this combination of categories
            (Business Profile 1.4, Clause 3(7), Rule 2377-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedTetheredDownloadService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(8), Rule
            2378-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedTetheredDownloadService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'ConditionalDownload']"
            role="Fatal Error">Fatal Error: The UseType should be ConditionalDownload for this
            Profile (Business Profile 1.4, Clause 3(8), Rule 2379-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedTetheredDownloadService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(8), Rule 2380-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedTetheredDownloadService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(8), Rule 2381-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="AdSupportedTetheredDownloadService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertisementSupportedModel']][Usage/UseType[text() = 'ConditionalDownload']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/AdSupportedTetheredDownloadService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/AdSupportedTetheredDownloadService' for this combination of
            categories (Business Profile 1.4, Clause 3(8), Rule 2382-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be SubscriptionModel for
            this Profile (Business Profile 1.4, Clause 3(9), Rule 2383-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'OnDemandStream']"
            role="Fatal Error">Fatal Error: The UseType should be OnDemandStream for this Profile
            (Business Profile 1.4, Clause 3(9), Rule 2384-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(9), Rule 2385-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(9), Rule 2386-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveSubscriptionStreamingService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'OnDemandStream']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveSubscriptionStreamingService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/InteractiveSubscriptionStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(9), Rule 2387-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(10), Rule
            2388-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'OnDemandStream']"
            role="Fatal Error">Fatal Error: The UseType should be OnDemandStream for this Profile
            (Business Profile 1.4, Clause 3(10), Rule 2389-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(10), Rule 2390-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(10), Rule 2391-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="InteractiveAdSupportedStreamingService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertismentSupportedModel']][Usage/UseType[text() = 'OnDemandStream']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/InteractiveAdSupportedStreamingService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/InteractiveAdSupportedStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(10), Rule 2392-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be SubscriptionModel for
            this Profile (Business Profile 1.4, Clause 3(11), Rule 2393-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'NonInteractiveStream']"
            role="Fatal Error">Fatal Error: The UseType should be NonInteractiveStream for this
            Profile (Business Profile 1.4, Clause 3(11), Rule 2394-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(11), Rule 2395-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(11), Rule 2396-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'NonInteractiveStream']]">
         <s:assert
            test="contains(/*:NewReleaseMessage/@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonInteractiveSubscriptionStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(11), Rule 2397-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'DeviceFeeModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be DeviceFeeModel for
            this Profile (Business Profile 1.4, Clause 3(12), Rule 2398-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'NonInteractiveStream']"
            role="Fatal Error">Fatal Error: The UseType should be NonInteractiveStream for this
            Profile (Business Profile 1.4, Clause 3(12), Rule 2399-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(12), Rule 2400-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(12), Rule 2401-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveSubscriptionStreamingServiceOnDevice_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'DeviceFeeModel']][Usage/UseType[text() = 'NonInteractiveStream']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonInteractiveSubscriptionStreamingServiceOnDevice' for this
            combination of categories (Business Profile 1.4, Clause 3(12), Rule 2402-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(13), Rule
            2403-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'NonInteractiveStream']"
            role="Fatal Error">Fatal Error: The UseType should be NonInteractiveStream for this
            Profile (Business Profile 1.4, Clause 3(13), Rule 2404-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(13), Rule 2405-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(13), Rule 2406-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="NonInteractiveAdSupportedStreamingService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertismentSupportedModel']][Usage/UseType[text() = 'NonInteractiveStream']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/NonInteractiveAdSupportedStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(13), Rule 2407-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="KioskService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(14), Rule 2408-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="KioskService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PermanentDownload']"
            role="Fatal Error">Fatal Error: The UseType should be PermanentDownload for this Profile
            (Business Profile 1.4, Clause 3(14), Rule 2409-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="KioskService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType[text() = 'Kiosk']"
            role="Fatal Error">Fatal Error: The UserInterfaceType should be Kiosk for this Profile
            (Business Profile 1.4, Clause 3(14), Rule 2410-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="KioskService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(14), Rule 2411-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="KioskService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'PermanentDonwload']][Usage/UserInterfaceType[text() = 'Kiosk']]">
         <s:assert test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/KioskService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/KioskService' for this combination of categories (Business Profile
            1.4, Clause 3(14), Rule 2412-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="RingtonesAndMobileService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(15), Rule 2413-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="RingtonesAndMobileService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[starts-with(text(),'UseAs')][ends-with(text(),'one')]"
            role="Fatal Error">Fatal Error: The UseType should be UseAsRingtone, UseAsRingbackTone
            or UseAsAlertTone for this Profile (Business Profile 1.4, Clause 3(15), Rule
            2414-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="RingtonesAndMobileService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(15), Rule 2415-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="RingtonesAndMobileService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(15), Rule 2416-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="RingtonesAndMobileService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[starts-with(text(),'UseAs')][ends-with(text(),'one')]]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RingtonesAndMobileService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/RingtonesAndMobileService' for this combination of categories
            (Business Profile 1.4, Clause 3(15), Rule 2417-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="RightsClaimsOnUserGeneratedContent_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'RightsClaimModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be RightsClaimModel for
            this Profile (Business Profile 1.4, Clause 3(16), Rule 2418-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="RightsClaimsOnUserGeneratedContent_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[starts-with(text(),'UserMakeAvailable')]"
            role="Fatal Error">Fatal Error: The UseType should be UserMakeAvailableLabelProvided or
            UserMakeAvailableUserProvided for this Profile (Business Profile 1.4, Clause 3(16), Rule
            2419-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="RightsClaimsOnUserGeneratedContent_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(16), Rule 2420-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="RightsClaimsOnUserGeneratedContent_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(16), Rule 2421-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="RightsClaimsOnUserGeneratedContent_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'RightsClaimModel']][Usage/UseType[starts-with(text(),'UserMakeAvailable')]]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/RightsClaimsOnUserGeneratedContent' for this combination of
            categories (Business Profile 1.4, Clause 3(16), Rule 2422-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="PurchaseAsPhysicalProduct_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PurchaseAsPhysicalProduct']"
            role="Fatal Error">Fatal Error: The UseType should be PurchaseAsPhysicalProduct for this
            Profile (Business Profile 1.4, Clause 3(17), Rule 2423-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="PurchaseAsPhysicalProduct_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(17), Rule 2424-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="PurchaseAsPhysicalProduct_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(17), Rule 2425-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="PurchaseAsPhysicalProduct_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'PurchaseAsPhysicalProduct']">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/PurchaseAsPhysicalProduct')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/PurchaseAsPhysicalProduct' for this combination of categories
            (Business Profile 1.4, Clause 3(17), Rule 2426-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'AdvertisementSupportedModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be
            AdvertisementSupportedModel for this Profile (Business Profile 1.4, Clause 3(18), Rule
            2427-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]">
         <s:assert test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Stream']"
            role="Fatal Error">Fatal Error: The UseType should be Stream for this Profile (Business
            Profile 1.4, Clause 3(18), Rule 2428-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(18), Rule 2429-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(18), Rule 2430-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericAdSupportedStreamingService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'AdvertismentSupportedModel']][Usage/UseType[text() = 'Stream']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericAdSupportedStreamingService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/GenericAdSupportedStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(18), Rule 2431-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'SubscriptionModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be SubscriptionModel for
            this Profile (Business Profile 1.4, Clause 3(19), Rule 2432-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]">
         <s:assert test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Stream']"
            role="Fatal Error">Fatal Error: The UseType should be Stream for this Profile (Business
            Profile 1.4, Clause 3(19), Rule 2433-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(19), Rule 2434-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(19), Rule 2435-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericSubscriptionStreamingService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'SubscriptionModel']][Usage/UseType[text() = 'Stream']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericSubscriptionStreamingService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/GenericSubscriptionStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(19), Rule 2436-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_CommercialModelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]">
         <s:assert
            test="DealList/ReleaseDeal/Deal/DealTerms/CommercialModelType[text() = 'PayAsYouGoModel']"
            role="Fatal Error">Fatal Error: The CommercialModelType should be PayAsyouGoModel for
            this Profile (Business Profile 1.4, Clause 3(20), Rule 2437-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_UseType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]">
         <s:assert test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UseType[text() = 'Stream']"
            role="Fatal Error">Fatal Error: The UseType should be Stream for this Profile (Business
            Profile 1.4, Clause 3(20), Rule 2438-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_UserInterfaceType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/UserInterfaceType" role="Error"
            >Error: The UserInterfaceType should not used for this Profile (Business Profile 1.4,
            Clause 3(20), Rule 2439-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_DistributionChannelType">
      <s:rule
         context="*:NewReleaseMessage[contains(@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')]">
         <s:report test="DealList/ReleaseDeal/Deal/DealTerms/Usage/DistributionChannelType"
            role="Error">Error: The DistributionChannelType should not used for this Profile
            (Business Profile 1.4, Clause 3(20), Rule 2440-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="GenericPayAsYouGoStreamingService_Categories">
      <s:rule
         context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CommercialModelType[text() = 'PayAsYouGoModel']][Usage/UseType[text() = 'Stream']]">
         <s:assert
            test="contains(//@BusinessProfileVersionId, 'CommonDealTypes/14/GenericPayAsYouGoStreamingService')"
            role="Fatal Error">Fatal Error: The BusinessProfileVersionId should contain
            'CommonDealTypes/14/GenericPayAsYouGoStreamingService' for this combination of
            categories (Business Profile 1.4, Clause 3(20), Rule 2441-1).</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
