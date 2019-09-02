//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Dawid Kolasinski on 02/09/2019.
//  Copyright © 2019 Dawid Kolasinski. All rights reserved.
//

import UIKit
import CoreData


class CategoryTableViewController: UITableViewController {
    
    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        tableView.reloadData()
    }

    

    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        return cell
    }
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving data: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)       //new NSManagedObject
            newCategory.name = textField.text!
            self.categoriesArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add new category"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        saveCategories()
    }
}
