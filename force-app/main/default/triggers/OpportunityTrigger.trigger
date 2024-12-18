trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update, before delete) {
    switch on Trigger.OperationType {
        when  BEFORE_DELETE {
            for(Opportunity deletedOpp: Trigger.old){
                if(deletedOpp.StageName == 'Closed Won'){
                    deletedOpp.addError('Cannot delete closed opportunity for a banking account that is won');                 
                }              
            }           
        }

        when BEFORE_UPDATE{
            for(Opportunity tempOpp: Trigger.new){
                if(tempOpp.Amount < 5000){
                    tempOpp.addError('Opportunity amount must be greater than 5000');                 
                }              
            }

            // Collect all AccountIds from the updated Opportunities
    Set<Id> accountIds = new Set<Id>();
    for (Opportunity opp : Trigger.new) {
        accountIds.add(opp.AccountId);
    }

    // Query Contacts with the title 'CEO' related to those Accounts
    Map<Id, Contact> accountToCEOContactMap = new Map<Id, Contact>();
    for (Contact con : [
        SELECT Id, AccountId, Title 
        FROM Contact 
        WHERE AccountId IN :accountIds AND Title = 'CEO'
    ]) {
        accountToCEOContactMap.put(con.AccountId, con);
    }

    // Assign the Primary_Contact__c field on the Opportunity
    for (Opportunity opp : Trigger.new) {
        if (accountToCEOContactMap.containsKey(opp.AccountId)) {
            opp.Primary_Contact__c = accountToCEOContactMap.get(opp.AccountId).Id;
        }
    }

            

        }

        when AFTER_INSERT{
            

        }

        when AFTER_UPDATE{
                       
        }
    }

}