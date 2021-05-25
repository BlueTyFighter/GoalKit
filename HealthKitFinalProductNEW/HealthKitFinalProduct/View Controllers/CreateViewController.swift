//
//  CreateViewController.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 3/9/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import UIKit
import HealthKit

class CreateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let healthKitManager = HealthKitManager.singletonHealthKitManager
    
    var madeGoal: Bool = false
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var realisticOptionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerData = ["Steps", "Miles", "Exercise Minutes", "Stand Hours", "Flights Climbed", "Mindful Minutes"]
        
        descriptionLabel.text = "Default Options: Just some values to get you on your feet! Ex: One Mile, then the next goal is a 5K, and so on!\n\nCustom Options: Make your own goals!"
        
        self.typePickerView.delegate = self
        self.typePickerView.dataSource = self
        
        if self.healthKitManager.allHealthGoals.count == 0 {
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up Buttons
    @IBAction func setUpDefaultOptions(_ sender: UIButton) {
        print("inside default options")
        
        
        if !madeGoal {
            var go = true
            
            let ref = pickerData[currentSelection]
            
            if ref == "Steps" {
                healthKitManager.addNewHealthGoal(name: "Steps Goal", units: "Steps", typeOfData: 0, goalValues: [2500.00, 6562.00], goalMeaning: ["First Mile!", "5K!"])
            } else if ref == "Miles" {
                healthKitManager.addNewHealthGoal(name: "Miles Goal", units: "Miles", typeOfData: 1, goalValues: [1.00, 3.1, 26.2], goalMeaning: ["First Mile!", "5K!", "Marathon!"])
            } else if ref == "Exercise Minutes" {
                healthKitManager.addNewHealthGoal(name: "Exercise Minutes Goal", units: "Minutes", typeOfData: 2, goalValues: [60.0, 600.0, 1500.0, 3000.0], goalMeaning: ["One Hour!", "10 Hours!", "25 Hours", "50 Hours"])
            } else if ref == "Stand Hours" {
                healthKitManager.addNewHealthGoal(name: "Stand Hours", units: "Hours", typeOfData: 3, goalValues: [10.0, 25.0, 50.0], goalMeaning: ["10 Hours!", "25 Hours!", "50 Hours"])
            } else if ref == "Flights Climbed" {
                healthKitManager.addNewHealthGoal(name: "Flights Climbed", units: "Flights", typeOfData: 4, goalValues: [100.0, 500.0], goalMeaning: ["100 Floors!", "500 Floors!"])
            } else if ref == "Mindful Minutes" {
                healthKitManager.addNewHealthGoal(name: "Mindful Minutes", units: "Minutes", typeOfData: 5, goalValues: [60.0, 600.0, 1500.0, 3000.0], goalMeaning: ["One Hour!", "10 Hours!", "25 Hours", "50 Hours"])
            } else {
                go = false
                let message = UIAlertController(title: "What in the world?", message: "You choose something that doesn't exist. Try restarting the app please and try again. Thanks!", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    self.performSegue(withIdentifier: "SendToFirstViewController", sender: self)
                })
                message.addAction(ok)
                self.present(message, animated: true, completion: nil)
            }
            if go {
                madeGoal = false
                self.performSegue(withIdentifier: "SendToFirstViewController", sender: self)
            }
        }
        
        
        
    }
    
    @IBAction func realisticOptionsPressed(_ sender: UIButton) {
        if !madeGoal {
            let ref = pickerData[currentSelection]
            print("inside releastic options")
            
            if ref == "Steps" {
                healthKitManager.addNewHealthGoal(name: "Steps Goal", units: "Steps", typeOfData: 0, goalValues: [2500.00, 6562.00], goalMeaning: ["First Mile!", "5K!"])
            } else if ref == "Miles" {
                healthKitManager.addNewHealthGoal(name: "Miles Goal", units: "Miles", typeOfData: 1, goalValues: [26.00, 70.0, 250.0, 500.0, 736.0, 990.0, 1600.0, 1869.0, 1997.0, 2500.0, 2983.0, 4132.0, 5000.0, 5500.0, 5772.0, 7900.0, 12430.0], goalMeaning: ["Marathon! You've walked your way to your first lifetime miles acheivment. If this is just the starting line, we can't wait to see where you end up!", "Penguin March: You walked the distance of the March of the Penguins, the annual trip emperor penguins make to their breeding grounds.", "London Underground: You've walked the length of the world's first underground railway and are laying the tracks for some big things in the future!", "Serengeti: Impressive! You've walked distance of the Serengeti, one of the 7 Natural Wonders of the World.", "Italy: By walking the entire length of Italy, you've stepped your way to another colossal achievement!", "New Zealand: You've walked the entire length of New Zealand!", "Great Barrier Reef: The Great Barrier Reef is the world's largest coral reef system - and you just walked that! Take a minute to swin in your success.", "Japan: You've walked the full length of Japan! It many not put a stamp in the passport, but your travels earned you another achievement.", "India: Exceptional! You walked the same distance as the length of India - a universally admired achievement.", "Monarch Migration: Eery year the monarch butterfly migrates that same number of miles to wamer climates.", "Sahara: Whoa! You've walked the length of the Sahara Desert, which streches from the Atlantic Ocean to the Red Sea.", "Nile: You've walked the length of the longest river in the world! There's no deNILEing how impressive that is.", "Africa: It's a jungle out there, but that's not stopping you - because apparently you went bananas and walked the length of Africa!", "Great Wall: You've officially walked the same distance as the Great Wall of China. A triumph like this should go down in history!", "Russian Railway: You're en route to destination fitness! You've walked the length of the Trans-Siberian railway in Russia!", "Earth: By walking a distance that's akin to taking a journey through the center of the earth, you proved you've got commitment to the core.", "Pole to Pole: Jingle all the Whoa! That's like dashing through the snow from the North Pole to the South Pole, Ho-ho-holy, we're impressed."])
            } else if ref == "Flights Climbed" {
                healthKitManager.addNewHealthGoal(name: "Flights Climbed", units: "Flights", typeOfData: 4, goalValues: [500.0, 1000.0, 2000.0, 4000.0, 8000.0, 14000.0, 20000.0, 28000.0, 35000.0], goalMeaning: ["Helicopter: That's the altitude of a helicoper. Heli-yes, you totally just did that!", "Skydiver: That's as high as you'd go to skydive! Corss another one off the ol' fitness bucket list.", "Hot Air Balloon: That's as high as a hot air balloon! You are really blowing up the lifetime badges list.", "747: Your lifetime achievements are really taking flight, because you just jetsetted your way to another acheivment.","Cloud: We're on cloud nine thinking about this awesome achievement!", "Spaceship: U.F.OOOH! With that many floors, it's clear you're alien to fitness. You little climbing phenomenon, you.", "Shooting Star: You just climbed as high as a shooting star. So make a big wish and set a new goal.", "Astronaut: That's as high as an astronaut goes. It doesn't take a rocket scientist to see you're crushing it!", "Satellite: We've seen some exceptional exercise efforts, but few have climbed this high! You've sent us into orbit with this achievement."])
            }
            
            
            madeGoal = false
            self.performSegue(withIdentifier: "SendToFirstViewController", sender: self)
        }
        
    }
    //MARK: - Picker View Delegate Methods
    @IBOutlet weak var typePickerView: UIPickerView!
    var pickerData: [String] = [String]()
    var currentSelection: Int = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelection = row
        if pickerData[currentSelection] == "Miles" || pickerData[currentSelection] == "Flights Climbed" {
            realisticOptionButton.isEnabled = true
            descriptionLabel.text = "Default Options: Just some values to get you on your feet! Ex: One Mile, then the next goal is a 5K, and so on!\n\nRelastic Options: Makes goals out of real life values. Ex: The Height of the Empire State Building might be one goal!\n\nCustom Options: Make your own goals!"
        } else {
            realisticOptionButton.isEnabled = false
            descriptionLabel.text = "Default Options: Just some values to get you on your feet! Ex: One Mile, then the next goal is a 5K, and so on!\n\nCustom Options: Make your own goals!"
        }
//        print("the current selection is \(currentSelection)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if !madeGoal {
            if segue.destination is CustomCreationViewController {
                let ref = pickerData[currentSelection]
                var typeOfData = -1
                var unit = ""
                
                if ref == "Steps" {
                    typeOfData = 0
                    unit = "Steps"
                } else if ref == "Miles" {
                    typeOfData = 1
                    unit = "Miles"
                } else if ref == "Exercise Minutes" {
                    typeOfData = 2
                    unit = "Minutes"
                } else if ref == "Stand Hours" {
                    typeOfData = 3
                    unit = "Hours"
                } else if ref == "Flights Climbed" {
                    typeOfData = 4
                    unit = "Flights"
                } else if ref == "Mindful Minutes" {
                    typeOfData = 5
                    unit = "Minutes"
                }
                
                madeGoal = false
                let vc = segue.destination as? CustomCreationViewController
                vc?.typeOfData = typeOfData
                vc?.unit = unit
            }
        }
        

    }

}

