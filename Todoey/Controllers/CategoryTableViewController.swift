//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Dawid Kolasinski on 02/09/2019.
//  Copyright © 2019 Dawid Kolasinski. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift


class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }

    

    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categoriesArray.count
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
//        cell.textLabel?.text = categoriesArray[indexPath.row].name
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
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
//            destinationVC.selectedCategory = categoriesArray[indexPath.row]
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving data: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    func loadCategories(){
        
        categories = realm.objects(Category.self)
            
        tableView.reloadData()
    }
    
    
    
    
    
    //MARK: - Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            let newCategory = Category(context: self.context)       //new NSManagedObject
            let newCategory = Category()
            newCategory.name = textField.text!
//            self.categoriesArray.append(newCategory)
            self.saveCategories(category: newCategory)
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add new category"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
//        saveCategories()
    }
}
