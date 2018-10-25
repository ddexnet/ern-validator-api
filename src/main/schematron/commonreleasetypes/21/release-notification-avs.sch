<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron"
          xmlns:xs="http://www.w3.org/2001/XMLSchema"
          queryBinding="xslt2">
								<!--
					  This Schematron rule set requires XPath2. 
					  This is enabled by the queryBinding=“xslt2” attribute in the root tag. Users may be required 
					  to instruct the processor used to running the Schematron rule to use XPath2 in another way.
								-->
								<s:p>© 2006-2018 Digital Data Exchange, LLC (DDEX)</s:p>
   <s:p>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If you wish to evaluate whether the standard meets your needs please have a look at the Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards. If you want to implement and use this DDEX standard, please take out an Implementation Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</s:p>
   <s:pattern id="ReleaseProfileVersionId_NewReleaseMessage">
      <s:rule context="*:NewReleaseMessage[@ReleaseProfileVersionId]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVersionId']/xs:restriction/xs:enumeration[@value=current()/@ReleaseProfileVersionId]"
                   role="Fatal Error">Fatal Error: The ReleaseProfileVersionId should conform to the allowed value set ReleaseProfileVersionId. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVersionId']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ReleaseProfileVariantVersionId_NewReleaseMessage">
      <s:rule context="*:NewReleaseMessage[@ReleaseProfileVariantVersionId]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVariantVersionId']/xs:restriction/xs:enumeration[@value=current()/@ReleaseProfileVariantVersionId]"
                   role="Fatal Error">Fatal Error: The ReleaseProfileVariantVersionId should conform to the allowed value set ReleaseProfileVariantVersionId. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ReleaseProfileVariantVersionId']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="AvsVersionId_NewReleaseMessage">
      <s:rule context="*:NewReleaseMessage[@AvsVersionId]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:restriction/xs:enumeration[@value=current()/@AvsVersionId]"
                   role="Fatal Error">Fatal Error: The AvsVersionId should conform to the allowed value set AvsVersionId. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="AvsVersionId_PurgeReleaseMessage">
      <s:rule context="*:PurgeReleaseMessage[@AvsVersionId]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:restriction/xs:enumeration[@value=current()/@AvsVersionId]"
                   role="Fatal Error">Fatal Error: The AvsVersionId should conform to the allowed value set AvsVersionId. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AvsVersionId']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_AdditionalTitle">
      <s:rule context="//AdditionalTitle[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="TitleType_AdditionalTitle">
      <s:rule context="//AdditionalTitle[@TitleType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AdditionalTitleType']/xs:restriction/xs:enumeration[@value=current()/@TitleType]"
                   role="Fatal Error">Fatal Error: The TitleType should conform to the allowed value set AdditionalTitleType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AdditionalTitleType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Reason_AvRating">
      <s:rule context="//AvRating[Reason]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='RatingReason']/xs:restriction/xs:enumeration[@value=current()/Reason]"
                   role="Fatal Error">Fatal Error: The Reason should conform to the allowed value set RatingReason. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='RatingReason']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_AvRating">
      <s:rule context="//AvRating[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_CLineWithDefault">
      <s:rule context="//CLineWithDefault[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_CourtesyLineWithDefault">
      <s:rule context="//CourtesyLineWithDefault[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="VideoDefinitionType_DealTermsTechnicalInstantiation">
      <s:rule context="//DealTermsTechnicalInstantiation[VideoDefinitionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:restriction/xs:enumeration[@value=current()/VideoDefinitionType]"
                   role="Fatal Error">Fatal Error: The VideoDefinitionType should conform to the allowed value set VideoDefinitionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CodingType_DealTermsTechnicalInstantiation">
      <s:rule context="//DealTermsTechnicalInstantiation[CodingType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CodingType']/xs:restriction/xs:enumeration[@value=current()/CodingType]"
                   role="Fatal Error">Fatal Error: The CodingType should conform to the allowed value set CodingType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CodingType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_Deity">
      <s:rule context="//Deity[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_DescriptionWithTerritory">
      <s:rule context="//DescriptionWithTerritory[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="SubTitleType_DisplaySubTitle">
      <s:rule context="//DisplaySubTitle[@SubTitleType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='SubTitleType']/xs:restriction/xs:enumeration[@value=current()/@SubTitleType]"
                   role="Fatal Error">Fatal Error: The SubTitleType should conform to the allowed value set SubTitleType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='SubTitleType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_DisplayTitle">
      <s:rule context="//DisplayTitle[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_DisplayTitleText">
      <s:rule context="//DisplayTitleText[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_EventDateTimeWithoutFlags">
      <s:rule context="//EventDateTimeWithoutFlags[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_EventDateWithDefault">
      <s:rule context="//EventDateWithDefault[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_EventDateWithoutFlags">
      <s:rule context="//EventDateWithoutFlags[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="DataType_Fingerprint">
      <s:rule context="//Fingerprint[DataType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:restriction/xs:enumeration[@value=current()/DataType]"
                   role="Fatal Error">Fatal Error: The DataType should conform to the allowed value set BinaryDataType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_PartyNameWithTerritory">
      <s:rule context="//PartyNameWithTerritory[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ExpressionType_PreviewDetails">
      <s:rule context="//PreviewDetails[ExpressionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:restriction/xs:enumeration[@value=current()/ExpressionType]"
                   role="Fatal Error">Fatal Error: The ExpressionType should conform to the allowed value set ExpressionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="PriceType_PriceInformationWithType">
      <s:rule context="//PriceInformationWithType[@PriceType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='PriceInformationType']/xs:restriction/xs:enumeration[@value=current()/@PriceType]"
                   role="Fatal Error">Fatal Error: The PriceType should conform to the allowed value set PriceInformationType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='PriceInformationType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_Raga">
      <s:rule context="//Raga[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ResourceRelationshipType_RelatedResource">
      <s:rule context="//RelatedResource[ResourceRelationshipType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ResourceRelationshipType']/xs:restriction/xs:enumeration[@value=current()/ResourceRelationshipType]"
                   role="Fatal Error">Fatal Error: The ResourceRelationshipType should conform to the allowed value set ResourceRelationshipType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ResourceRelationshipType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="LabelType_ReleaseLabelReference">
      <s:rule context="//ReleaseLabelReference[@LabelType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='LabelType']/xs:restriction/xs:enumeration[@value=current()/@LabelType]"
                   role="Fatal Error">Fatal Error: The LabelType should conform to the allowed value set LabelType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='LabelType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_ReleaseLabelReference">
      <s:rule context="//ReleaseLabelReference[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="RightsControllerRole_ResourceRightsController">
      <s:rule context="//ResourceRightsController[RightsControllerRole]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:restriction/xs:enumeration[@value=current()/RightsControllerRole]"
                   role="Fatal Error">Fatal Error: The RightsControllerRole should conform to the allowed value set RightsControllerRole. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ResourceGroupType_ResourceSubGroup">
      <s:rule context="//ResourceSubGroup[@ResourceGroupType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ResourceGroupType']/xs:restriction/xs:enumeration[@value=current()/@ResourceGroupType]"
                   role="Fatal Error">Fatal Error: The ResourceGroupType should conform to the allowed value set ResourceGroupType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ResourceGroupType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="LanguageOfLyrics_SheetMusic">
      <s:rule context="//SheetMusic[LanguageOfLyrics]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfLyrics]"
                   role="Fatal Error">Fatal Error: The LanguageOfLyrics should conform to the allowed value set IsoLanguageCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CompositeMusicalWorkType_SoundRecording">
      <s:rule context="//SoundRecording[CompositeMusicalWorkType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:restriction/xs:enumeration[@value=current()/CompositeMusicalWorkType]"
                   role="Fatal Error">Fatal Error: The CompositeMusicalWorkType should conform to the allowed value set CompositeMusicalWorkType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="LanguageOfPerformance_SoundRecording">
      <s:rule context="//SoundRecording[LanguageOfPerformance]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfPerformance]"
                   role="Fatal Error">Fatal Error: The LanguageOfPerformance should conform to the allowed value set IsoLanguageCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="AudioChannelConfiguration_SoundRecording">
      <s:rule context="//SoundRecording[AudioChannelConfiguration]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='RecordingMode']/xs:restriction/xs:enumeration[@value=current()/AudioChannelConfiguration]"
                   role="Fatal Error">Fatal Error: The AudioChannelConfiguration should conform to the allowed value set RecordingMode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='RecordingMode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ExpressionType_SoundRecordingPreviewDetails">
      <s:rule context="//SoundRecordingPreviewDetails[ExpressionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:restriction/xs:enumeration[@value=current()/ExpressionType]"
                   role="Fatal Error">Fatal Error: The ExpressionType should conform to the allowed value set ExpressionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ExpressionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_SynopsisWithTerritory">
      <s:rule context="//SynopsisWithTerritory[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_Tala">
      <s:rule context="//Tala[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_TechnicalImageDetails">
      <s:rule context="//TechnicalImageDetails[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_TechnicalSheetMusicDetails">
      <s:rule context="//TechnicalSheetMusicDetails[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_TechnicalSoftwareDetails">
      <s:rule context="//TechnicalSoftwareDetails[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_TechnicalSoundRecordingDetails">
      <s:rule context="//TechnicalSoundRecordingDetails[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_TechnicalTextDetails">
      <s:rule context="//TechnicalTextDetails[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="VideoDefinitionType_TechnicalVideoDetails">
      <s:rule context="//TechnicalVideoDetails[VideoDefinitionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:restriction/xs:enumeration[@value=current()/VideoDefinitionType]"
                   role="Fatal Error">Fatal Error: The VideoDefinitionType should conform to the allowed value set VideoDefinitionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VideoDefinitionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_TechnicalVideoDetails">
      <s:rule context="//TechnicalVideoDetails[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="TitleType_Title">
      <s:rule context="//Title[@TitleType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='TitleType']/xs:restriction/xs:enumeration[@value=current()/@TitleType]"
                   role="Fatal Error">Fatal Error: The TitleType should conform to the allowed value set TitleType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='TitleType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CompositeMusicalWorkType_Video">
      <s:rule context="//Video[CompositeMusicalWorkType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:restriction/xs:enumeration[@value=current()/CompositeMusicalWorkType]"
                   role="Fatal Error">Fatal Error: The CompositeMusicalWorkType should conform to the allowed value set CompositeMusicalWorkType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CompositeMusicalWorkType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="LanguageOfPerformance_Video">
      <s:rule context="//Video[LanguageOfPerformance]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfPerformance]"
                   role="Fatal Error">Fatal Error: The LanguageOfPerformance should conform to the allowed value set IsoLanguageCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="LanguageOfDubbing_Video">
      <s:rule context="//Video[LanguageOfDubbing]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/LanguageOfDubbing]"
                   role="Fatal Error">Fatal Error: The LanguageOfDubbing should conform to the allowed value set IsoLanguageCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="SubTitleLanguage_Video">
      <s:rule context="//Video[SubTitleLanguage]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:restriction/xs:enumeration[@value=current()/SubTitleLanguage]"
                   role="Fatal Error">Fatal Error: The SubTitleLanguage should conform to the allowed value set IsoLanguageCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='IsoLanguageCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="RightsControllerRole_WorkRightsController">
      <s:rule context="//WorkRightsController[RightsControllerRole]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:restriction/xs:enumeration[@value=current()/RightsControllerRole]"
                   role="Fatal Error">Fatal Error: The RightsControllerRole should conform to the allowed value set RightsControllerRole. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='RightsControllerRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="RightsControllerType_WorkRightsController">
      <s:rule context="//WorkRightsController[RightsControllerType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='RightsControllerType']/xs:restriction/xs:enumeration[@value=current()/RightsControllerType]"
                   role="Fatal Error">Fatal Error: The RightsControllerType should conform to the allowed value set RightsControllerType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='RightsControllerType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Type_Affiliation">
      <s:rule context="//Affiliation[Type]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AffiliationType']/xs:restriction/xs:enumeration[@value=current()/Type]"
                   role="Fatal Error">Fatal Error: The Type should conform to the allowed value set AffiliationType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AffiliationType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="IdentifierType_AllTerritoryCode">
      <s:rule context="//AllTerritoryCode[@IdentifierType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='TerritoryCodeTypeIncludingDeprecatedCodes']/xs:restriction/xs:enumeration[@value=current()/@IdentifierType]"
                   role="Fatal Error">Fatal Error: The IdentifierType should conform to the allowed value set TerritoryCodeTypeIncludingDeprecatedCodes. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='TerritoryCodeTypeIncludingDeprecatedCodes']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="AspectRatioType_AspectRatio">
      <s:rule context="//AspectRatio[@AspectRatioType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AspectRatioType']/xs:restriction/xs:enumeration[@value=current()/@AspectRatioType]"
                   role="Fatal Error">Fatal Error: The AspectRatioType should conform to the allowed value set AspectRatioType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AspectRatioType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="UnitOfMeasure_BitRate">
      <s:rule context="//BitRate[@UnitOfMeasure]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='UnitOfBitRate']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]"
                   role="Fatal Error">Fatal Error: The UnitOfMeasure should conform to the allowed value set UnitOfBitRate. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfBitRate']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Unit_ConditionForRightsClaimPolicy">
      <s:rule context="//ConditionForRightsClaimPolicy[Unit]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='UnitOfConditionValue']/xs:restriction/xs:enumeration[@value=current()/Unit]"
                   role="Fatal Error">Fatal Error: The Unit should conform to the allowed value set UnitOfConditionValue. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfConditionValue']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ReferenceCreation_ConditionForRightsClaimPolicy">
      <s:rule context="//ConditionForRightsClaimPolicy[ReferenceCreation]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ReferenceCreation']/xs:restriction/xs:enumeration[@value=current()/ReferenceCreation]"
                   role="Fatal Error">Fatal Error: The ReferenceCreation should conform to the allowed value set ReferenceCreation. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ReferenceCreation']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="RelationalRelator_ConditionForRightsClaimPolicy">
      <s:rule context="//ConditionForRightsClaimPolicy[RelationalRelator]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='RelationalRelator']/xs:restriction/xs:enumeration[@value=current()/RelationalRelator]"
                   role="Fatal Error">Fatal Error: The RelationalRelator should conform to the allowed value set RelationalRelator. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='RelationalRelator']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="IdentifierType_CurrentTerritoryCode">
      <s:rule context="//CurrentTerritoryCode[@IdentifierType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='TerritoryCodeType']/xs:restriction/xs:enumeration[@value=current()/@IdentifierType]"
                   role="Fatal Error">Fatal Error: The IdentifierType should conform to the allowed value set TerritoryCodeType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='TerritoryCodeType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="DataType_DetailedHashSum">
      <s:rule context="//DetailedHashSum[DataType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:restriction/xs:enumeration[@value=current()/DataType]"
                   role="Fatal Error">Fatal Error: The DataType should conform to the allowed value set BinaryDataType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='BinaryDataType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_DisplayArtistNameWithDefault">
      <s:rule context="//DisplayArtistNameWithDefault[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_DisplayCredits">
      <s:rule context="//DisplayCredits[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_EventDate">
      <s:rule context="//EventDate[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="TerritoryCode_EventDateTime">
      <s:rule context="//EventDateTime[@TerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@TerritoryCode]"
                   role="Fatal Error">Fatal Error: The TerritoryCode should conform to the allowed value set AllTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="UnitOfMeasure_Extent">
      <s:rule context="//Extent[@UnitOfMeasure]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='UnitOfExtent']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]"
                   role="Fatal Error">Fatal Error: The UnitOfMeasure should conform to the allowed value set UnitOfExtent. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfExtent']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_FirstPublicationDate">
      <s:rule context="//FirstPublicationDate[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="UnitOfMeasure_FrameRate">
      <s:rule context="//FrameRate[@UnitOfMeasure]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='UnitOfFrameRate']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]"
                   role="Fatal Error">Fatal Error: The UnitOfMeasure should conform to the allowed value set UnitOfFrameRate. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfFrameRate']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_FulfillmentDateWithTerritory">
      <s:rule context="//FulfillmentDateWithTerritory[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_GenreWithTerritory">
      <s:rule context="//GenreWithTerritory[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_KeywordsWithTerritory">
      <s:rule context="//KeywordsWithTerritory[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="LinkDescription_LinkedReleaseResourceReference">
      <s:rule context="//LinkedReleaseResourceReference[@LinkDescription]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='LinkDescription']/xs:restriction/xs:enumeration[@value=current()/@LinkDescription]"
                   role="Fatal Error">Fatal Error: The LinkDescription should conform to the allowed value set LinkDescription. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='LinkDescription']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_MarketingComment">
      <s:rule context="//MarketingComment[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MessageControlType_MessageHeader">
      <s:rule context="//MessageHeader[MessageControlType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='MessageControlType']/xs:restriction/xs:enumeration[@value=current()/MessageControlType]"
                   role="Fatal Error">Fatal Error: The MessageControlType should conform to the allowed value set MessageControlType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='MessageControlType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="PLineType_PLine">
      <s:rule context="//PLine[@PLineType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='PLineType']/xs:restriction/xs:enumeration[@value=current()/@PLineType]"
                   role="Fatal Error">Fatal Error: The PLineType should conform to the allowed value set PLineType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='PLineType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_PLineWithDefault">
      <s:rule context="//PLineWithDefault[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ApplicableTerritoryCode_ParentalWarningTypeWithTerritory">
      <s:rule context="//ParentalWarningTypeWithTerritory[@ApplicableTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/@ApplicableTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ApplicableTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CurrencyCode_Price">
      <s:rule context="//Price[@CurrencyCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrencyCode']/xs:restriction/xs:enumeration[@value=current()/@CurrencyCode]"
                   role="Fatal Error">Fatal Error: The CurrencyCode should conform to the allowed value set CurrencyCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrencyCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="RightsClaimPolicyType_RightsClaimPolicy">
      <s:rule context="//RightsClaimPolicy[RightsClaimPolicyType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='RightsClaimPolicyType']/xs:restriction/xs:enumeration[@value=current()/RightsClaimPolicyType]"
                   role="Fatal Error">Fatal Error: The RightsClaimPolicyType should conform to the allowed value set RightsClaimPolicyType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='RightsClaimPolicyType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="UnitOfMeasure_SamplingRate">
      <s:rule context="//SamplingRate[@UnitOfMeasure]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='UnitOfFrequency']/xs:restriction/xs:enumeration[@value=current()/@UnitOfMeasure]"
                   role="Fatal Error">Fatal Error: The UnitOfMeasure should conform to the allowed value set UnitOfFrequency. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='UnitOfFrequency']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="UseType_DealTerms">
      <s:rule context="//DealTerms[UseType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='UseType']/xs:restriction/xs:enumeration[@value=current()/UseType]"
                   role="Fatal Error">Fatal Error: The UseType should conform to the allowed value set UseType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='UseType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Role_AdministratingRecordCompanyWithReference">
      <s:rule context="//AdministratingRecordCompanyWithReference[Role]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AdministratingRecordCompanyRole']/xs:restriction/xs:enumeration[@value=current()/Role]"
                   role="Fatal Error">Fatal Error: The Role should conform to the allowed value set AdministratingRecordCompanyRole. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AdministratingRecordCompanyRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Territory_WorkRightsController">
      <s:rule context="//WorkRightsController[Territory]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/Territory]"
                   role="Fatal Error">Fatal Error: The Territory should conform to the allowed value set AllTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AllTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="AudioCodecType_TechnicalSoundRecordingDetails">
      <s:rule context="//TechnicalSoundRecordingDetails[AudioCodecType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:restriction/xs:enumeration[@value=current()/AudioCodecType]"
                   role="Fatal Error">Fatal Error: The AudioCodecType should conform to the allowed value set AudioCodecType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="AudioCodecType_TechnicalVideoDetails">
      <s:rule context="//TechnicalVideoDetails[AudioCodecType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:restriction/xs:enumeration[@value=current()/AudioCodecType]"
                   role="Fatal Error">Fatal Error: The AudioCodecType should conform to the allowed value set AudioCodecType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='AudioCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CarrierType_DealTerms">
      <s:rule context="//DealTerms[CarrierType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:restriction/xs:enumeration[@value=current()/CarrierType]"
                   role="Fatal Error">Fatal Error: The CarrierType should conform to the allowed value set CarrierType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CarrierType_ResourceGroup">
      <s:rule context="//ResourceGroup[CarrierType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:restriction/xs:enumeration[@value=current()/CarrierType]"
                   role="Fatal Error">Fatal Error: The CarrierType should conform to the allowed value set CarrierType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CarrierType_ResourceSubGroup">
      <s:rule context="//ResourceSubGroup[CarrierType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:restriction/xs:enumeration[@value=current()/CarrierType]"
                   role="Fatal Error">Fatal Error: The CarrierType should conform to the allowed value set CarrierType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CarrierType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CommercialModelType_DealTerms">
      <s:rule context="//DealTerms[CommercialModelType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CommercialModelType']/xs:restriction/xs:enumeration[@value=current()/CommercialModelType]"
                   role="Fatal Error">Fatal Error: The CommercialModelType should conform to the allowed value set CommercialModelType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CommercialModelType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ContainerFormat_TechnicalVideoDetails">
      <s:rule context="//TechnicalVideoDetails[ContainerFormat]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ContainerFormat']/xs:restriction/xs:enumeration[@value=current()/ContainerFormat]"
                   role="Fatal Error">Fatal Error: The ContainerFormat should conform to the allowed value set ContainerFormat. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ContainerFormat']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Role_Contributor">
      <s:rule context="//Contributor[Role]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:restriction/xs:enumeration[@value=current()/Role]"
                   role="Fatal Error">Fatal Error: The Role should conform to the allowed value set ContributorRole. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Role_DetailedResourceContributor">
      <s:rule context="//DetailedResourceContributor[Role]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:restriction/xs:enumeration[@value=current()/Role]"
                   role="Fatal Error">Fatal Error: The Role should conform to the allowed value set ContributorRole. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ArtisticRole_DisplayArtist">
      <s:rule context="//DisplayArtist[ArtisticRole]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:restriction/xs:enumeration[@value=current()/ArtisticRole]"
                   role="Fatal Error">Fatal Error: The ArtisticRole should conform to the allowed value set ContributorRole. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ContributorRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CueOrigin_DetailedCue">
      <s:rule context="//DetailedCue[CueOrigin]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CueOrigin']/xs:restriction/xs:enumeration[@value=current()/CueOrigin]"
                   role="Fatal Error">Fatal Error: The CueOrigin should conform to the allowed value set CueOrigin. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CueOrigin']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CueSheetType_DetailedCueSheet">
      <s:rule context="//DetailedCueSheet[CueSheetType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CueSheetType']/xs:restriction/xs:enumeration[@value=current()/CueSheetType]"
                   role="Fatal Error">Fatal Error: The CueSheetType should conform to the allowed value set CueSheetType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CueSheetType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CueThemeType_DetailedCue">
      <s:rule context="//DetailedCue[CueThemeType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ThemeType']/xs:restriction/xs:enumeration[@value=current()/CueThemeType]"
                   role="Fatal Error">Fatal Error: The CueThemeType should conform to the allowed value set ThemeType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ThemeType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CueUseType_DetailedCue">
      <s:rule context="//DetailedCue[CueUseType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CueUseType']/xs:restriction/xs:enumeration[@value=current()/CueUseType]"
                   role="Fatal Error">Fatal Error: The CueUseType should conform to the allowed value set CueUseType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CueUseType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CueVisualPerceptionType_DetailedCue">
      <s:rule context="//DetailedCue[CueVisualPerceptionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VisualPerceptionType']/xs:restriction/xs:enumeration[@value=current()/CueVisualPerceptionType]"
                   role="Fatal Error">Fatal Error: The CueVisualPerceptionType should conform to the allowed value set VisualPerceptionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VisualPerceptionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="CueVocalType_DetailedCue">
      <s:rule context="//DetailedCue[CueVocalType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VocalType']/xs:restriction/xs:enumeration[@value=current()/CueVocalType]"
                   role="Fatal Error">Fatal Error: The CueVocalType should conform to the allowed value set VocalType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VocalType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="TerritoryCode_DealTerms">
      <s:rule context="//DealTerms[TerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/TerritoryCode]"
                   role="Fatal Error">Fatal Error: The TerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ExcludedTerritoryCode_DealTerms">
      <s:rule context="//DealTerms[ExcludedTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/ExcludedTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ExcludedTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="TerritoryOfRightsDelegation_DelegatedUsageRights">
      <s:rule context="//DelegatedUsageRights[TerritoryOfRightsDelegation]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/TerritoryOfRightsDelegation]"
                   role="Fatal Error">Fatal Error: The TerritoryOfRightsDelegation should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="TerritoryCode_Affiliation">
      <s:rule context="//Affiliation[TerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/TerritoryCode]"
                   role="Fatal Error">Fatal Error: The TerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ExcludedTerritoryCode_Affiliation">
      <s:rule context="//Affiliation[ExcludedTerritoryCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:restriction/xs:enumeration[@value=current()/ExcludedTerritoryCode]"
                   role="Fatal Error">Fatal Error: The ExcludedTerritoryCode should conform to the allowed value set CurrentTerritoryCode. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='CurrentTerritoryCode']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="DisplayArtistRole_DisplayArtist">
      <s:rule context="//DisplayArtist[DisplayArtistRole]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='DisplayArtistRole']/xs:restriction/xs:enumeration[@value=current()/DisplayArtistRole]"
                   role="Fatal Error">Fatal Error: The DisplayArtistRole should conform to the allowed value set DisplayArtistRole. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='DisplayArtistRole']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ExternallyLinkedResourceType_ExternalResourceLink">
      <s:rule context="//ExternalResourceLink[ExternallyLinkedResourceType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ExternallyLinkedResourceType']/xs:restriction/xs:enumeration[@value=current()/ExternallyLinkedResourceType]"
                   role="Fatal Error">Fatal Error: The ExternallyLinkedResourceType should conform to the allowed value set ExternallyLinkedResourceType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ExternallyLinkedResourceType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Algorithm_Fingerprint">
      <s:rule context="//Fingerprint[Algorithm]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='FingerprintAlgorithmType']/xs:restriction/xs:enumeration[@value=current()/Algorithm]"
                   role="Fatal Error">Fatal Error: The Algorithm should conform to the allowed value set FingerprintAlgorithmType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='FingerprintAlgorithmType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Algorithm_DetailedHashSum">
      <s:rule context="//DetailedHashSum[Algorithm]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='HashSumAlgorithmType']/xs:restriction/xs:enumeration[@value=current()/Algorithm]"
                   role="Fatal Error">Fatal Error: The Algorithm should conform to the allowed value set HashSumAlgorithmType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='HashSumAlgorithmType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ImageCodecType_TechnicalImageDetails">
      <s:rule context="//TechnicalImageDetails[ImageCodecType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ImageCodecType']/xs:restriction/xs:enumeration[@value=current()/ImageCodecType]"
                   role="Fatal Error">Fatal Error: The ImageCodecType should conform to the allowed value set ImageCodecType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ImageCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Type_Image">
      <s:rule context="//Image[Type]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ImageType']/xs:restriction/xs:enumeration[@value=current()/Type]"
                   role="Fatal Error">Fatal Error: The Type should conform to the allowed value set ImageType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ImageType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="InstrumentType_Contributor">
      <s:rule context="//Contributor[InstrumentType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:restriction/xs:enumeration[@value=current()/InstrumentType]"
                   role="Fatal Error">Fatal Error: The InstrumentType should conform to the allowed value set InstrumentType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="InstrumentType_DetailedResourceContributor">
      <s:rule context="//DetailedResourceContributor[InstrumentType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:restriction/xs:enumeration[@value=current()/InstrumentType]"
                   role="Fatal Error">Fatal Error: The InstrumentType should conform to the allowed value set InstrumentType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='InstrumentType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="OperatingSystemType_TechnicalSoftwareDetails">
      <s:rule context="//TechnicalSoftwareDetails[OperatingSystemType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='OperatingSystemType']/xs:restriction/xs:enumeration[@value=current()/OperatingSystemType]"
                   role="Fatal Error">Fatal Error: The OperatingSystemType should conform to the allowed value set OperatingSystemType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='OperatingSystemType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ParentalWarningType_Image">
      <s:rule context="//Image[ParentalWarningType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"
                   role="Fatal Error">Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ParentalWarningType_Release">
      <s:rule context="//Release[ParentalWarningType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"
                   role="Fatal Error">Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ParentalWarningType_SheetMusic">
      <s:rule context="//SheetMusic[ParentalWarningType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"
                   role="Fatal Error">Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ParentalWarningType_Software">
      <s:rule context="//Software[ParentalWarningType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"
                   role="Fatal Error">Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ParentalWarningType_SoundRecording">
      <s:rule context="//SoundRecording[ParentalWarningType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"
                   role="Fatal Error">Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ParentalWarningType_Text">
      <s:rule context="//Text[ParentalWarningType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"
                   role="Fatal Error">Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ParentalWarningType_Video">
      <s:rule context="//Video[ParentalWarningType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:restriction/xs:enumeration[@value=current()/ParentalWarningType]"
                   role="Fatal Error">Fatal Error: The ParentalWarningType should conform to the allowed value set ParentalWarningType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ParentalWarningType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="PartyRelationshipType_RelatedParty">
      <s:rule context="//RelatedParty[PartyRelationshipType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='PartyRelationshipType']/xs:restriction/xs:enumeration[@value=current()/PartyRelationshipType]"
                   role="Fatal Error">Fatal Error: The PartyRelationshipType should conform to the allowed value set PartyRelationshipType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='PartyRelationshipType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="PriceCode_PriceInformationWithType">
      <s:rule context="//PriceInformationWithType[PriceCode]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='PriceType']/xs:restriction/xs:enumeration[@value=current()/PriceCode]"
                   role="Fatal Error">Fatal Error: The PriceCode should conform to the allowed value set PriceType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='PriceType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Purpose_ResourceContainedResourceReference">
      <s:rule context="//ResourceContainedResourceReference[Purpose]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='Purpose']/xs:restriction/xs:enumeration[@value=current()/Purpose]"
                   role="Fatal Error">Fatal Error: The Purpose should conform to the allowed value set Purpose. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='Purpose']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Agency_AvRating">
      <s:rule context="//AvRating[Agency]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='RatingAgency']/xs:restriction/xs:enumeration[@value=current()/Agency]"
                   role="Fatal Error">Fatal Error: The Agency should conform to the allowed value set RatingAgency. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='RatingAgency']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ReleaseRelationshipType_RelatedRelease">
      <s:rule context="//RelatedRelease[ReleaseRelationshipType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ReleaseRelationshipType']/xs:restriction/xs:enumeration[@value=current()/ReleaseRelationshipType]"
                   role="Fatal Error">Fatal Error: The ReleaseRelationshipType should conform to the allowed value set ReleaseRelationshipType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ReleaseRelationshipType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="ReleaseType_Release">
      <s:rule context="//Release[ReleaseType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='ReleaseType_ERN4']/xs:restriction/xs:enumeration[@value=current()/ReleaseType]"
                   role="Fatal Error">Fatal Error: The ReleaseType should conform to the allowed value set ReleaseType_ERN4. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='ReleaseType_ERN4']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="SheetMusicCodecType_TechnicalSheetMusicDetails">
      <s:rule context="//TechnicalSheetMusicDetails[SheetMusicCodecType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='SheetMusicCodecType']/xs:restriction/xs:enumeration[@value=current()/SheetMusicCodecType]"
                   role="Fatal Error">Fatal Error: The SheetMusicCodecType should conform to the allowed value set SheetMusicCodecType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='SheetMusicCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Type_SheetMusic">
      <s:rule context="//SheetMusic[Type]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='SheetMusicType']/xs:restriction/xs:enumeration[@value=current()/Type]"
                   role="Fatal Error">Fatal Error: The Type should conform to the allowed value set SheetMusicType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='SheetMusicType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="RightsType_Affiliation">
      <s:rule context="//Affiliation[RightsType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='RightsCoverage']/xs:restriction/xs:enumeration[@value=current()/RightsType]"
                   role="Fatal Error">Fatal Error: The RightsType should conform to the allowed value set RightsCoverage. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='RightsCoverage']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Type_Software">
      <s:rule context="//Software[Type]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='SoftwareType']/xs:restriction/xs:enumeration[@value=current()/Type]"
                   role="Fatal Error">Fatal Error: The Type should conform to the allowed value set SoftwareType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='SoftwareType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Type_SoundRecording">
      <s:rule context="//SoundRecording[Type]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='SoundRecordingType']/xs:restriction/xs:enumeration[@value=current()/Type]"
                   role="Fatal Error">Fatal Error: The Type should conform to the allowed value set SoundRecordingType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='SoundRecordingType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="TextCodecType_TechnicalTextDetails">
      <s:rule context="//TechnicalTextDetails[TextCodecType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='TextCodecType']/xs:restriction/xs:enumeration[@value=current()/TextCodecType]"
                   role="Fatal Error">Fatal Error: The TextCodecType should conform to the allowed value set TextCodecType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='TextCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Type_Text">
      <s:rule context="//Text[Type]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='TextType']/xs:restriction/xs:enumeration[@value=current()/Type]"
                   role="Fatal Error">Fatal Error: The Type should conform to the allowed value set TextType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='TextType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="UseType_DelegatedUsageRights">
      <s:rule context="//DelegatedUsageRights[UseType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='UseType']/xs:restriction/xs:enumeration[@value=current()/UseType]"
                   role="Fatal Error">Fatal Error: The UseType should conform to the allowed value set UseType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='UseType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="VersionType_Image">
      <s:rule context="//Image[VersionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"
                   role="Fatal Error">Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="VersionType_SheetMusic">
      <s:rule context="//SheetMusic[VersionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"
                   role="Fatal Error">Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="VersionType_Software">
      <s:rule context="//Software[VersionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"
                   role="Fatal Error">Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="VersionType_SoundRecording">
      <s:rule context="//SoundRecording[VersionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"
                   role="Fatal Error">Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="VersionType_Text">
      <s:rule context="//Text[VersionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"
                   role="Fatal Error">Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="VersionType_Video">
      <s:rule context="//Video[VersionType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:restriction/xs:enumeration[@value=current()/VersionType]"
                   role="Fatal Error">Fatal Error: The VersionType should conform to the allowed value set VersionType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VersionType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="VideoCodecType_TechnicalVideoDetails">
      <s:rule context="//TechnicalVideoDetails[VideoCodecType]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VideoCodecType']/xs:restriction/xs:enumeration[@value=current()/VideoCodecType]"
                   role="Fatal Error">Fatal Error: The VideoCodecType should conform to the allowed value set VideoCodecType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VideoCodecType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Type_Video">
      <s:rule context="//Video[Type]">
         <s:assert test="document('avs.xml')//xs:simpleType[@name='VideoType']/xs:restriction/xs:enumeration[@value=current()/Type]"
                   role="Fatal Error">Fatal Error: The Type should conform to the allowed value set VideoType. The allowed values are<s:value-of select="document('avs.xml')//xs:simpleType[@name='VideoType']/xs:annotation/xs:documentation[@source='ddex:ValueList']"/>.</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
