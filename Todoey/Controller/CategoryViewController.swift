//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sandeep Sahani on 25/02/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    // Adds an element when button is tapped.
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            // What will happen once user will click add item on our UIAlert.
            // print("Sucess! ")
            guard let category = textField.text else {
                print("Error while unwrapping optional")
                return
            }
            
            let newCategory = Category(context: self.context)
            newCategory.name = category
            self.categoriesArray.append(newCategory)
            
            self.saveItem()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    // MARK: Saves entered data in core data database.
    private func saveItem() {
        do {
            // Save data in core data database.
            try self.context.save()
        }
        catch {
            print("Error saving category \(error)")
        }
        // Reload table view
        tableView.reloadData()
        
    }
    
    // MARK: loads categories request.
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            // Fetch data from persistent container.
            categoriesArray = try context.fetch(request)
        }
        catch {
            print("Error while fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

// MARK: TableView Datasource and Delegate Methods
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let categoty = categoriesArray[indexPath.row]
        cell.textLabel?.text = categoty.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
        
    }
}


