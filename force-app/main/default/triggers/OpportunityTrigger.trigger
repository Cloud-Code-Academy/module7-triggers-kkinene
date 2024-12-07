trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    switch on Trigger.OperationType {
        when  BEFORE_INSERT {
           
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