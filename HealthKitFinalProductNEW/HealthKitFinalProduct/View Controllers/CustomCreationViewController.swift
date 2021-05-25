//
//  CustomCreationViewController.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 4/6/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

class CustomCreationViewController: UIViewController {
    var meaningStringArray: [String] = []
    var valuesArray: [Double] = []
    var typeOfData: Int = -1
    var unit: String = ""
    let healthKitManager = HealthKitManager.singletonHealthKitManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.allowsSelection = true
    }
    
    @IBOutlet weak var meaningTextField: UITextField!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButtonPressed: UIButton!
    
    @IBAction func addButtonPressedOutlet(_ sender: UIButton) {
        meaningStringArray.append(meaningTextField.text ?? "")
        let amount = Double(amountTextField.text ?? "")
        valuesArray.append(amount ?? 0.0)
        
        meaningTextField.text = ""
        amountTextField.text = ""
        
        tableView.reloadData()
        view.endEditing(true)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if self.valuesArray.count > 0 {
            let message = UIAlertController(title: "", message: "Enter the name for the Custom Goal", preferredStyle: .alert)
            
            message.addTextField(configurationHandler: { textField in
                textField.placeholder = "Type in the name"
            })
            
            let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
                
                self.healthKitManager.addNewHealthGoal(name: message.textFields?.first?.text ?? "", units: self.unit, typeOfData: self.typeOfData, goalValues: self.valuesArray, goalMeaning: self.meaningStringArray)
                
                self.performSegue(withIdentifier: "SendToFirstViewController", sender: self)
            })
            message.addAction(save)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                
            })
            message.addAction(cancel)
            
            self.present(message, animated: true, completion: nil)
        } else {
            let message = UIAlertController(title: "You need values!", message: "", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
                
            })
            message.addAction(cancel)
            self.present(message, animated: true, completion: nil)
        }
        
        
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let row = tableView.indexPathForSelectedRow?.row ?? -1
        if row != -1 {
            meaningStringArray.remove(at: row)
            valuesArray.remove(at: row)
            tableView.reloadData()
        }
        
    }
    
}

extension CustomCreationViewController: UITableViewDelegate {
    
}

extension CustomCreationViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("type of data \(typeOfData)")
        print("Unit \(unit)")
        return meaningStringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "\(meaningStringArray[indexPath.row]) \(valuesArray[indexPath.row])"
        
        
        return cell
    }
    
    
}
