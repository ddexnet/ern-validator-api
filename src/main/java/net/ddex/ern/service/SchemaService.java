package net.ddex.ern.service;

import java.io.IOException;
import java.io.InputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import net.ddex.ern.exception.ValidatorException;
import net.ddex.ern.schema.SchemaValidator;

/**
 * Created by rdewilder on 4/16/2017.
 */

@Service("schemaService")
public class SchemaService {

	private static final Logger logger = LoggerFactory.getLogger(SchemaService.class);

	@Autowired
	private SchemaValidator schemaValidator;

	public String validateSchema(InputStream is, String schemaVersion, String messageType)
			throws ParserConfigurationException, IOException, SAXException {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(true);
		DocumentBuilder parser = dbf.newDocumentBuilder();
		Document ret = parser.parse(is);
		schemaVersion = schemaVersion.replace(".", "");
		logger.info("schemaVersion: {}", schemaVersion);
		try {
			schemaValidator.validate(messageType, schemaVersion, ret, null);
		} catch (ValidatorException e) {
			// TODO Auto-generated catch block
			logger.error("An error occured while calling schema validation.", e);
		}
		return null;
	}

	public Document parseDocument() throws ParserConfigurationException, SAXException, IOException {
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setNamespaceAware(true);
		DocumentBuilder parser = dbf.newDocumentBuilder();
		System.out.println("Zoinks!!!!");
		return null;
	}
}