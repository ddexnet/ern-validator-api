<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron"
          xmlns:xs="http://www.w3.org/2001/XMLSchema"
          queryBinding="xslt2">
                    <!--
          This Schematron rule set requires XPath2. 
		  This is enabled by the queryBinding=“xslt2” attribute in the root tag. Users may be required 
		  to instruct the processor used to running the Schematron rule to use XPath2 in another way.
                    -->
                    <s:title>Schematron Release Profile for Ringtone (version 2.1) for the NewReleaseMessage.</s:title>
   <s:p>© 2006-2018 Digital Data Exchange, LLC (DDEX)</s:p>
   <s:p>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If you wish to evaluate whether the standard meets your needs please have a look at the Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards. If you want to implement and use this DDEX standard, please take out an Implementation Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</s:p>
   <s:p>Failing a rule with a role of 'Fatal Error' means that the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Fatal Error' is the same as a 'Fatal Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>Failing a rule a rule with a role of 'Error' means that the Conformance Tester must recommend to award a Partial Conformance Certificate or to downgrade a Conformance Certificate that has already been issued. However, if more than 2 rules (representing 50% of all rules with a role of 'Error') have been failed at least once, the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error' is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>The following Clauses from the Release Profile standard are NOT checked by this ISO Schematron file: 5.1.1 (partly), 5.3.1.1(1-3, 7.1, 7.3, 9), 5.3.1.2(2.1, 3-4, 5.1), 5.3.1.3(4-5), 5.3.1.4(3-5, 8), 5.3.3.1-2, 5.3.3.4, 5.4.1(4.1), 5.4.3(5), 5.4.4(3, 5), 5.5.1(2), 5.5.2(2.4, 3.5-3.7), 5.6(1, 3). This file also does not check any rules specified in the ERN Message Suite Standard (Version 4.1) specifications, sections 6.4 and 6.5, except for 6.4.8-10</s:p>
   <s:pattern id="MultiProfile_MustContainOneRelease">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert test="count(Release) = 1" role="Fatal Error">Fatal Error (Ringtone): A Release of this type must contain one (and only one) Release (Release Profile 2.1, Clause 5.1.1(a), Rule 1184-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ICPN">
      <s:rule context="//ICPN">
         <s:assert test="matches(., '^[0-9]{8}$|^[0-9]{12,14}$')" role="Fatal Error">Fatal Error (Ringtone): An ICPN must be a string conforming to the pattern [0-9]{8} or [0-9]{12,14} (Release Profile 2.1, Clause 5.3.1.1(4a), Rule 1185-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISNI">
      <s:rule context="//PartyId[@IsISNI = 'true']">
         <s:assert test="matches(., '^[0-9]{15}[X0-9]$')" role="Fatal Error">Fatal Error (Ringtone): A PartyId of type 'ISNI' must be a string conforming to the pattern [0-9]{15}[X0-9] (Release Profile 2.1, Clause 5.3.1.1(4b), Rule 1186-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_GRid">
      <s:rule context="//GRid">
         <s:assert test="matches(., '^[a-zA-Z0-9]{18}$')" role="Fatal Error">Fatal Error (Ringtone): A GRid must be a string conforming to the pattern [a-zA-Z0-9]{18} (Release Profile 2.1, Clause 5.3.1.1(4c), Rule 1187-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SICI">
      <s:rule context="//SICI">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9].+')" role="Fatal Error">Fatal Error (Ringtone): A SICI must be a string conforming to the pattern [0-9]{4}-[0-9]{3}[X0-9].+ (Release Profile 2.1, Clause 5.3.1.1(4d), Rule 1188-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISSN">
      <s:rule context="//ISSN">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9]$')" role="Fatal Error">Fatal Error (Ringtone): An ISSN must be a string conforming to the pattern [0-9]{4}-[0-9]{3}[X0-9] (Release Profile 2.1, Clause 5.3.1.1(4e), Rule 1189-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISBN">
      <s:rule context="//ISBN">
         <s:assert test="matches(., '^97[8-9][0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error (Ringtone): An ISBN must be a string conforming to the pattern 97[8-9][0-9]{9}[X0-9] (Release Profile 2.1, Clause 5.3.1.1(4f), Rule 1190-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_VISAN">
      <s:rule context="//VISAN">
         <s:assert test="matches(., '^[A-F0-9]{24}$')" role="Fatal Error">Fatal Error (Ringtone): A VISAN must be a string conforming to the pattern [A-F0-9]{24} (Release Profile 2.1, Clause 5.3.1.1(4g), Rule 1191-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISAN">
      <s:rule context="//ISAN">
         <s:assert test="matches(., '^[A-F0-9]{12}$')" role="Fatal Error">Fatal Error (Ringtone): An ISAN must be a string conforming to the pattern [A-F0-9]{12} (Release Profile 2.1, Clause 5.3.1.1(4h), Rule 1192-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISMN">
      <s:rule context="//ISMN">
         <s:assert test="matches(., '^979[0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error (Ringtone): An ISMN must be a string conforming to the pattern 979[0-9]{9}[X0-9] (Release Profile 2.1, Clause 5.3.1.1(4i), Rule 1193-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISWC">
      <s:rule context="//ISWC">
         <s:assert test="matches(., '^[a-zA-Z][0-9]{10}$')" role="Fatal Error">Fatal Error (Ringtone): An ISWC must be a string conforming to the pattern [a-zA-Z][0-9]{10} (Release Profile 2.1, Clause 5.3.1.1(4j), Rule 1194-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ISRC">
      <s:rule context="//ISRC">
         <s:assert test="matches(., '^[a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7}$')"
                   role="Fatal Error">Fatal Error (Ringtone): An ISRC must be a string conforming to the pattern [a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7} (Release Profile 2.1, Clause 5.3.1.1(4k), Rule 1195-1).</s:assert>
         <s:assert test="matches(substring(.,1,2), '(FX|QM|QZ|UK|CP|DG|ZZ|AD|AE|AF|AG|AI|AL|AM|AN|AO|AQ|AR|AS|AT|AU|AW|AX|AZ|BA|BB|BD|BE|BF|BG|BH|BI|BJ|BL|BM|BN|BO|BQ|BR|BS|BT|BV|BW|BY|BZ|CA|CC|CD|CF|CG|CH|CI|CK|CL|CM|CN|CO|CR|CS|CU|CV|CW|CX|CY|CZ|DE|DJ|DK|DM|DO|DZ|EC|EE|EG|EH|ER|ES|ET|FI|FJ|FK|FM|FO|FR|GA|GB|GD|GE|GF|GG|GH|GI|GL|GM|GN|GP|GQ|GR|GS|GT|GU|GW|GY|HK|HM|HN|HR|HT|HU|ID|IE|IL|IM|IN|IO|IQ|IR|IS|IT|JE|JM|JO|JP|KE|KG|KH|KI|KM|KN|KP|KR|KW|KY|KZ|LA|LB|LC|LI|LK|LR|LS|LT|LU|LV|LY|MA|MC|MD|ME|MF|MG|MH|MK|ML|MM|MN|MO|MP|MQ|MR|MS|MT|MU|MV|MW|MX|MY|MZ|NA|NC|NE|NF|NG|NI|NL|NO|NP|NR|NU|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PM|PN|PR|PS|PT|PW|PY|QA|RE|RO|RS|RU|RW|SA|SB|SC|SD|SE|SG|SH|SI|SJ|SK|SL|SM|SN|SO|SR|SS|ST|SV|SX|SY|SZ|TC|TD|TF|TG|TH|TJ|TK|TL|TM|TN|TO|TR|TT|TV|TW|TZ|UA|UG|UM|US|UY|UZ|VA|VC|VE|VG|VI|VN|VU|WF|WS|YE|YT|ZA|ZM|ZW)')"
                   role="Fatal Error">Fatal Error (Ringtone): An ISRC must be a string starting with an ISO 3166 code or FX, QM, QZ, UK, CP, DG or ZZ (Release Profile 2.1, Clause 5.3.1.1(4k), Rule 1195-2).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_UserDefinedValue">
      <s:rule context="//*[@UserDefinedValue]">
         <s:assert test=".='UserDefined' or @LinkDescription='UserDefined' or @LabelType='UserDefined'"
                   role="Fatal Error">Fatal Error (Ringtone): The value shall be 'UserDefined' if a user-defined value is supplied (Release Profile 2.1, Clause 5.3.1.1(5), Rule 1196-1).</s:assert>
         <s:assert test="@Namespace" role="Fatal Error">Fatal Error (Ringtone): The appropriate Namespace for the user-defined value shall be provided (Release Profile 2.1, Clause 5.3.1.1(5), Rule 1196-2).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_RightSharePercentageValue">
      <s:rule context="//RightSharePercentage">
         <s:assert test="//RightSharePercentage &gt; 0 and //RightSharePercentage &lt; 100"
                   role="Fatal Error">Fatal Error (Ringtone): A RightSharePercentage has a value between 0 and 100 (Release Profile 2.1, Clause 5.3.1.1(6), Rule 1197-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_IsDefaultTerritory">
      <s:rule context="//*[@IsDefault]">
         <s:assert test="count(../*[name(.)=name(current()) and @IsDefault = 'true']) = 1"
                   role="Fatal Error">Fatal Error (Ringtone): An IsDefault flag with value true may only be provided once (Release Profile 2.1, Clause 5.3.1.1(7.2), Rule 1198-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_Contributor">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[not(@IsSupplemental = 'true')] | *:NewReleaseMessage/ResourceList/Video[not(@IsSupplemental = 'true')]">
         <s:assert test="//Contributor[Role = 'Adapter' or Role = 'Arranger' or Role = 'Author' or Role = 'Composer' or Role = 'ComposerLyricist' or Role = 'Librettist' or Role = 'Lyricist' or Role = 'NonLyricAuthor' or Role = 'SubArranger' or Role = 'Translator']"
                   role="Conditional Fatal Error">Conditional Fatal Error (Ringtone): Any available information on Contributors that have one of the roles Adapter, Arranger, Author, Composer, ComposerLyricist, Librettist, Lyricist, NonLyricAuthor, SubArranger, Translator should be provided (Release Profile 2.1, Clause 5.3.1.1(8), Rule 1199-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_DisplayArtistsMustBeSequenced">
      <s:rule context="//DisplayArtist">
         <s:assert test="@SequenceNumber" role="Fatal Error">Fatal Error (Ringtone): All DisplayArtists should be sequenced (Release Profile 2.1, Clause 5.3.1.2(1), Rule 1200-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustNotHaveManyMainDisplayArtists">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release | *:NewReleaseMessage/ResourceList/*">
         <s:report test="count(DisplayArtist[DisplayArtistRole = 'MainArtist']) &gt; 1"
                   role="Conditional Error">Conditional Error (Ringtone): Additional artists may not have a DisplayArtistRole of MainArtist (Release Profile 2.1, Clause 5.3.1.2(2), Rule 1201-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourceGroupType">
      <s:rule context="*:NewReleaseMessage[not(@ReleaseProfileVariantVersionId)]/ReleaseList/Release/ResourceGroup/ResourceGroup">
         <s:assert test="@ResourceGroupType = 'Component' or @ResourceGroupType = 'Side'"
                   role="Fatal Error">Fatal Error (Ringtone): Second-level ResourceGroups shall have a ResourceGroupType of either Side or Component unless it is a variant Release Profile (Release Profile 2.1, Clause 5.3.1.2(5.2), Rule 1202-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourceGroupsMustBeSequenced">
      <s:rule context="//ResourceGroup[@ResourceGroupType = 'Component' or @ResourceGroupType = 'ComponentRelease' or @ResourceGroupType = 'Side' or @ResourceGroupType = 'MultiWorkPart']">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error (Ringtone): ResourceGroups of type Component, ComponentRelease, Side or MultiWorkPart shall be sequenced (Release Profile 2.1, Clause 5.3.1.2(5.3), Rule 1203-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_PrimaryResourcesMustBeSequenced">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[not(@IsSupplemental = 'true')] | *:NewReleaseMessage/ResourceList/Video[not(@IsSupplemental = 'true')]">
         <s:assert test="//ResourceGroupContentItem[ReleaseResourceReference = current()/ResourceReference]/SequenceNumber"
                   role="Fatal Error">Fatal Error (Ringtone): Primary Resources shall be sequenced in their ResourceGroupContentItem (Release Profile 2.1, Clause 5.3.1.2(5.4), Rule 1204-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SequenceNumberMustBeDifferent">
      <s:rule context="//SequenceNumber">
         <s:report test="count(../../*[name(.)=name(current()/..) and SequenceNumber=current()]) &gt; 1"
                   role="Fatal Error">Fatal Error (Ringtone): SequenceNumbers must all be different (Release Profile 2.1, Clause 5.3.1.2(5.5), Rule 1205-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SingleSequenceInResourceGroup">
      <s:rule context="//ResourceGroup/ResourceGroup/SequenceNumber">
         <s:report test="current() = ../../ResourceGroupContentItem/SequenceNumber"
                   role="Fatal Error">Fatal Error (Ringtone): There is only one sequence within a ResourceGroup (Release Profile 2.1, Clause 5.3.1.2(5.6), Rule 1206-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SecondaryResourcesMustNotBeSequenced">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Video[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Image | *:NewReleaseMessage/ResourceList/Text | *:NewReleaseMessage/ResourceList/SheetMusic | *:NewReleaseMessage/ResourceList/Software">
         <s:report test="//ResourceGroupContentItem[ReleaseResourceReference = current()/ResourceReference]/SequenceNumber"
                   role="Error">Error (Ringtone): Secondary Resources shall not be sequenced in their ResourceGroupContentItem (Release Profile 2.1, Clause 5.3.1.2(5.7a), Rule 1207-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_CueMustHaveStartTimeOrDuration">
      <s:rule context="//Cue">
         <s:assert test="StartTime[string-length(normalize-space(text())) &gt; 0] or Duration[string-length(normalize-space(text())) &gt; 0]"
                   role="Error">Error (Ringtone): Each Cue should have a StartTime or a Duration (Release Profile 2.1, Clause 5.3.1.2(6), Rule 1208-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MainReleaseMustHaveGridOrICPN">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | ReleaseId/ICPN[string-length(normalize-space(text())) &gt; 0] | ReleaseId/ProprietaryId"
                   role="Fatal Error">Fatal Error (Ringtone): The MainRelease shall be identified by either a GRid or by an ICPN or by a ProprietaryID (Release Profile 2.1, Clause 5.3.1.3(1), Rule 1209-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ReleaseMayHaveCLine">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="CLine" role="Conditional Fatal Error">Conditional Fatal Error (Ringtone): Each Release may have a CLine (Release Profile 2.1, Clause 5.3.1.3(6), Rule 1210-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ReleaseDateMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDate | OriginalReleaseDate" role="Conditional Error">Conditional Error (Ringtone): An OriginalReleaseDate or a ReleaseDate shall be provided for each Release (Release Profile 2.1, Clause 5.3.1.3(7), Rule 1211-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourceGroupTypeSide">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release[//@ResourceGroupType = 'Side']">
         <s:assert test="*:NewReleaseMessage/DealList/ReleaseDeal[DealReleaseReference = current()/ReleaseReference]/Deal/DealTerms/UseType[text() = 'PurchaseAsPhysicalProduct']"
                   role="Conditional Error">Conditional Error (Ringtone): A ResourceGroup of type Side shall only be provided for Releases that may be available with a UseType of PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 5.3.1.3(8), Rule 1212-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_SecondaryResourceMustHaveProprietaryId">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Image">
         <s:assert test="ResourceId/ProprietaryId[string-length(normalize-space(text())) &gt; 0]"
                   role="Fatal Error">Fatal Error (Ringtone): Secondary SoundRecordings and Images shall be identified with a ProprietaryId (Release Profile 2.1, Clause 5.3.1.4(2a), Rule 1213-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_NoContributorDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList/*">
         <s:assert test="count(Contributor)=count(Contributor[not(ContributorPartyReference=preceding-sibling::Contributor/ContributorPartyReference)])"
                   role="Fatal Error">Fatal Error (Ringtone): Contributors shall be provided only once (with multiple roles) (Release Profile 2.1, Clause 5.3.1.4(6), Rule 1214-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_FirstPublicationDateMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[not(@IsSupplemental = 'true')] | *:NewReleaseMessage/ResourceList/Video[not(@IsSupplemental = 'true')]">
         <s:assert test="count(FirstPublicationDate) &gt; 0" role="Conditional Error">Conditional Error (Ringtone): For each Primary Resource at least one FirstPublicationDate shall be provided (Release Profile 2.1, Clause 5.3.1.4(7), Rule 1215-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TechnicalDetails">
      <s:rule context="*:NewReleaseMessage/ResourceList/*">
         <s:report test="TechnicalDetails" role="Conditional Fatal Error">Conditional Fatal Error (Ringtone): TechnicalDetails are included, so a Resource File should be communicated (Release Profile 2.1, Clause 5.3.3.3, Rule 1216-1).</s:report>
         <s:assert test="TechnicalDetails" role="Conditional Fatal Error">Conditional Fatal Error (Ringtone): TechnicalDetails are not included, so no Resource File should be communicated (Release Profile 2.1, Clause 5.3.3.3, Rule 1216-2).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ChaptersMustBeReferenced">
      <s:rule context="//Chapter/ChapterReference">
         <s:assert test=".=//*[ends-with(name(),'Reference') and name()!=name(current())]"
                   role="Warning">Warning (Ringtone): All ChapterReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_CueSheetsMustBeReferenced">
      <s:rule context="//CueSheet/CueSheetReference">
         <s:assert test=".=//*[ends-with(name(),'Reference') and name()!=name(current())]"
                   role="Warning">Warning (Ringtone): All CueSheetReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.2).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourcesMustBeReferenced">
      <s:rule context="//ResourceList/*/ResourceReference">
         <s:assert test=".=//*[ends-with(name(),'Reference') and name()!=name(current())]"
                   role="Warning">Warning (Ringtone): All ResourceReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.3).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_PartiesMustBeReferenced">
      <s:rule context="//Party/PartyReference">
         <s:assert test=".=//*[(ends-with(name(),'Reference') and name()!=name(current()) or name()='MusicRightsSociety' or name()='Label')]"
                   role="Warning">Warning (Ringtone): All PartyReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.4).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ReleasesMustBeReferenced">
      <s:rule context="//Release/ReleaseReference">
         <s:assert test=".=//*[ends-with(name(),'Reference') and name()!=name(current())]"
                   role="Warning">Warning (Ringtone): All ReleaseReferences must have a Reference IDREF pointing to them (Release Profile 2.1, Generic Rule G.5).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_DateShouldBeBeforeDealStartDate">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[ValidityPeriod/StartDate]">
         <s:report test="translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A ReleaseDisplayStartDate may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1222-1).</s:report>
         <s:report test="translate(TrackListingPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A TrackListingPreviewStartDate may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1222-2).</s:report>
         <s:report test="translate(CoverArtPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A CoverArtPreviewStartDate may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1222-3).</s:report>
         <s:report test="translate(ClipPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A ClipPreviewStartDate may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1222-4).</s:report>
         <s:report test="translate(substring(ReleaseDisplayStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A ReleaseDisplayStartDateTime may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1222-5).</s:report>
         <s:report test="translate(substring(TrackListingPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A TrackListingPreviewStartDateTime may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1222-6).</s:report>
         <s:report test="translate(substring(CoverArtPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A CoverArtPreviewStartDateTime may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1222-7).</s:report>
         <s:report test="translate(substring(ClipPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDate,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A ClipPreviewStartDateTime may not be later than the StartDate of the Deal (Release Profile 2.1, Clause 6.4.8(a), Rule 1222-8).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_DateShouldBeBeforeDealStartDateTime">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[ValidityPeriod/StartDateTime]">
         <s:report test="translate(ReleaseDisplayStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A ReleaseDisplayStartDate may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1223-1).</s:report>
         <s:report test="translate(TrackListingPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A TrackListingPreviewStartDate may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1223-2).</s:report>
         <s:report test="translate(CoverArtPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A CoverArtPreviewStartDate may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1223-3).</s:report>
         <s:report test="translate(ClipPreviewStartDate,'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A ClipPreviewStartDate may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1223-4).</s:report>
         <s:report test="translate(substring(ReleaseDisplayStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A ReleaseDisplayStartDateTime may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1223-5).</s:report>
         <s:report test="translate(substring(TrackListingPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A TrackListingPreviewStartDateTime may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1223-6).</s:report>
         <s:report test="translate(substring(CoverArtPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A CoverArtPreviewStartDateTime may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1223-7).</s:report>
         <s:report test="translate(substring(ClipPreviewStartDateTime,1,10),'-','') &gt; translate(substring(ValidityPeriod/StartDateTime,1,10),'-','')"
                   role="Fatal Error">Fatal Error (Ringtone): A ClipPreviewStartDateTime may not be later than the StartDateTime of the Deal (Release Profile 2.1, Clause 6.4.8(b), Rule 1223-8).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustNotContainPriceType">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms/PriceInformation[@PriceType]">
         <s:report test="BulkOrderWholesalePricePerUnit or WholesalePricePerUnit"
                   role="Fatal Error">Fatal Error (Ringtone): WholesalePricePerUnit and BulkOrderWholesalePricePerUnit may not be combined with a PriceType. (Release Profile 2.1, Clause 6.4.9, Rule 1224-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainUseType1">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[PriceInformation/BulkOrderWholesalePricePerUnit]">
         <s:assert test="UseType='PurchaseAsPhysicalProduct'" role="Fatal Error">Fatal Error (Ringtone): BulkOrderWholesalePricePerUnit may only be used if UseType = PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 6.4.10(a), Rule 1225-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainUseType2">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[CarrierType]">
         <s:assert test="UseType='PurchaseAsPhysicalProduct'" role="Fatal Error">Fatal Error (Ringtone): CarrierType may only be used if UseType = PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 6.4.10(b), Rule 1226-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainUseType3">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[PhysicalReturns]">
         <s:assert test="UseType='PurchaseAsPhysicalProduct'" role="Fatal Error">Fatal Error (Ringtone): PhysicalReturns may only be used if UseType = PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 6.4.10(c), Rule 1227-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainUseType4">
      <s:rule context="*:NewReleaseMessage/DealList/ReleaseDeal/Deal/DealTerms[NumberOfProductsPerCarton]">
         <s:assert test="UseType='PurchaseAsPhysicalProduct'" role="Fatal Error">Fatal Error (Ringtone): NumberOfProductsPerCarton may only be used if UseType = PurchaseAsPhysicalProduct. (Release Profile 2.1, Clause 6.4.10(d), Rule 1228-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Ringtone_ReleaseProfileVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="@ReleaseProfileVersionId = 'Ringtone'" role="Fatal Error">Fatal Error (Ringtone): The ReleaseProfileVersionId should be 'Ringtone' (Release Profile 2.1, Clause 5.2.1, Rule 1229-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustNotContainTrackRelease">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:report test="TrackRelease" role="Fatal Error">Fatal Error (Ringtone): A Release of this type must not contain any TrackReleases (Release Profile 2.1, Clause 5.1.1(b), Rule 1230-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainOneSoundRecording">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(SoundRecording) = 1" role="Fatal Error">Fatal Error (Ringtone): A Release of this type must contain exactly one SoundRecording (Release Profile 2.1, Clause 5.1.2(a), Rule 1231-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Ringtone_SoundRecordingType">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="SoundRecording/Type[text() = 'MusicalWorkSoundRecording' or text() = 'NonMusicalWorkSoundRecording' or text() = 'SpokenWordSoundRecording']"
                   role="Fatal Error">Fatal Error (Ringtone): A Release of this type must contain SoundRecordings of type MusicalWorkSoundRecording or NonMusicalWorkSoundRecording or SpokenWordSoundRecording (Release Profile 2.1, Clause 5.1.2(b), Rule 1232-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MayContainOneImage">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:report test="count(Image) &gt; 1" role="Fatal Error">Fatal Error (Ringtone): A Release of this type must not contain more than one Image (Release Profile 2.1, Clause 5.1.2(c), Rule 1233-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ImageType">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="Image/Type[text() = 'FrontCoverImage']" role="Fatal Error">Fatal Error (Ringtone): A Release of this type must contain an Image of type FrontCoverImage (Release Profile 2.1, Clause 5.1.2(d), Rule 1234-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustNotContainBonusResource">
      <s:rule context="//ResourceGroupContentItem">
         <s:report test="IsBonusResource = 'true'" role="Fatal Error">Fatal Error (Ringtone): A Release of this type must not contain any bonus resources (Release Profile 2.1, Clause 5.1.2(e), Rule 1235-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustNotContainTextSheetMusicSoftware">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:report test="Text or SheetMusic or Software" role="Fatal Error">Fatal Error (Ringtone): A Release of this type must not contain any Text, SheetMusic and Software because bonus resources are not allowed (Release Profile 2.1, Clause 5.1.2(f), Rule 1236-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="Ringtone_MainReleaseType">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseType[text() = 'AlertToneRelease' or text() = 'Playlist' or text() = 'RingbackToneRelease' or text() = 'RingtoneRelease' or text() = 'VideoMastertoneRelease' or text() = 'UserDefined']"
                   role="Warning">Warning (Ringtone): The MainRelease must have a ReleaseType according to clause 5.1.3 (Release Profile 2.1, Clause 5.1.3, Rule 1237-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Ringtone_PrimaryResourceMustHaveIsrcOrProprietaryId">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording">
         <s:assert test="ResourceId/ISRC or ResourceId/ProprietaryId" role="Fatal Error">Fatal Error (Ringtone): Primary SoundRecording shall be identified with an ISRC or a ProprietaryId (Release Profile 2.1, Clause 5.4.2(1), Rule 1238-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_MustContainOneResourceGroup">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="count(ResourceGroup) = 1" role="Fatal Error">Fatal Error (Ringtone): A Release of this type must contain one (and only one) ResourceGroup (Release Profile 2.1, Clause 5.4.2(2), Rule 1239-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourceGroupContentItemSoundRecording">
      <s:rule context="//ResourceGroupContentItem">
         <s:assert test="ReleaseResourceReference = //ResourceList/SoundRecording/ResourceReference"
                   role="Fatal Error">Fatal Error (Ringtone): A Release of this type must contain one ReleaseResourceReference pointing to the Primary Resource (Release Profile 2.1, Clause 5.4.2(3.1), Rule 1240-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_ResourceGroupContentItemImage">
      <s:rule context="*:NewReleaseMessage/ResourceList/Image">
         <s:assert test="//Release/ResourceGroup/ResourceGroupContentItem[LinkedReleaseResourceReference = current()/ResourceReference]"
                   role="Fatal Error">Fatal Error (Ringtone): Images shall be linked from the ResourceGroupContentItem's LinkedReleaseResourceReference (Release Profile 2.1, Clause 5.4.2(3.2), Rule 1241-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Ringtone_MustContainReleaseFromRelease">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="RelatedRelease[ReleaseRelationshipType = 'IsReleaseFromRelease']"
                   role="Conditional Error">Conditional Error (Ringtone): A Ringtone shall contain a RelatedRelease of type IsReleaseFromRelease (Release Profile 2.1, Clause 5.4.2(4), Rule 1242-1).</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
