<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <!--
          This Schematron rule set requires XPath2. 
          This can be enforced by, for instance, adding an attribute into the above s:schema tag 
          (queryBinding="xslt2") or by instructing the processor for running the Schematron
          rule to use XPath2 in any other way.
                    -->
   <s:title>Schematron Release Profile for Single Resource With Cover Art (version 1.4) for the
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
      that has already been issued. However, if more than 7 rules (representing 50% of all rules
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
            #Single Resource With Cover Art) No deprecated date elements should be used.</s:report>
         <s:report test="MIDI/MasteredDate" role="Information">Information: #Single Resource With
            Cover Art) No deprecated date elements should be used.</s:report>
         <s:report test="ReleaseDetailsByTerritory/OriginalDigitalReleaseDate" role="Information"
            >Information: #Single Resource With Cover Art) No deprecated date elements should be
            used.</s:report>
         <s:report test="Release/GlobalReleaseDate" role="Information">Information: #Single Resource
            With Cover Art) No deprecated date elements should be used.</s:report>
         <s:report test="Release/GlobalOriginalReleaseDate" role="Information">Information: #Single
            Resource With Cover Art) No deprecated date elements should be used.</s:report>
         <s:report test="SoundRecordingDetailsByTerritory/RemasteredDate" role="Information"
            >Information: #Single Resource With Cover Art) No deprecated date elements should be
            used.</s:report>
         <s:report test="MIDI/RemasteredDate" role="Information">Information: #Single Resource With
            Cover Art) No deprecated date elements should be used.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MessageSchemaVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert
            test="substring(@MessageSchemaVersionId, 1, 4) = 'ern/' and number(substring(@MessageSchemaVersionId, 5,2)) &gt;= 39"
            role="Information">Information: #Single Resource With Cover Art) The
            MessageSchemaVersionId should be at least 3.9.</s:assert>
         <s:assert test="@MessageSchemaVersionId = 'ern/39Draft'" role="Information">Information:
            #Single Resource With Cover Art) You are not using the latest XSD supported by this
            Schematron file.</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainSixResourceGroups">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup">
         <s:report test="ResourceGroup" role="Information">Information: #Single Resource With Cover
            Art) There should not be more than 5 nested ResourceGroups.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SoundRecordingMustNotHaveDeprecatedFlags">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording">
         <s:report test="IsHiddenResource" role="Information">Information: #Single Resource With
            Cover Art) No deprecated Flags (IsHiddenResource) must be provided for
            SoundRecordings.</s:report>
         <s:report test="IsBonusResource" role="Information">Information: #Single Resource With
            Cover Art) No deprecated Flags (IsBonusResource) must be provided for
            SoundRecordings.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainComponentRelease">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
         <s:assert
            test="//Release[ReleaseType[(text() = 'TrackRelease') or (text() = 'VideoTrackRelease')]]/ReleaseResourceReferenceList/ReleaseResourceReference = ./ReleaseResourceReference"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) One component release
            should be supplied per primary resource referenced on the Main release, regardless of
            whether there are any deals available for the component release (Release Profile 1.4,
            Clause 3.1, Rule 2038-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MainReleaseMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:report test="count(Release[@IsMainRelease = 'true']) &lt; 1" role="Fatal Error">Fatal
            Error: #Single Resource With Cover Art) At least one Release shall have IsMainRelease
            flag = True (Release Profile 1.4, Clause 3.3.1(1), Rule 2039-1).</s:report>
         <s:report test="count(Release[@IsMainRelease = 'true']) &gt; 1" role="Fatal Error">Fatal
            Error: #Single Resource With Cover Art) More than one Release with IsMainRelease has
            been specified (Release Profile 1.4, Clause 3.3.1(1), Rule 2039-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimaryResourcesMustBeSequenced">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release/*/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error: #Single Resource With Cover
            Art) Track bundle resource groups should be sequenced (Release Profile 1.4, Clause
            3.3.1(2)+3.3.1(3)+3.3.1(5), Rule 2040-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceGroupsMustBeSequenced">
      <s:rule
         context="//Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroup">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error: #Single Resource With Cover
            Art) All ResourceGroups should be sequenced (Release Profile 1.4, Clause 3.3.1(2), Rule
            2041-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimaryResourcesMustBeSequencedWithinTheirGroup">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroup">
         <s:report
            test="descendant::ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource'] and SequenceNumber &gt; '1'] and not(descendant::ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource'] and SequenceNumber = '1'])"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) All Primary Resources
            should be sequenced in the context of their track bundle ResourceGroup (i.e. the
            sequence restarts with the next track bundle) (Release Profile 1.4, Clause 3.3.1(3),
            Rule 2042-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceGroupContentItemsMustBeSequenced">
      <s:rule
         context="//Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference/@ReleaseResourceType='PrimaryResource']">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error: #Single Resource With Cover
            Art) All ResourceGroupContentItems should be sequenced (Release Profile 1.4, Clause
            3.3.1(3), Rule 2043-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SecondaryResourcesMustNotBeSequenced">
      <s:rule
         context="//ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
         <s:report test="SequenceNumber" role="Error">Error: #Single Resource With Cover Art)
            Secondary Resources (e.g. cover images) content items shall not be sequenced (Release
            Profile 1.4, Clause 3.3.1(4), Rule 2044-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimarySoundRecordingMustHaveIndirectSoundRecordingId">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'SoundRecording']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert test="//ResourceReference[text() = current()]/../IndirectSoundRecordingId"
            role="Conditional Fatal Error">Conditional Fatal Error: #Single Resource With Cover Art)
            Primary SoundRecording Resources shall have an IndirectSoundRecordingId (Release Profile
            1.4, Clause 3.3.1(6), Rule 2045-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ReleaseResourceTypeMustBeProvided">
      <s:rule context="*:ResourceGroupContentItem/ReleaseResourceReference">
         <s:assert test="@ReleaseResourceType" role="Fatal Error">Fatal Error: #Single Resource With
            Cover Art) For each ReleaseResourceReference a ReleaseResourceType shall be provided
            (Release Profile 1.4, Clause 4.3(1)+4.3(2), Rule 2046-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainResource">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(*) &gt; 0" role="Fatal Error">Fatal Error: #Single Resource With
            Cover Art) A ResourceList must contain at least one Resource (Release Profile 1.4,
            Clause 4.3(3), Rule 2047-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SoundRecordingMustHaveReferenceTitle">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording">
         <s:assert
            test="count(ReferenceTitle[string-length(normalize-space(TitleText)) &gt; 0]) = 1"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) A Single ReferenceTitle
            must be provided for each SoundRecording (Release Profile 1.4, Clause 4.3(4), Rule
            2048-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SingleFormalTitlePerTerritory">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory[1]">
         <s:assert
            test="Title[@TitleType='FormalTitle'][string-length(normalize-space(TitleText)) &gt; 0]"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) At least one Title of
            type FormalTitle shall be provided for the default Worldwide ReleaseDetailsByTerritory
            section (Release Profile 1.4, Clause 4.3(4), Rule 2049-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SingleDisplayTitlePerTerritory">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory[1]">
         <s:assert
            test="Title[@TitleType='DisplayTitle'][string-length(normalize-space(TitleText)) &gt; 0]"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) At least one Title of
            type DisplayTitle shall be provided for the default Worldwide ReleaseDetailsByTerritory
            section (Release Profile 1.4, Clause 4.3(4), Rule 2050-1).</s:assert>
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
            >Error: #Single Resource With Cover Art) If more than one LabelName is provided, exactly
            one shall be a DisplayLabelName (Release Profile 1.4, Clause 4.3(6), Rule
            2053-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_LabelNameMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory[position() = 1 and not(LabelName[string-length(normalize-space(text())) &gt; 0])] and ReleaseDetailsByTerritory[position() &gt; 1 and not(LabelName[string-length(normalize-space(text())) &gt; 0])]"
            role="Error">Error: #Single Resource With Cover Art) If a LabelName is not specified for
            the Worldwide ReleaseDetailsByTerritory, it needs to be specified in all the other
            ReleaseDetailsByTerritory composites (Release Profile 1.4, Clause 4.3(6a)+4.3(6b), Rule
            2054-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_UserDefinedLabelNameType">
      <s:rule context="//LabelName[@UserDefinedValue]">
         <s:assert test="@LabelNameType='UserDefined'" role="Error">Error: #Single Resource With
            Cover Art) The LabelNameType shall be 'UserDefined' if a user-defined value is supplied
            for a LabelName (Release Profile 1.4, Clause 4.3(6b), Rule 2055-1).</s:assert>
         <s:assert test="@Namespace" role="Error">Error: #Single Resource With Cover Art) The
            appropriate Namespace for the user-defined value shall be provided (Release Profile 1.4,
            Clause 4.3(6b), Rule 2055-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_GenreMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory[position = 1 and not(Genre/GenreText[string-length(normalize-space(text())) &gt; 0])] and ReleaseDetailsByTerritory[position() &gt; 1 and not(Genre/GenreText[string-length(normalize-space(text())) &gt; 0])]"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) If a Genre is not
            specified for the Worldwide ReleaseDetailsByTerritory, it needs to be specified in all
            the other ReleaseDetailsByTerritory composites. (Release Profile 1.4, Clause 4.3(7),
            Rule 2056-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ParentalWarningTypeMustBeProvided">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="//ParentalWarningType[string-length(normalize-space(text())) &gt; 0]"
            role="Error">Error: #Single Resource With Cover Art) The appropriate ParentalWarningType
            shall be provided (Release Profile 1.4, Clause 4.3(8), Rule 2057-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ReleaseDateMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/ReleaseDate | GlobalReleaseDate"
            role="Conditional Error">Conditional Error: #Single Resource With Cover Art) A
            GlobalReleaseDate or a ReleaseDate shall be provided for each Release (Release Profile
            1.4, Clause 4.3(9), Rule 2058-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceReleaseDateMustBeProvided">
      <s:rule
         context="//ResourceGroupContentItem/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../SoundRecordingDetailsByTerritory/ResourceReleaseDate | //ResourceReference[text() = current()]/../SoundRecordingDetailsByTerritory/OriginalResourceReleaseDate"
            role="Conditional Error">Conditional Error: #Single Resource With Cover Art) A
            ResourceReleaseDate or an OriginalResourceReleaseDate shall be provided for each primary
            Resource if available to the Message Sender (Release Profile 1.4, Clause 4.3(10), Rule
            2059-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MusicalWorkContributorRole">
      <s:rule context="//MusicalWork">
         <s:assert
            test="MusicalWorkContributor/MusicalWorkContributorRole[text() = 'Adapter' or text() = 'Arranger' or text() = 'AssociatedPerformer' or text() = 'Author' or text() = 'Composer' or text() = 'ComposerLyricist' or text() = 'Librettist' or text() = 'Lyricist' or text() = 'NonLyricAuthor' or text() = 'SubArranger' or text() = 'Translator']"
            role="Conditional Error">Conditional Error: #Single Resource With Cover Art) If there is
            a MusicalWork, there has to be a creative contributor (Release Profile 1.4, Clause
            4.3(12a), Rule 2060-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ShouldContainIndirectResourceContributor">
      <s:rule
         context="*:NewReleaseMessage/ResourceList/SoundRecording/SoundRecordingDetailsByTerritory">
         <s:assert test="IndirectResourceContributor" role="Conditional Error">Conditional Error:
            #Single Resource With Cover Art) No MusicalWorkContributor was found; information of at
            least one MusicalWorkContributor should be provided if available (Release Profile 1.4,
            Clause 4.3(12a), Rule 2061-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceContributorDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList/*/*">
         <s:assert
            test="count(ResourceContributor)=count(ResourceContributor[not(PartyId=preceding-sibling::ResourceContributor/PartyId)])"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) ResourceContributors
            shall be provided only once (with multiple roles) (Release Profile 1.4, Clause
            4.3(13)+4.3(20), Rule 2062-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistNameDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:report test="*/*/DisplayArtistName" role="Error">Error: #Single Resource With Cover Art)
            The DisplayArtistNames of a Resource shall not be the same as the DisplayArtistName of
            the Album it belongs to (Release Profile 1.4, Clause 4.3(18), Rule 2063-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_IndirectResourceContributorDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList/*/*">
         <s:assert
            test="count(IndirectResourceContributor)=count(IndirectResourceContributor[not(PartyId=preceding-sibling::IndirectResourceContributor/PartyId)])"
            role="Conditional Fatal Error">Conditional Fatal Error: #Single Resource With Cover Art)
            IndirectResourceContributors shall be provided only once (with multiple roles) (Release
            Profile 1.4, Clause 4.3(21), Rule 2064-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_RightSharePercentage">
      <s:rule context="//MusicalWork">
         <s:report test="sum(//RightShare/RightSharePercentage) &gt; 100" role="Fatal Error">Fatal
            Error: #Single Resource With Cover Art) The total of all RightSharePercentages for each
            MusicalWork must not exceed 100% (Release Profile 1.4, Clause 4.3(22), Rule
            2065-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_RightSharePercentageValue">
      <s:rule context="//RightSharePercentage">
         <s:assert test="//RightSharePercentage &gt; 0 and //RightSharePercentage &lt; 100"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) A RightSharePercentage
            has a value between 0 and 100 (Release Profile 1.4, Clause 4.3(22), Rule
            2066-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_CatalogTransfer">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="CatalogTransfer" role="Conditional Fatal Error">Conditional Fatal Error:
            #Single Resource With Cover Art) The CatalogTransfer element has been used. This is only
            to be used when communicating a catalogue transfer (Release Profile 1.4, Clause 4.3(23),
            Rule 2067-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_FlagsOnlyOnContentItems">
      <s:rule context="*:NewReleaseMessage">
         <s:report
            test="SoundRecording/IsHiddenResource | MIDI/IsHiddenResource | Video/IsHiddenResource"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) IsHiddenResource must
            not be used on a Resource (Release Profile 1.4, Clause 4.3(24)+4.10(7g)+4.10(7h), Rule
            2068-1).</s:report>
         <s:report
            test="SoundRecording/IsBonusResource | MIDI/IsBonusResource | Video/IsBonusResource"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) IsBonusResource must
            not be used on a Resource (Release Profile 1.4, Clause 4.3(24)+4.10(7g)+4.10(7h), Rule
            2068-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_Territory">
      <s:rule context="//TerritoryCode | //ExcludedTerritoryCode">
         <s:report
            test="(substring(@IdentifierType, 1, 3) = 'ISO' or not(@IdentifierType)) and string-length(normalize-space(text())) != 2 and text() != 'Worldwide' and translate(text(), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '') != ''"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) A TerritoryCode of type
            'ISO' must be a two-letter code or 'Worldwide' (Release Profile 1.4, Clause 4.3(25),
            Rule 2069-1).</s:report>
         <s:report test="substring(@IdentifierType, 1, 3) = 'TIS' and number() != ."
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) A TerritoryCode of type
            'TIS' must be a numeric code (Release Profile 1.4, Clause 4.3(25), Rule
            2069-2).</s:report>
         <s:report
            test="substring(@IdentifierType, 1, 3) = 'Dep' and (string-length(normalize-space(text())) != 4 or number() = .)"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) A deprecated
            TerritoryCode must be a four-letter code (Release Profile 1.4, Clause 4.3(25), Rule
            2069-3).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_TerritoryTIS">
      <s:rule context="//TerritoryCode | //ExcludedTerritoryCode">
         <s:report test="substring(@IdentifierType, 1, 3) = 'TIS'" role="Fatal Error">Fatal Error:
            #Single Resource With Cover Art) A TerritoryCode of type 'TIS' must not be used (Release
            Profile 1.4, Clause 4.3(25), Rule 2070-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISNI">
      <s:rule context="//PartyId[@IsISNI = 'true']">
         <s:assert test="matches(., '^[0-9]{15}[X0-9]$')" role="Fatal Error">Fatal Error: #Single
            Resource With Cover Art) A PartyId of type 'ISNI' must be a string conforming to the
            pattern [0-9]{15}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 2071-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISRC">
      <s:rule context="//ISRC">
         <s:assert test="matches(., '^[a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7}$')" role="Fatal Error">Fatal
            Error: #Single Resource With Cover Art) An ISRC must be a string conforming to the
            pattern [a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7} (Release Profile 1.4, Clause 4.3(30), Rule
            2072-1).</s:assert>
         <s:assert
            test="matches(substring(.,1,2), '(FX|QM|UK|CP|DG|ZZ|AD|AE|AF|AG|AI|AL|AM|AN|AO|AQ|AR|AS|AT|AU|AW|AX|AZ|BA|BB|BD|BE|BF|BG|BH|BI|BJ|BL|BM|BN|BO|BQ|BR|BS|BT|BV|BW|BY|BZ|CA|CC|CD|CF|CG|CH|CI|CK|CL|CM|CN|CO|CR|CS|CU|CV|CW|CX|CY|CZ|DE|DJ|DK|DM|DO|DZ|EC|EE|EG|EH|ER|ES|ET|FI|FJ|FK|FM|FO|FR|GA|GB|GD|GE|GF|GG|GH|GI|GL|GM|GN|GP|GQ|GR|GS|GT|GU|GW|GY|HK|HM|HN|HR|HT|HU|ID|IE|IL|IM|IN|IO|IQ|IR|IS|IT|JE|JM|JO|JP|KE|KG|KH|KI|KM|KN|KP|KR|KW|KY|KZ|LA|LB|LC|LI|LK|LR|LS|LT|LU|LV|LY|MA|MC|MD|ME|MF|MG|MH|MK|ML|MM|MN|MO|MP|MQ|MR|MS|MT|MU|MV|MW|MX|MY|MZ|NA|NC|NE|NF|NG|NI|NL|NO|NP|NR|NU|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PM|PN|PR|PS|PT|PW|PY|QA|RE|RO|RS|RU|RW|SA|SB|SC|SD|SE|SG|SH|SI|SJ|SK|SL|SM|SN|SO|SR|SS|ST|SV|SX|SY|SZ|TC|TD|TF|TG|TH|TJ|TK|TL|TM|TN|TO|TR|TT|TV|TW|TZ|UA|UG|UM|US|UY|UZ|VA|VC|VE|VG|VI|VN|VU|WF|WS|YE|YT|ZA|ZM|ZW)')"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) An ISRC must be a
            string starting with an ISO 3166 code or FX, QM, UK, CP, DG or ZZ (Release Profile 1.4,
            Clause 4.3(30), Rule 2072-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_GRid">
      <s:rule context="//GRid">
         <s:assert test="matches(., '^[a-zA-Z0-9]{18}$')" role="Fatal Error">Fatal Error: #Single
            Resource With Cover Art) A GRid must be a string conforming to the pattern
            [a-zA-Z0-9]{18} (Release Profile 1.4, Clause 4.3(30), Rule 2073-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SICI">
      <s:rule context="//SICI">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9].+')" role="Fatal Error">Fatal Error:
            #Single Resource With Cover Art) A SICI must be a string conforming to the pattern
            [0-9]{4}-[0-9]{3}[X0-9].+ (Release Profile 1.4, Clause 4.3(30), Rule 2074-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISSN">
      <s:rule context="//ISSN">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9]$')" role="Fatal Error">Fatal Error:
            #Single Resource With Cover Art) An ISSN must be a string conforming to the pattern
            [0-9]{4}-[0-9]{3}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 2075-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISBN">
      <s:rule context="//ISBN">
         <s:assert test="matches(., '^97[8-9][0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error:
            #Single Resource With Cover Art) An ISBN must be a string conforming to the pattern
            97[8-9][0-9]{9}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 2076-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_VISAN">
      <s:rule context="//VISAN">
         <s:assert test="matches(., '^[A-F0-9]{24}$')" role="Fatal Error">Fatal Error: #Single
            Resource With Cover Art) A VISAN must be a string conforming to the pattern [A-F0-9]{24}
            (Release Profile 1.4, Clause 4.3(30), Rule 2077-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISAN">
      <s:rule context="//ISAN">
         <s:assert test="matches(., '^[A-F0-9]{12}$')" role="Fatal Error">Fatal Error: #Single
            Resource With Cover Art) An ISAN must be a string conforming to the pattern [A-F0-9]{12}
            (Release Profile 1.4, Clause 4.3(30), Rule 2078-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISMN">
      <s:rule context="//ISMN">
         <s:assert test="matches(., '^979[0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error: #Single
            Resource With Cover Art) An ISMN must be a string conforming to the pattern
            979[0-9]{9}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 2079-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISWC">
      <s:rule context="//ISWC">
         <s:assert test="matches(., '^[a-zA-Z][0-9]{10}$')" role="Fatal Error">Fatal Error: #Single
            Resource With Cover Art) An ISWC must be a string conforming to the pattern
            [a-zA-Z][0-9]{10} (Release Profile 1.4, Clause 4.3(30), Rule 2080-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ICPN">
      <s:rule context="//ICPN">
         <s:assert test="matches(., '^[0-9]{8}$|^[0-9]{12,14}$')" role="Fatal Error">Fatal Error:
            #Single Resource With Cover Art) An ICPN must be a string conforming to the pattern
            [0-9]{8} or [0-9]{12,14} (Release Profile 1.4, Clause 4.3(30), Rule 2081-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_UserDefinedValue">
      <s:rule context="//*[(name() != 'LabelName') and @UserDefinedValue]">
         <s:assert test=".='UserDefined'" role="Fatal Error">Fatal Error: #Single Resource With
            Cover Art) The value shall be 'UserDefined' if a user-defined value is supplied (Release
            Profile 1.4, Clause 4.3(31), Rule 2082-1).</s:assert>
         <s:assert test="@Namespace" role="Fatal Error">Fatal Error: #Single Resource With Cover
            Art) The appropriate Namespace for the user-defined value shall be provided (Release
            Profile 1.4, Clause 4.3(31), Rule 2082-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_CommentMustNotBeProvided">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="//Comment" role="Error">Error: #Single Resource With Cover Art) No Comment
            shall be provided (Release Profile 1.4, Clause 4.3(32), Rule 2083-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistsMustBeSequenced">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory/DisplayArtist">
         <s:assert test="@SequenceNumber" role="Fatal Error">Fatal Error: #Single Resource With
            Cover Art) All DisplayArtists should be sequenced (Release Profile 1.4, Clause 4.3(34),
            Rule 2084-1).</s:assert>
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
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) SequenceNumbers must
            run from 1 to the number of sequenced elements (Release Profile 1.4, Clause 4.3(35),
            Rule 2086-1).</s:assert>
         <s:report
            test="@SequenceNumber=following-sibling::*[name()=name(current())]/@SequenceNumber"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) SequenceNumbers must
            all be different (Release Profile 1.4, Clause 4.3(35), Rule 2086-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PercentageValue">
      <s:rule context="//*[@HasMaxValueOfOne = 'true']">
         <s:report test="number(.) &gt; 1" role="Fatal Error">Fatal Error: #Single Resource With
            Cover Art) A Percentage with HasMaxValueOfOne set to true has a value between 0 and 1
            (Release Profile 1.4, Clause 4.3(36a), Rule 2087-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PercentageValue2">
      <s:rule context="//*[@HasMaxValueOfOne = 'false']">
         <s:report test="number(.) &lt;= 1" role="Information">Information: #Single Resource With
            Cover Art) Percentages are typically provided in the interval between 0 and 100. The
            value provided seems to indicate a value equal to, or less than, 1% (Release Profile
            1.4, Clause 4.3(36b), Rule 2088-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_RightSharePercentageValue2">
      <s:rule context="//RightSharePercentage[not(@HasMaxValueOfOne)]">
         <s:report test="number(.) &lt;= 1" role="Information">Information: #Single Resource With
            Cover Art) Percentages are typically provided in the interval between 0 and 100. The
            value provided seems to indicate a value equal to, or less than, 1% (Release Profile
            1.4, Clause 4.3(36b), Rule 2089-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceReleaseWithCoverArt_ReleaseProfileVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert
            test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/SingleResourceReleaseWithCoverArt'"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) The
            ReleaseProfileVersionId should be
            'CommonReleaseTypes/14/SingleResourceReleaseWithCoverArt' (Release Profile 1.4, Clause
            3.2, Rule 2090-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimaryVideoMustHaveISRC">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'Video']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ISRC[string-length(normalize-space(text())) &gt; 0]"
            role="Error">Error: #Single Resource With Cover Art) Primary Video Resources should be
            identified with an ISRC (Release Profile 1.4, Clause 3.1, Rule 2091-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustContainOneResource">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(descendant::ResourceReference) = 2" role="Fatal Error">Fatal Error:
            #Single Resource With Cover Art) A Single Resource Release must contain exactly two Resources (Release Profile 1.4, Clause 3.1, Rule 2092-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustContainSingleResourceRelease">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert test="Release/ReleaseType[text() = 'SingleResourceRelease']" role="Fatal Error"
            >Fatal Error: #Single Resource With Cover Art) A Single Resource Release must contain
            one SingleResourceRelease release (Release Profile 1.4, Clause 3.1, Rule
            2093-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustNotContainSecondaryResource">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert
            test="not(descendant::ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']])"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) A Single Resource
            Release must not contain any Secondary Resources (Release Profile 1.4, Clause 3.1, Rule
            2094-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/DisplayArtist" role="Fatal Error">Fatal Error:
            #Single Resource With Cover Art) At least one DisplayArtist shall be provided (Release
            Profile 1.4, Clause 4.3(12c)+4.3(15b), Rule 2095-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistNamesMustBeDifferent">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory/DisplayArtistName = ReleaseResourceReferenceList/descendant::DisplayArtistName"
            role="Error">Error: #Single Resource With Cover Art) DisplayArtistNames for Release and
            Resource must be different (Release Profile 1.4, Clause 4.3(16a), Rule
            2096-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustNotContainReleaseResourceStructure">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="not(descendant::ResourceGroup)" role="Fatal Error">Fatal Error: #Single
            Resource With Cover Art) A Single Resource Release must not contain a release resource
            structure (Release Profile 1.4, Clause 4, Rule 2097-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustNotContainResourceGroup">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report test="ResourceGroup" role="Fatal Error">Fatal Error: #Single Resource With Cover
            Art) A Single Resource Release must not contain any Resource Group (Release Profile 1.4,
            Clause 4.12(7), Rule 2098-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MainReleaseMustHaveGridOrICPN">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert
            test="Release[@IsMainRelease = 'true']/ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | Release[@IsMainRelease = 'true']/ReleaseId/ICPN[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) The MainRelease shall
            be identified by either a GRid or by an ICPN (Release Profile 1.4, Clause 4.18(4), Rule
            2099-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimarySoundRecordingMustHaveISRC">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'SoundRecording']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ISRC[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Single Resource With Cover Art) Primary SoundRecording
            Resources shall be identified with an ISRC (Release Profile 1.4, Clause 4.18(5), Rule
            2100-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_LabelNameMustBeProvided2">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/LabelName" role="Fatal Error">Fatal Error:
            #Single Resource With Cover Art) A LabelName has to be specified for each Release
            (Release Profile 1.4, Clause 4.18(8), Rule 2101-1).</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
