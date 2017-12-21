package net.ddex.ern.schema;

import net.ddex.ern.exception.ValidatorException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;
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
import java.util.Arrays;
import java.util.List;

@Component
public class SchemaValidator implements Schema {

  private static final Logger logger = LoggerFactory.getLogger(SchemaValidator.class);
  private javax.xml.validation.Schema schema;
  private static final String FILE_PATH_PREFIX = "schema/";

  @Autowired
  private Environment env;
  private SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);

  @Override
  public Validator getValidator() {
    return schema.newValidator();
  }

  @Override
  public String validate(String messageType, String schemaVersion, Document ern, Result result) throws ValidatorException {
    DOMSource source = new DOMSource(ern);
    String valid = "Document is Invalid";
    StringBuffer schemaProp = new StringBuffer();
    schemaProp.append(messageType).append(".").append(schemaVersion);
    List<String> schemaFiles = Arrays.asList(env.getProperty(schemaProp.toString()).split("\\s*,\\s*"));
    Source[] sources = new Source[schemaFiles.size()];
    for (int i = 0; i < schemaFiles.size(); i++) {
      sources[i] = new StreamSource(new File(String.format("%s%s/%s/%s", SchemaValidator.FILE_PATH_PREFIX, messageType, schemaVersion, schemaFiles.get(i))));
    }
    try {
      schema = factory.newSchema(sources);
      getValidator().validate(source);
      valid = "Document is valid";
    } catch (IOException e) {
      logger.error("An error occured while validating schema.", e);
      throw new ValidatorException(e.getMessage(), e);
    } catch (SAXException e) {
      logger.error("An error occured while validating schema.", e);
      throw new ValidatorException(e.getMessage(), e);
    }
    return valid;

  }

}