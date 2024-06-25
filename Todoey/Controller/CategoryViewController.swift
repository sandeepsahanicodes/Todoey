//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sandeep Sahani on 25/02/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()

    var categoriesArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 85.0
        loadCategories()
    }
    
    // Adds an element when button is tapped.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            // What will happen once user will click add item on our UIAlert.
            // print("Success!")
            guard let category = textField.text else {
                print("Error while unwrapping optional")
                return
            }
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: Saves entered data in core data database.
    private func save(category: Category) {
        do {
            // Fetch data from persistent container.
            try realm.write({
                realm.add(category)
            })
        }
        catch {
            print("Error saving category \(error)")
        }
        // Reload table view
        tableView.reloadData()
        
    }
    
    // MARK: loads categories request.
    func loadCategories() {
        categoriesArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
}

// MARK: TableView Datasource and Delegate Methods
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        let category = categoriesArray?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Categories Added Yet"
        
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
        }

    }
}

extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let categoryForDeletion = self.categoriesArray?[indexPath.row] {
                
                do {
                    try self.realm.write({
                        self.realm.delete(categoryForDeletion)
                    })
                } catch {
                    print("Error while deleting category, \(error.localizedDescription)")
                }
            }
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "deleteIcon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}


