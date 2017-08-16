package net.ddex.ern.schema;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Created by rdewilde on 5/13/2017.
 */
public class SchemaFactory {

    private static final Logger logger = LoggerFactory.getLogger(SchemaFactory.class);

    public Schema getSchema() {
        return new ThreeFourOneSchema();
    }
}
