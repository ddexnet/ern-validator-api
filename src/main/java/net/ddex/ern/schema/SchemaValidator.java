package net.ddex.ern.schema;

import java.io.IOException;

import javax.xml.transform.Result;
import javax.xml.transform.dom.DOMSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import net.ddex.ern.exception.ValidatorException;
import net.ddex.ern.util.SchemaBuilder;

@Component
public class SchemaValidator {

  private static final Logger LOGGER = LoggerFactory.getLogger(SchemaValidator.class);
  private javax.xml.validation.Schema schema;

  @Autowired
  private SchemaBuilder schemaBuilder;

  public String validate(String messageType, String schemaVersion, Document ern, Result result) throws ValidatorException {
    DOMSource source = new DOMSource(ern);
    String valid = "Document is Invalid";
    try {
      schema = schemaBuilder.getSchema(messageType, schemaVersion);
      schema.newValidator().validate(source);
      valid = "Document is valid";
    } catch (IOException e) {
      LOGGER.error("An error occured while validating schema.", e);
      throw new ValidatorException(e.getMessage(), e);
    } catch (SAXException e) {
      LOGGER.error("An error occured while validating schema.", e);
      throw new ValidatorException(e.getMessage(), e);
    }
    return valid;
  }
}