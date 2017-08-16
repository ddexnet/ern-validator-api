package net.ddex.ern.schema;

import net.ddex.ern.exception.ValidatorException;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.transform.Result;
import javax.xml.validation.Validator;

/**
 * Created by rdewilde on 5/13/2017.
 */
public interface Schema {
    Validator getValidator();

    String validate(Document ern, Result result) throws SAXException, ValidatorException;
}