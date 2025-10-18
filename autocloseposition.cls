// Trigger: JobApplicationTrigger.trigger
trigger JobApplicationTrigger on Job_Application__c (after insert, after update) {
    Set<Id> positionIds = new Set<Id>();
    
    // Collect all positions affected by job applications
    for (Job_Application__c app : Trigger.new) {
        if (app.Position__c != null) {
            positionIds.add(app.Position__c);
        }
    }

    // Fetch Positions and update status if required number of hires is reached
    List<Position__c> positionsToUpdate = new List<Position__c>();
    List<Position__c> positions = [SELECT Id, Name, Status__c, Required_Hires__c,
                                          (SELECT Id FROM Job_Applications__r WHERE Status__c = 'Selected')
                                   FROM Position__c
                                   WHERE Id IN :positionIds];

    for (Position__c pos : positions) {
        Integer selectedCount = pos.Job_Applications__r.size();
        if (selectedCount >= pos.Required_Hires__c) {
            pos.Status__c = 'Closed';
            positionsToUpdate.add(pos);
        }
    }

    if (!positionsToUpdate.isEmpty()) {
        update positionsToUpdate;
    }
}