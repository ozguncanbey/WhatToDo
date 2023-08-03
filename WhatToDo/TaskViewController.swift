//
//  TaskViewController.swift
//  WhatToDo
//
//  Created by Özgün Can Beydili on 2.08.2023.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var priority: String = "low"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }

    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func segmentedControlSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            priority = "low"
            sender.selectedSegmentTintColor = UIColor(named: "low")
        } else if sender.selectedSegmentIndex == 1 {
            priority = "normal"
            sender.selectedSegmentTintColor = UIColor(named: "normal")
        } else {
            priority = "high"
            sender.selectedSegmentTintColor = UIColor(named: "high")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let task = NSEntityDescription.insertNewObject(forEntityName: "TaskItem", into: context)
        
        task.setValue(taskTextField.text, forKey: "content")
        task.setValue(priority, forKey: "priority")
        task.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
        } catch {
            print("Error!")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("saved"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
}
