//
//  AddContactsViewController.swift
//  peeps
//
//  Created by LUNVCA on 9/25/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit
import Contacts


class AddContactsViewController: ViewController {
    var importToggle = false
    var contactIDS : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func buttonPressed(button: UIButton) {
        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                let req = CNContactFetchRequest(keysToFetch: [
                CNContactIdentifierKey as CNKeyDescriptor
                    ])
                
                
                var message: String!
                
                let contactsStore = AppDelegate.getAppDelegate().contactStore
                do {
                    try contactsStore.enumerateContacts(with: req) {
                        contact, stop in
                      
                        self.contactIDS.append(contact.identifier)
                    }
                    
                    if self.contactIDS.count == 0 {
                        message = "No contacts were found!."
                    }
                }
                catch {
                    message = "Unable to fetch contacts."
                }
                
                
                if message != nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        AppDelegate.getAppDelegate().showMessage(message: message)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: { () -> Void in
                        print("contacts found")
                        self.performSegue(withIdentifier: "toContactLoader", sender: self)

                    })                               }
        }
        
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toContactLoader" {
                let ContactLoaderViewController = segue.destination as! ContactLoaderViewController
                for i in contactIDS{
                ContactLoaderViewController.contactIDS.append(i)
                }
            }
        }
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
