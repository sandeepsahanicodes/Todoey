//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // URL where sqlite file is been saved.
        // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
        // Do any additional setup after loading the view.
    }
    
    // MARK: Add new item.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // What will happen once user will click add item on our UIAlert.
            // print("Success! ")
            guard let unwrappedTitle = textField.text else {
                print("Error while unwrapping optional value of text field")
                return
            }
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = unwrappedTitle
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving items, \(error.localizedDescription)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: Model Manipulation methods
    func saveItem() {
         
          tableView.reloadData()
    }
    
    // MARK: loads item into tasks array with request.
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}

// MARK: Table view datasource methods.

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added"
        }
    
        return cell
    }
}

// MARK: Table View Delegate methods.

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Delete and update the selected row on table view.
        // context.delete(tasksArray[indexPath.row])
        // tasksArray.remove(at: indexPath.row)

        // tasksArray[indexPath.row].done = !tasksArray[indexPath.row].done

        tableView.reloadData()

        // Deselecting selected row with an animation.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Extension for UISearchBar.

//extension TodoListViewController: UISearchBarDelegate {
//    // Quering searched element in search bar.
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request )
//    }
//
//    // Getting original list back after searching element.
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//         // Compilation time problem!
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//}

