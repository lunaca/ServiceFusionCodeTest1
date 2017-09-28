//
//  DetailViewController.swift
//  peeps
//
//  Created by LUNVCA on 9/26/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit
import CoreData
class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var contact : NSManagedObject!
    var headers : [String] = []
    var rowCount :  [Int] = []
    var rows : [String] = []
    var faveToggle = 0;
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    var indices : [Int] = [0]
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var contactName : UILabel!
    @IBOutlet var textButton : UIButton!
    @IBOutlet var callButton : UIButton!
    @IBOutlet var emailButton : UIButton!
    @IBOutlet var faveButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generator.prepare()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
       var name = contact.value(forKey: "firstName") as! String
        contactName.text = name
        self.headers = []
        self.rows = []
        self.rowCount = []
        self.indices = [0]
        self.faveToggle = contact.value(forKey: "faveToggle") as! Int
        
        if faveToggle == 1 {
            faveButton.setImage(UIImage(named: "faveON.png"), for: .normal)
        }
        
        
        
        var imageCheck = contact.value(forKey: "contactImage")
        
        if imageCheck != nil {
            
            let image = contact.value(forKey: "contactImage") as! NSData
            imageView.image = UIImage(data: image as Data)!
        }
        if imageCheck == nil {
           imageView.image = UIImage(named: "white.png")!
        }

        determineSections()
        configureButtons()
        // Do any additional setup after loading the view.
        tableView.reloadData()
    }
    func determineSections(){
        var total = 0
        var rowCounter = 0
        var nicknameTest = contact.value(forKey: "company") as? String
        //company
        if nicknameTest != nil && nicknameTest != "" {
            self.headers.append("Company")
            self.rows.append(contact.value(forKey: "company") as! String)
            rowCounter += 1
            rowCount.append(rowCounter)
            total += rowCounter
            indices.append(total)
        }
        rowCounter = 0
        var phoneTest = contact.value(forKey: "phone1") as? String
        //phone
         if phoneTest != nil && phoneTest != "" {
               self.headers.append( "Phone")
            textButton.setImage(UIImage(named: "textON.png"), for: .normal)
            textButton.backgroundColor = UIColor.black
            callButton.setImage(UIImage(named: "callON.png"), for: .normal)
            callButton.backgroundColor = UIColor.black
            callButton.isUserInteractionEnabled = true

            
            
            self.rows.append(contact.value(forKey: "phone1") as! String)
            rowCounter += 1
            var phoneTest2 = contact.value(forKey: "phone2") as? String

            if phoneTest2 != nil  && phoneTest2 != "" {
                self.rows.append(phoneTest2 as! String)
                rowCounter += 1
                  var phoneTest3 = contact.value(forKey: "phone3") as? String
                if phoneTest3 != nil   && phoneTest3 != ""{
                    self.rows.append(phoneTest3 as! String)
                    rowCounter += 1
                }
            }
            rowCount.append(rowCounter)
            total += rowCounter
            indices.append(total)
        }
        rowCounter = 0
        var emailTest = contact.value(forKey: "email1") as? String
     //email
        if emailTest != nil && emailTest != "" {
            self.headers.append("Email")
            emailButton.setImage(UIImage(named: "emailON.png"), for: .normal)
            emailButton.backgroundColor = UIColor.black
            emailButton.isEnabled = true
            self.rows.append(contact.value(forKey: "email1") as! String)
            rowCounter += 1
            var emailTest2 = contact.value(forKey: "email2") as? String
            
            if emailTest2 != nil  && emailTest2 != "" {
                self.rows.append(emailTest2 as! String)
                rowCounter += 1
                var emailTest3 = contact.value(forKey: "email3") as? String
                if emailTest3 != nil   && emailTest3 != ""{
                    self.rows.append(emailTest3 as! String)
                    rowCounter += 1
                }
            }
            rowCount.append(rowCounter)
            total += rowCounter
            indices.append(total)
        }
        rowCounter = 0
        var addressTest = contact.value(forKey: "address1") as? String
        //address
        if addressTest != nil && addressTest != "" {
            self.headers.append("Address")
            
            self.rows.append(contact.value(forKey: "address1") as! String)
            rowCounter += 1
            var addressTest2 = contact.value(forKey: "address2") as? String
            
            if addressTest2 != nil  && addressTest2 != "" {
                self.rows.append(addressTest2 as! String)
                rowCounter += 1
                var addressTest3 = contact.value(forKey: "address3") as? String
                if addressTest3 != nil   && addressTest3 != ""{
                    self.rows.append(addressTest3 as! String)
                    rowCounter += 1
                }
            }

            rowCount.append(rowCounter)
            total += rowCounter
            indices.append(total)
        }

        //birthday
        rowCounter = 0
        var birthdayTest = contact.value(forKey: "birthday") as? String
       
        if birthdayTest != nil && birthdayTest != "" {

               self.headers.append( "Birthday")
            self.rows.append(contact.value(forKey: "birthday") as! String)
              rowCounter += 1
         rowCount.append(rowCounter)
            total += rowCounter
            indices.append(total)
        }

        
        
        
        
    }
    func configureButtons(){
        
        callButton.layer.cornerRadius = 10.0;
        callButton.clipsToBounds = true;
        
        textButton.layer.cornerRadius =    10.0;
        textButton.clipsToBounds = true;
        
        emailButton.layer.cornerRadius = 10.0;
        emailButton.clipsToBounds = true;
        
        

        
    }
    
    @IBAction func phoneButtonPressed(sender: UIButton){
          print("calling phone")
    }
    @IBAction func faveButtonPressed(sender: UIButton){
        generator.impactOccurred()
        generator.prepare()
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
        

        var changeToggle = 0
     
        if self.faveToggle == 0 {
            changeToggle = 1
            self.faveToggle = 1
            faveButton.setImage(UIImage(named: "faveON.png"), for: .normal)
              self.contact.setValue(1, forKey: "faveToggle")
        }
        if self.faveToggle == 1 && changeToggle != 1{
           
            self.faveToggle = 0
            faveButton.setImage(UIImage(named: "faveOFF.png"), for: .normal)
            self.contact.setValue(0, forKey: "faveToggle")
            
        }
        do {
            try managedContext.save()
            print("Success")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
               return headers.count
    }

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
  
        return rowCount[section]
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
    
    print(indices[indexPath.section] + indexPath.row)
       cell.textLabel?.text = rows[indices[indexPath.section] + indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return headers[section]
    }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toEdit" {
                
                let detailsVC = segue.destination as! ContactTableViewController
                let thisContact = self.contact
                detailsVC.contact = thisContact
                
            }

    }


}
