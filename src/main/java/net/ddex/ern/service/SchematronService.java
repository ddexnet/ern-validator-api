package net.ddex.ern.service;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.NamespaceContext;
import javax.xml.stream.XMLStreamException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import net.ddex.ern.exception.ValidatorException;

/**
 * Created by rdewilde on 4/16/2017.
 */

@Service("schematronService")
public class SchematronService {

	private SAXTransformerFactory stf = new net.sf.saxon.TransformerFactoryImpl();
	private static final Logger LOGGER = LoggerFactory.getLogger(SchematronService.class);

	public List<Map<String, String>> schematron2Map(InputStream is, String profileVersion, String schemaVersion)
			throws XMLStreamException, IOException, TransformerException, XPathExpressionException, ValidatorException {

		SAXSource saxSource = new SAXSource(new InputSource(is));
		DOMResult result = new DOMResult();
		// SAXTransformerFactory stf = new net.sf.saxon.TransformerFactoryImpl();
		try {
			Transformer transformer = stf.newTransformer(new StreamSource(profileVersion));
			transformer.transform(saxSource, result);
		} catch (TransformerException ex) {
			LOGGER.error("Exception: {}", ex.getMessage());
			String releaseProfile = profileVersion.substring(profileVersion.lastIndexOf("/") + 1,
					profileVersion.lastIndexOf("."));
			throw new ValidatorException(
					String.format("%s%s%s%s", "Error while validating Schematron. Release profile ", releaseProfile,
							" does not exist for schema version ", schemaVersion),
					ex);
		}
		XPathFactory xPathfactory = XPathFactory.newInstance();
		XPath xpath = xPathfactory.newXPath();

		xpath.setNamespaceContext(getNamespaceContext());

		XPathExpression expr = xpath.compile("/svrl:schematron-output/svrl:failed-assert");
		NodeList nl = (NodeList) expr.evaluate(result.getNode(), XPathConstants.NODESET);

		List<Map<String, String>> data = new ArrayList<>();
		int fatalErrors = 0;
		int conditionalErrors = 0;
		int errors = 0;
		int conditionalFatalErrors = 0;
		if (nl.getLength() > 0) {
			for (int i = 0; i < nl.getLength(); i++) {
				String role = String.format("/svrl:schematron-output/svrl:failed-assert[%d]/@role", i + 1);
				String msg = String.format("/svrl:schematron-output/svrl:failed-assert[%d]/svrl:text", i + 1);
				XPathExpression exprMsg = xpath.compile(msg);
				XPathExpression exprRole = xpath.compile(role);

				Map<String, String> failure = new HashMap<>();
				if (exprRole.evaluate(result.getNode()).equalsIgnoreCase("Fatal Error")) {
					fatalErrors = fatalErrors + 1;
				}
				if (exprRole.evaluate(result.getNode()).equalsIgnoreCase("Conditional Error")) {
					conditionalErrors = conditionalErrors + 1;
				}
				if (exprRole.evaluate(result.getNode()).equalsIgnoreCase("Error")) {
					errors = errors + 1;
				}
				if (exprRole.evaluate(result.getNode()).equalsIgnoreCase("Conditional Fatal Error")) {
					conditionalFatalErrors = conditionalFatalErrors + 1;
				}
				failure.put("role", exprRole.evaluate(result.getNode()));
				failure.put("msg", exprMsg.evaluate(result.getNode()));
				data.add(failure);
			}

			Map<String, String> errorCountMap = new HashMap<>();
			errorCountMap.put("fatalErrors", String.valueOf(fatalErrors));
			errorCountMap.put("conditionalErrors", String.valueOf(conditionalErrors));
			errorCountMap.put("errors", String.valueOf(errors));
			errorCountMap.put("conditionalFatalErrors", String.valueOf(conditionalFatalErrors));
			data.add(errorCountMap);
		} else {
			Map<String, String> errorCountMap = new HashMap<>();
			errorCountMap.put("noError", "Message validates against Profile.");
			data.add(errorCountMap);
		}
		return data;

	}

	private NamespaceContext getNamespaceContext() {
		NamespaceContext ctx = new NamespaceContext() {
			@Override
			public String getNamespaceURI(String prefix) {
				if (prefix.equals("svrl")) {
					return "http://purl.oclc.org/dsdl/svrl";
				} else {
					return null;
				}
			}

			@Override
			public String getPrefix(String namespaceURI) {
				return null; // not used
			}

			@Override
			public Iterator<String> getPrefixes(String namespaceURI) {
				return null; // not used
			}
		};
		return ctx;
	}

}