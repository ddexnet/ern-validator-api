<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron"
          xmlns:xs="http://www.w3.org/2001/XMLSchema"
          queryBinding="xslt2">
                    <!--
          This Schematron rule set requires XPath2. 
		  This is enabled by the queryBinding=“xslt2” attribute in the root tag. Users may be required 
		  to instruct the processor used to running the Schematron rule to use XPath2 in another way.
                    -->
                    <s:title>Schematron Release Profile for Mixed Media (version 2.1) for the NewReleaseMessage.</s:title>
   <s:p>© 2006-2018 Digital Data Exchange, LLC (DDEX)</s:p>
   <s:p>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If you wish to evaluate whether the standard meets your needs please have a look at the Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards. If you want to implement and use this DDEX standard, please take out an Implementation Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</s:p>
   <s:p>Failing a rule with a role of 'Fatal Error' means that the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Fatal Error' is the same as a 'Fatal Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>Failing a rule a rule with a role of 'Error' means that the Conformance Tester must recommend to award a Partial Conformance Certificate or to downgrade a Conformance Certificate that has already been issued. However, if more than 4 rules (representing 50% of all rules with a role of 'Error') have been failed at least once, the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error' is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>The following Clauses from the Release Profile standard are NOT checked by this ISO Schematron file: 5.1.1 (partly), 5.3.1.1(1-3, 7.1, 7.3, 9), 5.3.1.2(2.1, 3-4, 5.1), 5.3.1.3(4-5), 5.3.1.4(3-5, 8), 5.3.3.1-2, 5.3.3.4, 5.4.1(4.1), 5.4.3(5), 5.4.4(3, 5), 5.5.1(2), 5.5.2(2.4, 3.5-3.7), 5.6(1, 3). This file also does not check any rules specified in the ERN Message Suite Standard (Version 4.1) specifications, sections 6.4 and 6.5, except for 6.4.8-10</s:p>
   <s:pattern id="MultiProfile_MustContainOneRelease">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert test="count(Release) = 1" role="Fatal Error">Fatal Error (Mixed Media): A Release of this type must contain one (and only one) Release (Release Profile 2.1, Clause 5.1.1(a), Rule 1122-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ICPN">
      <s:rule context="//ICPN">
         <s:assert test="matches(., '^[0-9]{8}$|^[0-9]{12,14}$')" role="Fatal Error">Fatal Error (Mixed Media): An ICPN must be a string conforming to the pattern [0-9]{8} or [0-9]{12,14} (Release Profile 2.1, Clause 5.3.1.1(4a), Rule 1123-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISNI">
      <s:rule context="//PartyId[@IsISNI = 'true']">
         <s:assert test="matches(., '^[0-9]{15}[X0-9]$')" role="Fatal Error">Fatal Error (Mixed Media): A PartyId of type 'ISNI' must be a string conforming to the pattern [0-9]{15}[X0-9] (Release Profile 2.1, Clause 5.3.1.1(4b), Rule 1124-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_GRid">
      <s:rule context="//GRid">
         <s:assert test="matches(., '^[a-zA-Z0-9]{18}$')" role="Fatal Error">Fatal Error (Mixed Media): A GRid must be a string conforming to the pattern [a-zA-Z0-9]{18} (Release Profile 2.1, Clause 5.3.1.1(4c), Rule 1125-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SICI">
      <s:rule context="//SICI">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9].+')" role="Fatal Error">Fatal Error (Mixed Media): A SICI must be a string conforming to the pattern [0-9]{4}-[0-9]{3}[X0-9].+ (Release Profile 2.1, Clause 5.3.1.1(4d), Rule 1126-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISSN">
      <s:rule context="//ISSN">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9]$')" role="Fatal Error">Fatal Error (Mixed Media): An ISSN must be a string conforming to the pattern [0-9]{4}-[0-9]{3}[X0-9] (Release Profile 2.1, Clause 5.3.1.1(4e), Rule 1127-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISBN">
      <s:rule context="//ISBN">
         <s:assert test="matches(., '^97[8-9][0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error (Mixed Media): An ISBN must be a string conforming to the pattern 97[8-9][0-9]{9}[X0-9] (Release Profile 2.1, Clause 5.3.1.1(4f), Rule 1128-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_VISAN">
      <s:rule context="//VISAN">
         <s:assert test="matches(., '^[A-F0-9]{24}$')" role="Fatal Error">Fatal Error (Mixed Media): A VISAN must be a string conforming to the pattern [A-F0-9]{24} (Release Profile 2.1, Clause 5.3.1.1(4g), Rule 1129-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISAN">
      <s:rule context="//ISAN">
         <s:assert test="matches(., '^[A-F0-9]{12}$')" role="Fatal Error">Fatal Error (Mixed Media): An ISAN must be a string conforming to the pattern [A-F0-9]{12} (Release Profile 2.1, Clause 5.3.1.1(4h), Rule 1130-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISMN">
      <s:rule context="//ISMN">
         <s:assert test="matches(., '^979[0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error (Mixed Media): An ISMN must be a string conforming to the pattern 979[0-9]{9}[X0-9] (Release Profile 2.1, Clause 5.3.1.1(4i), Rule 1131-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISWC">
      <s:rule context="//ISWC">
         <s:assert test="matches(., '^[a-zA-Z][0-9]{10}$')" role="Fatal Error">Fatal Error (Mixed Media): An ISWC must be a string conforming to the pattern [a-zA-Z][0-9]{10} (Release Profile 2.1, Clause 5.3.1.1(4j), Rule 1132-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISRC">
      <s:rule context="//ISRC">
         <s:assert test="matches(., '^[a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7}$')"
                   role="Fatal Error">Fatal Error (Mixed Media): An ISRC must be a string conforming to the pattern [a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7} (Release Profile 2.1, Clause 5.3.1.1(4k), Rule 1133-1).</s:assert>
         <s:assert test="matches(substring(.,1,2), '(FX|QM|QZ|UK|CP|DG|ZZ|AD|AE|AF|AG|AI|AL|AM|AN|AO|AQ|AR|AS|AT|AU|AW|AX|AZ|BA|BB|BD|BE|BF|BG|BH|BI|BJ|BL|BM|BN|BO|BQ|BR|BS|BT|BV|BW|BY|BZ|CA|CC|CD|CF|CG|CH|CI|CK|CL|CM|CN|CO|CR|CS|CU|CV|CW|CX|CY|CZ|DE|DJ|DK|DM|DO|DZ|EC|EE|EG|EH|ER|ES|ET|FI|FJ|FK|FM|FO|FR|GA|GB|GD|GE|GF|GG|GH|GI|GL|GM|GN|GP|GQ|GR|GS|GT|GU|GW|GY|HK|HM|HN|HR|HT|HU|ID|IE|IL|IM|IN|IO|IQ|IR|IS|IT|JE|JM|JO|JP|KE|KG|KH|KI|KM|KN|KP|KR|KW|KY|KZ|LA|LB|LC|LI|LK|LR|LS|LT|LU|LV|LY|MA|MC|MD|ME|MF|MG|MH|MK|ML|MM|MN|MO|MP|MQ|MR|MS|MT|MU|MV|MW|MX|MY|MZ|NA|NC|NE|NF|NG|NI|NL|NO|NP|NR|NU|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PM|PN|PR|PS|PT|PW|PY|QA|RE|RO|RS|RU|RW|SA|SB|SC|SD|SE|SG|SH|SI|SJ|SK|SL|SM|SN|SO|SR|SS|ST|SV|SX|SY|SZ|TC|TD|TF|TG|TH|TJ|TK|TL|TM|TN|TO|TR|TT|TV|TW|TZ|UA|UG|UM|US|UY|UZ|VA|VC|VE|VG|VI|VN|VU|WF|WS|YE|YT|ZA|ZM|ZW)')"
                   role="Fatal Error">Fatal Error (Mixed Media): An ISRC must be a string starting with an ISO 3166 code or FX, QM, QZ, UK, CP, DG or ZZ (Release Profile 2.1, Clause 5.3.1.1(4k), Rule 1133-2).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_UserDefinedValue">
      <s:rule context="//*[@UserDefinedValue]">
         <s:assert test=".='UserDefined' or @LinkDescription='UserDefined' or @LabelType='UserDefined'"
                   role="Fatal Error">Fatal Error (Mixed Media): The value shall be 'UserDefined' if a user-defined value is supplied (Release Profile 2.1, Clause 5.3.1.1(5), Rule 1134-1).</s:assert>
         <s:assert test="@Namespace" role="Fatal Error">Fatal Error (Mixed Media): The appropriate Namespace for the user-defined value shall be provided (Release Profile 2.1, Clause 5.3.1.1(5), Rule 1134-2).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_RightSharePercentageValue">
      <s:rule context="//RightSharePercentage">
         <s:assert test="//RightSharePercentage &gt; 0 and //RightSharePercentage &lt; 100"
                   role="Fatal Error">Fatal Error (Mixed Media): A RightSharePercentage has a value between 0 and 100 (Release Profile 2.1, Clause 5.3.1.1(6), Rule 1135-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_IsDefaultTerritory">
      <s:rule context="//*[@IsDefault]">
         <s:assert test="count(../*[name(.)=name(current()) and @IsDefault = 'true']) = 1"
                   role="Fatal Error">Fatal Error (Mixed Media): An IsDefault flag with value true may only be provided once (Release Profile 2.1, Clause 5.3.1.1(7.2), Rule 1136-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_Contributor">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[not(@IsSupplemental = 'true')] | *:NewReleaseMessage/ResourceList/Video[not(@IsSupplemental = 'true')]">
         <s:assert test="//Contributor[Role = 'Adapter' or Role = 'Arranger' or Role = 'Author' or Role = 'Composer' or Role = 'ComposerLyricist' or Role = 'Librettist' or Role = 'Lyricist' or Role = 'NonLyricAuthor' or Role = 'SubArranger' or Role = 'Translator']"
                   role="Conditional Fatal Error">Conditional Fatal Error (Mixed Media): Any available information on Contributors that have one of the roles Adapter, Arranger, Author, Composer, ComposerLyricist, Librettist, Lyricist, NonLyricAuthor, SubArranger, Translator should be provided (Release Profile 2.1, Clause 5.3.1.1(8), Rule 1137-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_DisplayArtistsMustBeSequenced">
      <s:rule context="//DisplayArtist">
         <s:assert test="@SequenceNumber" role="Fatal Error">Fatal Error (Mixed Media): All DisplayArtists should be sequenced (Release Profile 2.1, Clause 5.3.1.2(1), Rule 1138-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustNotHaveManyMainDisplayArtists">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release | *:NewReleaseMessage/ResourceList/*">
         <s:report test="count(DisplayArtist[DisplayArtistRole = 'MainArtist']) &gt; 1"
                   role="Conditional Error">Conditional Error (Mixed Media): Additional artists may not have a DisplayArtistRole of MainArtist (Release Profile 2.1, Clause 5.3.1.2(2), Rule 1139-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourceGroupType">
      <s:rule context="*:NewReleaseMessage[not(@ReleaseProfileVariantVersionId)]/ReleaseList/Release/ResourceGroup/ResourceGroup">
         <s:assert test="@ResourceGroupType = 'Component' or @ResourceGroupType = 'Side'"
                   role="Fatal Error">Fatal Error (Mixed Media): Second-level ResourceGroups shall have a ResourceGroupType of either Side or Component unless it is a variant Release Profile (Release Profile 2.1, Clause 5.3.1.2(5.2), Rule 1140-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourceGroupsMustBeSequenced">
      <s:rule context="//ResourceGroup[@ResourceGroupType = 'Component' or @ResourceGroupType = 'ComponentRelease' or @ResourceGroupType = 'Side' or @ResourceGroupType = 'MultiWorkPart']">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error (Mixed Media): ResourceGroups of type Component, ComponentRelease, Side or MultiWorkPart shall be sequenced (Release Profile 2.1, Clause 5.3.1.2(5.3), Rule 1141-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_PrimaryResourcesMustBeSequenced">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[not(@IsSupplemental = 'true')] | *:NewReleaseMessage/ResourceList/Video[not(@IsSupplemental = 'true')]">
         <s:assert test="//ResourceGroupContentItem[ReleaseResourceReference = current()/ResourceReference]/SequenceNumber"
                   role="Fatal Error">Fatal Error (Mixed Media): Primary Resources shall be sequenced in their ResourceGroupContentItem (Release Profile 2.1, Clause 5.3.1.2(5.4), Rule 1142-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SequenceNumberMustBeDifferent">
      <s:rule context="//SequenceNumber">
         <s:report test="count(../../*[name(.)=name(current()/..) and SequenceNumber=current()]) &gt; 1"
                   role="Fatal Error">Fatal Error (Mixed Media): SequenceNumbers must all be different (Release Profile 2.1, Clause 5.3.1.2(5.5), Rule 1143-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SingleSequenceInResourceGroup">
      <s:rule context="//ResourceGroup/ResourceGroup/SequenceNumber">
         <s:report test="current() = ../../ResourceGroupContentItem/SequenceNumber"
                   role="Fatal Error">Fatal Error (Mixed Media): There is only one sequence within a ResourceGroup (Release Profile 2.1, Clause 5.3.1.2(5.6), Rule 1144-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SecondaryResourcesMustNotBeSequenced">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Video[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Image | *:NewReleaseMessage/ResourceList/Text | *:NewReleaseMessage/ResourceList/SheetMusic | *:NewReleaseMessage/ResourceList/Software">
         <s:report test="//ResourceGroupContentItem[ReleaseResourceReference = current()/ResourceReference]/SequenceNumber"
                   role="Error">Error (Mixed Media): Secondary Resources shall not be sequenced in their ResourceGroupContentItem (Release Profile 2.1, Clause 5.3.1.2(5.7a), Rule 1145-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_CueMustHaveStartTimeOrDuration">
      <s:rule context="//Cue">
         <s:assert test="StartTime[string-length(normalize-space(text())) &gt; 0] or Duration[string-length(normalize-space(text())) &gt; 0]"
                   role="Error">Error (Mixed Media): Each Cue should have a StartTime or a Duration (Release Profile 2.1, Clause 5.3.1.2(6), Rule 1146-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MainReleaseMustHaveGridOrICPN">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | ReleaseId/ICPN[string-length(normalize-space(text())) &gt; 0] | ReleaseId/ProprietaryId"
                   role="Fatal Error">Fatal Error (Mixed Media): The MainRelease shall be identified by either a GRid or by an ICPN or by a ProprietaryID (Release Profile 2.1, Clause 5.3.1.3(1), Rule 1147-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ReleaseMayHaveCLine">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="CLine" role="Conditional Fatal Error">Conditional Fatal Error (Mixed Media): Each Release may have a CLine (Release Profile 2.1, Clause 5.3.1.3(6), Rule 1148-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ReleaseDateMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDate | OriginalReleaseDate" role="Conditional Error">Conditional Error (Mixed Media): An OriginalReleaseDate or a ReleaseDate shall be provided for each Release (Release Profile 2.1, Clause 5.3.1.3(7), Rule 1149-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourceGroupTypeSide">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release[//@ResourceGroupType = 'Side']">
         <s:assert test="*:NewReleaseMessage/DealList/ReleaseDeal[DealReleaseReference = current()/ReleaseReference]/Deal/DealTerms/UseType[text() = 'PurchaseAsPhysicalProduct']"
                   role="Conditional Error">Conditional Error (Mixed Media): A ResourceGroup of type Side shall only be provided for Releases that may be available with a UseType of PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 5.3.1.3(8), Rule 1150-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SecondaryResourceMustHaveProprietaryId">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Image">
         <s:assert test="ResourceId/ProprietaryId[string-length(normalize-space(text())) &gt; 0]"
                   role="Fatal Error">Fatal Error (Mixed Media): Secondary SoundRecordings and Images shall be identified with a ProprietaryId (Release Profile 2.1, Clause 5.3.1.4(2a), Rule 1151-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_NoContributorDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList/*">
         <s:assert test="count(Contributor)=count(Contributor[not(ContributorPartyReference=preceding-sibling::Contributor/ContributorPartyReference)])"
                   role="Fatal Error">Fatal Error (Mixed Media): Contributors shall be provided only once (with multiple roles) (Release Profile 2.1, Clause 5.3.1.4(6), Rule 1152-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_FirstPublicationDateMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[not(@IsSupplemental = 'true')] | *:NewReleaseMessage/ResourceList/Video[not(@IsSupplemental = 'true')]">
         <s:assert test="count(FirstPublicationDate) &gt; 0" role="Conditional Error">Conditional Error (Mixed Media): For each Primary Resource at least one FirstPublicationDate shall be provided (Release Profile 2.1, Clause 5.3.1.4(7), Rule 1153-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TechnicalDetails">
      <s:rule context="*:NewReleaseMessage/ResourceList/*">
         <s:report test="TechnicalDetails" role="Conditional Fatal Error">Conditional Fatal Error (Mixed Media): TechnicalDetails are included, so a Resource File should be communicated (Release Profile 2.1, Clause 5.3.3.3, Rule 1154-1).</s:report>
         <s:assert test="TechnicalDetails" role="Conditional Fatal Error">Conditional Fatal Error (Mixed Media): TechnicalDetails are not included, so no Resource File should be communicated (Release Profile 2.1, Clause 5.3.3.3, Rule 1154-2).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ChaptersMustBeReferenced">
      <s:rule context="//Chapter/ChapterReference">
         <s:assert test=".=//*[ends-with(name(),'Reference') and name()!=name(current())]"
                   role="Warning">Warning (Mixed Media): All ChapterReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_CueSheetsMustBeReferenced">
      <s:rule context="//CueSheet/CueSheetReference">
         <s:assert test=".=//*[ends-with(name(),'Reference') and name()!=name(current())]"
                   role="Warning">Warning (Mixed Media): All CueSheetReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.2).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourcesMustBeReferenced">
      <s:rule context="//ResourceList/*/ResourceReference">
         <s:assert test=".=//*[ends-with(name(),'Reference') and name()!=name(current())]"
                   role="Warning">Warning (Mixed Media): All ResourceReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.3).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_PartiesMustBeReferenced">
      <s:rule context="//Party/PartyReference">
         <s:assert test=".=//*[(ends-with(name(),'Reference') and name()!=name(current()) or name()='MusicRightsSociety' or name()='Label')]"
                   role="Warning">Warning (Mixed Media): All PartyReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.4).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ReleasesMustBeReferenced">
      <s:rule context="//Release/ReleaseReference">
         <s:assert test=".=//*[ends-with(name(),'Reference') and name()!=name(current())]"
                   role="Warning">Warning (Mixed Media): All ReleaseReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.5).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_DateShouldBeBeforeDealStartDate">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[ValidityPeriod/StartDate]">
         <s:report test="translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A ReleaseDisplayStartDate may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1160-1).</s:report>
         <s:report test="translate(TrackListingPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A TrackListingPreviewStartDate may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1160-2).</s:report>
         <s:report test="translate(CoverArtPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A CoverArtPreviewStartDate may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1160-3).</s:report>
         <s:report test="translate(ClipPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A ClipPreviewStartDate may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1160-4).</s:report>
         <s:report test="translate(substring(ReleaseDisplayStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A ReleaseDisplayStartDateTime may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1160-5).</s:report>
         <s:report test="translate(substring(TrackListingPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A TrackListingPreviewStartDateTime may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1160-6).</s:report>
         <s:report test="translate(substring(CoverArtPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A CoverArtPreviewStartDateTime may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1160-7).</s:report>
         <s:report test="translate(substring(ClipPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A ClipPreviewStartDateTime may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1160-8).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_DateShouldBeBeforeDealStartDateTime">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[ValidityPeriod/StartDateTime]">
         <s:report test="translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A ReleaseDisplayStartDate may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1161-1).</s:report>
         <s:report test="translate(TrackListingPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A TrackListingPreviewStartDate may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1161-2).</s:report>
         <s:report test="translate(CoverArtPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A CoverArtPreviewStartDate may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1161-3).</s:report>
         <s:report test="translate(ClipPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A ClipPreviewStartDate may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1161-4).</s:report>
         <s:report test="translate(substring(ReleaseDisplayStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A ReleaseDisplayStartDateTime may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1161-5).</s:report>
         <s:report test="translate(substring(TrackListingPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A TrackListingPreviewStartDateTime may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1161-6).</s:report>
         <s:report test="translate(substring(CoverArtPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A CoverArtPreviewStartDateTime may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1161-7).</s:report>
         <s:report test="translate(substring(ClipPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Mixed Media): A ClipPreviewStartDateTime may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1161-8).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustNotContainPriceType">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation[@PriceType]">
         <s:report test="BulkOrderWholesalePricePerUnit or WholesalePricePerUnit"
                   role="Fatal Error">Fatal Error (Mixed Media): WholesalePricePerUnit and BulkOrderWholesalePricePerUnit may not be combined with a PriceType. (Release Profile 2.1, Clause 6.4.9, Rule 1162-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainUseType1">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[PriceInformation/BulkOrderWholesalePricePerUnit]">
         <s:assert test="UseType='PurchaseAsPhysicalProduct'" role="Fatal Error">Fatal Error (Mixed Media): BulkOrderWholesalePricePerUnit may only be used if UseType = PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 6.4.10(a), Rule 1163-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainUseType2">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CarrierType]">
         <s:assert test="UseType='PurchaseAsPhysicalProduct'" role="Fatal Error">Fatal Error (Mixed Media): CarrierType may only be used if UseType = PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 6.4.10(b), Rule 1164-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainUseType3">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[PhysicalReturns]">
         <s:assert test="UseType='PurchaseAsPhysicalProduct'" role="Fatal Error">Fatal Error (Mixed Media): PhysicalReturns may only be used if UseType = PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 6.4.10(c), Rule 1165-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainUseType4">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[NumberOfProductsPerCarton]">
         <s:assert test="UseType='PurchaseAsPhysicalProduct'" role="Fatal Error">Fatal Error (Mixed Media): NumberOfProductsPerCarton may only be used if UseType = PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 6.4.10(d), Rule 1166-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainOneTrackReleasePerPrimaryResource">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[not(@IsSupplemental = 'true')] | *:NewReleaseMessage/ResourceList/Video[not(@IsSupplemental = 'true')]">
         <s:assert test="count(//TrackRelease[ReleaseResourceReference = current()/ResourceReference]) = 1"
                   role="Fatal Error">Fatal Error (Mixed Media): A Release of this type must contain exactly one TrackRelease for each Primary Resource referenced in the Main Release (Release Profile 2.1, Clause 5.1.1(b), Rule 1167-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TrackReleaseMustNotHaveISRC">
      <s:rule context="*:NewReleaseMessage/ReleaseList/TrackRelease">
         <s:report test="ReleaseId/ISRC" role="Fatal Error">Fatal Error (Mixed Media): An ISRC as an identifier for a TrackRelease shall be communicated as a ProprietaryId (Release Profile 2.1, Clause 5.3.1.3(3), Rule 1168-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TrackReleaseMustHaveOnePrimaryResource">
      <s:rule context="*:NewReleaseMessage/ReleaseList/TrackRelease">
         <s:assert test="count(ReleaseResourceReference) = 1" role="Fatal Error">Fatal Error (Mixed Media): A TrackRelease must refer to one Primary Resource (Release Profile 2.1, Clause 5.6(2a), Rule 1169-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TrackReleaseMustNotHaveSecondaryResources">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Video[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Image | *:NewReleaseMessage/ResourceList/Text | *:NewReleaseMessage/ResourceList/SheetMusic | *:NewReleaseMessage/ResourceList/Software">
         <s:report test="ResourceReference[text() = //TrackRelease/ReleaseResourceReference]"
                   role="Fatal Error">Fatal Error (Mixed Media): A TrackRelease must not refer to a Secondary Resource (Release Profile 2.1, Clause 5.6(2b), Rule 1170-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TrackReleaseMustNotHaveRedundantTitles">
      <s:rule context="*:NewReleaseMessage/ReleaseList/TrackRelease">
         <s:report test="DisplayTitle = //ResourceList/*[ResourceReference = current()/ReleaseResourceReference]/DisplayTitle"
                   role="Error">Error (Mixed Media): Title information for TrackReleases shall only be provided if it differs from the title information provided on the Resource (Release Profile 2.1, Clause 5.6(4), Rule 1171-1).</s:report>
         <s:report test="DisplayTitleText = //ResourceList/*[ResourceReference = current()/ReleaseResourceReference]/DisplayTitleText"
                   role="Error">Error (Mixed Media): Title information for TrackReleases shall only be provided if it differs from the title information provided on the Resource (Release Profile 2.1, Clause 5.6(4), Rule 1171-2).</s:report>
         <s:report test="AdditionalTitle = //ResourceList/*[ResourceReference = current()/ReleaseResourceReference]/AdditionalTitle"
                   role="Error">Error (Mixed Media): Title information for TrackReleases shall only be provided if it differs from the title information provided on the Resource (Release Profile 2.1, Clause 5.6(4), Rule 1171-3).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MixedMedia_ReleaseProfileVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="@ReleaseProfileVersionId = 'MixedMedia'" role="Fatal Error">Fatal Error (Mixed Media): The ReleaseProfileVersionId should be 'MixedMedia' (Release Profile 2.1, Clause 5.2.1, Rule 1172-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ReleaseProfileVariantVersionId">
      <s:rule context="*:NewReleaseMessage[@ReleaseProfileVariantVersionId]">
         <s:assert test="@ReleaseProfileVariantVersionId = 'BoxedSet' or @ReleaseProfileVariantVersionId = 'Classical' or @ReleaseProfileVariantVersionId = 'BoxedSet Classical' or @ReleaseProfileVariantVersionId = 'Classical BoxedSet'"
                   role="Fatal Error">Fatal Error (Mixed Media): The ReleaseProfileVariantVersionId should conform to clause 5.2.2 (Release Profile 2.1, Clause 5.2.2, Rule 1173-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainWorkSoundRecording">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="SoundRecording/Type[text() = 'MusicalWorkSoundRecording' or text() = 'NonMusicalWorkSoundRecording']"
                   role="Fatal Error">Fatal Error (Mixed Media): A Release of this type must contain SoundRecordings of type MusicalWorkSoundRecording or NonMusicalWorkSoundRecording (Release Profile 2.1, Clause 5.1.2(a), Rule 1174-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainShortFormMusicalWorkVideo">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="Video/Type[text() = 'ShortFormMusicalWorkVideo']"
                   role="Fatal Error">Fatal Error (Mixed Media): A Release of this type must contain at least one Video of type ShortFormMusicalWorkVideo (Release Profile 2.1, Clause 5.1.2(b), Rule 1175-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainOneFrontCoverImage">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(Image[Type[text() = 'FrontCoverImage']]) = 1"
                   role="Fatal Error">Fatal Error (Mixed Media): A Release of this type must contain one (and only one) Image of type FrontCoverImage (Release Profile 2.1, Clause 5.1.2(c), Rule 1176-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TextSheetMusicSoftwareMustBeBonus">
      <s:rule context="*:NewReleaseMessage/ResourceList/Text | *:NewReleaseMessage/ResourceList/SheetMusic | *:NewReleaseMessage/ResourceList/Software">
         <s:report test="ResourceReference = //ResourceGroupContentItem[IsBonusResource = 'true']/ReleaseResourceReference"
                   role="Fatal Error">Fatal Error (Mixed Media): Text, SheetMusic and Software must be bonus resources (Release Profile 2.1, Clause 5.1.2(d), Rule 1177-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MixedMedia_MainReleaseType">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseType[text() = 'Album' or text() = 'Bundle' or text() = 'ClassicalAlbum' or text() = 'ClassicalDigitalBoxedSet' or text() = 'ClassicalMultimediaAlbum' or text() = 'DigitalBoxSetRelease' or text() = 'Documentary' or text() = 'EBookRelease' or text() = 'EP' or text() = 'Episode' or text() = 'MaxiSingle' or text() = 'MiniAlbum' or text() = 'MultimediaAlbum' or text() = 'MultimediaDigitalBoxedSet' or text() = 'MultimediaSingle' or text() = 'Playlist' or text() = 'Season' or text() = 'Series' or text() = 'Single' or text() = 'UserDefined']"
                   role="Warning">Warning (Mixed Media): The MainRelease must have a ReleaseType according to clause 5.1.3 (Release Profile 2.1, Clause 5.1.3, Rule 1178-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_BonusResourcesMustNotBeSequenced">
      <s:rule context="//ResourceGroupContentItem[IsBonusResource = 'true']">
         <s:report test="SequenceNumber" role="Error">Error (Mixed Media): Secondary Resources shall not be sequenced in their ResourceGroupContentItem (Release Profile 2.1, Clause 5.3.1.2(5.7b), Rule 1179-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_FrontCoverImageMustBeLinked">
      <s:rule context="*:NewReleaseMessage/ResourceList/Image[Type = 'FrontCoverImage']">
         <s:assert test="//Release/ResourceGroup[LinkedReleaseResourceReference = current()/ResourceReference]"
                   role="Error">Error (Mixed Media): FrontCoverImages shall be linked from the top-level ResourceGroup's LinkedReleaseResourceReference (Release Profile 2.1, Clause 5.3.1.2(5.8), Rule 1180-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_VideoScreenCaptureMustBeLinked">
      <s:rule context="*:NewReleaseMessage/ResourceList/Image[Type[text() = 'VideoScreenCapture']]">
         <s:assert test="//ResourceGroupContentItem/LinkedReleaseResourceReference[@LinkDescription = 'VideoScreenCapture' and text() = current()/ResourceReference]"
                   role="Error">Error (Mixed Media): VideoScreenCaptures shall be linked from the ResourceGroupContentItem by a LinkedReleaseResourceReference element with a LinkDescription of VideoScreenCapture (Release Profile 2.1, Clause 5.3.1.2(5.9), Rule 1181-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_PrimaryResourceMustHaveISRC">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[not(@IsSupplemental = 'true')] | *:NewReleaseMessage/ResourceList/Video[not(@IsSupplemental = 'true')]">
         <s:assert test="ResourceId/ISRC[string-length(normalize-space(text())) &gt; 0]"
                   role="Error">Error (Mixed Media): Primary SoundRecordings and Videos shall be identified with an ISRC (Release Profile 2.1, Clause 5.3.1.4(1), Rule 1182-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_BonusResourceMustHaveProprietaryId">
      <s:rule context="*:NewReleaseMessage/ResourceList/*[ResourceReference = //ResourceGroupContentItem[IsBonusResource = 'true']/ReleaseResourceReference]">
         <s:assert test="ResourceId/ProprietaryId[string-length(normalize-space(text())) &gt; 0]"
                   role="Fatal Error">Fatal Error (Mixed Media): Bonus Resources shall be identified with a ProprietaryId (Release Profile 2.1, Clause 5.3.1.4(2b), Rule 1183-1).</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
