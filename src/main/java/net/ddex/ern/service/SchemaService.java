package net.ddex.ern.service;

import java.io.IOException;
import java.io.InputStream;
import java.util.AbstractMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import net.ddex.ern.exception.ValidatorException;
import net.ddex.ern.schema.SchemaValidator;

/**
 * Created by rdewilder on 4/16/2017.
 */

@Service("schemaService")
public class SchemaService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SchemaService.class);

    private static final String XPATH_EXPRESSION = "/*";

    @Autowired
    private SchemaValidator schemaValidator;

    // Todo: https://stackoverflow.com/questions/15732/whats-the-best-way-to-validate-an-xml-file-against-an-xsd-file
    // use SAX instead of Dom
    public AbstractMap.SimpleEntry<String, String> validateSchema(InputStream is, String schemaVersion, String profile)
            throws SAXException, ValidatorException {

        // DocumentBuilderFactory and DocumentBuilder are not thread safe
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        Document doc;

        // Try to create the DOM from the uploaded file
        try {
            DocumentBuilder parser = dbf.newDocumentBuilder();
            doc = parser.parse(is);
        } catch (ParserConfigurationException e) {
            LOGGER.error(e.getMessage());
            throw new ValidatorException("Could not create XML parser", e);
        } catch (IOException e) {
            LOGGER.error(e.getMessage());
            throw new ValidatorException("IOException during XML parse", e);
        }

        // Extract the Schema and profile from XML if not in request
        if (schemaVersion.isEmpty() || profile.isEmpty()) {
        	AbstractMap.SimpleEntry<String, String> schemaProfile = exractProfileAndSchemaVersion(doc);

            if (schemaVersion.isEmpty() && !"".equals(schemaProfile.getKey()))
                schemaVersion = schemaProfile.getKey();
            else if (schemaVersion.isEmpty()) {
                LOGGER.error("Schema Version not found in request or XML.");
                throw new ValidatorException("MANDATORY_PARAMS_NOT_FOUND",
                        "Error occurred while validating XML. Message Schema Version not found in request or XML.");
            }

            if (profile.isEmpty() && !"".equals(schemaProfile.getValue()))
                profile = schemaProfile.getValue();
            else if (profile.isEmpty()) {
                LOGGER.error("Profile not found in request or XML.");
                throw new ValidatorException("MANDATORY_PARAMS_NOT_FOUND",
                        "Error occurred while validating XML. Release Profile Version not found in request or XML.");
            }
        }
        LOGGER.info("schemaVersion: {}, profile: {}", schemaVersion, profile);
        schemaValidator.validate(schemaVersion, profile, doc, null);
        return new AbstractMap.SimpleEntry<>(schemaVersion, profile);
    }

    // Todo: use SAX instead of DOM
    private AbstractMap.SimpleEntry<String, String> exractProfileAndSchemaVersion(Document doc)
            throws ValidatorException {
        XPath xPath = XPathFactory.newInstance().newXPath();
        String schemaVersion = "";
        String profile = "";
        try {
            NodeList nodeList = (NodeList) xPath.compile(SchemaService.XPATH_EXPRESSION).evaluate(doc, XPathConstants.NODESET);
            for (int i = 0; i < nodeList.getLength(); i++) {
                Node nNode = nodeList.item(i);
                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) nNode;
                    if (!"".equals(eElement.getAttribute("MessageSchemaVersionId"))) {
                        schemaVersion = eElement.getAttribute("MessageSchemaVersionId");
                        schemaVersion = schemaVersion.startsWith("/") ? schemaVersion.substring(1) : schemaVersion;
                    }
                    if (!"".equals(eElement.getAttribute("ReleaseProfileVersionId "))) {
                        profile = eElement.getAttribute("ReleaseProfileVersionId ");
                        profile = profile.startsWith("/") ? profile.substring(1) : profile;
                    }
                }
            }
        } catch (XPathExpressionException e) {
            LOGGER.error(e.getMessage());
            throw new ValidatorException("XPath error during schema version extraction", e);
        }

        return new AbstractMap.SimpleEntry<>(schemaVersion, profile);
    }
}