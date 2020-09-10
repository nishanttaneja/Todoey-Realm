//
//  CategoryTableViewController.swift
//  Todoey-Realm
//
//  Created by Nishant Taneja on 10/09/20.
//  Copyright © 2020 Nishant Taneja. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    //MARK:- Constant|Variable
    private let realm = try! Realm()
    private var categories: Results<Category>?
    
    //MARK:- Override ViewLifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK:- IBAction
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {}
    
    //MARK:- TableView DataSource|Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet."
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CategoryToItemScene", sender: self)
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    //MARK:- Realm CRUD
    /// This function is executed to load data.
    private func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}
