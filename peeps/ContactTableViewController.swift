//
//  ContactTableViewController.swift
//  peeps
//
//  Created by LUNVCA on 9/26/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit 
import CoreData

class ContactTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var contact : NSManagedObject!
    @IBOutlet var contactImageView : UIImageView!
 
    @IBOutlet var addPhoneButton : UIButton!
    @IBOutlet var imageButton : UIButton!
    let imagePicker = UIImagePickerController()
    var imageToggle = 0
    
    //textFields
    @IBOutlet var fNameTF : UITextField!
    @IBOutlet var lNameTF : UITextField!
    @IBOutlet var companyTF : UITextField!
    @IBOutlet var phone1TF :UITextField!
    @IBOutlet var phone2TF :UITextField!
    @IBOutlet var phone3TF :UITextField!
    @IBOutlet var email1TF : UITextField!
    @IBOutlet var email2TF : UITextField!
    @IBOutlet var email3TF : UITextField!
    @IBOutlet var address1TF : UITextField!
    @IBOutlet var address2TF : UITextField!
    @IBOutlet var address3TF : UITextField!

    @IBOutlet var newGroupButton : UIButton!
    @IBOutlet var picker : UIPickerView!
    @IBOutlet var myDatePicker : UIDatePicker!
    var groups: [NSManagedObject] = []
    
    var phoneShowToggles : [Bool] = [false,false,false,true]
    var phoneNums : [String] = []
    var phoneShowCount = 0
    
    var emailShowToggles : [Bool] = [false,false,false,true]
    var emails : [String] = []
    var emailShowCount = 0
    
    var addressShowToggles : [Bool] = [false,false,false,true]
    var addresses : [String] = []
    var addressShowCount = 0
    var groupNames : [String] = ["----"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        let imageCheck = contact.value(forKey: "contactImage")
        if imageCheck != nil {
            
            let image = contact.value(forKey: "contactImage") as! NSData
            contactImageView.image = UIImage(data: image as Data)!
        }
        if imageCheck == nil {
            contactImageView.image = UIImage(named: "white.png")!
        }
        setToggles()
        
        let fName = contact.value(forKey: "firstName") as! String
        let lName = contact.value(forKey: "lastName") as! String
        
        self.fNameTF.text = fName
        self.fNameTF.textColor = UIColor.white
        self.fNameTF.attributedPlaceholder = NSAttributedString(string:"first name", attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.lNameTF.text = lName
        self.lNameTF.textColor = UIColor.white
        self.lNameTF.attributedPlaceholder = NSAttributedString(string:"last name", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        self.companyTF.textColor = UIColor.white
        self.companyTF.attributedPlaceholder = NSAttributedString(string:"company", attributes: [NSForegroundColorAttributeName: UIColor.gray])

           }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Groups")
     
        do {
            groups = try managedContext.fetch(fetchRequest1)
            
            for item in groups{
                let groupName = item.value(forKey: "groupName")
                self.groupNames.append(groupName as! String)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    func setToggles(){
       
        let phoneTest = contact.value(forKey: "phone1") as? String
        //phone
        if phoneTest != nil && phoneTest != "" {
            self.phoneShowToggles[0] = true
            self.phoneNums.append(phoneTest!)
            self.phone1TF.text = phoneTest!
            
            let phoneTest2 = contact.value(forKey: "phone2") as? String
            if phoneTest2 != nil && phoneTest2 != ""{
                self.phoneShowCount = 1
                self.phoneShowToggles[1] = true
                self.phoneNums.append(phoneTest2!)
                 self.phone2TF.text = phoneTest2!
               
                let phoneTest3 = contact.value(forKey: "phone3") as? String

                if phoneTest3 != nil && phoneTest3 != ""{
                    self.phoneShowToggles[2] = true
                    self.phoneShowCount = 2
                    self.phoneNums.append(phoneTest3!)
                    self.phone3TF.text = phoneTest3!

                }

    }
        }
        let emailTest = contact.value(forKey: "email1") as? String
        //email
        if emailTest != nil && emailTest != "" {
            self.emailShowToggles[0] = true
            self.emails.append(emailTest!)
            self.email1TF.text = emailTest!
             let emailTest2 = contact.value(forKey: "email2") as? String
            
            
            if emailTest2 != nil && emailTest2 != "" {
                self.emailShowCount = 1
                self.emailShowToggles[1] = true
                self.emails.append(emailTest2!)
                self.email2TF.text = emailTest2!
               
                let emailTest3 = contact.value(forKey: "email3") as? String

                if emailTest3  != nil && emailTest3 != "" {
                    self.emailShowToggles[2] = true
                    self.emailShowCount = 2
                    self.emails.append(emailTest3!)
                      self.email3TF.text = emailTest3!
                }
                
            }
        }
            let addressTest = contact.value(forKey: "address1") as? String
            //address
            if addressTest != nil && addressTest != "" {
                self.addressShowToggles[0] = true
                self.addresses.append(contact.value(forKey: "address1") as! String)
                self.address1TF.text = (contact.value(forKey: "address1") as! String)
                let addressTest2 = contact.value(forKey: "address2") as? String

                if addressTest2 != nil && addressTest2 != "" {
                    self.addressShowCount = 1
                    self.addressShowToggles[1] = true
                    self.addresses.append(addressTest2!)
                    self.address2TF.text = addressTest2!
                    
                    let addressTest3 = contact.value(forKey: "address3") as? String
                    
                    if addressTest3  != nil && addressTest3 != "" {
                        self.addressShowToggles[2] = true
                        self.addressShowCount = 2
                        self.addresses.append(addressTest3!)
                        self.address3TF.text = addressTest3!
                    }
                    
                }

        }
        }
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {  
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            contactImageView.contentMode = .scaleAspectFit
            contactImageView.image = pickedImage
            self.imageToggle = 1
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func groupButtonPressed(sender: UIButton){
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.saveGroup(name: nameToSave)
            self.tableView.reloadData()
            self.picker.reloadAllComponents()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
func saveGroup(name: String) {
    
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return
    }
    
    // 1
    let managedContext =
        appDelegate.persistentContainer.viewContext
    
    // 2
    let entity =
        NSEntityDescription.entity(forEntityName: "Groups",
                                   in: managedContext)!
    
    let group = NSManagedObject(entity: entity,
                                 insertInto: managedContext)
    
    // 3
    group.setValue(name, forKeyPath: "groupName")
    
    // 4
    do {
        try managedContext.save()
        print("Saved Group")
            groups.append(group)
        groupNames.append(name)
        

        picker.reloadAllComponents()
        
    } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
    }
}

    @IBAction func addPhoneButtonPressed(){
        phoneShowToggles[phoneShowCount] = true

        self.phoneShowCount += 1
        
        if  self.phoneShowCount == 3 {
           self.phoneShowToggles[3] = false
            
        }
        tableView.reloadData()
        
    }
    @IBAction func addEmailButtonPressed(){
        emailShowToggles[emailShowCount] = true

        self.emailShowCount += 1
        
        if  self.emailShowCount == 3{
            self.emailShowToggles[3] = false
            
        }
        tableView.reloadData()
        
    }
    @IBAction func addAddressButtonPressed(){
        addressShowToggles[addressShowCount] = true

        self.addressShowCount += 1
        
        if  self.addressShowCount == 3 {
            self.addressShowToggles[3] = false
            
        }
        tableView.reloadData()
        
    }
    @IBAction func saveButtonPressed(sender: UIButton)
    {
        //first name and companies
        var fName = ""
        var lName = ""
        var company = ""
        
        let fNameTest = fNameTF.text
        let lNameTest = lNameTF.text
        let companyTest = companyTF.text
        
         if fNameTest != nil && fNameTest != "" {
            fName = fNameTest!
        }
        if lNameTest != nil && lNameTest != "" {
            lName = lNameTest!
        }
        if companyTest != nil && companyTest != "" {
            company = companyTest!
        }
        
        //now phone
        var phone1 = ""
        var phone2 = ""
        var phone3 = ""
        
        let phone1Test = phone1TF.text
        let phone2Test = phone2TF.text
        let phone3Test = phone3TF.text
        
        if phone1Test != nil && phone1Test != "" {
            phone1 =  phone1Test!
        }
        if phone2Test != nil && phone2Test != "" {
            phone2 = phone2Test!
        }
        if phone3Test != nil && phone3Test != "" {
            phone3 = phone3Test!
        }
        
        //now email
        
        var email1 = ""
        var email2 = ""
        var email3 = ""
        
        let email1Test = email1TF.text
        let email2Test = email2TF.text
        let email3Test = email3TF.text
        
        if email1Test != nil && email1Test != "" {
            email1 =  email1Test!
        }
        if email2Test != nil && email2Test != "" {
            email2 = email2Test!
        }
        if email3Test != nil && email3Test != "" {
            email3 = email3Test!
        }
        
        //now address
        
        var address1 = ""
        var address2 = ""
        var address3 = ""
        
        let address1Test = address1TF.text
        let address2Test = address2TF.text
        let address3Test = address3TF.text
        
        if address1Test != nil && address1Test != "" {
            address1 =  address1Test!
        }
        if address2Test != nil && address2Test != "" {
            address2 = address2Test!
        }
        if address3Test != nil && address3Test != "" {
            address3 = address3Test!
        }
        var groupName : String? = nil
        if picker.selectedRow(inComponent: 0) != 0{
        groupName = groupNames[picker.selectedRow(inComponent: 0) ]
        }
        
        let date = Date()
        let formatter = DateFormatter()
   
        formatter.dateFormat = "MM/dd/yy"
       
        let result = formatter.string(from: date)

       
        
        
        myDatePicker.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let selectedDate = dateFormatter.string(from: myDatePicker.date)
        print(selectedDate)
        var birthday : String?
        if selectedDate != result {
            print("birthdaySet")
            birthday = selectedDate
        }
        
        
    
        if imageToggle == 1 {
            let userImage = contactImageView.image
            
            let imageData = NSData(data: UIImageJPEGRepresentation(userImage!, 1.0)!)
            contact.setValue(imageData, forKey: "contactImage")

        }
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // 1 first get context
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2 then get entity
        _ =
            NSEntityDescription.entity(forEntityName: "Peeps",
                                       in: managedContext)!
        
        self.contact.setValue(fName, forKeyPath: "firstName")
        self.contact.setValue(lName, forKey: "lastName")
        
        self.contact.setValue(email1, forKeyPath: "email1")
        self.contact.setValue(email2, forKeyPath: "email2")
        self.contact.setValue(email3 , forKeyPath: "email3")
        self.contact.setValue(phone1, forKeyPath: "phone1")
        self.contact.setValue(phone2, forKey: "phone2")
        self.contact.setValue(phone3, forKey: "phone3")
        self.contact.setValue(address1, forKeyPath: "address1")
        self.contact.setValue(address2, forKey: "address2")
        self.contact.setValue(address3, forKey: "address3")

        if groupName != nil {
            self.contact.setValue(groupName!, forKey: "groupName")
        }
        if birthday != nil {
            self.contact.setValue(birthday!, forKey: "birthday")
        }

        do {
            try managedContext.save()
            print("Success")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
           HUD.flash(.success, delay: 1.0)
        let when = DispatchTime.now() + 1.3 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            _ = self.navigationController?.popViewController(animated: true)

            
        }

    }
    
 

    

    
    
    
    @IBAction func minusButtonPressed(sender:UIButton){
        
        switch sender.tag {
        case 0:
           self.phone1TF.text = ""
        case 1:
            self.phone2TF.text = ""
        case 2:
            self.phone3TF.text = ""
        case 3:
            self.email1TF.text = ""
        case 4:
            self.email2TF.text = ""
        case 5:
            self.email3TF.text = ""
        case 6:
            self.address1TF.text = ""
        case 7:
            self.address2TF.text = ""
        case 8:
            self.address3TF.text = ""

            
        default:
            break


        
        
        }

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && !(phoneShowToggles[indexPath.row]) {
             return 0.0
        }
    if indexPath.section == 1 && !(emailShowToggles[indexPath.row]) {
        return 0.0

    }
    if indexPath.section == 2 && !(addressShowToggles[indexPath.row]) {
        return 0.0
    }

    if indexPath.section == 3 {
        return 150.0
    }
    if indexPath.section == 4 && indexPath.row == 0{
        return 150.0
    }
    return 55.0

        }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupNames.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupNames[row]
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
