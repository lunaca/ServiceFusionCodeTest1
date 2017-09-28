//
//  ContactLoaderViewController.swift
//  peeps
//
//  Created by LUNVCA on 9/25/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit
import Contacts
import CoreData


class ContactLoaderViewController: ViewController {
    var contactIDS : [String] = []
    @IBOutlet var button : UIButton!
    
    
      let contactsStore = AppDelegate.getAppDelegate().contactStore
    override func viewDidLoad() {
        super.viewDidLoad()
  
         }
    @IBAction func buttonPressed(sender: UIButton){

        let predicate = CNContact.predicateForContacts(withIdentifiers: self.contactIDS)
        
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactImageDataAvailableKey, CNContactBirthdayKey, CNContactNicknameKey, CNContactPostalAddressesKey]
        
        var fullContacts = [CNContact]()
        var message: String!
        
        
        
        do {
            fullContacts = try self.contactsStore.unifiedContacts(matching: predicate, keysToFetch: keys as [CNKeyDescriptor])
            
            if fullContacts.count == 0 {
                message = "No contacts were found???."
            }
        }
        catch {
            message = "Unable to fetch contacts."
        }
        var count1 = 0
        var full = fullContacts.count-1
        
        //now that we have all the contacts, we will save the entries into CORE DATA
        
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // 1 first get context
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2 then get entity
        let entity =
            NSEntityDescription.entity(forEntityName: "Peeps",
                                       in: managedContext)!
        
        
        //this loop will saving all of the contact info!!
        for contact in fullContacts{
            var progress = CGFloat(count1/full)
          
            
       
            var firstName = contact.givenName
           
            
            var lastName = contact.familyName
          
            var birthday : String = ""
            if contact.birthday != nil{
                birthday = String(describing: contact.birthday!.month!) + "/" + String(describing: contact.birthday!.day!) + "/" + String(describing: contact.birthday!.year!)
                
            }
            var nickname = contact.nickname
           
            
            var count = 0
            var email1 : String?
            var email2 : String?
            var email3 : String?
            
            for item in contact.emailAddresses{
                if count == 0{
                    email1 = item.value as String
                  
                }
                if count == 1{
                    email2 = item.value as String
                    
                }
                if count == 2 {
                    email3 = item.value as String
                   
                }
                count += 1
            }
            count = 0
            var phone1 : String?
            var phone2 : String?
            var phone3 : String?
            
            for item in contact.phoneNumbers{
                if count == 0{
                    phone1 = item.value.stringValue as String
                    
                }
                if count == 1{
                    phone2 = item.value.stringValue as String
                  
                }
                if count == 2 {
                    phone3 = item.value.stringValue as String
                
                }
                count += 1
            }

      
            let incomingPerson = NSManagedObject(entity: entity,
                                                 insertInto: managedContext)
            
            var userImage : UIImage?
            if let imageData = contact.imageData {
                //If so create the image
                userImage = UIImage(data: imageData)
              
                let imageData = NSData(data: UIImageJPEGRepresentation(userImage!, 1.0)!)
                incomingPerson.setValue(imageData, forKey: "contactImage")

            }

            
            // 3
            incomingPerson.setValue(firstName, forKeyPath: "firstName")
            incomingPerson.setValue(lastName, forKey: "lastName")
            incomingPerson.setValue(nickname, forKeyPath: "nickname")
            incomingPerson.setValue(email1, forKeyPath: "email1")
            incomingPerson.setValue(email2, forKeyPath: "email2")
            incomingPerson.setValue(email3 , forKeyPath: "email3")
            incomingPerson.setValue(phone1, forKeyPath: "phone1")
            incomingPerson.setValue(phone2, forKey: "phone2")
            incomingPerson.setValue(phone3, forKey: "phone3")
            incomingPerson.setValue(birthday, forKey: "birthday")
            incomingPerson.setValue(0, forKey: "faveToggle")
            
            count1 += 1
            do {
                try managedContext.save()
                print("Success")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            
        }
        
        HUD.flash(.success, delay: 1.0)
        let when = DispatchTime.now() + 1.3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
         self.performSegue(withIdentifier: "loadFinished", sender: self)

    }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
