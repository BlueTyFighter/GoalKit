//
//  TableViewControllerForMap1.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 4/18/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import UIKit

class TableViewControllerForMap1: UITableViewController {
    
    var nameArray: [String] = []
    var pictureArray: [UIImage] = []
    
    var city: String = ""
    
    let healthKitManager = HealthKitManager.singletonHealthKitManager

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = city
        
        if city == "New York" {
            nameArray = ["Parks"]
            pictureArray = [UIImage(named: "timesSquare")!]
        } else if city == "Chicago" {
            nameArray = ["Conant to Downtown"]
            pictureArray = [UIImage(named: "conant")!]
        } else if city == "Washington DC" {
            nameArray = ["All Of Washington"]
            pictureArray = [UIImage(named: "washington")!]
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if healthKitManager.mapGoal != nil {
                   self.performSegue(withIdentifier: "goToMap", sender: self)
               }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let message = UIAlertController(title: "Are you sure you want to create this goal?", message: "", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            
            if self.city == "New York"{
                if self.nameArray[indexPath.row] == "Parks" {
                    self.healthKitManager.createMapGoal(name: "New York", coor: [Annotations(lat: 40.712602, long: -74.013288, name: "World Trade Center Memorial", webPage: "https://en.wikipedia.org/wiki/World_Trade_Center_Memorial"), Annotations(lat: 40.731228, long: -73.997152, name: "Washington Square Arch", webPage: "https://en.wikipedia.org/wiki/Washington_Square_Arch"), Annotations(lat: 40.74105, long: -73.98970, name: "Flatiron Building", webPage: "https://en.wikipedia.org/wiki/Flatiron_Building"), Annotations(lat: 40.74874, long: -73.98574, name: "Empire State Building", webPage: "https://en.wikipedia.org/wiki/Empire_State_Building")])
                }
            } else if self.city == "Chicago" {
                if self.nameArray[indexPath.row] == "Conant to Downtown" {
                    self.healthKitManager.createMapGoal(name: "Conant to Downtown", coor: [Annotations(lat: 42.03751, long: -88.06143, name: "Conant High School", webPage: "https://en.wikipedia.org/wiki/James_B._Conant_High_School"), Annotations(lat: 41.87579, long: -87.61960, name: "Buckingham Fountain", webPage: "https://en.wikipedia.org/wiki/Buckingham_Fountain"), Annotations(lat: 41.79115, long: -87.58296, name: "Museum of Science and Industry", webPage: "https://en.wikipedia.org/wiki/Museum_of_Science_and_Industry_%28Chicago%29")])
                }
            } else if self.city == "Washington DC" {
                if self.nameArray[indexPath.row] == "All Of Washington" {
                    self.healthKitManager.createMapGoal(name: "Conant to Downtown", coor: [Annotations(lat: 38.89005, long: -77.00911, name: "United States Capitol", webPage: "https://en.wikipedia.org/wiki/United_States_Capitol"), Annotations(lat: 38.88961, long: -77.03536, name: "Washington Monument", webPage: "https://en.wikipedia.org/wiki/Washington_Monument"), Annotations(lat: 38.88955, long: -77.05027, name: "Lincoln Memorial", webPage: "https://en.wikipedia.org/wiki/Lincoln_Memorial"), Annotations(lat: 38.89801, long: -77.03657, name: "The White House", webPage: "https://en.wikipedia.org/wiki/White_House")])
                }
            }
            
            
            self.dismiss(animated: false) {
                self.performSegue(withIdentifier: "goToMap", sender: self)
            }
            
            
            
        })
        message.addAction(yes)
        
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
            
        })
        message.addAction(cancel)
        
        self.present(message, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else {
            fatalError("This should not happen hopefully")
        }
        
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.imageView?.image = pictureArray[indexPath.row]

        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
