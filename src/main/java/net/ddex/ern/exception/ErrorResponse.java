package net.ddex.ern.exception;

/**
 * Created by eli on 8/7/2017.
 */
public class ErrorResponse {
  private int errorCode;
  private String message;

  public int getErrorCode() {
    return errorCode;
  }

  public void setErrorCode(int errorCode) {
    this.errorCode = errorCode;
  }

  public String getMessage() {
    return message;
  }

  public void setMessage(String message) {
    this.message = message;
  }

}
