package net.ddex.ern.vo;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by rdewilde on 5/18/2017.
 */
public class ValidationResult {

  private Boolean isValid;
  private List<String> messages = null;

  public Boolean getValid() {
    return isValid;
  }

  public void setValid(Boolean valid) {
    isValid = valid;
  }

  public List<String> getMessages() {
    return messages;
  }

  public void setMessages(List<String> messages) {
    this.messages = messages;
  }

  public void addMessage(String msg) {
    if (messages == null) {
      messages = new ArrayList<>();
    }
    messages.add(msg);
  }

}
