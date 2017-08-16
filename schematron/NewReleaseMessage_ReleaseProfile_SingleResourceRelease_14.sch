<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <!--
          This Schematron rule set requires XPath2. 
          This can be enforced by, for instance, adding an attribute into the above s:schema tag 
          (queryBinding="xslt2") or by instructing the processor for running the Schematron
          rule to use XPath2 in any other way.
                    -->
   <s:title>Schematron Release Profile for Single Resource Release (version 1.4) for the
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
      that has already been issued. However, if more than 2 rules (representing 50% of all rules
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

   <s:pattern id="SingleResourceRelease_ReleaseProfileVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="@ReleaseProfileVersionId = 'CommonReleaseTypes/14/SingleResourceRelease'"
            role="Fatal Error">Fatal Error: #Single Resource Release) The ReleaseProfileVersionId
            should be 'CommonReleaseTypes/14/SingleResourceRelease' (Release Profile 1.4, Clause
            3.2, Rule 1463-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimaryVideoMustHaveISRC">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'Video']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ISRC[string-length(normalize-space(text())) &gt; 0]"
            role="Error">Error: #Single Resource Release) Primary Video Resources should be
            identified with an ISRC (Release Profile 1.4, Clause 3.1, Rule 1464-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustContainOneResource">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="count(descendant::ResourceReference) = 1" role="Fatal Error">Fatal Error:
            #Single Resource Release) A Single Resource Release must contain one (and only one)
            Resource (Release Profile 1.4, Clause 3.1, Rule 1465-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustContainSingleResourceRelease">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert test="Release/ReleaseType[text() = 'SingleResourceRelease']" role="Fatal Error"
            >Fatal Error: #Single Resource Release) A Single Resource Release must contain one
            SingleResourceRelease release (Release Profile 1.4, Clause 3.1, Rule
            1466-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustNotContainReleaseResourceStructure">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="not(descendant::ResourceGroup)" role="Fatal Error">Fatal Error: #Single
            Resource Release) A Single Resource Release must not contain a release resource
            structure (Release Profile 1.4, Clause 3.1, Rule 1467-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustNotContainSecondaryResource">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert
            test="not(descendant::ResourceGroupContentItem[ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']])"
            role="Fatal Error">Fatal Error: #Single Resource Release) A Single Resource Release must
            not contain any Secondary Resources (Release Profile 1.4, Clause 3.1, Rule
            1468-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistMustBeProvided">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/DisplayArtist" role="Fatal Error">Fatal Error:
            #Single Resource Release) At least one DisplayArtist shall be provided (Release Profile
            1.4, Clause 4.3(12c)+4.3(15b), Rule 1469-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_DisplayArtistNamesMustBeDifferent">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report
            test="ReleaseDetailsByTerritory/DisplayArtistName = ReleaseResourceReferenceList/descendant::DisplayArtistName"
            role="Error">Error: #Single Resource Release) DisplayArtistNames for Release and
            Resource must be different (Release Profile 1.4, Clause 4.3(16a), Rule
            1470-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_MainReleaseMustHaveGridOrICPN">
      <s:rule context="*:NewReleaseMessage/ReleaseList">
         <s:assert
            test="Release[@IsMainRelease = 'true']/ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | Release[@IsMainRelease = 'true']/ReleaseId/ICPN[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Single Resource Release) The MainRelease shall be
            identified by either a GRid or by an ICPN (Release Profile 1.4, Clause 4.12(4), Rule
            1471-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_PrimarySoundRecordingMustHaveISRC">
      <s:rule
         context="//ResourceGroupContentItem[ResourceType = 'SoundRecording']/ReleaseResourceReference[@ReleaseResourceType = 'PrimaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ISRC[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Single Resource Release) Primary SoundRecording
            Resources shall be identified with an ISRC (Release Profile 1.4, Clause 4.12(5), Rule
            1472-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_SecondaryResourceMustHaveProprietaryId">
      <s:rule
         context="//ResourceGroupContentItem/ReleaseResourceReference[@ReleaseResourceType = 'SecondaryResource']">
         <s:assert
            test="//ResourceReference[text() = current()]/../*/ProprietaryId[string-length(normalize-space(text())) &gt; 0]"
            role="Fatal Error">Fatal Error: #Single Resource Release) Secondary Resources shall be
            identified by a ProprietaryId (Release Profile 1.4, Clause 4.12(6), Rule
            1473-1).</s:assert>
      </s:rule>
   </s:pattern>

   <s:pattern id="SingleResourceRelease_MustNotContainResourceGroup">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:report test="ResourceGroup" role="Fatal Error">Fatal Error: #Single Resource Release) A
            Single Resource Release must not contain any Resource Group (Release Profile 1.4,
            Clause 4.12(7), Rule 1474-1).</s:report>
      </s:rule>
   </s:pattern>

   <s:pattern id="MultiProfile_LabelNameMustBeProvided2">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="ReleaseDetailsByTerritory/LabelName" role="Fatal Error">Fatal Error:
            #Single Resource Release) A LabelName has to be specified for each Release (Release
            Profile 1.4, Clause 4.12(8), Rule 1475-1).</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
