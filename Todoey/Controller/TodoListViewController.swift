//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData


@available(iOS 16.0, *)
class TodoListViewController: UITableViewController
{

    var tasksArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        // URL where sqlite file is been saved.
//        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        print(dataFilePath)

        loadItems()
    
        // Do any additional setup after loading the view.
    }
    
    // MARK: Add new item.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // What will happen once user will click add item on our UIAlert.
            // print("Sucess! ")
            guard let safeText = textField.text else
            {
                print("Error while unwrapping optional")
                return
            }
            
            let newItem = Item(context: self.context)
            newItem.title = safeText
            newItem.done = false
            self.tasksArray.append(newItem)
            
            self.saveItem()
        }
        alert.addTextField { alertTextField in
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: Model Manipulation methods
    func saveItem()
    {
    
         do
         {
             try self.context.save()
         }
         catch
         {
           print("Error Saving context \(error)")
         }
          tableView.reloadData()
    }
    
    // MARK: loads item into tasks array.
    func loadItems()
    {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
         do
        {
            // Fetch data from persistent container.
            tasksArray = try context.fetch(request)
        }
        catch
        {
            print("Error while fetching data from context \(error)")
        }
       
    }
    
}

// MARK: Table view datasource methods.
@available(iOS 16.0, *)
extension TodoListViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tasksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let item = tasksArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//         if item.done == true
//        {
//            cell.accessoryType = .checkmark
//        }
//        else
//        {
//            cell.accessoryType = .none
//        }
        
        // Terniary expression of above statement
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
        
    }
}

// MARK: Table View Delegte methods.
@available(iOS 16.0, *)
extension TodoListViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Adds check mark image in cell when its selected and remove it when selected second time.
//        if tasksArray[indexPath.row].done == false
//        {
//            tasksArray[indexPath.row].done = true
//        }
//        else
//        {
//            tasksArray[indexPath.row].done = false
//        }
        
        // Delete and upadate the selected row on table view.
        context.delete(tasksArray[indexPath.row])
        tasksArray.remove(at: indexPath.row)
        
        // tasksArray[indexPath.row].done = !tasksArray[indexPath.row].done
    
        self.saveItem()
        
        tableView.reloadData()
        // Deselecting selected row with an animation.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Extension for UISearchBar.
@available(iOS 16.0, *)
extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // print(searchBar.text!)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
    }
}

