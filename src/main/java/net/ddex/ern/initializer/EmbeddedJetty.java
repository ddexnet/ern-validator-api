package net.ddex.ern.initializer;

import java.io.IOException;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.servlet.FilterHolder;
import org.eclipse.jetty.servlet.FilterMapping;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.servlet.ServletHolder;
import org.eclipse.jetty.servlets.CrossOriginFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.ContextLoaderListener;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.AnnotationConfigWebApplicationContext;
import org.springframework.web.servlet.DispatcherServlet;

public class EmbeddedJetty {

  private static final Logger LOGGER = LoggerFactory.getLogger(EmbeddedJetty.class);
  private static final int DEFAULT_PORT = 6060;
  private static final String CONTEXT_PATH = "/";
  private static final String CONFIG_LOCATION = "net/ddex/ern/config";
  private static final String MAPPING_URL = "/api/*";
  private static final String DEFAULT_PROFILE = "dev";
  private static org.springframework.web.context.WebApplicationContext WebApplicationContext;

  public static void main(String[] args) throws Exception {
    new EmbeddedJetty().startJetty(getPortFromArgs(args));
  }

  private static int getPortFromArgs(String[] args) {
    if (args.length > 0) {
      try {
        return Integer.valueOf(args[0]);
      } catch (NumberFormatException ignore) {}
    }
    LOGGER.debug("No server port configured, falling back to {}", DEFAULT_PORT);
    return DEFAULT_PORT;
  }

  private void startJetty(int port) throws Exception {
    LOGGER.debug("Starting server at port {}", port);
    Server server = new Server(port);
    ServletContextHandler myHand = getServletContextHandler(getContext());
    setAccessControlAllowOrigin(myHand);
    server.setHandler(myHand);
    server.start();
    LOGGER.info("Server started at port {}", port);
    server.join();
  }

  private static ServletContextHandler getServletContextHandler(WebApplicationContext context) throws IOException {

    ServletContextHandler contextHandler = new ServletContextHandler();
    contextHandler.setContextPath(CONTEXT_PATH);
    contextHandler.setWelcomeFiles(new String[]{ "index.html" });
    contextHandler.setErrorHandler(null);
    contextHandler.addServlet(new ServletHolder(new DispatcherServlet(context)), MAPPING_URL);
    contextHandler.addEventListener(new ContextLoaderListener(context));

    return contextHandler;

  }

  private static void setAccessControlAllowOrigin(ServletContextHandler context) {
    FilterHolder holder = new FilterHolder(CrossOriginFilter.class);
    holder.setInitParameter(CrossOriginFilter.ALLOWED_ORIGINS_PARAM, "*");
    holder.setInitParameter(CrossOriginFilter.ACCESS_CONTROL_ALLOW_ORIGIN_HEADER, "http://localhost:8000/");
    holder.setInitParameter(CrossOriginFilter.ALLOWED_METHODS_PARAM, "GET,POST,PUT,HEAD");
    holder.setInitParameter(CrossOriginFilter.ALLOWED_HEADERS_PARAM, "X-Requested-With,Content-Type,Accept,Origin");
    holder.setName("cross-origin");
    FilterMapping fm = new FilterMapping();
    fm.setFilterName("cross-origin");
    fm.setPathSpec("*");
    context.getServletHandler().addFilter(holder, fm);
  }

  private static WebApplicationContext getContext() {
    AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
    context.setConfigLocation(CONFIG_LOCATION);
    context.getEnvironment().setDefaultProfiles(DEFAULT_PROFILE);
    return context;
  }

}