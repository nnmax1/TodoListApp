//
//  SecondViewController.swift
//  TodoList
//
//  Created by Admin on 7/4/20.
//  Copyright © 2020 nnmax1. All rights reserved.
//

import UIKit
import CoreData
class SecondViewController: UIViewController {

    @IBOutlet weak var todoInput: UITextField!
    
    var todoItem = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //Save text input to core data when button is clicked
    @IBAction func saveButtonClicked(_ sender: Any) {
                
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "TodoList", into: context)
        
        newItem.setValue(todoInput.text!, forKey: "todo")
        newItem.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            
        } catch {
            print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newTodo"), object: nil)
        navigationController?.popViewController(animated: true)
        
    }


}
