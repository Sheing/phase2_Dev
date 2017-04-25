/**
 * UM_PageReferenceParamsWrapper
 * 
 * @description This wrapper class will allow for the passing in of page parametres for the redirects.
 * @author Darkis
 * @created 19/02/2016
 */
public class UM_PageReferenceParamsWrapper {
  public String key { get; set; }
  public String value { get; set; }

  public UM_PageReferenceParamsWrapper(String key, String value) {
    this.key = key;
    this.value = value;
  }
}