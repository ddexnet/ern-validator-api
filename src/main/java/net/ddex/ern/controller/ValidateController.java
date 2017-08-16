package net.ddex.ern.controller;

import net.ddex.ern.exception.ValidatorException;
import net.ddex.ern.service.SchemaService;
import net.ddex.ern.service.SchematronService;
import net.ddex.ern.vo.ValidationResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLStreamException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class ValidateController {

    private static final Logger logger = LoggerFactory.getLogger(ValidateController.class);

    @Autowired
    private SchemaService schemaService;

    @Autowired
    private SchematronService schematronService;

    @GetMapping(path = "/status", produces = "text/plain")
    public String test()
            throws ParserConfigurationException, SAXException, IOException,
            XMLStreamException, TransformerException, XPathExpressionException {

        return "The service is running";
    }

    @PostMapping(path = "/json/validateSchematron", produces = "application/json")
    public List<Map<String, String>> validateSchematronJSON(@RequestParam(value = "ernFile") MultipartFile file,
                                                            @RequestParam(value = "schematronVersion") String schematronVersion,
                                                            @RequestParam(value = "profileVersion") String profileVersion)
            throws ParserConfigurationException, SAXException, IOException,
            XMLStreamException, TransformerException, XPathExpressionException {
        logger.info("Validating ERN {} as schematron version {} and product version {}. ", file.getOriginalFilename(), schematronVersion, profileVersion);
        return schematronService.schematron2Map(file.getInputStream(), schematronVersion, profileVersion);
    }

    @PostMapping(path = "/json/validateXML", produces = "application/json")
    public List<Map<String, Object>> validateXMLJSON(
            @RequestParam("ernFile") MultipartFile file,
            @RequestParam(value = "schematronVersion") String schematronVersion,
            @RequestParam(value = "profileVersion") String profileVersion,
            @RequestParam("schemaVersion") String schemaVersion)
            throws ParserConfigurationException, IOException,
            XMLStreamException, TransformerException, SAXException, XPathExpressionException, ValidatorException {
        logger.info("Validating ERN {} as schema version {}. ", file.getOriginalFilename(), schemaVersion);
        logger.info("Validating ERN {} as schematron version {} and product version {}. ", file.getOriginalFilename(), schematronVersion, profileVersion);
        List<Map<String, Object>> list = new ArrayList<>();
        Map<String, Object> map = new HashMap<>();
        logger.info("working swell");

        try {
            map.put("schema", schemaService.validate(file.getInputStream(), schemaVersion));

        } catch (SAXException e) {
            logger.info(e.getMessage());
            map.put("schema", e.getMessage());
            list.add(map);
            return list;

        }
        map.put("schematron", schematronService.schematron2Map(file.getInputStream(), schematronVersion, profileVersion));
        list.add(map);
        return list;

    }

    @ExceptionHandler
    public ValidationResponse handleValidatorException(ValidatorException ex) {
        ex.printStackTrace();
        return new ValidationResponse();
    }


}