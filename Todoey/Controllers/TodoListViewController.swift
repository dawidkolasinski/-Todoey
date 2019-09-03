//
//  ViewController.swift
//  Todoey
//
//  Created by Dawid Kolasinski on 26/08/2019.
//  Copyright © 2019 Dawid Kolasinski. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row] {
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none     //value = condition ? true : false
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItems()
        do{
        if let item = todoItems?[indexPath.row] {
            try realm.write {
                item.done = !item.done
//                realm.delete(item)
            }
        }
        } catch {
            print("Error saving done status: \(error)")
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK  - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()       //inicjalizacja pola tekstowego
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                        print("Error saving data: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField ) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

    }
    
}


//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {       //once presses the search bar //search button on keyboard
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        }
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }

    }
}

