trigger AccountTriggers on Account (before insert, before update, after insert, after update) {

    switch on Trigger.OperationType {
        when  BEFORE_INSERT {
            for(Account tempAcc: Trigger.new){
                if(tempAcc.Name!= null){
                    tempAcc.Type = 'Prospect';
                    tempAcc.Rating = 'Hot';
                    
                }
            }
        }

        when BEFORE_UPDATE{

        }

        //* 4. Create a contact for each account inserted.
        when AFTER_INSERT{
            list <Contact> createConts = new list <Contact>();
            Contact tempCont = new Contact();
            for(Account tempAcc: Trigger.new){
                if(tempAcc.Name!= null){
                    tempCont.FirstName = tempAcc.Name;
                    tempCont.LastName = tempAcc.Name.substring(0)+'_lastname';
                    tempCont.AccountId=tempAcc.Id;
                    tempCont.Email = 'jdummyrec@email.com';
                    createConts.add(tempCont);
                }
            }

            insert createConts;
        }

        when AFTER_UPDATE{
            
        }
       
    }
}