//
//  ViewController.swift
//  WhatToDo
//
//  Created by Özgün Can Beydili on 2.08.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var contentArray = [String]()
    var priorityArray = [String]()
    var idArray = [UUID]()
    
    var isChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor(named: "purple")
    
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        getDatas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getDatas), name: NSNotification.Name("saved"), object: nil)
    }
    
    @objc func addButtonTapped() {
        performSegue(withIdentifier: "toTaskVC", sender: self)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc func getDatas() {
        contentArray.removeAll(keepingCapacity: false)
        priorityArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskItem")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            if results.count > 0 {
                for result in results {
                    if let content = result.value(forKey: "content") as? String {
                        contentArray.append(content)
                    }
                    if let priority = result.value(forKey: "priority") as? String {
                        priorityArray.append(priority)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                }
                tableView.reloadData()
            }
        } catch {
            print("Error!")
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        cell.taskLabel.text = contentArray[indexPath.row]
        
        if priorityArray[indexPath.row] == "low" {
            cell.priorityImageView.tintColor = UIColor(named: "low")
        } else if priorityArray[indexPath.row] == "normal" {
            cell.priorityImageView.tintColor = UIColor(named: "normal")
        } else {
            cell.priorityImageView.tintColor = UIColor(named: "high")
        }
        
        cell.checkedImageView.isUserInteractionEnabled = true
        let checkedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(checked))
        cell.addGestureRecognizer(checkedGestureRecognizer)

        cell.checkedImageView.image = checked()

        return cell
    }
    
    @objc func checked() -> UIImage {
        isChecked.toggle()

        if isChecked {
            return UIImage(named: "circle.fill")!
        } else {
            return UIImage(named: "circle")!
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskItem")
            let uuidString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest) as! [NSManagedObject]
                
                if results.count > 0 {
                    for result in results {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                
                                context.delete(result)
                                
                                contentArray.remove(at: indexPath.row)
                                priorityArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                tableView.reloadData()
                                
                                do {
                                    try context.save()
                                } catch {
                                    print("Error!")
                                }
                                
                                break
                            }
                        }
                    }
                }
            } catch {
                print("Error!")
            }
        }
    }
}
