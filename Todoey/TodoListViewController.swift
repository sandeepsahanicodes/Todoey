//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var tasksArray = ["Ask for ear piece","Visit dentist","Buy Handwash "]
    let defaults = UserDefaults.standard
    override func viewDidLoad()
    {
        super.viewDidLoad()
        guard let items = defaults.array(forKey: "TodoListArray") as? [String] else
        {
            print("Error while unwrapping optional value!!")
            return
        }
        tasksArray = items
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
            self.tasksArray.append(safeText)
            self.defaults.set(self.tasksArray, forKey: "TodoListArray")
            self.tableView.reloadData()
            // print(textField.text)
            
        }
        alert.addTextField { alertTextField in
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
}

// MARK: Table view datasource methods.
extension TodoListViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tasksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = tasksArray[indexPath.row]
        return cell
       }
}

// MARK: Table View Delegte methods.
extension TodoListViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Adds check mark image in cell when its selected and remove it when selected second time.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        // Deselecting selected row with an animation.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

