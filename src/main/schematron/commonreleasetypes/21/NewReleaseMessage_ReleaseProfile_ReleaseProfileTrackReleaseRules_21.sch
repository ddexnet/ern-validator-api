<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron"
          xmlns:xs="http://www.w3.org/2001/XMLSchema"
          queryBinding="xslt2">
                    <!--
          This Schematron rule set requires XPath2. 
		  This is enabled by the queryBinding=“xslt2” attribute in the root tag. Users may be required 
		  to instruct the processor used to running the Schematron rule to use XPath2 in another way.
                    -->
                    <s:title>Schematron Release Profile for Release Profile Track Release Rules (version 2.1) for the NewReleaseMessage.</s:title>
   <s:p>© 2006-2018 Digital Data Exchange, LLC (DDEX)</s:p>
   <s:p>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If you wish to evaluate whether the standard meets your needs please have a look at the Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards. If you want to implement and use this DDEX standard, please take out an Implementation Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</s:p>
   <s:p>Failing a rule with a role of 'Fatal Error' means that the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Fatal Error' is the same as a 'Fatal Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>Failing a rule a rule with a role of 'Error' means that the Conformance Tester must recommend to award a Partial Conformance Certificate or to downgrade a Conformance Certificate that has already been issued. However, if more than 1 rules (representing 50% of all rules with a role of 'Error') have been failed at least once, the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error' is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:pattern id="MultiProfile_MustContainOneTrackReleasePerPrimaryResource">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[not(@IsSupplemental = 'true')] | *:NewReleaseMessage/ResourceList/Video[not(@IsSupplemental = 'true')]">
         <s:assert test="count(//TrackRelease[ReleaseResourceReference = current()/ResourceReference]) = 1"
                   role="Fatal Error">Fatal Error (Release Profile Track Release Rules): A Release of this type must contain exactly one TrackRelease for each Primary Resource referenced in the Main Release (Release Profile 2.1, Clause 5.1.1(b), Rule 1538-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TrackReleaseMustNotHaveISRC">
      <s:rule context="*:NewReleaseMessage/ReleaseList/TrackRelease">
         <s:report test="ReleaseId/ISRC" role="Fatal Error">Fatal Error (Release Profile Track Release Rules): An ISRC as an identifier for a TrackRelease shall be communicated as a ProprietaryId (Release Profile 2.1, Clause 5.3.1.3(3), Rule 1539-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TrackReleaseMustHaveOnePrimaryResource">
      <s:rule context="*:NewReleaseMessage/ReleaseList/TrackRelease">
         <s:assert test="count(ReleaseResourceReference) = 1" role="Fatal Error">Fatal Error (Release Profile Track Release Rules): A TrackRelease must refer to one Primary Resource (Release Profile 2.1, Clause 5.6(2a), Rule 1540-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TrackReleaseMustNotHaveSecondaryResources">
      <s:rule context="*:NewReleaseMessage/ResourceList/SoundRecording[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Video[@IsSupplemental = 'true'] | *:NewReleaseMessage/ResourceList/Image | *:NewReleaseMessage/ResourceList/Text | *:NewReleaseMessage/ResourceList/SheetMusic | *:NewReleaseMessage/ResourceList/Software">
         <s:report test="ResourceReference[text() = //TrackRelease/ReleaseResourceReference]"
                   role="Fatal Error">Fatal Error (Release Profile Track Release Rules): A TrackRelease must not refer to a Secondary Resource (Release Profile 2.1, Clause 5.6(2b), Rule 1541-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="MultiProfile_TrackReleaseMustNotHaveRedundantTitles">
      <s:rule context="*:NewReleaseMessage/ReleaseList/TrackRelease">
         <s:report test="DisplayTitle = //ResourceList/*[ResourceReference = current()/ReleaseResourceReference]/DisplayTitle"
                   role="Error">Error (Release Profile Track Release Rules): Title information for TrackReleases shall only be provided if it differs from the title information provided on the Resource (Release Profile 2.1, Clause 5.6(4), Rule 1542-1).</s:report>
         <s:report test="DisplayTitleText = //ResourceList/*[ResourceReference = current()/ReleaseResourceReference]/DisplayTitleText"
                   role="Error">Error (Release Profile Track Release Rules): Title information for TrackReleases shall only be provided if it differs from the title information provided on the Resource (Release Profile 2.1, Clause 5.6(4), Rule 1542-2).</s:report>
         <s:report test="AdditionalTitle = //ResourceList/*[ResourceReference = current()/ReleaseResourceReference]/AdditionalTitle"
                   role="Error">Error (Release Profile Track Release Rules): Title information for TrackReleases shall only be provided if it differs from the title information provided on the Resource (Release Profile 2.1, Clause 5.6(4), Rule 1542-3).</s:report>
      </s:rule>
   </s:pattern>
</s:schema>
