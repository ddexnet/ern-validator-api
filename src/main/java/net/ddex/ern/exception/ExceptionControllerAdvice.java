package net.ddex.ern.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

/**
 * Created by eli on 8/7/2017.
 */
@ControllerAdvice
public class ExceptionControllerAdvice {

  private static final Logger LOGGER = LoggerFactory.getLogger(ExceptionControllerAdvice.class);

  @ExceptionHandler(ValidatorException.class)
  public ResponseEntity<ErrorResponse> exceptionHandler(ValidatorException ex) {
    ErrorResponse error = new ErrorResponse();
    error.setErrorCode(HttpStatus.INTERNAL_SERVER_ERROR.value());
    System.out.println("##############################");
    error.setMessage(ex.getErrorMessage());
    LOGGER.error("An error occured while processing request. {}", ex.getMessage());
    return new ResponseEntity<>(error, HttpStatus.INTERNAL_SERVER_ERROR);
  }

}
