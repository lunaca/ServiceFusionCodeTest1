//
//  SearchExerciseViewController.swift
//  fitspire
//
//  Created by LUNVCA on 7/20/17.
//  Copyright © 2017 uca. All rights reserved.
//

import UIKit
import CloudKit
import QuartzCore
import CoreData

class FavoritesViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate{
    let reuseIdentifier = "cell"
    @IBOutlet var collection : UICollectionView!
    
    var favorites: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Peeps")
        fetchRequest.predicate = NSPredicate(format: "faveToggle = %i", 1)
        do {
            favorites = try managedContext.fetch(fetchRequest)
            print("sucess")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        for item in favorites{
            print(item.value(forKey: "firstName"))
        }
        print(favorites.count)
        collection.reloadData()
    }
    
    
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.favorites.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FavoriteCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let contact = favorites[indexPath.row]
        
        cell.name.text = contact.value(forKey: "firstName") as? String
        
        if contact.value(forKey: "contactImage") != nil {
           var NScontactImage = contact.value(forKey: "contactImage") as! NSData
            cell.image.image = UIImage(data: NScontactImage as Data)
        }
        if contact.value(forKey: "contactImage") == nil {
           
            cell.image.image = UIImage(named: "white.png")
        }

   
        
        
        return cell
    }
    
  
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
        print("You selected cell #\(indexPath.item)!")
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {
            
            
            
            let detailsVC = segue.destination as! DetailViewController
            let cell = sender as! FavoriteCollectionViewCell
            let indexPaths = self.collection.indexPath(for: cell)
            
            let contact = self.favorites[indexPaths!.row]
            
            
            detailsVC.contact = contact
            
            
            
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
