<?xml version="1.0" encoding="UTF-8"?>
<s:schema xmlns:s="http://purl.oclc.org/dsdl/schematron"
          xmlns:xs="http://www.w3.org/2001/XMLSchema"
          queryBinding="xslt2">
                    <!--
          This Schematron rule set requires XPath2. 
		  This is enabled by the queryBinding=“xslt2” attribute in the root tag. Users may be required 
		  to instruct the processor used to running the Schematron rule to use XPath2 in another way.
                    -->
                    <s:title>Schematron Release Profile for Boxed Set Variant (version 2.1) for the NewReleaseMessage.</s:title>
   <s:p>© 2006-2018 Digital Data Exchange, LLC (DDEX)</s:p>
   <s:p>This ISO Schematron file is, together with all DDEX standards, subject to two licences: If you wish to evaluate whether the standard meets your needs please have a look at the Evaluation Licence at https://kb.ddex.net/display/HBK/Evaluation+Licence+for+DDEX+Standards. If you want to implement and use this DDEX standard, please take out an Implementation Licence. For details please go to http://ddex.net/apply-ddex-implementation-licence.</s:p>
   <s:p>Failing a rule with a role of 'Fatal Error' means that the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Fatal Error' is the same as a 'Fatal Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>Failing a rule a rule with a role of 'Error' means that the Conformance Tester must recommend to award a Partial Conformance Certificate or to downgrade a Conformance Certificate that has already been issued. However, if more than 1 rules (representing 50% of all rules with a role of 'Error') have been failed at least once, the Conformance Tester must recommend to not award a Conformance Certificate or to retract a Conformance Certificate if one has already been issued. Failing a rule with a role of 'Conditional Error' is the same as an 'Error', however, the rule may be ignored if the Conformance Tester has no means of asserting whether the condition expressed in the rule has been met.</s:p>
   <s:p>The following Clauses from the Release Profile standard are NOT checked by this ISO Schematron file: 5.1.1 (partly), 5.3.1.1(1-3, 7.1, 7.3, 9), 5.3.1.2(2.1, 3-4, 5.1), 5.3.1.3(4-5), 5.3.1.4(3-5, 8), 5.3.3.1-2, 5.3.3.4, 5.4.1(4.1), 5.4.3(5), 5.4.4(3, 5), 5.5.1(2), 5.5.2(2.4, 3.5-3.7), 5.6(1, 3). This file also does not check any rules specified in the ERN Message Suite Standard (Version 4.1) specifications, sections 6.4 and 6.5, except for 6.4.8-10</s:p>
   <s:pattern id="BoxedSet_ReleaseProfileVariantVersionId">
      <s:rule context="*:NewReleaseMessage">
         <s:assert test="@ReleaseProfileVariantVersionId = 'BoxedSet' or @ReleaseProfileVariantVersionId = 'BoxedSet Classical' or @ReleaseProfileVariantVersionId = 'Classical BoxedSet'"
                   role="Fatal Error">Fatal Error (Boxed Set Variant): The ReleaseProfileVariantVersionId should conform to clause 5.2.2 (Release Profile 2.1, Clause 5.2.2, Rule 1543-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="BoxedSet_ResourceGroupType">
      <s:rule context="*:NewReleaseMessage[@ReleaseProfileVariantVersionId = 'BoxedSet']/ReleaseList/Release/ResourceGroup/ResourceGroup">
         <s:assert test="@ResourceGroupType = 'Component' or @ResourceGroupType = 'Side' or @ResourceGroupType = 'ComponentRelease' or @ResourceGroupType = 'ReleaseComponent'"
                   role="Fatal Error">Fatal Error (Boxed Set Variant): For a Release of this type, second-level ResourceGroups shall have a ResourceGroupType of either Side, Component, ComponentRelease or ReleaseComponent (Release Profile 2.1, Clause 5.3.1.2(5.2), Rule 1544-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="BoxedSet_MustContainResourceGroups">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release">
         <s:assert test="count(descendant::ResourceGroup[@ResourceGroupType='ReleaseComponent']) &gt; 1"
                   role="Fatal Error">Fatal Error (Boxed Set Variant): A Release of this type must contain at least two ResourceGroups of type ReleaseComponent (Release Profile 2.1, Clause 5.5.1(1), Rule 1545-1).</s:assert>
      </s:rule>
   </s:pattern>
   <s:pattern id="BoxedSet_MustContainReleaseId">
      <s:rule context="*:NewReleaseMessage/ReleaseList/Release/ResourceGroup[@ResourceGroupType='ReleaseComponent']">
         <s:assert test="ReleaseId" role="Fatal Error">Fatal Error (Boxed Set Variant): The identifier of the 'component' Releases that make up the Boxed Set Release shall be placed into the ReleaseId composite of the relevant ResourceGroup (Release Profile 2.1, Clause 5.5.1(3), Rule 1546-1).</s:assert>
         <s:assert test="ReleaseId/GRid[string-length(normalize-space(text())) &gt; 0] | ReleaseId/ICPN[string-length(normalize-space(text())) &gt; 0]"
                   role="Fatal Error">Fatal Error (Boxed Set Variant): The identifier of the 'component' Releases that make up the Boxed Set Release shall be identified by either a GRid or an ICPN (Release Profile 2.1, Clause 5.5.1(3), Rule 1546-2).</s:assert>
      </s:rule>
   </s:pattern>
</s:schema>
