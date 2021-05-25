//
//  CustomMapGoalCreationViewController.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 5/20/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import UIKit

class CustomMapGoalCreationViewController: UIViewController {

    let healthKitManager = HealthKitManager.singletonHealthKitManager
    var vSpinner : UIView?
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        healthKitManager.customMapCreationArray = []
        
        tableView.allowsSelection = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showSpinner(onView: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.reloadData()
            self.removeSpinner()
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        self.healthKitManager.createMapGoal(name: "Dummy Name", coor: healthKitManager.customMapCreationArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let row = tableView.indexPathForSelectedRow?.row ?? -1
        if row != -1 {
            healthKitManager.customMapCreationArray.remove(at: row)
            tableView.reloadData()
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CustomMapGoalCreationViewController: UITableViewDelegate {
    
}

extension CustomMapGoalCreationViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(healthKitManager.customMapCreationArray.count)")
        return healthKitManager.customMapCreationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let ref = healthKitManager.customMapCreationArray
        
        cell.textLabel?.text = "\(ref[indexPath.row].name)"
        
        print("inside cell")
        
        return cell
    }
    
    
}

// taken from https://brainwashinc.com/2017/07/21/loading-activity-indicator-ios-swift/
extension CustomMapGoalCreationViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
