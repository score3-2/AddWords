//
//  TableViewController.swift
//  AddWords
//
//  Created by zero on 8/25/18.
//  Copyright © 2018 Abel C. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
        
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //A
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        
        //B fetch = ir a buscar || traer || extraer
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        
        //C
        do {
            managedObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Couldn't get data back error was: \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Properties
    
    var managedObjects:[NSManagedObject] = []

    // MARK - Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return managedObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // Confiure the cell...
        let managedObject = managedObjects[indexPath.row]
        cell.textLabel?.text = managedObject.value(forKey: "word") as? String

        return cell
    }
  
    func saveWord(word: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate!.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "List", in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        managedObject.setValue(word, forKey: "word")
        do {
            try managedContext.save()
            managedObjects.append(managedObject)
        } catch let error as NSError {
            print("Could not be saved. Error \(error), \(error.userInfo)" )
        }
    }
    
    // Actions
    @IBAction func addWords(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Word", message: "Add New Word", preferredStyle: .alert)
        
        
        let save = UIAlertAction(title: "Add", style: .default, handler: {
            
            (action:UIAlertAction) -> Void in
            
            let textField = alert.textFields!.first
            self.saveWord(word: textField!.text!)
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        {(action: UIAlertAction) -> Void in }
        
        alert.addTextField {(textField:UITextField) -> Void in}
        
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
 
    
}//End

