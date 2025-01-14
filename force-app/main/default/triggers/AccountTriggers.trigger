trigger AccountTriggers on Account (before insert, before update, after insert, after update) {

    switch on Trigger.OperationType {
        when  BEFORE_INSERT {
            for(Account tempAcc: Trigger.new){
                
                if(String.isBlank(tempAcc.Type)){
                    tempAcc.Type = 'Prospect';
                    tempAcc.Rating = 'Hot';                    
                }
                

                // Copy Shipping Address to Billing Address if Shipping is populated
                if (tempAcc.ShippingStreet != null ) {
                
                    tempAcc.BillingStreet = tempAcc.ShippingStreet;
                }

                if (tempAcc.ShippingCity != null) {
                
                    tempAcc.BillingCity = tempAcc.ShippingCity;                    
                }
                if (tempAcc.ShippingState != null) {
                
                    tempAcc.BillingState = tempAcc.ShippingState;                   
                }
                if (tempAcc.ShippingPostalCode != null) {
                
                    tempAcc.BillingPostalCode = tempAcc.ShippingPostalCode;
                    
                }
                if (tempAcc.ShippingCountry != null) {
                    tempAcc.BillingCountry = tempAcc.ShippingCountry;
                }
            }
        }

        

        when AFTER_INSERT{
            List<Contact> createContacts = new List<Contact>();
            for (Account tempAcc : Trigger.new) {
                if (tempAcc.Name != null) {
                    //Understand that the only reason this works is that the creation is on a different object
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

       
    }
}