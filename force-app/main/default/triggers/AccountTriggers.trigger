trigger AccountTriggers on Account (before insert, before update, after insert, after update) {

    switch on Trigger.OperationType {
        when  BEFORE_INSERT {
            for(Account tempAcc: Trigger.new){
                if(tempAcc.Type == null){
                    tempAcc.Type = 'Prospect';
                    tempAcc.Rating = 'Hot';                    
                }

                // Copy Shipping Address to Billing Address if Shipping is populated
                /*if (tempAcc.ShippingStreet != null || tempAcc.ShippingCity != null || 
                    tempAcc.ShippingState != null || tempAcc.ShippingPostalCode != null || 
                    tempAcc.ShippingCountry != null) */
                tempAcc.BillingStreet = tempAcc.ShippingStreet;
                tempAcc.BillingCity = tempAcc.ShippingCity;
                tempAcc.BillingState = tempAcc.ShippingState;
                tempAcc.BillingPostalCode = tempAcc.ShippingPostalCode;
                tempAcc.BillingCountry = tempAcc.ShippingCountry;
                
            }
        }

        when BEFORE_UPDATE{
            
            /* 4. Create a contact for each account inserted.
            list <Contact> createConts = new list <Contact>();
            Contact tempCont = new Contact(); // According to ChatGpt this should be in the loop
            for(Account tempAcct: Trigger.new){
                if(tempAcct.Name!= null){
                    tempCont.FirstName = tempAcct.Name;
                    tempCont.LastName = tempAcct.Name.substring(0)+'_lastname';
                    tempCont.AccountId=tempAcct.Id;
                    tempCont.Email = 'jdummyrec@email.com';
                    createConts.add(tempCont);
                }                
            }    

            insert createConts;  
            */

        }

        when AFTER_INSERT{
            List<Contact> createContacts = new List<Contact>();
            for (Account tempAcc : Trigger.new) {
                if (tempAcc.Name != null) {
                    // Create a Contact for each newly inserted Account
                    Contact tempContact = new Contact(
                        FirstName = tempAcc.Name,
                        LastName = 'DefaultContact',
                        AccountId = tempAcc.Id,
                        Email = 'default@email.com'
                    );
                    createContacts.add(tempContact);
                }
            }

            // Insert Contacts
            if (!createContacts.isEmpty()) {
                insert createContacts;
            }

        }

        when AFTER_UPDATE{
            
        }
    }
}