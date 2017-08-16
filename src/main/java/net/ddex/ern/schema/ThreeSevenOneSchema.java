package net.ddex.ern.schema;

import net.ddex.ern.exception.ValidatorException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.XMLConstants;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;
import java.io.File;
import java.io.IOException;

/**
 * Electronic Release Notification 3.4.1
 */
public class ThreeSevenOneSchema implements Schema {

    private static final Logger logger = LoggerFactory.getLogger(ThreeFourOneSchema.class);
    private static javax.xml.validation.Schema schema;

    static {
        Source[] schemaFiles = new Source[]{
                new StreamSource(new File("schema/release-notification.xsd")),
                new StreamSource(new File("schema/ddexC.xsd")),
                new StreamSource(new File("schema/ddex.xsd")),
                new StreamSource(new File("schema/iso3166a2.xsd")),
                new StreamSource(new File("schema/iso4217a.xsd")),
                new StreamSource(new File("schema/iso639a2.xsd"))
        };

        SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
        try {
            schema = factory.newSchema(schemaFiles);
        } catch (SAXException e) {
            e.printStackTrace();
            // TODO: Catch this on startup earlier
            System.exit(2);
        }
    }

    @Override
    public Validator getValidator() {
        return schema.newValidator();
    }

    @Override
    public String validate(Document ern, Result result) throws ValidatorException {
        DOMSource source = new DOMSource(ern);
        String valid = "Document is valid";
        try {
            getValidator().validate(source);
        } catch (IOException e) {
//            logger.error(e.getMessage());
            throw new ValidatorException(e.getMessage(), e);
        } catch (SAXException e) {
//            logger.error(e.getMessage());
            throw new ValidatorException(e.getMessage(), e);
        }
        return valid;

    }
}