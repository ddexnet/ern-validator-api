<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron"
          xmlns:xs="http://www.w3.org/2001/XMLSchema"
          queryBinding="xslt2">
                    <!--
          This Schematron rule set requires XPath2. 
		  This is enabled by the queryBinding=“xslt2” attribute in the root tag. Users may be required 
		  to instruct the processor used to running the Schematron rule to use XPath2 in another way.
                    -->
                    <s:title>Schematron Release Profile for Classical Variant (version 2.1) for the NewReleaseMessage.</s:title>
   <s:p>© 2006-2018 Digital Data Exchange, LLC (DDEX)</s:p>
   <s:p>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If you wish to evaluate whether the standard meets your needs please have a look at the Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards. If you want to implement and use this DDEX standard, please take out an Implementation Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</s:p>
   <s:p>Failing a rule with a role of 'Fatal Error' means that the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Fatal Error' is the same as a 'Fatal Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>Failing a rule a rule with a role of 'Error' means that the Conformance Tester must recommend to award a Partial Conformance Certificate or to downgrade a Conformance Certificate that has already been issued. However, if more than 1 rules (representing 50% of all rules with a role of 'Error') have been failed at least once, the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error' is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>The following Clauses from the Release Profile standard are NOT checked by this ISO Schematron file: 5.1.1 (partly), 5.3.1.1(1-3, 7.1, 7.3, 9), 5.3.1.2(2.1, 3-4, 5.1), 5.3.1.3(4-5), 5.3.1.4(3-5, 8), 5.3.3.1-2, 5.3.3.4, 5.4.1(4.1), 5.4.3(5), 5.4.4(3, 5), 5.5.1(2), 5.5.2(2.4, 3.5-3.7), 5.6(1, 3). This file also does not check any rules specified in the ERN Message Suite Standard (Version 4.1) specifications, sections 6.4 and 6.5, except for 6.4.8-10</s:p>
   <s:pattern id="Classical_ReleaseProfileVariantVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="@ReleaseProfileVariantVersionId = 'Classical' or @ReleaseProfileVariantVersionId = 'BoxedSet Classical' or @ReleaseProfileVariantVersionId = 'Classical BoxedSet'"
                   role="Fatal Error">Fatal Error (Classical Variant): The ReleaseProfileVariantVersionId should conform to clause 5.2.2 (Release Profile 2.1, Clause 5.2.2, Rule 1547-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Classical_ResourceGroupType">
      <s:rule context="*:NewReleaseMessage[@ReleaseProfileVariantVersionId = 'Classical']/ReleaseList/Release/ResourceGroup/ResourceGroup">
         <s:assert test="@ResourceGroupType = 'Component' or @ResourceGroupType = 'Side' or @ResourceGroupType = 'MultiWorkPart'"
                   role="Fatal Error">Fatal Error (Classical Variant): For a Release of this type, second-level ResourceGroups shall have a ResourceGroupType of either Side, Component or MultiWorkPart (Release Profile 2.1, Clause 5.3.1.2(5.2), Rule 1548-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Classical_MustContainMusicalWorkSoundRecording">
      <s:rule context="*:NewReleaseMessage/ResourceList">
         <s:assert test="SoundRecording/Type[text() = 'MusicalWorkSoundRecording']"
                   role="Fatal Error">Fatal Error (Classical Variant): A Release of this type must contain SoundRecordings of type MusicalWorkSoundRecording (Release Profile 2.1, Clause 5.5.2(1), Rule 1549-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Classical_MustContainResourceGroup">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="descendant::ResourceGroup[@ResourceGroupType='MultiWorkPart']"
                   role="Fatal Error">Fatal Error (Classical Variant): A Release of this type must contain at least one ResourceGroup of type MultiWorkPart (Release Profile 2.1, Clause 5.5.2(2.1), Rule 1550-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Classical_MustContainResourceGroupContentItems">
      <s:rule context="//ResourceGroup[@ResourceGroupType='MultiWorkPart']">
         <s:assert test="count(ResourceGroupContentItem) &gt; 1"
                   role="Conditional Fatal Error">Conditional Fatal Error (Classical Variant): A Release of this type must contain at least two ResourceGroupContentItems in each ResourceGroup of type MultiWorkPart (Release Profile 2.1, Clause 5.5.2(2.2), Rule 1551-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Classical_ResourceGroupsMustBeNested">
      <s:rule context="//ResourceGroup">
         <s:report test="ResourceGroup[@ResourceGroupType='MultiWorkPart'] and ResourceGroup[@ResourceGroupType!='MultiWorkPart']"
                   role="Fatal Error">Fatal Error (Classical Variant):  (Release Profile 2.1, Clause 5.5.2(2.5), Rule 1552-1).</s:report>
      </s:rule>
   </s:pattern>
   <s:pattern id="Classical_MustContainFormalTitle">
      <s:rule context="*:NewReleaseMessage/ResourceList/*[ResourceReference = //ResourceGroup[ResourceGroupType='MultiWorkPart']/ResourceGroupContentItem/ReleaseResourceReference]">
         <s:assert test="AdditionalTitle[@TitleType='FormalTitle']" role="Warning">Warning (Classical Variant): A Resource in a Release of this type must contain an AdditionalTitle of type FormalTitle (Release Profile 2.1, Clause 5.5.2(3.1), Rule 1553-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Classical_MayContainGroupingTitle">
      <s:rule context="*:NewReleaseMessage/ResourceList/*[ResourceReference = //ResourceGroup[ResourceGroupType='MultiWorkPart']/ResourceGroupContentItem/ReleaseResourceReference]">
         <s:assert test="AdditionalTitle[@TitleType='GroupingTitle']" role="Warning">Warning (Classical Variant): A Resource in a Release of this type may contain an AdditionalTitle of type GroupingTitle (Release Profile 2.1, Clause 5.5.2(3.2), Rule 1554-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Classical_MustContainDisplayTitle">
      <s:rule context="//ResourceGroup[ResourceGroupType='MultiWorkPart' and count(ResourceGroupContentItem) &gt; 1]">
         <s:assert test="DisplayTitle or DisplayTitleText" role="Fatal Error">Fatal Error (Classical Variant): A ResourceGroup in a Release of this type must contain a DisplayTitle and/or a DisplayTitleText (Release Profile 2.1, Clause 5.5.2(3.3), Rule 1555-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="Classical_MayContainFormalTitle">
      <s:rule context="//ResourceGroup[ResourceGroupType='MultiWorkPart' and count(ResourceGroupContentItem) &gt; 1]">
         <s:assert test="AdditionalTitle[@TitleType='FormalTitle']" role="Warning">Warning (Classical Variant): A ResourceGroup in a Release of this type shall contain an AdditionalTitle of type FormalTitle (Release Profile 2.1, Clause 5.5.2(3.4), Rule 1556-1).</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
