package net.ddex.ern.service;

import net.ddex.ern.exception.ValidatorException;
import net.ddex.ern.schema.ThreeFourOneSchema;
import net.ddex.ern.schema.ThreeSevenOneSchema;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.io.InputStream;


/**
 * Created by rdewilder on 4/16/2017.
 */

@Service("schemaService")
public class SchemaService {

    private static final Logger logger = LoggerFactory.getLogger(SchemaService.class);
    ThreeFourOneSchema schema341 = new ThreeFourOneSchema();
    ThreeSevenOneSchema schema371 = new ThreeSevenOneSchema();

    /**
     * TODO:
     * See if we can validate XSD using stream parser.
     * DOM parser has potential to cause memory issues with larger documents
     */


    // TODO: look intializing doucmentbuilder.  Is it expensive to build?  Threadsafe?
    public String validate(InputStream is, String schemaVersion) throws ParserConfigurationException, IOException, SAXException {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(true);
        DocumentBuilder parser = dbf.newDocumentBuilder();
        Document ret = parser.parse(is);

        switch (schemaVersion) {

            case "3.4.1":
                try {
                    return schema341.validate(ret, null);
                } catch (ValidatorException e) {
                    logger.error(e.getMessage());
                    return e.getCause().getMessage();
                }

            case "3.7.1":
                try {
                    return schema371.validate(ret, null);
                } catch (ValidatorException e) {
                    logger.error(e.getMessage());
                    return e.getMessage();
                }
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