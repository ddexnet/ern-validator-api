<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <!--
          This Schematron rule set requires XPath2. 
          This can be enforced by, for instance, adding an attribute into the above s:schema tag 
          (queryBinding="xslt2") or by instructing the processor for running the Schematron
          rule to use XPath2 in any other way.
                    -->
   <s:title>Schematron Release Profile for Longform Video (version 1.4) for the
      NewReleaseMessage.</s:title>
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
      that has already been issued. However, if more than 11 rules (representing 50% of all rules
      with a role of 'Error' or 'Conditional Error') have been failed at least once, the Conformance
      Tester must recommend to not award a Conformance Certificate or to retract a Conformance
      Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error'
      is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no
      means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>The following Clauses from the Release Profile standard are NOT checked by this ISO
      Schematron file: 3.3.1(1), 3.3.1(7)-(8), 3.4, 4.1, 4.2, 4.3(11), 4.3(14), 4.3(15a), 4.3(16b),
      4.3(17), 4.3(19), 4.3(27)-(29), 4.3(37), 4.16(11)-(12), 4.7(11)-(12), 4.8(8), 4.8(9d),
      4.8(10f), 4.8(11)-(12), 4.10(9) and similar clauses, 4.10(10) and similar clauses, 4.14(8) and
      4.15(11).</s:p>

   <s:pattern id="MultiProfile_DeprecatedDatesMustNotBeUsed">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="MidiDetailsByTerritory/RemasteredDate" role="Information">Information:
            #Longform Video) No deprecated date elements should be used.</s:report>
         <s:report test="MIDI/MasteredDate" role="Information">Information: #Longform Video) No
            deprecated date elements should be used.</s:report>
         <s:report test="ReleaseDetailsByTerritory/OriginalDigitalReleaseDate" role="Information"
            >Information: #Longform Video) No deprecated date elements should be used.</s:report>
         <s:report test="Release/GlobalReleaseDate" role="Information">Information: #Longform Video)
            No deprecated date elements should be used.</s:report>
         <s:report test="Release/GlobalOriginalReleaseDate" role="Information">Information:
            #Longform Video) No deprecated date elements should be used.</s:report>
         <s:report test="SoundRecordingDetailsByTerritory/RemasteredDate" role="Information"
            >Information: #Longform Video) No deprecated date elements should be used.</s:report>
         <s:report test="MIDI/RemasteredDate" role="Information">Information: #Longform Video) No
            deprecated date elements should be used.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MessageSchemaVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert
            test="substring(@MessageSchemaVersionId, 1, 4) = 'ern/' and number(substring(@MessageSchemaVersionId, 5,2)) &gt;= 39"
            role="Information">Information: #Longform Video) The MessageSchemaVersionId should be at
            least 3.9.</s:assert>
         <s:assert test="@MessageSchemaVersionId = 'ern/39Draft'" role="Information">Information:
            #Longform Video) You are not using the latest XSD supported by this Schematron
            file.</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainSixResourceGroups">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup">
         <s:report test="ResourceGroup" role="Information">Information: #Longform Video) There
            should not be more than 5 nested ResourceGroups.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SoundRecordingMustNotHaveDeprecatedFlags">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording">
         <s:report test="IsHiddenResource" role="Information">Information: #Longform Video) No
            deprecated Flags (IsHiddenResource) must be provided for SoundRecordings.</s:report>
         <s:report test="IsBonusResource" role="Information">Information: #Longform Video) No
            deprecated Flags (IsBonusResource) must be provided for SoundRecordings.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainComponentRelease">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
         <s:assert
            test="//Release[ReleaseType[(text() = 'TrackRelease') or (text() = 'VideoTrackRelease')]]/ReleaseResourceReferenceList/ReleaseResourceReference = ./ReleaseResourceReference"
            role="Fatal Error">Fatal Error: #Longform Video) One component release should be
            supplied per primary resource referenced on the Main release, regardless of whether
            there are any deals available for the component release (Release Profile 1.4, Clause
            3.1, Rule 1379-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MainReleaseMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:report test="count(Release[@IsMainRelease = 'true']) &lt; 1" role="Fatal Error">Fatal
            Error: #Longform Video) At least one Release shall have IsMainRelease flag = True
            (Release Profile 1.4, Clause 3.3.1(1), Rule 1380-1).</s:report>
         <s:report test="count(Release) &gt; 1" role="Fatal Error">Fatal
            Error: #Longform Video) More than one Release with IsMainRelease has been specified
            (Release Profile 1.4, Clause 3.3.1(1), Rule 1380-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimaryResourcesMustBeSequenced">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release/*/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error: #Longform Video) Track
            bundle resource groups should be sequenced (Release Profile 1.4, Clause
            3.3.1(2)+3.3.1(3)+3.3.1(5), Rule 1381-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceGroupsMustBeSequenced">
      <s:rule
         context="//Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroup">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error: #Longform Video) All
            ResourceGroups should be sequenced (Release Profile 1.4, Clause 3.3.1(2), Rule
            1382-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimaryResourcesMustBeSequencedWithinTheirGroup">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroup">
         <s:report
            test="descendant::ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource'] and SequenceNumber &gt; '1'] and not(descendant::ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource'] and SequenceNumber = '1'])"
            role="Fatal Error">Fatal Error: #Longform Video) All Primary Resources should be
            sequenced in the context of their track bundle ResourceGroup (i.e. the sequence restarts
            with the next track bundle) (Release Profile 1.4, Clause 3.3.1(3), Rule
            1383-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceGroupContentItemsMustBeSequenced">
      <s:rule
         context="//Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference/@ReleaseResourceType='PrimaryResource']">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error: #Longform Video) All
            ResourceGroupContentItems should be sequenced (Release Profile 1.4, Clause 3.3.1(3),
            Rule 1384-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SecondaryResourcesMustNotBeSequenced">
      <s:rule
         context="//ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
         <s:report test="SequenceNumber" role="Error">Error: #Longform Video) Secondary Resources
            (e.g. cover images) content items shall not be sequenced (Release Profile 1.4, Clause
            3.3.1(4), Rule 1385-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimarySoundRecordingMustHaveIndirectSoundRecordingId">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'SoundRecording']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert test="//ResourceReference[text() = current()]/../IndirectSoundRecordingId"
            role="Conditional Fatal Error">Conditional Fatal Error: #Longform Video) Primary
            SoundRecording Resources shall have an IndirectSoundRecordingId (Release Profile 1.4,
            Clause 3.3.1(6), Rule 1386-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ReleaseResourceTypeMustBeProvided">
      <s:rule context="*:ResourceGroupContentItem/ReleaseResourceReference">
         <s:assert test="@ReleaseResourceType" role="Fatal Error">Fatal Error: #Longform Video) For
            each ReleaseResourceReference a ReleaseResourceType shall be provided (Release Profile
            1.4, Clause 4.3(1)+4.3(2), Rule 1387-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainResource">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(*) &gt; 0" role="Fatal Error">Fatal Error: #Longform Video) A
            ResourceList must contain at least one Resource (Release Profile 1.4, Clause 4.3(3),
            Rule 1388-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SoundRecordingMustHaveReferenceTitle">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording">
         <s:assert
            test="count(ReferenceTitle[string-length(normalize-space(TitleText)) &gt; 0]) = 1"
            role="Fatal Error">Fatal Error: #Longform Video) A Single ReferenceTitle must be
            provided for each SoundRecording (Release Profile 1.4, Clause 4.3(4), Rule
            1389-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SingleFormalTitlePerTerritory">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory[1]">
         <s:assert
            test="Title[@TitleType='FormalTitle'][string-length(normalize-space(TitleText)) &gt; 0]"
            role="Fatal Error">Fatal Error: #Longform Video) At least one Title of type FormalTitle
            shall be provided for the default Worldwide ReleaseDetailsByTerritory section (Release
            Profile 1.4, Clause 4.3(4), Rule 1390-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SingleDisplayTitlePerTerritory">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory[1]">
         <s:assert
            test="Title[@TitleType='DisplayTitle'][string-length(normalize-space(TitleText)) &gt; 0]"
            role="Fatal Error">Fatal Error: #Longform Video) At least one Title of type DisplayTitle
            shall be provided for the default Worldwide ReleaseDetailsByTerritory section (Release
            Profile 1.4, Clause 4.3(4), Rule 1391-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PLineMustBeProvidedAtTerritorialLevel1">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release[PLine]">
         <s:report test="count(ReleaseDetailsByTerritory)=count(ReleaseDetailsByTerritory/PLine)"
            role="Fatal Error">Fatal Error: A PLine shall not be provided in all
            ReleaseDetailsByTerritory (Release Profile 1.4, Clause 4.3(5a), Rule 1017-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_PLineMustBeProvidedAtTerritorialLevel2">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release[not(PLine)]">
         <s:report test="ReleaseDetailsByTerritory[not(PLine)]" role="Fatal Error">Fatal Error: A
            PLine shall be provided in all ReleaseDetailsByTerritory composites if no PLine is
            provided for Release (Release Profile 1.4, Clause 4.3(5a), Rule 1017-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_CLineMustBeProvidedAtTerritorialLevel1">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release[CLine]">
         <s:report test="count(ReleaseDetailsByTerritory)=count(ReleaseDetailsByTerritory/CLine)"
            role="Fatal Error">Fatal Error: A CLine shall not be provided in all
            ReleaseDetailsByTerritory (Release Profile 1.4, 1017-1NR).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_CLineMustBeProvidedAtTerritorialLevel2">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release[not(CLine)]">
         <s:report test="ReleaseDetailsByTerritory[not(CLine)]" role="Fatal Error">Fatal Error: A
            CLine shall be provided in all ReleaseDetailsByTerritory composites if no CLine is
            provided for Release (Release Profile 1.4, 1017-1NR).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayLabelMustBeProvided">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory[count(LabelName) &gt; 1]">
         <s:assert test="count(LabelName[@LabelNameType='DisplayLabelName']) = 1" role="Error"
            >Error: #Longform Video) If more than one LabelName is provided, exactly one shall be a
            DisplayLabelName (Release Profile 1.4, Clause 4.3(6), Rule 1394-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_LabelNameMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory[position() = 1 and not(LabelName[string-length(normalize-space(text())) &gt; 0])] and ReleaseDetailsByTerritory[position() &gt; 1 and not(LabelName[string-length(normalize-space(text())) &gt; 0])]"
            role="Error">Error: #Longform Video) If a LabelName is not specified for the Worldwide
            ReleaseDetailsByTerritory, it needs to be specified in all the other
            ReleaseDetailsByTerritory composites (Release Profile 1.4, Clause 4.3(6a)+4.3(6b), Rule
            1395-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_UserDefinedLabelNameType">
      <s:rule context="//LabelName[@UserDefinedValue]">
         <s:assert test="@LabelNameType='UserDefined'" role="Error">Error: #Longform Video) The
            LabelNameType shall be 'UserDefined' if a user-defined value is supplied for a LabelName
            (Release Profile 1.4, Clause 4.3(6b), Rule 1396-1).</s:assert>
         <s:assert test="@Namespace" role="Error">Error: #Longform Video) The appropriate Namespace
            for the user-defined value shall be provided (Release Profile 1.4, Clause 4.3(6b), Rule
            1396-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_GenreMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory[position = 1 and not(Genre/GenreText[string-length(normalize-space(text())) &gt; 0])] and ReleaseDetailsByTerritory[position() &gt; 1 and not(Genre/GenreText[string-length(normalize-space(text())) &gt; 0])]"
            role="Fatal Error">Fatal Error: #Longform Video) If a Genre is not specified for the
            Worldwide ReleaseDetailsByTerritory, it needs to be specified in all the other
            ReleaseDetailsByTerritory composites. (Release Profile 1.4, Clause 4.3(7), Rule
            1397-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ParentalWarningTypeMustBeProvided">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="//ParentalWarningType[string-length(normalize-space(text())) &gt; 0]"
            role="Error">Error: #Longform Video) The appropriate ParentalWarningType shall be
            provided (Release Profile 1.4, Clause 4.3(8), Rule 1398-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ReleaseDateMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/ReleaseDate | GlobalReleaseDate"
            role="Conditional Error">Conditional Error: #Longform Video) A GlobalReleaseDate or a
            ReleaseDate shall be provided for each Release (Release Profile 1.4, Clause 4.3(9), Rule
            1399-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceReleaseDateMustBeProvided">
      <s:rule
         context="//ResourceGroupContentItem/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../SoundRecordingDetailsByTerritory/ResourceReleaseDate | //ResourceReference[text() = current()]/../SoundRecordingDetailsByTerritory/OriginalResourceReleaseDate"
            role="Conditional Error">Conditional Error: #Longform Video) A ResourceReleaseDate or an
            OriginalResourceReleaseDate shall be provided for each primary Resource if available to
            the Message Sender (Release Profile 1.4, Clause 4.3(10), Rule 1400-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MusicalWorkContributorRole">
      <s:rule context="//MusicalWork">
         <s:assert
            test="MusicalWorkContributor/MusicalWorkContributorRole[text() = 'Adapter' or text() = 'Arranger' or text() = 'AssociatedPerformer' or text() = 'Author' or text() = 'Composer' or text() = 'ComposerLyricist' or text() = 'Librettist' or text() = 'Lyricist' or text() = 'NonLyricAuthor' or text() = 'SubArranger' or text() = 'Translator']"
            role="Conditional Error">Conditional Error: #Longform Video) If there is a MusicalWork,
            there has to be a creative contributor (Release Profile 1.4, Clause 4.3(12a), Rule
            1401-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ShouldContainIndirectResourceContributor">
      <s:rule
         context="*:NewReleaseMessage/ResourceList/SoundRecording/SoundRecordingDetailsByTerritory">
         <s:assert test="IndirectResourceContributor" role="Conditional Error">Conditional Error:
            #Longform Video) No MusicalWorkContributor was found; information of at least one
            MusicalWorkContributor should be provided if available (Release Profile 1.4, Clause
            4.3(12a), Rule 1402-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceContributorDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList/*/*">
         <s:assert
            test="count(ResourceContributor)=count(ResourceContributor[not(PartyId=preceding-sibling::ResourceContributor/PartyId)])"
            role="Fatal Error">Fatal Error: #Longform Video) ResourceContributors shall be provided
            only once (with multiple roles) (Release Profile 1.4, Clause 4.3(13)+4.3(20), Rule
            1403-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistNameDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:report test="*/*/DisplayArtistName" role="Error">Error: #Longform Video) The
            DisplayArtistNames of a Resource shall not be the same as the DisplayArtistName of the
            Album it belongs to (Release Profile 1.4, Clause 4.3(18), Rule 1404-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_IndirectResourceContributorDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList/*/*">
         <s:assert
            test="count(IndirectResourceContributor)=count(IndirectResourceContributor[not(PartyId=preceding-sibling::IndirectResourceContributor/PartyId)])"
            role="Conditional Fatal Error">Conditional Fatal Error: #Longform Video)
            IndirectResourceContributors shall be provided only once (with multiple roles) (Release
            Profile 1.4, Clause 4.3(21), Rule 1405-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_RightSharePercentage">
      <s:rule context="//MusicalWork">
         <s:report test="sum(//RightShare/RightSharePercentage) &gt; 100" role="Fatal Error">Fatal
            Error: #Longform Video) The total of all RightSharePercentages for each MusicalWork must
            not exceed 100% (Release Profile 1.4, Clause 4.3(22), Rule 1406-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_RightSharePercentageValue">
      <s:rule context="//RightSharePercentage">
         <s:assert test="//RightSharePercentage &gt; 0 and //RightSharePercentage &lt; 100"
            role="Fatal Error">Fatal Error: #Longform Video) A RightSharePercentage has a value
            between 0 and 100 (Release Profile 1.4, Clause 4.3(22), Rule 1407-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_CatalogTransfer">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="CatalogTransfer" role="Conditional Fatal Error">Conditional Fatal Error:
            #Longform Video) The CatalogTransfer element has been used. This is only to be used when
            communicating a catalogue transfer (Release Profile 1.4, Clause 4.3(23), Rule
            1408-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_FlagsOnlyOnContentItems">
      <s:rule context="*:NewReleaseMessage">
         <s:report
            test="SoundRecording/IsHiddenResource | MIDI/IsHiddenResource | Video/IsHiddenResource"
            role="Fatal Error">Fatal Error: #Longform Video) IsHiddenResource must not be used on a
            Resource (Release Profile 1.4, Clause 4.3(24)+4.10(7g)+4.10(7h), Rule
            1409-1).</s:report>
         <s:report
            test="SoundRecording/IsBonusResource | MIDI/IsBonusResource | Video/IsBonusResource"
            role="Fatal Error">Fatal Error: #Longform Video) IsBonusResource must not be used on a
            Resource (Release Profile 1.4, Clause 4.3(24)+4.10(7g)+4.10(7h), Rule
            1409-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_Territory">
      <s:rule context="//TerritoryCode | //ExcludedTerritoryCode">
         <s:report
            test="(substring(@IdentifierType, 1, 3) = 'ISO' or not(@IdentifierType)) and string-length(normalize-space(text())) != 2 and text() != 'Worldwide' and translate(text(), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '') != ''"
            role="Fatal Error">Fatal Error: #Longform Video) A TerritoryCode of type 'ISO' must be a
            two-letter code or 'Worldwide' (Release Profile 1.4, Clause 4.3(25), Rule
            1410-1).</s:report>
         <s:report test="substring(@IdentifierType, 1, 3) = 'TIS' and number() != ."
            role="Fatal Error">Fatal Error: #Longform Video) A TerritoryCode of type 'TIS' must be a
            numeric code (Release Profile 1.4, Clause 4.3(25), Rule 1410-2).</s:report>
         <s:report
            test="substring(@IdentifierType, 1, 3) = 'Dep' and (string-length(normalize-space(text())) != 4 or number() = .)"
            role="Fatal Error">Fatal Error: #Longform Video) A deprecated TerritoryCode must be a
            four-letter code (Release Profile 1.4, Clause 4.3(25), Rule 1410-3).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_TerritoryTIS">
      <s:rule context="//TerritoryCode | //ExcludedTerritoryCode">
         <s:report test="substring(@IdentifierType, 1, 3) = 'TIS'" role="Fatal Error">Fatal Error:
            #Longform Video) A TerritoryCode of type 'TIS' must not be used (Release Profile 1.4,
            Clause 4.3(25), Rule 1411-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISNI">
      <s:rule context="//PartyId[@IsISNI = 'true']">
         <s:assert test="matches(., '^[0-9]{15}[X0-9]$')" role="Fatal Error">Fatal Error: #Longform
            Video) A PartyId of type 'ISNI' must be a string conforming to the pattern
            [0-9]{15}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 1412-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISRC">
      <s:rule context="//ISRC">
         <s:assert test="matches(., '^[a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7}$')" role="Fatal Error">Fatal
            Error: #Longform Video) An ISRC must be a string conforming to the pattern
            [a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7} (Release Profile 1.4, Clause 4.3(30), Rule
            1413-1).</s:assert>
         <s:assert
            test="matches(substring(.,1,2), '(FX|QM|UK|CP|DG|ZZ|AD|AE|AF|AG|AI|AL|AM|AN|AO|AQ|AR|AS|AT|AU|AW|AX|AZ|BA|BB|BD|BE|BF|BG|BH|BI|BJ|BL|BM|BN|BO|BQ|BR|BS|BT|BV|BW|BY|BZ|CA|CC|CD|CF|CG|CH|CI|CK|CL|CM|CN|CO|CR|CS|CU|CV|CW|CX|CY|CZ|DE|DJ|DK|DM|DO|DZ|EC|EE|EG|EH|ER|ES|ET|FI|FJ|FK|FM|FO|FR|GA|GB|GD|GE|GF|GG|GH|GI|GL|GM|GN|GP|GQ|GR|GS|GT|GU|GW|GY|HK|HM|HN|HR|HT|HU|ID|IE|IL|IM|IN|IO|IQ|IR|IS|IT|JE|JM|JO|JP|KE|KG|KH|KI|KM|KN|KP|KR|KW|KY|KZ|LA|LB|LC|LI|LK|LR|LS|LT|LU|LV|LY|MA|MC|MD|ME|MF|MG|MH|MK|ML|MM|MN|MO|MP|MQ|MR|MS|MT|MU|MV|MW|MX|MY|MZ|NA|NC|NE|NF|NG|NI|NL|NO|NP|NR|NU|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PM|PN|PR|PS|PT|PW|PY|QA|RE|RO|RS|RU|RW|SA|SB|SC|SD|SE|SG|SH|SI|SJ|SK|SL|SM|SN|SO|SR|SS|ST|SV|SX|SY|SZ|TC|TD|TF|TG|TH|TJ|TK|TL|TM|TN|TO|TR|TT|TV|TW|TZ|UA|UG|UM|US|UY|UZ|VA|VC|VE|VG|VI|VN|VU|WF|WS|YE|YT|ZA|ZM|ZW)')"
            role="Fatal Error">Fatal Error: #Longform Video) An ISRC must be a string starting with
            an ISO 3166 code or FX, QM, UK, CP, DG or ZZ (Release Profile 1.4, Clause 4.3(30), Rule
            1413-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_GRid">
      <s:rule context="//GRid">
         <s:assert test="matches(., '^[a-zA-Z0-9]{18}$')" role="Fatal Error">Fatal Error: #Longform
            Video) A GRid must be a string conforming to the pattern [a-zA-Z0-9]{18} (Release
            Profile 1.4, Clause 4.3(30), Rule 1414-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SICI">
      <s:rule context="//SICI">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9].+')" role="Fatal Error">Fatal Error:
            #Longform Video) A SICI must be a string conforming to the pattern
            [0-9]{4}-[0-9]{3}[X0-9].+ (Release Profile 1.4, Clause 4.3(30), Rule 1415-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISSN">
      <s:rule context="//ISSN">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9]$')" role="Fatal Error">Fatal Error:
            #Longform Video) An ISSN must be a string conforming to the pattern
            [0-9]{4}-[0-9]{3}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 1416-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISBN">
      <s:rule context="//ISBN">
         <s:assert test="matches(., '^97[8-9][0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error:
            #Longform Video) An ISBN must be a string conforming to the pattern
            97[8-9][0-9]{9}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 1417-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_VISAN">
      <s:rule context="//VISAN">
         <s:assert test="matches(., '^[A-F0-9]{24}$')" role="Fatal Error">Fatal Error: #Longform
            Video) A VISAN must be a string conforming to the pattern [A-F0-9]{24} (Release Profile
            1.4, Clause 4.3(30), Rule 1418-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISAN">
      <s:rule context="//ISAN">
         <s:assert test="matches(., '^[A-F0-9]{12}$')" role="Fatal Error">Fatal Error: #Longform
            Video) An ISAN must be a string conforming to the pattern [A-F0-9]{12} (Release Profile
            1.4, Clause 4.3(30), Rule 1419-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISMN">
      <s:rule context="//ISMN">
         <s:assert test="matches(., '^979[0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error:
            #Longform Video) An ISMN must be a string conforming to the pattern 979[0-9]{9}[X0-9]
            (Release Profile 1.4, Clause 4.3(30), Rule 1420-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISWC">
      <s:rule context="//ISWC">
         <s:assert test="matches(., '^[a-zA-Z][0-9]{10}$')" role="Fatal Error">Fatal Error:
            #Longform Video) An ISWC must be a string conforming to the pattern [a-zA-Z][0-9]{10}
            (Release Profile 1.4, Clause 4.3(30), Rule 1421-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ICPN">
      <s:rule context="//ICPN">
         <s:assert test="matches(., '^[0-9]{8}$|^[0-9]{12,14}$')" role="Fatal Error">Fatal Error:
            #Longform Video) An ICPN must be a string conforming to the pattern [0-9]{8} or
            [0-9]{12,14} (Release Profile 1.4, Clause 4.3(30), Rule 1422-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_UserDefinedValue">
      <s:rule context="//*[(name() != 'LabelName') and @UserDefinedValue]">
         <s:assert test=".='UserDefined'" role="Fatal Error">Fatal Error: #Longform Video) The value
            shall be 'UserDefined' if a user-defined value is supplied (Release Profile 1.4, Clause
            4.3(31), Rule 1423-1).</s:assert>
         <s:assert test="@Namespace" role="Fatal Error">Fatal Error: #Longform Video) The
            appropriate Namespace for the user-defined value shall be provided (Release Profile 1.4,
            Clause 4.3(31), Rule 1423-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_CommentMustNotBeProvided">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="//Comment" role="Error">Error: #Longform Video) No Comment shall be
            provided (Release Profile 1.4, Clause 4.3(32), Rule 1424-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistsMustBeSequenced">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory/DisplayArtist">
         <s:assert test="@SequenceNumber" role="Fatal Error">Fatal Error: #Longform Video) All
            DisplayArtists should be sequenced (Release Profile 1.4, Clause 4.3(34), Rule
            1425-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SequenceNumberAsElement">
      <s:rule context="//*[SequenceNumber]">
         <s:assert
            test="number(SequenceNumber) &gt; 0 and number(SequenceNumber) &lt; count(preceding-sibling::*[SequenceNumber])+count(following-sibling::*[SequenceNumber])+2"
            role="Fatal Error">Fatal Error: SequenceNumbers must run from 1 to the number of
            sequenced elements (Release Profile 1.4, Clause 4.3(35), Rule 1669-1).</s:assert>
         <s:report test="preceding-sibling::*/SequenceNumber = SequenceNumber" role="Fatal Error"
            >Fatal Error: SequenceNumbers must all be different (Release Profile 1.3, Clause
            4.3(35), Rule 1129-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SequenceNumberAsAttribute">
      <s:rule context="//*[@SequenceNumber]">
         <s:assert
            test="@SequenceNumber &gt; 0 and @SequenceNumber &lt; 1+count(../*[name()=name(current())])"
            role="Fatal Error">Fatal Error: #Longform Video) SequenceNumbers must run from 1 to the
            number of sequenced elements (Release Profile 1.4, Clause 4.3(35), Rule
            1427-1).</s:assert>
         <s:report
            test="@SequenceNumber=following-sibling::*[name()=name(current())]/@SequenceNumber"
            role="Fatal Error">Fatal Error: #Longform Video) SequenceNumbers must all be different
            (Release Profile 1.4, Clause 4.3(35), Rule 1427-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PercentageValue">
      <s:rule context="//*[@HasMaxValueOfOne = 'true']">
         <s:report test="number(.) &gt; 1" role="Fatal Error">Fatal Error: #Longform Video) A
            Percentage with HasMaxValueOfOne set to true has a value between 0 and 1 (Release
            Profile 1.4, Clause 4.3(36a), Rule 1428-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PercentageValue2">
      <s:rule context="//*[@HasMaxValueOfOne = 'false']">
         <s:report test="number(.) &lt;= 1" role="Information">Information: #Longform Video)
            Percentages are typically provided in the interval between 0 and 100. The value provided
            seems to indicate a value equal to, or less than, 1% (Release Profile 1.4, Clause
            4.3(36b), Rule 1429-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_RightSharePercentageValue2">
      <s:rule context="//RightSharePercentage[not(@HasMaxValueOfOne)]">
         <s:report test="number(.) &lt;= 1" role="Information">Information: #Longform Video)
            Percentages are typically provided in the interval between 0 and 100. The value provided
            seems to indicate a value equal to, or less than, 1% (Release Profile 1.4, Clause
            4.3(36b), Rule 1430-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_ReleaseProfileVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/LongformMusicVideo'"
            role="Fatal Error">Fatal Error: #Longform Video) The ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/LongformMusicVideo' (Release Profile 1.4, Clause 3.2, Rule
            1431-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainVideo">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="Video" role="Fatal Error">Fatal Error: #Longform Video) A Release of this
            type must contain at least one Video (Release Profile 1.4, Clause 3.1, Rule
            1432-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainOneFrontCoverImageAsSecondaryResource">
      <s:rule context="//Release[@IsMainRelease='true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroupContentItem">
         <s:assert
            test="count(//ResourceList/Image[ImageType/text() = 'FrontCoverImage' and ResourceReference=current()/ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]) = 1"
            role="Fatal Error">Fatal Error: #Longform Video) A Release of this type must contain
            exactly one Image of type FrontCoverImage as a secondary Resource (Release Profile 1.4,
            Clause 3.1, Rule 1433-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainOneImage">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(Image) &gt; 0" role="Fatal Error">Fatal Error: #Longform Video) A
            Release of this type must contain one Image (Release Profile 1.4, Clause
            3.1, Rule 1434-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_TrackReleaseMustNotContainManyResources">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType[text() = 'TrackRelease']]/ReleaseResourceReferenceList">
         <s:report test="count(ReleaseResourceReference) &gt; 1" role="Fatal Error">Fatal Error:
            #Longform Video) A Track Release must not contain more than one Resource (Release
            Profile 1.4, Clause 3.1, Rule 1435-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimaryVideoMustHaveISRC">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'Video']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ISRC[string-length(normalize-space(text())) &gt; 0]"
            role="Error">Error: #Longform Video) Primary Video Resources should be identified with
            an ISRC (Release Profile 1.4, Clause 3.1, Rule 1436-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_MustContainVideoType">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert
            test="Video/VideoType[text() = 'LongFormMusicalWorkVideo' or text() = 'ConcertVideo' or text() = 'Documentary']"
            role="Fatal Error">Fatal Error: #Longform Video) A Longform Video must contain at least
            one Video of type LongFormMusicalWorkVideo or ConcertVideo or Documentary (Release
            Profile 1.4, Clause 3.1, Rule 1437-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_MustContainLongFormMusicalWorkVideoRelease">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert test="Release/ReleaseType[text() = 'LongFormMusicalWorkVideoRelease']"
            role="Fatal Error">Fatal Error: #Longform Video) A Longform Video must contain one
            LongFormMusicalWorkVideoRelease (Release Profile 1.4, Clause 3.1, Rule
            1438-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_MustContainOneRelease">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert test="count(Release) = 1" role="Fatal Error">Fatal Error: #Longform Video) A
            Longform Video must only contain one Release (Release Profile 1.4, Clause 3.1, Rule
            1439-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/DisplayArtist" role="Fatal Error">Fatal Error:
            #Longform Video) At least one DisplayArtist shall be provided (Release Profile 1.4,
            Clause 4.3(12c)+4.3(15b), Rule 1440-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistNamesMustBeDifferent">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory/DisplayArtistName = ReleaseResourceReferenceList/descendant::DisplayArtistName"
            role="Error">Error: #Longform Video) DisplayArtistNames for Release and Resource must be
            different (Release Profile 1.4, Clause 4.3(16a), Rule 1441-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MainReleaseMustHaveGridOrICPN">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert
            test="Release[@IsMainRelease = 'true']/ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | Release[@IsMainRelease = 'true']/ReleaseId/ICPN[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Longform Video) The MainRelease shall be identified by
            either a GRid or by an ICPN (Release Profile 1.4, Clause 4.8(4), Rule
            1442-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimarySoundRecordingMustHaveISRC">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'SoundRecording']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ISRC[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Longform Video) Primary SoundRecording Resources shall
            be identified with an ISRC (Release Profile 1.4, Clause 4.8(5), Rule 1443-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SecondaryResourceMustHaveProprietaryId">
      <s:rule
         context="//ResourceGroupContentItem/ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ProprietaryId[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Longform Video) Secondary Resources shall be identified
            by a ProprietaryId (Release Profile 1.4, Clause 4.8(6), Rule 1444-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_PrimaryResourcesMustHaveCorrespondingCueSheet">
      <s:rule
         context="//ResourceGroupContentItem/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/VideoCueSheetReference[string-length(normalize-space(text())) &gt; 0]"
            role="Error">Error: #Longform Video) Each primary Longform video resource should have a
            corresponding CueSheet referenced using the VideoCueSheetReference on the resource
            (Release Profile 1.4, Clause 4.8(9a), Rule 1445-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CueSheetMustContainCue">
      <s:rule context="//CueSheet">
         <s:assert test="Cue" role="Fatal Error">Fatal Error: #Longform Video) Each CueSheet will
            consist of 1 to many Cues (Release Profile 1.4, Clause 4.8(9b), Rule 1446-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CueMustHaveStartTimeAndDuration">
      <s:rule context="//Cue">
         <s:assert test="StartTime[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Longform Video) Each Cue should have a StartTime
            (Release Profile 1.4, Clause 4.8(9c), Rule 1447-1).</s:assert>
         <s:assert test="Duration[string-length(normalize-space(text())) &gt; 0]" role="Fatal Error"
            >Fatal Error: #Longform Video) Each Cue should have a Duration (Release Profile 1.4,
            Clause 4.8(9c), Rule 1447-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CueMustHaveIsrcOrISWC">
      <s:rule context="//Cue">
         <s:assert
            test="ReferencedCreationId/ISRC[string-length(normalize-space(text())) &gt; 0] | ReferencedCreationId/ISWC[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Longform Video) Each Cue should have an ISRC or an ISWC
            (Release Profile 1.4, Clause 4.8(9e1), Rule 1448-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CueMustHaveOneFormalTitle">
      <s:rule context="//Cue">
         <s:assert
            test="count(ReferencedCreationTitle[@TitleType='FormalTitle']/TitleText[string-length(normalize-space(text())) &gt; 0]) = 1"
            role="Error">Error: #Longform Video) Each Cue should have one and only one
            ReferencedCreationTitle of type FormalTitle (Release Profile 1.4, Clause 4.8(9e2), Rule
            1449-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CueMustHaveDisplayTitle">
      <s:rule context="//Cue">
         <s:assert
            test="ReferencedCreationTitle[@TitleType='DisplayTitle']/TitleText[string-length(normalize-space(text())) &gt; 0]"
            role="Error">Error: #Longform Video) Each Cue should have a ReferencedCreationTitle of
            type DisplayTitle (Release Profile 1.4, Clause 4.8(9e2), Rule 1450-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CueMustHaveContributor">
      <s:rule context="//Cue">
         <s:assert test="ReferencedCreationContributor" role="Error">Error: #Longform Video) Each
            Cue should have a ReferencedCreationContributor (Release Profile 1.4, Clause 4.8(9e3),
            Rule 1451-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CueMustHavePLine">
      <s:rule context="//Cue">
         <s:assert test="PLine" role="Error">Error: #Longform Video) Each Cue should have a PLine
            (Release Profile 1.4, Clause 4.8(9e3), Rule 1452-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CueMustHaveMusicalContent">
      <s:rule context="//Cue">
         <s:assert test="HasMusicalContent[lower-case(text()) = 'true']" role="Error">Error:
            #Longform Video) Each Cue should have a HasMusicalContent flag = True (Release Profile
            1.4, Clause 4.8(9e4), Rule 1453-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CueMustHaveCLine">
      <s:rule context="//Cue">
         <s:assert test="CLine" role="Error">Error: #Longform Video) Each Cue should have a CLine
            (Release Profile 1.4, Clause 4.8(9e6), Rule 1454-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CollectionItemMustBeVideoChapter">
      <s:rule context="//Collection">
         <s:assert test="CollectionType[text() = 'VideoChapter']" role="Fatal Error">Fatal Error:
            #Longform Video) Each Collection item should have the CollectionType VideoChapter
            (Release Profile 1.4, Clause 4.8(10a), Rule 1455-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CollectionItemMustHaveProprietaryId">
      <s:rule context="//Collection">
         <s:assert test="CollectionId/ProprietaryId[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Longform Video) Each Collection item should have a
            Proprietary CollectionId (Release Profile 1.4, Clause 4.8(10b), Rule 1456-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CollectionItemMustHaveTitle">
      <s:rule context="//Collection">
         <s:assert test="Title" role="Fatal Error">Fatal Error: #Longform Video) Each Collection
            item should have a Title (Release Profile 1.4, Clause 4.8(10c), Rule 1457-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CollectionItemMustBeComplete">
      <s:rule context="//Collection">
         <s:assert test="IsComplete[lower-case(text()) = 'true']" role="Error">Error: #Longform
            Video) Each Collection item should have an IsComplete flag = True (Release Profile 1.4,
            Clause 4.8(10d), Rule 1458-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_CollectionItemMustReferencePrimaryVideo">
      <s:rule context="//Collection/CollectionResourceReferenceList/*/CollectionResourceReference">
         <s:assert
            test="//ResourceGroupContentItem/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource' and text() = current()]"
            role="Fatal Error">Fatal Error: #Longform Video) Each Collection item should have a
            CollectionResourceReferenceList containing one reference to the Video representing the
            primary resource on the Longform release (Release Profile 1.4, Clause 4.8(10e), Rule
            1459-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_PrimaryVideoResourceMustHaveSoundRecordingCollectionReference">
      <s:rule
         context="Video[ResourceReference = //ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]/VideoCollectionReferenceList/SoundRecordingCollectionReference/SoundRecordingCollectionReference">
         <s:assert
            test="//Collection[CollectionType='VideoChapter' and CollectionReference[text() = current()]]/CollectionResourceReferenceList/*/CollectionResourceReference[text() = current()/../../../ResourceReference]"
            role="Fatal Error">Fatal Error: #Longform Video) The primary Video resource should have
            a SoundRecordingCollectionReference for each VideoChapter collection item (Release
            Profile 1.4, Clause 4.8(10g), Rule 1460-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="LongformVideo_SoundRecordingCollectionReferenceMustHaveStartTime">
      <s:rule
         context="Video[ResourceReference = //ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]/VideoCollectionReferenceList/SoundRecordingCollectionReference">
         <s:assert test="StartTime[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Longform Video) Each SoundRecordingCollectionReference
            on the primary Video resource should have a StartTime indicating the chapter start time
            on the Video (Release Profile 1.4, Clause 4.8(10h), Rule 1461-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_LabelNameMustBeProvided2">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/LabelName" role="Fatal Error">Fatal Error:
            #Longform Video) A LabelName has to be specified for each Release (Release Profile 1.4,
            Clause 4.13(13), Rule 1462-1).</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
