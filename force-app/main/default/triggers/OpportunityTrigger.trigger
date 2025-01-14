trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update, before delete) {
    switch on Trigger.OperationType {
        when  BEFORE_DELETE {
            // Collect Account IDs
            Set<Id> accountIds = new Set<Id>();
            for (Opportunity opp : Trigger.old) {
                if (opp.AccountId != null) {
                    accountIds.add(opp.AccountId);
                }
            }

            // Query related Account records that have Banking Industry Value
            Map<Id, Account> accountMap = new Map<Id, Account>(
                [SELECT Id, Industry 
                FROM Account 
                WHERE Id IN :accountIds AND Industry = 'Banking']
            );

            for(Opportunity deletedOpp: Trigger.old){
                if(deletedOpp.AccountId != null){
                    Account relatedAccount= accountMap.get(deletedOpp.AccountId);
                    if(relatedAccount != null && deletedOpp.StageName == 'Closed Won'){
                        deletedOpp.addError('Cannot delete closed opportunity for a banking account that is won');
                    }
                                     
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

                    //Null check on contact value
                    Contact ceoContact = accountToCEOContactMap.get(opp.AccountId);
                    if (ceoContact != null) {
                        opp.Primary_Contact__c = ceoContact.Id;
                    }
                    
                }
            }          

        }

        
    }

}