package net.ddex.ern.schema;

import javax.xml.transform.Result;
import javax.xml.validation.Validator;

import org.w3c.dom.Document;

import net.ddex.ern.exception.ValidatorException;

/**
 * Created by rdewilde on 5/13/2017.
 */
public interface Schema {
  Validator getValidator();

  String validate(String messageType, String schemaVersion, Document ern, Result result) throws ValidatorException;
}