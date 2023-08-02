//
//  TaskViewController.swift
//  WhatToDo
//
//  Created by Özgün Can Beydili on 2.08.2023.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var newTaskTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
            sender.selectedSegmentTintColor = UIColor(named: "low")
        } else if sender.selectedSegmentIndex == 1 {
            sender.selectedSegmentTintColor = UIColor(named: "normal")
        } else {
            sender.selectedSegmentTintColor = UIColor(named: "high")
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
}
