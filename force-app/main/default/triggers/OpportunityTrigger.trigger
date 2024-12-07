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

        }

        when AFTER_INSERT{
            

        }

        when AFTER_UPDATE{
            
        }
    }

}