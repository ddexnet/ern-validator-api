package net.ddex.ern.util;

import java.io.File;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;
import org.xml.sax.SAXException;

import net.ddex.ern.exception.ValidatorException;

@Component
public class SchemaBuilder {

  private static final Logger LOGGER = LoggerFactory.getLogger(SchemaBuilder.class);
  private static final String FILE_PATH_PREFIX = "schema/";
  private ConcurrentHashMap<String, Schema> schemaMap = new ConcurrentHashMap<String, Schema>();
  private SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);

  @Autowired
  private Environment env;

  public Schema getSchema(String messageType, String schemaVersion) throws ValidatorException {
    String schemaKey = (String.format("%s.%s", messageType, schemaVersion));
    if (!schemaMap.containsKey(schemaKey)) {
      List<String> schemaFiles = Arrays.asList(env.getProperty(schemaKey).split("\\s*,\\s*"));
      Source[] sources = new Source[schemaFiles.size()];
      for (int i = 0; i < schemaFiles.size(); i++) {
        sources[i] = new StreamSource(new File(String.format("%s%s/%s/%s", SchemaBuilder.FILE_PATH_PREFIX, messageType, schemaVersion, schemaFiles.get(i))));
      }
      try {
        schemaMap.put(schemaKey, factory.newSchema(sources));
      } catch (SAXException e) {
        LOGGER.error("Error while building Schema Object");
        throw new ValidatorException(e.getMessage(), e);
      }
    }
    return schemaMap.get(schemaKey);
  }
}