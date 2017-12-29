package net.ddex.ern.service;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;

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

  public String validateSchema(InputStream is, String schemaVersion, String messageType) throws ParserConfigurationException, IOException, SAXException, ValidatorException {
    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
    dbf.setNamespaceAware(true);
    DocumentBuilder parser = dbf.newDocumentBuilder();
    String valid = "Document is Invalid";
    Document ret = parser.parse(is);
    if (schemaVersion.isEmpty() || messageType.isEmpty()) {
      XPath xPath = XPathFactory.newInstance().newXPath();
      try {
        NodeList nodeList = (NodeList) xPath.compile(SchemaService.XPATH_EXPRESSION).evaluate(ret, XPathConstants.NODESET);
        for (int i = 0; i < nodeList.getLength(); i++) {
          Node nNode = nodeList.item(i);
          if (nNode.getNodeType() == Node.ELEMENT_NODE) {
            Element eElement = (Element) nNode;
            LOGGER.info("MessageSchemaVersionId is: {}", eElement.getAttribute("MessageSchemaVersionId"));
            if (eElement.getAttribute("MessageSchemaVersionId") != "") {
              List<String> schemaProps = Arrays.asList(eElement.getAttribute("MessageSchemaVersionId").split("\\s*/\\s*"));
              for (int j = 0; j < schemaProps.size(); j++) {
                messageType = messageType.isEmpty() ? schemaProps.get(1) : messageType;
                schemaVersion = schemaVersion.isEmpty() ? schemaProps.get(2) : schemaVersion;
              }
            }
            break;
          }
        }
      } catch (XPathExpressionException e1) {
        LOGGER.error("Error while parsing the XML for Schema Version: {}", e1);
      }
    }
    if (schemaVersion.isEmpty() || messageType.isEmpty()) {
      LOGGER.error("Schema Version or Message Type not found in request or XML.");
      throw new ValidatorException("MANDATORY_PARAMS_NOT_FOUND", "Error occured while validating XML. Schema Version or Message Type not found in request or XML.");
    }
    LOGGER.info("schemaVersion: {}", schemaVersion);
    try {
      valid = schemaValidator.validate(messageType, schemaVersion, ret, null);
    } catch (ValidatorException e) {
      LOGGER.error("An error occured while calling schema validation.", e);
      throw new ValidatorException("SCHEMA_VALIDATION_FAILED", "Schema validation failed for the Input XML.");
    }
    return valid;
  }

  public Document parseDocument() throws ParserConfigurationException, SAXException, IOException {
    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
    dbf.setNamespaceAware(true);
    DocumentBuilder parser = dbf.newDocumentBuilder();
    System.out.println("Zoinks!!!!");
    return null;
  }
}