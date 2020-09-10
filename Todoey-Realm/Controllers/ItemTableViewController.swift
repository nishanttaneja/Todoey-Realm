//
//  ItemTableViewController.swift
//  Todoey-Realm
//
//  Created by Nishant Taneja on 10/09/20.
//  Copyright © 2020 Nishant Taneja. All rights reserved.
//

import UIKit
import RealmSwift

class ItemTableViewController: UITableViewController {
    //MARK: Constant|Variables
    let realm = try! Realm()
    var items: Results<Item>?
    var parentCategory: Category? {
        didSet {loadItems()}
    }
    
    //MARK:- IBAction
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    self.parentCategory!.items.append(newItem)
        //            self.saveItem(newItem)
                }
                self.tableView.reloadData()
            }
            catch {print(error)}
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "New Item"
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK:- TableView DataSource|Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {cell.textLabel?.text = "No items added yet"}
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
        //            saveItem(item)
                }
                tableView.reloadData()
            }
            catch {print(error)}
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Realm CRUD
    /// This function saves new data.
    private func saveItem(_ item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
            tableView.reloadData()
        }
        catch {print(error)}
    }
    /// This function loads data.
    private func loadItems() {
        items = parentCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}
