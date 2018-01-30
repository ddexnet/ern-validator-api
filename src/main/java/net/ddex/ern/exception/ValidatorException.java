package net.ddex.ern.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR, reason = "Validator configuration error")
public class ValidatorException extends Exception {

  private static final long serialVersionUID = 1L;
  private String status;
  private String errorMessage;

  public ValidatorException() {
    super();
  }

  public ValidatorException(String errorMessage) {
    super(errorMessage);
    this.errorMessage = errorMessage;
  }

  public ValidatorException(String status, String errorMessage) {
    super(errorMessage);
    this.status = status;
    this.errorMessage = errorMessage;
  }

  public ValidatorException(String errorMessage, Throwable throwable) {
    super(throwable);
    this.errorMessage = errorMessage;
  }

  public String getErrorMessage() {
    return errorMessage;
  }

  public String getStatus() {
    return status;
  }
}
