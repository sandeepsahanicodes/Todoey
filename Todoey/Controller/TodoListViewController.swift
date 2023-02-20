//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit


@available(iOS 16.0, *)
class TodoListViewController: UITableViewController {

    var tasksArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(component: "Items.plist")
   
    let defaults = UserDefaults.standard
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        // print(dataFilePath)
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
            let newItem = Item()
            newItem.title = safeText
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
        let encoder = PropertyListEncoder()
         
         do{
             
             let data = try encoder.encode(tasksArray)
             try data.write(to: dataFilePath!)
         }
         catch
         {
           print("Error encoding task array \(error)")
         }
          tableView.reloadData()
    }
    // MARK: loads item into tasks array.
    func loadItems()
    {
        do {
            
            let data = try Data(contentsOf: dataFilePath!)
            let decoder = PropertyListDecoder()
            tasksArray = try decoder.decode([Item].self, from: data)
        }
        catch
        {
            print("Error while decoding data \(error)")
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
        
//        if item.done == true
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
        
        tasksArray[indexPath.row].done = !tasksArray[indexPath.row].done
        self.saveItem()
        
        tableView.reloadData()
        // Deselecting selected row with an animation.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

