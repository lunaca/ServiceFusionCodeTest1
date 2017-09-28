//
//  AllTableViewController.swift
//  peeps
//
//  Created by LUNVCA on 9/25/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit
import CoreData
class AllTableViewController: UITableViewController, UISearchBarDelegate {
    var contacts : [NSManagedObject] = []
    var contactFullNames : [String] = []
    var searchToggle = false
    var images : [UIImage] = []
     @IBOutlet var searchBar : UISearchBar!
    var sections : [(index: Int, length :Int, title: String)] = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Peeps")
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest1.sortDescriptors = sortDescriptors
        do {
            self.contacts = try managedContext.fetch(fetchRequest1)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        populateNames(contacts: contacts)
        setupSections()
        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupSearchBar()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        contacts.removeAll()
        contactFullNames.removeAll()
        sections.removeAll()
        images = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Peeps")
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest1.sortDescriptors = sortDescriptors
        do {
            self.contacts = try managedContext.fetch(fetchRequest1)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        populateNames(contacts: contacts)
        setupSections()
        
       
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupSearchBar()
        tableView.reloadData()
    }
    
    
func setupSections(){
    var index = 0
   
    for var i in (0..<self.contactFullNames.count) {
        
        let commonPrefix = contactFullNames[i].commonPrefix(with: contactFullNames[index], options: .caseInsensitive)
        
        if (commonPrefix.characters.count == 0 ) {
            
            let string = contactFullNames[index].uppercased();
            
            let firstCharacter = string[string.startIndex]
            
            let title = "\(firstCharacter)"
            
            let newSection = (index: index, length: i - index, title: title)
            
            self.sections.append(newSection)
            
            index = i;
            
        }
        
}

    }
    func setupSearchBar() {
        
        
        searchBar.delegate = self
     
        searchBar.isTranslucent = true
        searchBar.placeholder = "Search Anything!"
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.keyboardAppearance = .dark
        searchBar.tintColor = UIColor.red
        
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      self.searchToggle = true
           searchBar.showsCancelButton = true
        fetchContacts(searchPredicate: searchText)
       
    }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        searchBar.resignFirstResponder()
        // Hide the cancel button
        searchBar.showsCancelButton = false
        self.viewWillAppear(true)
        searchToggle = false
        // You could also change the position, frame etc of the searchBar
        self.tableView.reloadData()
    }
    
    func fetchContacts(searchPredicate: String) {
       self.contacts =  []
        self.contactFullNames = []
        self.sections.removeAll()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // 1 first get context
        let moc = appDelegate.persistentContainer.viewContext
        let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Peeps")
     
        let subPredicate1 = NSPredicate(format: "(firstName CONTAINS %@)", searchPredicate)
        let subPredicate2 = NSPredicate(format: "(lastName CONTAINS %@)", searchPredicate)
        let subPredicate3 = NSPredicate(format: "(nickname CONTAINS %@)", searchPredicate)
        let subPredicate4 = NSPredicate(format: "(phone1 CONTAINS %@)", searchPredicate)
          let subPredicate5 = NSPredicate(format: "(email1 CONTAINS %@)", searchPredicate)
          let subPredicate6 = NSPredicate(format: "(company CONTAINS %@)", searchPredicate)
          let subPredicate7 = NSPredicate(format: "(address1 CONTAINS %@)", searchPredicate)
        
        myRequest.predicate = NSCompoundPredicate(type: .or, subpredicates: [subPredicate1, subPredicate2, subPredicate3, subPredicate4, subPredicate5, subPredicate6, subPredicate7])
        
        
        do{
           self.contacts = try moc.fetch(myRequest) as! [NSManagedObject]
            
           
                populateNames(contacts: contacts as! [NSManagedObject])
                setupSections()
            
            
        } catch let error{
            print(error)
        }
        DispatchQueue.main.async(){
            self.tableView.reloadData()
           
          
        }
        
            }
    

func populateNames (contacts: [NSManagedObject]){
    for item in contacts{
        var thisFirstName = item.value(forKey: "firstName") as! String
        var thisLastName = item.value(forKey: "lastName") as? String
        
        var fullName = thisFirstName
        
        if thisLastName != nil {
            fullName = thisFirstName + " " +  thisLastName!
        }
        self.contactFullNames.append(fullName)
       
        
        
        var imageCheck = item.value(forKey: "contactImage")
        
        if imageCheck != nil {

        let image = item.value(forKey: "contactImage") as! NSData
        images.append(UIImage(data: image as Data)!)
        }
        if imageCheck == nil {
            images.append(UIImage(named: "white.png")!)
        }
    }
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.searchToggle == false{
        return sections.count
        }
      return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.searchToggle == false{
          return sections[section].length
        }
        return contactFullNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllTableViewCell;
        if self.searchToggle == false{
            cell.name.text = contactFullNames[sections[indexPath.section].index + indexPath.row]
           cell.pic.image = images[sections[indexPath.section].index + indexPath.row]
            cell.pic.layer.cornerRadius = 5.0;
            cell.pic.clipsToBounds = true;

        }
        if self.searchToggle == true {
            cell.name.text = contactFullNames[indexPath.row]
            cell.pic.image = images[indexPath.row]
            cell.pic.layer.cornerRadius = 5.0;
            cell.pic.clipsToBounds = true;

        }

     
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.black
        if searchToggle == false {
        let label = UILabel()
        label.text = sections[section].title
        label.frame = CGRect(x: 25, y: 5, width: 50, height: 35)
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir Heavy", size: 30.0)
        
        view.addSubview(label)
        }
        return view
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        

        return sections.map { $0.title }
        
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return index
        
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

    func deleteContact(contact: NSManagedObject) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Peeps",
                                       in: managedContext)!
        
        
        // 3
        managedContext.delete(contact)
        // 4
        do {
            try managedContext.save()
            print("Deleted Contact")
            
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            print("index Path section is ")
            print(indexPath.section)
            
            print("index Path row is ")
            print(indexPath.row)
            var thisContact : NSManagedObject?
            if searchToggle == false{
                thisContact = contacts[sections[(indexPath.section)].index + (indexPath.row)]
            }
            if searchToggle == true{
                thisContact = contacts[(indexPath.row)]
            }

            deleteContact(contact: thisContact!)

            self.viewWillAppear(true)
            
            
            
            // you would also save the new array here so that the next time you open the tableview viewController it shows the changes made.
            
            
            
        }
    }

 override func prepare(for segue: UIStoryboardSegue, sender: Any?){
 if segue.identifier == "toDetail" {
 
 
 
 let detailsVC = segue.destination as! DetailViewController
 let cell = sender as! AllTableViewCell
 let indexPath =  self.tableView.indexPath(for: cell)
    
    var thisContact : NSManagedObject?
    if searchToggle == false{
  thisContact = contacts[sections[(indexPath?.section)!].index + (indexPath?.row)!]
    }
    if searchToggle == true{
        thisContact = contacts[(indexPath?.row)!]
    }
 detailsVC.contact = thisContact
 
 }
 }
 }


