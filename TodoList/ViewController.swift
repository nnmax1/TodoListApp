//
//  ViewController.swift
//  TodoList
//
//  Created by Admin on 7/4/20.
//  Copyright © 2020 nnmax1. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    var todoArr = [String]()
    var todoIDArr = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //add a plus sign shaped button to the top of the navigation controller that the user
        //clicks to add an item to the todo list
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonClicked))
        //call get data
        getData()
    }
    //update the table view when a todo item is added
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newTodo"), object: nil)
    }
    //number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let numRows = todoArr.count
        return numRows
    }
    //insert each todo item into a cell in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = todoArr[indexPath.row]
        return cell
    }
    
    //get data from core data using a fetch request
    @objc func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                self.todoArr.removeAll(keepingCapacity: false)
                self.todoIDArr.removeAll(keepingCapacity: false)
            }
            for result in results as! [NSManagedObject] {
                if let todo = result.value(forKey: "todo") as? String {
                    todoArr.append(todo)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    todoIDArr.append(id)
                }
            }
            //refresh tableview
            tableView.reloadData()
        } catch {
            print("Error")
        }
        
    }
    //perform segue to the second view controller
    @objc func addButtonClicked() {
        performSegue(withIdentifier: "toSecondVC", sender: nil)
    }
    //delete functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        
        let idStr = todoIDArr[indexPath.row].uuidString
        
        request.predicate = NSPredicate(format: "id = %@", idStr)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                 
                for result in results as! [NSManagedObject] {
                    if let id = result.value(forKey: "id") as? UUID{
                        //remove values from the table view
                        if id == todoIDArr[indexPath.row] {
                            context.delete(result)
                            todoArr.remove(at: indexPath.row)
                            todoIDArr.remove(at: indexPath.row)
                            self.tableView.reloadData()
                        }
                        do {
                            try context.save()
                        }catch {
                            print("Error")
                        }
                        //end loop
                        break
                    }
                }
            }
            
        } catch {
            print("error")
        }
        
    }
}

