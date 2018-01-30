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

  public void validate(String schemaVersion, String profile, Document ern, Result result)
          throws SAXException, ValidatorException {
    DOMSource source = new DOMSource(ern);
    try {
      schema = schemaBuilder.getSchema(schemaVersion);
      schema.newValidator().validate(source, result);
    } catch (IOException e) {
      LOGGER.error("IOException while validating schema.", e);
      throw new ValidatorException(e.getMessage(), e);
    }
  }
}