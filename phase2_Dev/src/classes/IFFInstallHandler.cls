/*
    Install handler for IFF Forms.
    
    Each new version should add a new function. Existing versioning functions should NEVER change the resulting
    data. If you need to modify existing data, you should create a new function.
    
    To have your versioning function called, add a check to the upgrade function. To ensure that it is always run,
    make sure you do a less then check
    
    Ensure that you update the ObjectsVersion__c property of the IFFPackageInformation custom setting once you have
    commited your changes. It should be equal to the version number of your function
    
    Changes must be able to run regardless of what version a client is on.
    
    To run the upgrade path in development, you can use the "Run Apex" function of the developer console (Ctrl+e)
    and simply do 
    
    ```
    IFFInstallHandler.upgrade(IFFPackageInformation__c.getOrgDefaults());
    ```
    
    To reset all data, you can run the following (in the Run Apex mode)
    
    ```
    List<ComponentProperty__c> cps = [SELECT ID From ComponentProperty__c];
    delete cps;
    
    List<Property__c> ps = [SELECT ID From Property__c];
    delete ps;
    
    List<Component__c> cs = [SELECT ID From Component__c];
    delete cs;
    
    IFFPackageInformation__c info = IFFPackageInformation__c.getOrgDefaults();
    info.ObjectsVersion__c = 0;
    upsert info;
    ```
    
    Current Version: 1
*/
public class IFFInstallHandler implements InstallHandler {

    public void onInstall(InstallContext context) {
        IFFPackageInformation__c info = IFFPackageInformation__c.getOrgDefaults();
        upgrade(info);
    }
    
    /*
        Determine which versioning functions need to be run.
    */
    public static void upgrade(IFFPackageInformation__c info) {
        
        if(info.ObjectsVersion__c == NULL) {
            IFFInstallHandler.v0(info);
        }
        
        if(info.ObjectsVersion__c < 1) {
            IFFInstallHandler.v1(info);
        }
         
        System.debug('[IFFInstallHandler] DML Count / Limit ------> ' + Limits.getDMLStatements() + ' / ' + Limits.getLimitDMLStatements());
        System.debug('[IFFInstallHandler] Query Count / Limit ----> ' + Limits.getQueries() + ' / ' + Limits.getLimitQueries());
    }
    
    /*
        Init the IFFPackageInformation object.
        
        @author John Benson
    */
    @TestVisible
    private static void v0(IFFPackageInformation__c info) {
        info.ObjectsVersion__c = 0;
        upsert info;
    }
    
