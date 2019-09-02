//
//  ViewController.swift
//  Todoey
//
//  Created by Dawid Kolasinski on 26/08/2019.
//  Copyright © 2019 Dawid Kolasinski. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        

//        print(dataFilePath)
        
//
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogogron"
//        itemArray.append(newItem3)
//
        //zapis
//      loadItems()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none     //value = condition ? true : false
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
    
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        itemArray[indexPath.row].setValue("\(itemArray[indexPath.row].title!) - Completed!", forKey: "title")       //tylko ciekawostka
        
        
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveItems()
        
        
    }
    
    //MARK  - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()       //inicjalizacja pola tekstowego
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen
//            let newItem = Item()
//            newItem.title = textField.text!
//            self.itemArray.append(newItem)
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField ) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
//        let encoder = PropertyListEncoder()
        do {
//        let data = try encoder.encode(itemArray)
//        try data.write(to: dataFilePath!)
            try self.context.save()
        } catch {
            print("Error while saving data \(error)")
        }
        tableView.reloadData()
    }
    
//    func loadItems() {
////        if let data = try? Data.in it(contentsOf: dataFilePath!){
////            let decoder = PropertyListDecoder()
//            do {
////            itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Errors while decoding data: \(error)")
//            }
//        }
//    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate??, categoryPredicate])
//        request.predicate = compoundPredicate

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
}


//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {       //once presses the search bar //search button on keyboard
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()     //read from context , create request
//        print(searchBar.text!)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)       //query %@ - text and how we query , modify request
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]             //sort
        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context: \(error)")
//        }
        loadItems(with: request, predicate: predicate)                                                                //perform
//        tableView.reloadData()  //with current array
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()  //stop search bar to be first responde
            }
        }
        
    }
    
}

