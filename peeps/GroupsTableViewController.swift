//
//  AllTableViewController.swift
//  peeps
//
//  Created by LUNVCA on 9/25/17.
//  Copyright © 2017 lunaca software solutions. All rights reserved.
//

import UIKit
import CoreData
class GroupsTableViewController: UITableViewController{
    var groups : [NSManagedObject] = []
    var contactFullNames : [String] = []
    var searchToggle = false
    var contacts : [NSManagedObject] = []
    var groupCounts : [Int] = []
    var indices :[Int] = [0]
    var groupsCount = 0
    var contactCounter = 0
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupCounts.removeAll()
        groups.removeAll()
        contactFullNames.removeAll()
        indices = [0]
        print("view will appear was called")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Groups")
        let sortDescriptor = NSSortDescriptor(key: "groupName", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest1.sortDescriptors = sortDescriptors
        do {
            groups = try managedContext.fetch(fetchRequest1)
            self.groupsCount = groups.count
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        populateGroups(groups: groups)
       
        var total = 0
        for item in groupCounts{
            let thisValue = item + total
            self.indices.append(thisValue)
            total += item
        }
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        print(contacts.count)
        
           }
    
    
    
    
    
    
    func populateGroups (groups: [NSManagedObject]){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        // 1 first get context
        let moc = appDelegate.persistentContainer.viewContext
      
        _ = 0
        for item in groups{
            let groupName = item.value(forKey: "groupName") as! String
            
            let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Peeps")
            
            let predicate1 = NSPredicate(format: "groupName =%@", groupName)
            
            myRequest.predicate = predicate1
            
            
            do{
                let groupContacts = try moc.fetch(myRequest)
                self.groupCounts.append(groupContacts.count)
                
                
                for item in groupContacts{
                contacts.append(item as! NSManagedObject)
                }
                
                
                
            } catch let error{
                print(error)
            }
            DispatchQueue.main.async(){
                self.tableView.reloadData()
                
                
            }

                  }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       
            return self.groupsCount
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
              return self.groupCounts[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllTableViewCell;
        if contacts.count != 0 {
            cell.name.text = contacts[contactCounter].value(forKey: "firstName") as? String
        
        let imageTest = contacts[contactCounter].value(forKey: "contactImage") as? NSData
        if imageTest != nil{
            cell.pic.image = UIImage(data: imageTest! as Data)
        }
        if imageTest == nil{
            cell.pic.image = UIImage(named: "white.png")
        }
            cell.pic.layer.cornerRadius = 5.0;
            cell.pic.clipsToBounds = true;
          
        
        self.contactCounter += 1
        if (contactCounter == contacts.count){
            contactCounter = 0
        }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.black
      let group =  self.groups[section]
            let label = UILabel()
            label.text = group.value(forKey: "groupName") as? String
            label.frame = CGRect(x: 25, y: 5, width: 500, height: 35)
            label.textColor = UIColor.white
            label.font = UIFont(name: "Avenir Heavy", size: 30.0)
            
            view.addSubview(label)
        
        return view
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group =  self.groups[section]
       
        let headerTitle = group.value(forKey: "groupName") as! String
        return headerTitle
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    func clearGroup(contact: NSManagedObject) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        _ =
            NSEntityDescription.entity(forEntityName: "Peeps",
                                       in: managedContext)!
        
        
        // 3
        contact.setValue(nil, forKeyPath: "groupName")
        
        // 4
        do {
            try managedContext.save()
            print("Cleared Group")
            
            
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
            
              let thisContact = contacts[self.indices[indexPath.section] + indexPath.row ]
            clearGroup(contact: thisContact)
               contacts.remove(at: self.indices[indexPath.section] + indexPath.row )
          self.viewWillAppear(true)
         
           
            
            // you would also save the new array here so that the next time you open the tableview viewController it shows the changes made.
            
            
            
        }
    }
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toDetail" {
            
            
            
            let detailsVC = segue.destination as! DetailViewController
            let cell = sender as! AllTableViewCell
            let indexPath =  self.tableView.indexPath(for: cell)
            let index = (self.indices[(indexPath?.section)!] + (indexPath?.row)! ) 
            print(index)
            let thisContact = contacts[index]
            detailsVC.contact = thisContact
            
        }
    }
}