    /*
        Setup the basic types for Forms; including <input /> based inputs (date, number, text),
        basic grouping components (page, fieldset, as well as one, two and three column sections), 
        and basic actions (submit, cancel, next page, previous page)
        
        @author John Benson
    */
    @TestVisible
    private static void v1(IFFPackageInformation__c info) {
        
        Component__c text = new Component__c(Type__c = 'Input', Name = 'Text', DeveloperName__c = 'text');
        Component__c numberInput = new Component__c(Type__c = 'Input', Name = 'Number', DeveloperName__c = 'number');
        Component__c dateInput = new Component__c(Type__c = 'Input', Name = 'Date', DeveloperName__c = 'date');
        Component__c page = new Component__c(Type__c = 'Grouping', Name = 'Page', DeveloperName__c = 'page');
        Component__c oneColSection = new Component__c(Type__c = 'Grouping', Name = 'Section', DeveloperName__c = 'section');
        Component__c twoColSection = new Component__c(Type__c = 'Grouping', Name = 'Two Column Section', DeveloperName__c = 'twoColSection');
        Component__c threeColSection = new Component__c(Type__c = 'Grouping', Name = 'Three Column Section', DeveloperName__c = 'threeColSection');
        Component__c fieldset = new Component__c(Type__c = 'Grouping', Name = 'Fieldset', DeveloperName__c = 'fieldset');
        Component__c submit = new Component__c(Type__c = 'Action', Name = 'Submit', DeveloperName__c = 'submit');
        Component__c cancel = new Component__c(Type__c = 'Action', Name = 'Cancel', DeveloperName__c = 'cancel');
        Component__c nextPage = new Component__c(Type__c = 'Action', Name = 'Next Page', DeveloperName__c = 'nextPage');
        Component__c prevPage = new Component__c(Type__c = 'Action', Name = 'Previous Page', DeveloperName__c = 'prevPage');
        Component__c repeater = new Component__c(Type__c = 'Grouping', Name = 'Repeater', DeveloperName__c = 'repeater');
        Component__c picklist = new Component__c(Type__c = 'Picklist', Name = 'Picklist', DeveloperName__c = 'picklist');
        Component__c checkbox = new Component__c(Name = 'Checkbox', DeveloperName__c = 'checkbox', Type__c = 'Input');
        Component__c checkboxGroup = new Component__c(Name = 'Checkbox Group', DeveloperName__c = 'checkboxGroup', Type__c = 'Input');
        Component__c radioButton = new Component__c(Name = 'Radio Button', DeveloperName__c = 'radio', Type__c = 'Input');
        Component__c radioButtonGroup = new Component__c(Name = 'Radio Button Group', DeveloperName__c = 'radioGroup', Type__c = 'Input');
        Component__c fileUpload = new Component__c(Name = 'File Upload', DeveloperName__c = 'fileUpload', Type__c = 'Input');
        Component__c summaryPage = new Component__c(Name = 'Summary Page', DeveloperName__c = 'summaryPage', Type__c = 'Display');
        
        List<Component__c> components = new List<Component__c>{
            text, numberInput, dateInput, page, oneColSection, twoColSection, 
            threeColSection, fieldset, submit, cancel, nextPage, prevPage,
            checkbox, checkboxGroup, radioButton, radioButtonGroup, picklist,
            repeater, fileUpload, summaryPage
        };
        
        insert components;
        
        Property__c label = new Property__c(Name = 'Label', DeveloperName__c = 'label', Datatype__c = 'Text');
        Property__c placeholder = new Property__c(Name = 'Placeholder', DeveloperName__c = 'placeholder', Datatype__c = 'Text');
        Property__c hintProperty = new Property__c(Name = 'Hint Text', DeveloperName__c = 'hintText', Datatype__c = 'Text');
        Property__c required = new Property__c(Name = 'Required', DeveloperName__c = 'required', Datatype__c = 'Boolean');
        Property__c visible = new Property__c(Name = 'Visible', DeveloperName__c = 'visible', Datatype__c = 'Boolean');
        Property__c value = new Property__c(Name = 'Value', DeveloperName__c = 'value', Datatype__c = 'Text');
        
        List<Property__c> properties = new List<Property__c>{ label, placeholder, hintProperty, required, visible, value   };
        
        insert properties;
        
        List<ComponentProperty__c> componentProperties = new List<ComponentProperty__c>();
        
        // Everything needs label
        for(Component__c c : components) {
            componentProperties.add(new ComponentProperty__c(Property__c = label.Id, Component__c = c.Id));
        }
        
        // required property for inputs
        componentProperties.add(new ComponentProperty__c(Property__c = required.Id, Component__c = text.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = required.Id, Component__c = numberInput.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = required.Id, Component__c = dateInput.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = required.Id, Component__c = picklist.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = required.Id, Component__c = checkbox.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = required.Id, Component__c = checkboxGroup.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = required.Id, Component__c = radioButton.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = required.Id, Component__c = radioButtonGroup.Id));
        
        // placeholder property for inputs
        componentProperties.add(new ComponentProperty__c(Property__c = placeholder.Id, Component__c = text.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = placeholder.Id, Component__c = numberInput.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = placeholder.Id, Component__c = dateInput.Id));
        
        // hint property for inputs
        componentProperties.add(new ComponentProperty__c(Property__c = hintProperty.Id, Component__c = text.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = hintProperty.Id, Component__c = numberInput.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = hintProperty.Id, Component__c = dateInput.Id));
        
        // visible property for grouping
        componentProperties.add(new ComponentProperty__c(Property__c = visible.Id, Component__c = oneColSection.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = visible.Id, Component__c = twoColSection.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = visible.Id, Component__c = threeColSection.Id));
        
        // value properties for radio and checkbox
        componentProperties.add(new ComponentProperty__c(Property__c = value.Id, Component__c = checkbox.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = value.Id, Component__c = checkboxGroup.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = value.Id, Component__c = radioButton.Id));
        componentProperties.add(new ComponentProperty__c(Property__c = value.Id, Component__c = radioButtonGroup.Id));
        
        insert componentProperties;
        
        info.ObjectsVersion__c = 1;
        update info;
    }
}