  <?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <!--
          This Schematron rule set requires XPath2. 
          This can be enforced by, for instance, adding an attribute into the above s:schema tag 
          (queryBinding="xslt2") or by instructing the processor for running the Schematron
          rule to use XPath2 in any other way.
                    -->
   <s:title>Schematron Release Profile for Audio Album (version 1.4) for the
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
            #Audio Album Music Only) No deprecated date elements should be used.</s:report>
         <s:report test="MIDI/MasteredDate" role="Information">Information: #Audio Album Music Only)
            No deprecated date elements should be used.</s:report>
         <s:report test="ReleaseDetailsByTerritory/OriginalDigitalReleaseDate" role="Information"
            >Information: #Audio Album Music Only) No deprecated date elements should be
            used.</s:report>
         <s:report test="Release/GlobalReleaseDate" role="Information">Information: #Audio Album
            Music Only) No deprecated date elements should be used.</s:report>
         <s:report test="Release/GlobalOriginalReleaseDate" role="Information">Information: #Audio
            Album Music Only) No deprecated date elements should be used.</s:report>
         <s:report test="SoundRecordingDetailsByTerritory/RemasteredDate" role="Information"
            >Information: #Audio Album Music Only) No deprecated date elements should be
            used.</s:report>
         <s:report test="MIDI/RemasteredDate" role="Information">Information: #Audio Album Music
            Only) No deprecated date elements should be used.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MessageSchemaVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert
            test="substring(@MessageSchemaVersionId, 1, 4) = 'ern/' and number(substring(@MessageSchemaVersionId, 5,2)) &gt;= 39"
            role="Information">Information: #Audio Album Music Only) The MessageSchemaVersionId
            should be at least 3.9.</s:assert>
         <s:assert test="@MessageSchemaVersionId = 'ern/39Draft'" role="Information">Information:
            #Audio Album Music Only) You are not using the latest XSD supported by this Schematron
            file.</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustNotContainSixResourceGroups">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup">
         <s:report test="ResourceGroup" role="Information">Information: #Audio Album Music Only)
            There should not be more than 5 nested ResourceGroups.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SoundRecordingMustNotHaveDeprecatedFlags">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording">
         <s:report test="IsHiddenResource" role="Information">Information: #Audio Album Music Only)
            No deprecated Flags (IsHiddenResource) must be provided for SoundRecordings.</s:report>
         <s:report test="IsBonusResource" role="Information">Information: #Audio Album Music Only)
            No deprecated Flags (IsBonusResource) must be provided for SoundRecordings.</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainComponentRelease">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']] | *:NewReleaseMessage/ReleaseList/Release[1]/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
         <s:assert
            test="//Release[ReleaseType[(text() = 'TrackRelease') or (text() = 'VideoTrackRelease')]]/ReleaseResourceReferenceList/ReleaseResourceReference = ./ReleaseResourceReference"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) One component release should be
            supplied per primary resource referenced on the Main release, regardless of whether
            there are any deals available for the component release (Release Profile 1.4, Clause
            3.1, Rule 1077-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MainReleaseMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:report test="count(Release[@IsMainRelease = 'true']) &lt; 1" role="Fatal Error">Fatal
            Error: #Audio Album Music Only) At least one Release shall have IsMainRelease flag =
            True (Release Profile 1.4, Clause 3.3.1(1), Rule 1078-1).</s:report>
         <s:report test="count(Release[@IsMainRelease = 'true']) &gt; 1" role="Fatal Error">Fatal
            Error: #Audio Album Music Only) More than one Release with IsMainRelease has been
            specified (Release Profile 1.4, Clause 3.3.1(1), Rule 1078-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimaryResourcesMustBeSequenced">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release/*/ResourceGroup/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']]">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error: #Audio Album Music Only)
            Track bundle resource groups should be sequenced (Release Profile 1.4, Clause
            3.3.1(2)+3.3.1(3)+3.3.1(5), Rule 1079-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceGroupsMustBeSequenced">
      <s:rule
         context="//Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroup">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error: #Audio Album Music Only)
            All ResourceGroups should be sequenced (Release Profile 1.4, Clause 3.3.1(2), Rule
            1080-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimaryResourcesMustBeSequencedWithinTheirGroup">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroup">
         <s:report
            test="descendant::ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource'] and SequenceNumber &gt; '1'] and not(descendant::ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource'] and SequenceNumber = '1'])"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) All Primary Resources should be
            sequenced in the context of their track bundle ResourceGroup (i.e. the sequence restarts
            with the next track bundle) (Release Profile 1.4, Clause 3.3.1(3), Rule
            1081-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceGroupContentItemsMustBeSequenced">
      <s:rule
         context="//Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference/@ReleaseResourceType='PrimaryResource']">
         <s:assert test="SequenceNumber" role="Fatal Error">Fatal Error: #Audio Album Music Only)
            All ResourceGroupContentItems should be sequenced (Release Profile 1.4, Clause 3.3.1(3),
            Rule 1082-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SecondaryResourcesMustNotBeSequenced">
      <s:rule
         context="//ResourceGroup/ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]">
         <s:report test="SequenceNumber" role="Error">Error: #Audio Album Music Only) Secondary
            Resources (e.g. cover images) content items shall not be sequenced (Release Profile 1.4,
            Clause 3.3.1(4), Rule 1083-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimarySoundRecordingMustHaveIndirectSoundRecordingId">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'SoundRecording']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert test="//ResourceReference[text() = current()]/../IndirectSoundRecordingId"
            role="Conditional Fatal Error">Conditional Fatal Error: #Audio Album Music Only) Primary
            SoundRecording Resources shall have an IndirectSoundRecordingId (Release Profile 1.4,
            Clause 3.3.1(6), Rule 1084-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ReleaseResourceTypeMustBeProvided">
      <s:rule context="*:ResourceGroupContentItem/ReleaseResourceReference">
         <s:assert test="@ReleaseResourceType" role="Fatal Error">Fatal Error: #Audio Album Music
            Only) For each ReleaseResourceReference a ReleaseResourceType shall be provided (Release
            Profile 1.4, Clause 4.3(1)+4.3(2), Rule 1085-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainResource">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(*) &gt; 0" role="Fatal Error">Fatal Error: #Audio Album Music Only) A
            ResourceList must contain at least one Resource (Release Profile 1.4, Clause 4.3(3),
            Rule 1086-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SoundRecordingMustHaveReferenceTitle">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording">
         <s:assert
            test="count(ReferenceTitle[string-length(normalize-space(TitleText)) &gt; 0]) = 1"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) A Single ReferenceTitle must be
            provided for each SoundRecording (Release Profile 1.4, Clause 4.3(4), Rule
            1087-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SingleFormalTitlePerTerritory">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory[1]">
         <s:assert
            test="Title[@TitleType='FormalTitle'][string-length(normalize-space(TitleText)) &gt; 0]"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) At least one Title of type
            FormalTitle shall be provided for the default Worldwide ReleaseDetailsByTerritory
            section (Release Profile 1.4, Clause 4.3(4), Rule 1088-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SingleDisplayTitlePerTerritory">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory[1]">
         <s:assert
            test="Title[@TitleType='DisplayTitle'][string-length(normalize-space(TitleText)) &gt; 0]"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) At least one Title of type
            DisplayTitle shall be provided for the default Worldwide ReleaseDetailsByTerritory
            section (Release Profile 1.4, Clause 4.3(4), Rule 1089-1).</s:assert>
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
            >Error: #Audio Album Music Only) If more than one LabelName is provided, exactly one
            shall be a DisplayLabelName (Release Profile 1.4, Clause 4.3(6), Rule
            1092-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_LabelNameMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory[position() = 1 and not(LabelName[string-length(normalize-space(text())) &gt; 0])] and ReleaseDetailsByTerritory[position() &gt; 1 and not(LabelName[string-length(normalize-space(text())) &gt; 0])]"
            role="Error">Error: #Audio Album Music Only) If a LabelName is not specified for the
            Worldwide ReleaseDetailsByTerritory, it needs to be specified in all the other
            ReleaseDetailsByTerritory composites (Release Profile 1.4, Clause 4.3(6a)+4.3(6b), Rule
            1093-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_UserDefinedLabelNameType">
      <s:rule context="//LabelName[@UserDefinedValue]">
         <s:assert test="@LabelNameType='UserDefined'" role="Error">Error: #Audio Album Music Only)
            The LabelNameType shall be 'UserDefined' if a user-defined value is supplied for a
            LabelName (Release Profile 1.4, Clause 4.3(6b), Rule 1094-1).</s:assert>
         <s:assert test="@Namespace" role="Error">Error: #Audio Album Music Only) The appropriate
            Namespace for the user-defined value shall be provided (Release Profile 1.4, Clause
            4.3(6b), Rule 1094-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_GenreMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory[position = 1 and not(Genre/GenreText[string-length(normalize-space(text())) &gt; 0])] and ReleaseDetailsByTerritory[position() &gt; 1 and not(Genre/GenreText[string-length(normalize-space(text())) &gt; 0])]"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) If a Genre is not specified for
            the Worldwide ReleaseDetailsByTerritory, it needs to be specified in all the other
            ReleaseDetailsByTerritory composites. (Release Profile 1.4, Clause 4.3(7), Rule
            1095-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ParentalWarningTypeMustBeProvided">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="//ParentalWarningType[string-length(normalize-space(text())) &gt; 0]"
            role="Error">Error: #Audio Album Music Only) The appropriate ParentalWarningType shall
            be provided (Release Profile 1.4, Clause 4.3(8), Rule 1096-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ReleaseDateMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/ReleaseDate | GlobalReleaseDate"
            role="Conditional Error">Conditional Error: #Audio Album Music Only) A GlobalReleaseDate
            or a ReleaseDate shall be provided for each Release (Release Profile 1.4, Clause 4.3(9),
            Rule 1097-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceReleaseDateMustBeProvided">
      <s:rule
         context="//ResourceGroupContentItem/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../SoundRecordingDetailsByTerritory/ResourceReleaseDate | //ResourceReference[text() = current()]/../SoundRecordingDetailsByTerritory/OriginalResourceReleaseDate"
            role="Conditional Error">Conditional Error: #Audio Album Music Only) A
            ResourceReleaseDate or an OriginalResourceReleaseDate shall be provided for each primary
            Resource if available to the Message Sender (Release Profile 1.4, Clause 4.3(10), Rule
            1098-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MusicalWorkContributorRole">
      <s:rule context="//MusicalWork">
         <s:assert
            test="MusicalWorkContributor/MusicalWorkContributorRole[text() = 'Adapter' or text() = 'Arranger' or text() = 'AssociatedPerformer' or text() = 'Author' or text() = 'Composer' or text() = 'ComposerLyricist' or text() = 'Librettist' or text() = 'Lyricist' or text() = 'NonLyricAuthor' or text() = 'SubArranger' or text() = 'Translator']"
            role="Conditional Error">Conditional Error: #Audio Album Music Only) If there is a
            MusicalWork, there has to be a creative contributor (Release Profile 1.4, Clause
            4.3(12a), Rule 1099-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ShouldContainIndirectResourceContributor">
      <s:rule
         context="*:NewReleaseMessage/ResourceList/SoundRecording/SoundRecordingDetailsByTerritory">
         <s:assert test="IndirectResourceContributor" role="Conditional Error">Conditional Error:
            #Audio Album Music Only) No MusicalWorkContributor was found; information of at least
            one MusicalWorkContributor should be provided if available (Release Profile 1.4, Clause
            4.3(12a), Rule 1100-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ResourceContributorDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList/*/*">
         <s:assert
            test="count(ResourceContributor)=count(ResourceContributor[not(PartyId=preceding-sibling::ResourceContributor/PartyId)])"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) ResourceContributors shall be
            provided only once (with multiple roles) (Release Profile 1.4, Clause 4.3(13)+4.3(20),
            Rule 1101-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistNameDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:report test="*/*/DisplayArtistName" role="Error">Error: #Audio Album Music Only) The
            DisplayArtistNames of a Resource shall not be the same as the DisplayArtistName of the
            Album it belongs to (Release Profile 1.4, Clause 4.3(18), Rule 1102-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_IndirectResourceContributorDuplicate">
      <s:rule context="*:NewReleaseMessage/ResourceList/*/*">
         <s:assert
            test="count(IndirectResourceContributor)=count(IndirectResourceContributor[not(PartyId=preceding-sibling::IndirectResourceContributor/PartyId)])"
            role="Conditional Fatal Error">Conditional Fatal Error: #Audio Album Music Only)
            IndirectResourceContributors shall be provided only once (with multiple roles) (Release
            Profile 1.4, Clause 4.3(21), Rule 1103-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_RightSharePercentage">
      <s:rule context="//MusicalWork">
         <s:report test="sum(//RightShare/RightSharePercentage) &gt; 100" role="Fatal Error">Fatal
            Error: #Audio Album Music Only) The total of all RightSharePercentages for each
            MusicalWork must not exceed 100% (Release Profile 1.4, Clause 4.3(22), Rule
            1104-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_RightSharePercentageValue">
      <s:rule context="//RightSharePercentage">
         <s:assert test="//RightSharePercentage &gt; 0 and //RightSharePercentage &lt; 100"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) A RightSharePercentage has a
            value between 0 and 100 (Release Profile 1.4, Clause 4.3(22), Rule 1105-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_CatalogTransfer">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="CatalogTransfer" role="Conditional Fatal Error">Conditional Fatal Error:
            #Audio Album Music Only) The CatalogTransfer element has been used. This is only to be
            used when communicating a catalogue transfer (Release Profile 1.4, Clause 4.3(23), Rule
            1106-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_FlagsOnlyOnContentItems">
      <s:rule context="*:NewReleaseMessage">
         <s:report
            test="SoundRecording/IsHiddenResource | MIDI/IsHiddenResource | Video/IsHiddenResource"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) IsHiddenResource must not be
            used on a Resource (Release Profile 1.4, Clause 4.3(24)+4.10(7g)+4.10(7h), Rule
            1107-1).</s:report>
         <s:report
            test="SoundRecording/IsBonusResource | MIDI/IsBonusResource | Video/IsBonusResource"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) IsBonusResource must not be
            used on a Resource (Release Profile 1.4, Clause 4.3(24)+4.10(7g)+4.10(7h), Rule
            1107-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_Territory">
      <s:rule context="//TerritoryCode | //ExcludedTerritoryCode">
         <s:report
            test="(substring(@IdentifierType, 1, 3) = 'ISO' or not(@IdentifierType)) and string-length(normalize-space(text())) != 2 and text() != 'Worldwide' and translate(text(), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '') != ''"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) A TerritoryCode of type 'ISO'
            must be a two-letter code or 'Worldwide' (Release Profile 1.4, Clause 4.3(25), Rule
            1108-1).</s:report>
         <s:report test="substring(@IdentifierType, 1, 3) = 'TIS' and number() != ."
            role="Fatal Error">Fatal Error: #Audio Album Music Only) A TerritoryCode of type 'TIS'
            must be a numeric code (Release Profile 1.4, Clause 4.3(25), Rule 1108-2).</s:report>
         <s:report
            test="substring(@IdentifierType, 1, 3) = 'Dep' and (string-length(normalize-space(text())) != 4 or number() = .)"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) A deprecated TerritoryCode must
            be a four-letter code (Release Profile 1.4, Clause 4.3(25), Rule 1108-3).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_TerritoryTIS">
      <s:rule context="//TerritoryCode | //ExcludedTerritoryCode">
         <s:report test="substring(@IdentifierType, 1, 3) = 'TIS'" role="Fatal Error">Fatal Error:
            #Audio Album Music Only) A TerritoryCode of type 'TIS' must not be used (Release Profile
            1.4, Clause 4.3(25), Rule 1109-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISNI">
      <s:rule context="//PartyId[@IsISNI = 'true']">
         <s:assert test="matches(., '^[0-9]{15}[X0-9]$')" role="Fatal Error">Fatal Error: #Audio
            Album Music Only) A PartyId of type 'ISNI' must be a string conforming to the pattern
            [0-9]{15}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 1110-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISRC">
      <s:rule context="//ISRC">
         <s:assert test="matches(., '^[a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7}$')" role="Fatal Error">Fatal
            Error: #Audio Album Music Only) An ISRC must be a string conforming to the pattern
            [a-zA-Z]{2}[a-zA-Z0-9]{3}[0-9]{7} (Release Profile 1.4, Clause 4.3(30), Rule
            1111-1).</s:assert>
         <s:assert
            test="matches(substring(.,1,2), '(FX|QM|UK|CP|DG|ZZ|AD|AE|AF|AG|AI|AL|AM|AN|AO|AQ|AR|AS|AT|AU|AW|AX|AZ|BA|BB|BD|BE|BF|BG|BH|BI|BJ|BL|BM|BN|BO|BQ|BR|BS|BT|BV|BW|BY|BZ|CA|CC|CD|CF|CG|CH|CI|CK|CL|CM|CN|CO|CR|CS|CU|CV|CW|CX|CY|CZ|DE|DJ|DK|DM|DO|DZ|EC|EE|EG|EH|ER|ES|ET|FI|FJ|FK|FM|FO|FR|GA|GB|GD|GE|GF|GG|GH|GI|GL|GM|GN|GP|GQ|GR|GS|GT|GU|GW|GY|HK|HM|HN|HR|HT|HU|ID|IE|IL|IM|IN|IO|IQ|IR|IS|IT|JE|JM|JO|JP|KE|KG|KH|KI|KM|KN|KP|KR|KW|KY|KZ|LA|LB|LC|LI|LK|LR|LS|LT|LU|LV|LY|MA|MC|MD|ME|MF|MG|MH|MK|ML|MM|MN|MO|MP|MQ|MR|MS|MT|MU|MV|MW|MX|MY|MZ|NA|NC|NE|NF|NG|NI|NL|NO|NP|NR|NU|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PM|PN|PR|PS|PT|PW|PY|QA|RE|RO|RS|RU|RW|SA|SB|SC|SD|SE|SG|SH|SI|SJ|SK|SL|SM|SN|SO|SR|SS|ST|SV|SX|SY|SZ|TC|TD|TF|TG|TH|TJ|TK|TL|TM|TN|TO|TR|TT|TV|TW|TZ|UA|UG|UM|US|UY|UZ|VA|VC|VE|VG|VI|VN|VU|WF|WS|YE|YT|ZA|ZM|ZW)')"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) An ISRC must be a string
            starting with an ISO 3166 code or FX, QM, UK, CP, DG or ZZ (Release Profile 1.4, Clause
            4.3(30), Rule 1111-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_GRid">
      <s:rule context="//GRid">
         <s:assert test="matches(., '^[a-zA-Z0-9]{18}$')" role="Fatal Error">Fatal Error: #Audio
            Album Music Only) A GRid must be a string conforming to the pattern [a-zA-Z0-9]{18}
            (Release Profile 1.4, Clause 4.3(30), Rule 1112-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SICI">
      <s:rule context="//SICI">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9].+')" role="Fatal Error">Fatal Error:
            #Audio Album Music Only) A SICI must be a string conforming to the pattern
            [0-9]{4}-[0-9]{3}[X0-9].+ (Release Profile 1.4, Clause 4.3(30), Rule 1113-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISSN">
      <s:rule context="//ISSN">
         <s:assert test="matches(., '^[0-9]{4}-[0-9]{3}[X0-9]$')" role="Fatal Error">Fatal Error:
            #Audio Album Music Only) An ISSN must be a string conforming to the pattern
            [0-9]{4}-[0-9]{3}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 1114-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISBN">
      <s:rule context="//ISBN">
         <s:assert test="matches(., '^97[8-9][0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error:
            #Audio Album Music Only) An ISBN must be a string conforming to the pattern
            97[8-9][0-9]{9}[X0-9] (Release Profile 1.4, Clause 4.3(30), Rule 1115-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_VISAN">
      <s:rule context="//VISAN">
         <s:assert test="matches(., '^[A-F0-9]{24}$')" role="Fatal Error">Fatal Error: #Audio Album
            Music Only) A VISAN must be a string conforming to the pattern [A-F0-9]{24} (Release
            Profile 1.4, Clause 4.3(30), Rule 1116-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISAN">
      <s:rule context="//ISAN">
         <s:assert test="matches(., '^[A-F0-9]{12}$')" role="Fatal Error">Fatal Error: #Audio Album
            Music Only) An ISAN must be a string conforming to the pattern [A-F0-9]{12} (Release
            Profile 1.4, Clause 4.3(30), Rule 1117-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISMN">
      <s:rule context="//ISMN">
         <s:assert test="matches(., '^979[0-9]{9}[X0-9]$')" role="Fatal Error">Fatal Error: #Audio
            Album Music Only) An ISMN must be a string conforming to the pattern 979[0-9]{9}[X0-9]
            (Release Profile 1.4, Clause 4.3(30), Rule 1118-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ISWC">
      <s:rule context="//ISWC">
         <s:assert test="matches(., '^[a-zA-Z][0-9]{10}$')" role="Fatal Error">Fatal Error: #Audio
            Album Music Only) An ISWC must be a string conforming to the pattern [a-zA-Z][0-9]{10}
            (Release Profile 1.4, Clause 4.3(30), Rule 1119-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_ICPN">
      <s:rule context="//ICPN">
         <s:assert test="matches(., '^[0-9]{8}$|^[0-9]{12,14}$')" role="Fatal Error">Fatal Error:
            #Audio Album Music Only) An ICPN must be a string conforming to the pattern [0-9]{8} or
            [0-9]{12,14} (Release Profile 1.4, Clause 4.3(30), Rule 1120-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_UserDefinedValue">
      <s:rule context="//*[(name() != 'LabelName') and @UserDefinedValue]">
         <s:assert test=".='UserDefined'" role="Fatal Error">Fatal Error: #Audio Album Music Only)
            The value shall be 'UserDefined' if a user-defined value is supplied (Release Profile
            1.4, Clause 4.3(31), Rule 1121-1).</s:assert>
         <s:assert test="@Namespace" role="Fatal Error">Fatal Error: #Audio Album Music Only) The
            appropriate Namespace for the user-defined value shall be provided (Release Profile 1.4,
            Clause 4.3(31), Rule 1121-2).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_CommentMustNotBeProvided">
      <s:rule context="*:NewReleaseMessage">
         <s:report test="//Comment" role="Error">Error: #Audio Album Music Only) No Comment shall be
            provided (Release Profile 1.4, Clause 4.3(32), Rule 1122-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistsMustBeSequenced">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release/ReleaseDetailsByTerritory/DisplayArtist">
         <s:assert test="@SequenceNumber" role="Fatal Error">Fatal Error: #Audio Album Music Only)
            All DisplayArtists should be sequenced (Release Profile 1.4, Clause 4.3(34), Rule
            1123-1).</s:assert>
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
            role="Fatal Error">Fatal Error: #Audio Album Music Only) SequenceNumbers must run from 1
            to the number of sequenced elements (Release Profile 1.4, Clause 4.3(35), Rule
            1125-1).</s:assert>
         <s:report
            test="@SequenceNumber=following-sibling::*[name()=name(current())]/@SequenceNumber"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) SequenceNumbers must all be
            different (Release Profile 1.4, Clause 4.3(35), Rule 1125-2).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PercentageValue">
      <s:rule context="//*[@HasMaxValueOfOne = 'true']">
         <s:report test="number(.) &gt; 1" role="Fatal Error">Fatal Error: #Audio Album Music Only)
            A Percentage with HasMaxValueOfOne set to true has a value between 0 and 1 (Release
            Profile 1.4, Clause 4.3(36a), Rule 1126-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PercentageValue2">
      <s:rule context="//*[@HasMaxValueOfOne = 'false']">
         <s:report test="number(.) &lt;= 1" role="Information">Information: #Audio Album Music Only)
            Percentages are typically provided in the interval between 0 and 100. The value provided
            seems to indicate a value equal to, or less than, 1% (Release Profile 1.4, Clause
            4.3(36b), Rule 1127-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_RightSharePercentageValue2">
      <s:rule context="//RightSharePercentage[not(@HasMaxValueOfOne)]">
         <s:report test="number(.) &lt;= 1" role="Information">Information: #Audio Album Music Only)
            Percentages are typically provided in the interval between 0 and 100. The value provided
            seems to indicate a value equal to, or less than, 1% (Release Profile 1.4, Clause
            4.3(36b), Rule 1128-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="AudioAlbum_ReleaseProfileVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/AudioAlbum'"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) The ReleaseProfileVersionId
            should be 'CommonReleaseTypes/14/AudioAlbum' (Release Profile 1.4, Clause 3.2, Rule
            1129-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainTrackRelease">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert test="Release/ReleaseType[text() = 'TrackRelease']" role="Fatal Error">Fatal
            Error: #Audio Album Music Only) A Release of this type must contain at least one
            TrackRelease (Release Profile 1.4, Clause 3.1, Rule 1130-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainMultipleReleases">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert
            test="count(Release) =count(Release[@IsMainRelease = 'true']/ReleaseResourceReferenceList/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource'])+1"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) A Release of this type must
            contain multiple releases (a Single and a TrackRelease for every resource marked as
            primary) (Release Profile 1.4, Clause 3.1, Rule 1131-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="AudioAlbum_MustContainMultipleSoundRecordings">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(SoundRecording) &gt; 1" role="Fatal Error">Fatal Error: #Audio Album
            Music Only) An Audio Album must contain more than one SoundRecording (Release Profile
            1.4, Clause 3.1, Rule 1132-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainOneImage">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(Image) = 1" role="Fatal Error">Fatal Error: #Audio Album Music Only)
            A Release of this type must contain one (and only one) Image (Release Profile 1.4,
            Clause 3.1, Rule 1133-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainMusicalWorkSoundRecording">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="SoundRecording/SoundRecordingType[text() = 'MusicalWorkSoundRecording']"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) A Release of this type must
            contain one SoundRecording of type MusicalWorkSoundRecording (Release Profile 1.4,
            Clause 3.1, Rule 1134-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainOneFrontCoverImageAsSecondaryResource">
      <s:rule
         context="//Release[@IsMainRelease = 'true']/ReleaseDetailsByTerritory/ResourceGroup/ResourceGroupContentItem">
         <s:assert
            test="count(//ResourceList/Image[ImageType/text() = 'FrontCoverImage' and ResourceReference=current()/ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']]) = 1"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) A Release of this type must
            contain exactly one Image of type FrontCoverImage as a secondary Resource (Release
            Profile 1.4, Clause 3.1, Rule 1135-1NR).</s:assert>
      </s:rule>
   </s:pattern>


   <s:pattern id="MultiProfile_MustContainOneSoundRecording">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="SoundRecording" role="Fatal Error">Fatal Error: #Audio Album Music Only) An
            Audio Single must contain at least one SoundRecording (Release Profile 1.4, Clause 3.1,
            Rule 1136-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MustContainTwoReleases">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert test="count(Release) &gt;= 2" role="Fatal Error">Fatal Error: #Audio Album Music
            Only) A Release of this type must contain at least two releases. (Release Profile 1.4,
            Clause 3.1, Rule 1137-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_TrackReleaseMustNotContainManyResources">
      <s:rule
         context="*:NewReleaseMessage/ReleaseList/Release[ReleaseType[text() = 'TrackRelease']]/ReleaseResourceReferenceList">
         <s:report test="count(ReleaseResourceReference) &gt; 1" role="Fatal Error">Fatal Error:
            #Audio Album Music Only) A Track Release must not contain more than one Resource
            (Release Profile 1.4, Clause 3.1, Rule 1138-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/DisplayArtist" role="Fatal Error">Fatal Error:
            #Audio Album Music Only) At least one DisplayArtist shall be provided (Release Profile
            1.4, Clause 4.3(12c)+4.3(15b), Rule 1139-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistNamesMustBeDifferent">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory/DisplayArtistName = ReleaseResourceReferenceList/descendant::DisplayArtistName"
            role="Error">Error: #Audio Album Music Only) DisplayArtistNames for Release and Resource
            must be different (Release Profile 1.4, Clause 4.3(16a), Rule 1140-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="AudioAlbum_MainReleaseMustBeAlbum">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release[@IsMainRelease = 'true']">
         <s:assert test="ReleaseType = 'Album'" role="Fatal Error">Fatal Error: #Audio Album Music
            Only) The MainRelease must have a ReleaseType of Album (Release Profile 1.4, Clause
            4.4(3), Rule 1141-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MainReleaseMustHaveGridOrICPN">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert
            test="Release[@IsMainRelease = 'true']/ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | Release[@IsMainRelease = 'true']/ReleaseId/ICPN[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) The MainRelease shall be
            identified by either a GRid or by an ICPN (Release Profile 1.4, Clause 4.4(4), Rule
            1142-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimarySoundRecordingMustHaveISRC">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'SoundRecording']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ISRC[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) Primary SoundRecording
            Resources shall be identified with an ISRC (Release Profile 1.4, Clause 4.4(5), Rule
            1143-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SecondaryResourceMustHaveProprietaryId">
      <s:rule
         context="//ResourceGroupContentItem/ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ProprietaryId[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Audio Album Music Only) Secondary Resources shall be
            identified by a ProprietaryId (Release Profile 1.4, Clause 4.4(6), Rule
            1144-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_LabelNameMustBeProvided2">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/LabelName" role="Fatal Error">Fatal Error: #Audio
            Album Music Only) A LabelName has to be specified for each Release (Release Profile 1.4,
            Clause 4.4(8), Rule 1145-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_LabelNameMustBeProvided3">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/LabelName" role="Fatal Error">Fatal Error: #Audio
            Album Music Only) A LabelName has to be specified for each Release (Release Profile 1.4,
            Clause 4.10(8), Rule 1146-1).</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
