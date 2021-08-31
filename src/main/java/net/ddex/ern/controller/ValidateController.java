package net.ddex.ern.controller;

import java.io.IOException;
import java.util.AbstractMap;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import javax.xml.stream.XMLStreamException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.SAXException;

import net.ddex.ern.exception.ValidatorException;
import net.ddex.ern.service.SchemaService;
import net.ddex.ern.service.SchematronService;
import net.ddex.ern.vo.ValidationResponse;

@RestController
public class ValidateController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ValidateController.class);
	private static String PROFILE_ROOT = "profiles/commonreleasetypes/";

	@Autowired
	private SchemaService schemaService;

	@Autowired
	private SchematronService schematronService;

	@Value("${max.input.file.size.kb}")
	private Long maxInputFileSizeinKb;
	
	@Value("#{${releaseProfileVersion.map.schema}}")
	private Map<String, String> releaseProfileVersionMap;

	@GetMapping(path = "/status", produces = "text/plain")
	public String test() {
		return "The service is running";
	}

	@PostMapping(path = "/json/validate", produces = "application/json")
	public List<Map<String, Object>> validate(@RequestParam(value = "messageFile") MultipartFile file,
			@RequestParam(value = "messageSchemaVersionId") Optional<String> schemaVersion,
			@RequestParam(value = "releaseProfileVersionId") Optional<String> releaseProfile,
			@RequestParam(value = "businessProfileValidationRequired", required = false, defaultValue = "false") boolean businessProfileValidationRequired)
			throws IOException, XMLStreamException, TransformerException, SAXException, XPathExpressionException,
			ValidatorException {
		
		LOGGER.info("file size is : {}", file.getSize() / 1000);
		if (file.getSize() / 1000 > maxInputFileSizeinKb) {
			throw new ValidatorException("MAX_FILE_SIZE_LIMIT_FAILED",
					"Input File Size cannot be greater than 15000 KB");
		}
		List<Map<String, Object>> list = new ArrayList<>(2);
		Map<String, Object> map = new HashMap<>(2);

		String _schemaVersion = schemaVersion.isPresent() ? schemaVersion.get().replace(".", "") : "";
		_schemaVersion = _schemaVersion.startsWith("/") ? _schemaVersion.substring(1) : _schemaVersion;
		_schemaVersion = _schemaVersion.endsWith("/") ? _schemaVersion.substring(0, _schemaVersion.length() - 1)
				: _schemaVersion;
		
		String _releaseProfile = releaseProfile.isPresent() ? releaseProfile.get().replace(".", "") : "none";
		_releaseProfile = _releaseProfile.startsWith("/") ? _releaseProfile.substring(1) : _releaseProfile;
		_releaseProfile = _releaseProfile.endsWith("/") ? _releaseProfile.substring(0, _releaseProfile.length() - 1)
				: _releaseProfile;

		String releaseProfileVersion = releaseProfileVersionMap.get(_schemaVersion.replace("/", "")) != null ? releaseProfileVersionMap.get(_schemaVersion.replace("/", "")).concat("/") : "none";
		LOGGER.info("releaseProfileVersion is  : {}", releaseProfileVersion);
		String releaseProfileXslPath = null;
		try {
			AbstractMap.SimpleEntry<String, String> spec = schemaService.validateSchema(file.getInputStream(),
					_schemaVersion, _releaseProfile);
			map.put("schema", "Message validates against schema version " + spec.getKey());
			_schemaVersion = _schemaVersion.isEmpty() ? spec.getKey() : _schemaVersion;
			releaseProfileXslPath = _releaseProfile.isEmpty() ? String.format("%s%s", spec.getValue(), ".xsl")
					: String.format("%s%s%s%s", PROFILE_ROOT, releaseProfileVersion, _releaseProfile, ".xsl");
		} catch (SAXException e) {
			LOGGER.error(e.getMessage());
			map.put("schema", e.getMessage());
			list.add(map);
			return list;
		}
		if (!(_releaseProfile.equalsIgnoreCase("none") || _schemaVersion.equalsIgnoreCase("341"))) {
			map.put("schematron",
					schematronService.schematron2Map(file.getInputStream(), releaseProfileXslPath, _schemaVersion));
		}
		if (businessProfileValidationRequired) {
			map.put("businessProfileSchematron", schematronService.schematron2Map(file.getInputStream(),
					String.format("%s%s%s%s", PROFILE_ROOT, releaseProfileVersion, "BusinessProfile", ".xsl"), _schemaVersion));
		}
		list.add(map);
		return list;
	}

	@ExceptionHandler
	public ValidationResponse handleValidatorException(ValidatorException ex) {
		LOGGER.error(ex.getMessage());
		return new ValidationResponse(ex.getStatus(), ex.getErrorMessage());
	}
}