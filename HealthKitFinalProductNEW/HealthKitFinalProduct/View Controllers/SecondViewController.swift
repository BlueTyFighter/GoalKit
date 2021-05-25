//
//  SecondViewController.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 3/1/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    let healthKitManager = HealthKitManager.singletonHealthKitManager
    
    var nameArray: [String] = []
    var pictureArray: [UIImage] = []
    var cityName = ""
    
    
    @IBOutlet weak var tableViewForMap: UITableView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("this should hopefuly not run yet")
        // Do any additional setup after loading the view.
        
//        if healthKitManager.mapGoal != nil {
//            self.performSegue(withIdentifier: "SkipSelectionToMap", sender: self)
//        }
        
        tableViewForMap.delegate = self
        tableViewForMap.dataSource = self
        
        
        nameArray = ["New York", "Chicago", "Washington DC"]
        pictureArray = [UIImage(named: "timesSquare")!,UIImage(named: "chicago")!, UIImage(named: "washington")!]
        
    }
    
    func moveOn(){
        print("inside move on")
        self.performSegue(withIdentifier: "continueToScreenMap", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if healthKitManager.mapGoal != nil {
            self.performSegue(withIdentifier: "SkipSelectionToMap", sender: self)
        }
    }
    
    

}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityName = nameArray[indexPath.row]
        self.tableViewForMap.deselectRow(at: self.tableViewForMap.indexPathForSelectedRow!, animated: true)
        self.performSegue(withIdentifier: "MoveToSecondSelection", sender: self)
    }
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("haha this is working NOT")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else {
            fatalError("This should not happen hopefully")
        }
        
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.imageView?.image = pictureArray[indexPath.row]

        

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TableViewControllerForMap1 {
            
           let vc = segue.destination as? TableViewControllerForMap1
            vc?.city = cityName
            
        }
            
    }
}

