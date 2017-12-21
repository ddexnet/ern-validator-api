package net.ddex.ern.service;

import java.io.IOException;
import java.io.InputStream;

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
import org.w3c.dom.NamedNodeMap;
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

  private static final Logger logger = LoggerFactory.getLogger(SchemaService.class);
  
  private static final String XPATH_EXPRESSION = "/*";

  @Autowired
  private SchemaValidator schemaValidator;

  public String validateSchema(InputStream is, String schemaVersion, String messageType) throws ParserConfigurationException, IOException, SAXException, ValidatorException {
    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
    dbf.setNamespaceAware(true);
    DocumentBuilder parser = dbf.newDocumentBuilder();
    String valid = "Document is Invalid";
    Document ret = parser.parse(is);
    if (schemaVersion.isEmpty()) {
      XPath xPath = XPathFactory.newInstance().newXPath();
      try {
        NodeList nodeList = (NodeList) xPath.compile(SchemaService.XPATH_EXPRESSION).evaluate(ret, XPathConstants.NODESET);
        for (int i = 0; i < nodeList.getLength(); i++) {
          Node nNode = nodeList.item(i);
          logger.info("Message Type is : {}", nNode.getNodeName());
          if (nNode.getNodeType() == Node.ELEMENT_NODE) {
            Element eElement = (Element) nNode;
            logger.info("Schema Version is : {}", eElement.getAttribute("MessageSchemaVersionId"));
            String tempSchemaVersion = eElement.getAttribute("MessageSchemaVersionId");
            schemaVersion = tempSchemaVersion.substring(tempSchemaVersion.lastIndexOf("/") + 1, tempSchemaVersion.length());
            if (schemaVersion.isEmpty()) {
              logger.error("Schema Version not found in request or XML.");
              throw new ValidatorException("SCHEMA_VERSION_NOT_FOUND", "Error occured while validating XML. Schema Version not found in request or XML.");
            }
            break;
          }
        }
      } catch (XPathExpressionException e1) {
        logger.error("Error while parsing the XML for Schema Version: {}", e1);
      }
    } else {
      schemaVersion = schemaVersion.replace(".", "");
    }
    logger.info("schemaVersion: {}", schemaVersion);
    try {
      valid = schemaValidator.validate(messageType, schemaVersion, ret, null);
    } catch (ValidatorException e) {
      logger.error("An error occured while calling schema validation.", e);
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