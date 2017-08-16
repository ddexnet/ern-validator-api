package net.ddex.ern.service;

import net.ddex.ern.exception.ValidatorException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.namespace.NamespaceContext;
import javax.xml.stream.XMLStreamException;
import javax.xml.transform.Result;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.sax.SAXSource;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.*;
import java.io.*;
import java.util.*;

/**
 * Created by rdewilde on 4/16/2017.
 */

@Service("schematronService")
public class SchematronService {

    private SAXTransformerFactory stf = new net.sf.saxon.TransformerFactoryImpl();
    private static final Logger logger = LoggerFactory.getLogger(SchematronService.class);
    private static String PROFILE_ROOT = "xslt/profiles/";

    private FileInputStream loadSchematronXSLT(String profile, String version) throws ValidatorException {
        String xsltFilePath = PROFILE_ROOT + version + File.separator + profile + ".xsl";
        File f = new File(xsltFilePath);

        try {
            return new FileInputStream(f);
        } catch (FileNotFoundException e) {
            throw new ValidatorException(String.format("Profile %s-%s is could not be loaded", version, profile), e);
        }

    }

    private void transform(InputStream xslt, InputStream ern, Result result) throws ValidatorException {
        SAXSource saxSource = new SAXSource(new InputSource(ern));
        try {
            Transformer transformer = stf.newTransformer(new StreamSource(xslt));
            transformer.transform(saxSource, result);
        } catch (TransformerConfigurationException e) {
            throw new ValidatorException(e.getMessage(), e);
        } catch (TransformerException e) {
            throw new ValidatorException(e.getMessage(), e);
        }

    }


    public String validate2XML(InputStream ern, String profile, String version) throws ValidatorException {
        FileInputStream xslt = loadSchematronXSLT(profile, version);
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);

        transform(xslt, ern, result);
        return writer.toString();
    }

    public List<Map<String, String>> validate2Map(InputStream ern, String profile, String version) throws ValidatorException {
        FileInputStream xslt = loadSchematronXSLT(version, profile);
        DOMResult result = new DOMResult();

        transform(xslt, ern, result);

        XPathFactory xPathfactory = XPathFactory.newInstance();
        XPath xpath = xPathfactory.newXPath();

        xpath.setNamespaceContext(new NamespaceContext() {
            @Override
            public String getNamespaceURI(String prefix) {
                if (prefix.equals("svrl")) {
                    return "http://purl.oclc.org/dsdl/svrl";
                } else {
                    return null;
                }
            }

            @Override
            public String getPrefix(String namespaceURI) {
                return null; // not used
            }

            @Override
            public Iterator<?> getPrefixes(String namespaceURI) {
                return null; // not used
            }
        });

        List<Map<String, String>> data = new ArrayList<>();

        try {
            XPathExpression expr = xpath.compile("/svrl:schematron-output/svrl:failed-assert");
            NodeList nl = (NodeList) expr.evaluate(result.getNode(), XPathConstants.NODESET);

            for (int i = 0; i < nl.getLength(); i++) {
                String role = String.format("/svrl:schematron-output/svrl:failed-assert[%d]/@role", i + 1);
                String msg = String.format("/svrl:schematron-output/svrl:failed-assert[%d]/svrl:text", i + 1);
                XPathExpression exprMsg = xpath.compile(msg);
                XPathExpression exprRole = xpath.compile(role);

                Map<String, String> failure = new HashMap<>();
                failure.put("role", exprRole.evaluate(result.getNode()));
                failure.put("msg", exprMsg.evaluate(result.getNode()));
                data.add(failure);
            }
        } catch (XPathExpressionException e) {
            e.printStackTrace();
            throw new ValidatorException(e.getMessage(), e);
        }

        return data;
    }


    public String schematron2XML(InputStream is) throws XMLStreamException, IOException, TransformerException {
        String XSLT_FILE = "xslt/release-profiles/NewReleaseMessage_ReleaseProfile_AudioAlbumMusicOnly_14.xslt";
        SAXSource saxSource = new SAXSource(new InputSource(is));
        // Object to hold the result
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);

        Transformer transformer = stf.newTransformer(new StreamSource(XSLT_FILE));
        // the actual transformation
        transformer.transform(saxSource, result);
        return writer.toString();

    }

    public List<Map<String, String>> schematron2Map(InputStream is, String schematronVersion, String profileVersion) throws XMLStreamException, IOException,
            TransformerException, XPathExpressionException {

        String XSLT_FILE = ("xslt/profiles/" + schematronVersion + "/" + profileVersion + ".xsl");
        SAXSource saxSource = new SAXSource(new InputSource(is));
        DOMResult result = new DOMResult();
        SAXTransformerFactory stf = new net.sf.saxon.TransformerFactoryImpl();
        Transformer transformer = stf.newTransformer(new StreamSource(XSLT_FILE));
        transformer.transform(saxSource, result);
        XPathFactory xPathfactory = XPathFactory.newInstance();
        XPath xpath = xPathfactory.newXPath();

        xpath.setNamespaceContext(new NamespaceContext() {
            @Override
            public String getNamespaceURI(String prefix) {
                if (prefix.equals("svrl")) {
                    return "http://purl.oclc.org/dsdl/svrl";
                } else {
                    return null;
                }
            }

            @Override
            public String getPrefix(String namespaceURI) {
                return null; // not used
            }

            @Override
            public Iterator<?> getPrefixes(String namespaceURI) {
                return null; // not used
            }
        });

        XPathExpression expr = xpath.compile("/svrl:schematron-output/svrl:failed-assert");
        NodeList nl = (NodeList) expr.evaluate(result.getNode(), XPathConstants.NODESET);

        List<Map<String, String>> data = new ArrayList<>();

        for (int i = 0; i < nl.getLength(); i++) {
            String role = String.format("/svrl:schematron-output/svrl:failed-assert[%d]/@role", i + 1);
            String msg = String.format("/svrl:schematron-output/svrl:failed-assert[%d]/svrl:text", i + 1);
            XPathExpression exprMsg = xpath.compile(msg);
            XPathExpression exprRole = xpath.compile(role);

            Map<String, String> failure = new HashMap<>();
            failure.put("role", exprRole.evaluate(result.getNode()));
            failure.put("msg", exprMsg.evaluate(result.getNode()));
            data.add(failure);
        }
        return data;

    }

}