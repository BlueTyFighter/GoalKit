//
//  FirstViewController.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 3/1/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import UIKit
import HealthKit


class FirstViewController: UIViewController {
    
    let healthKitManager = HealthKitManager.singletonHealthKitManager
    let appSettings = Settings.singletonSettings
    
    var currentPage = 0
    
    var timer = Timer()
    var cpProgress: Float = 0.0
    
    var confettiView: SAConfettiView?
    
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    
    @IBOutlet weak var pagesLabel: UILabel!
    
    @IBOutlet weak var nameOfGoalLabel: UILabel!
    
    let forward = UISwipeGestureRecognizer(target: self, action: #selector(moveForward(_:)))
   
    let backward = UISwipeGestureRecognizer(target: self, action: #selector(moveBackward(_:)))
    
    
    @IBAction func moveForward(_ sender: UIButton) {
        if currentPage+1 < healthKitManager.allHealthGoals.count {
            currentPage = currentPage + 1
        }
        updateUI()
    }
    
    @objc func moveForward2(){
        if currentPage+1 < healthKitManager.allHealthGoals.count {
            currentPage = currentPage + 1
        }
        updateUI()
    }
    
    @IBAction func moveBackward(_ sender: UIButton) {

        if currentPage > 0 {
            currentPage = currentPage - 1
        }
        updateUI()
    }
    
    @objc func moveBackward2(){
           if currentPage > 0 {
               currentPage = currentPage - 1
           }
           updateUI()
       }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        healthKitManager.updateValues()
        healthKitManager.saveData()
        updateUI()
        
        
        
//        if !appSettings.isGuestureEnabled {
//            forward.isEnabled = false
//            backward.isEnabled = false
//        } else {
//            if !forward.isEnabled {
//                forward.isEnabled = true
//                backward.isEnabled = true
//            }
//
//        }
//
//
//        if appSettings.guestureDirectionIsRightUp && forward.direction == .left {
//            forward.direction = .right
//            backward.direction = .left
//        } else if forward.direction == .right && !appSettings.guestureDirectionIsRightUp {
//            forward.direction = .left
//            backward.direction = .right
//        }
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("View did load")
//        let f = DateFormatter()
//        f.dateStyle = .full
//        f.timeStyle = .full
//        print(f.string(from: Date()))
        
        healthKitManager.loadData()
        healthKitManager.updateValues()
        
        // Do any additional setup after loading the view, typically from a nib.
        let circularProgress = CircularProgress(frame: CGRect(x: 10.0, y: 30.0, width: 100.0, height: 100.0))
        circularProgress.progressColor = UIColor(red: 52.0/255.0, green: 141.0/255.0, blue: 252.0/255.0, alpha: 1.0)
        circularProgress.trackColor = UIColor(red: 52.0/255.0, green: 141.0/255.0, blue: 252.0/255.0, alpha: 0.4)
        circularProgress.tag = 101
        circularProgress.center = self.view.center
        self.view.addSubview(circularProgress)
        
        self.view.addGestureRecognizer(forward)
        self.view.addGestureRecognizer(backward)
        
        forward.direction = .left
        backward.direction = .right
        
        forward.isEnabled = true
        backward.isEnabled = true
        
        
        confettiView = SAConfettiView(frame: self.view.bounds)
        
        if healthKitManager.allHealthGoals.count == 0 {
            self.performSegue(withIdentifier: "goToWelcomeScreen", sender: self)
//            let message = UIAlertController(title: "Welcome!", message: "You have just started the app and have no goals. Let's create one on the next screen!", preferredStyle: .alert)
//
//            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//
//            })
//            message.addAction(ok)
//            self.present(message, animated: true, completion: nil)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.updateUI()
            }
            
        }
        
        scheduledTimerWithTimeInterval()
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        let message = UIAlertController(title: "What action do you want to do?", message: "Click 'Edit Title' or 'Delete Goal' to do the respective actions", preferredStyle: .actionSheet)
        
        let edit = UIAlertAction(title: "Edit Title", style: .default, handler: { (action) -> Void in
            
            let message = UIAlertController(title: "", message: "Enter the new name, then click 'Save'. Or click 'Cancel' if you don't want to change the name. ", preferredStyle: .alert)
            
            message.addTextField(configurationHandler: { textField in
                textField.placeholder = "Type in the new name"
            })
            
            let save = UIAlertAction(title: "Save", style: .default, handler: { (action) -> Void in
                self.healthKitManager.allHealthGoals[self.currentPage].setNewTitle(value: message.textFields?.first?.text ?? "")
                print("new name: \(self.healthKitManager.allHealthGoals[self.currentPage].name)")
                self.healthKitManager.saveData()
                self.updateUI()
            })
            message.addAction(save)
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                
            })
            message.addAction(cancel)
            
            self.present(message, animated: true, completion: nil)
            
        })
        message.addAction(edit)
        
        let delete = UIAlertAction(title: "Delete Achievement", style: .default, handler: { (action) -> Void in
            
            let message = UIAlertController(title: "Are you sure you want to delete this Achievement?", message: "", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) -> Void in
                self.healthKitManager.allHealthGoals.remove(at: self.currentPage)
                self.healthKitManager.saveData()
                if self.healthKitManager.allHealthGoals.count == 0 {
                    let message = UIAlertController(title: "", message: "You have deleted all of your achievements. You must make a new one on the next screen!", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        self.currentPage = 0
                        self.performSegue(withIdentifier: "goToCreatePage", sender: self)
                    })
                    message.addAction(ok)
                    self.present(message, animated: true, completion: nil)
                }
                if self.currentPage > 0 {
                    self.currentPage = self.currentPage - 1
                }
                
            })
            message.addAction(delete)
            
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
                
            })
            message.addAction(cancel)
            
            self.present(message, animated: true, completion: nil)
        })
        message.addAction(delete)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        })
        message.addAction(cancel)


        
        self.present(message, animated: true, completion: nil)
    }
    
    var inGetGoal = false
    
    
    
    func updateUI(){
        if healthKitManager.allHealthGoals.count != 0 {
            let ref = healthKitManager.allHealthGoals[currentPage]
            
            if healthKitManager.getGoal && !inGetGoal {
                // MARK: CONFEETI
                confettiView?.type = .image(UIImage(named: "confetti")!)
                confettiView?.intensity = 0.5
                confettiView?.startConfetti()
                
                self.view.addSubview(confettiView!)
                
                self.inGetGoal = true
                let stringForMessage = healthKitManager.goalMeaning
                let message = UIAlertController(title: "You got a goal!", message: stringForMessage, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    
                    
                    self.inGetGoal = false
                    self.healthKitManager.getGoal = false
                    self.healthKitManager.goalMeaning = ""
                    self.confettiView?.stopConfetti()
                    self.confettiView!.removeFromSuperview()
                    
//                    if (self.healthKitManager.allHealthGoals[self.currentPage].goalReached >= self.healthKitManager.allHealthGoals[self.currentPage].goalValues.count){
//                        self.healthKitManager.allHealthGoals.remove(at: self.currentPage)
//                        self.healthKitManager.saveData()
//                        if self.healthKitManager.allHealthGoals.count == 0 {
//                            let message = UIAlertController(title: "", message: "You have deleted all of your goals. You must make a new one on the next screen!", preferredStyle: .alert)
//                            
//                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//                                self.currentPage = 0
//                                self.performSegue(withIdentifier: "goToCreatePage", sender: self)
//                            })
//                            message.addAction(ok)
//                            self.present(message, animated: true, completion: nil)
//                        }
//                        if self.currentPage > 0 {
//                            self.currentPage = self.currentPage - 1
//                        }
//                    }
                })
                message.addAction(ok)
                self.present(message, animated: true, completion: nil)
            }
            
            
            if currentPage == 0 {
                backButton.isHidden = true
            } else {
                backButton.isHidden = false
            }
            
            if currentPage == healthKitManager.allHealthGoals.count-1 {
                forwardButton.isHidden = true
            } else {
                forwardButton.isHidden = false
            }
            
            nameOfGoalLabel.text = ref.name
            unitsLabel.text = ref.units
            // self.allHealthGoals[x].goalReached < self.allHealthGoals[x].goalValues.count-1
            if ref.goalReached < ref.goalValues.count {
                animateProgress()
                counterLabel.text = "\(ref.currentValue)/\(ref.goalValues[ref.goalReached])"
                pagesLabel.text = "\(currentPage+1)/\(healthKitManager.allHealthGoals.count)"
            } else {
                confettiView?.type = .image(UIImage(named: "confetti")!)
                confettiView?.startConfetti()
                confettiView?.intensity = 1.0
                self.view.addSubview(confettiView!)
                
                // MARK: OTHER
                let message = UIAlertController(title: "Congrats!", message: "You got through all your goals and acheived the achievement!", preferredStyle: .alert)
                
                let delete = UIAlertAction(title: "Yes!", style: .default, handler: { (action) -> Void in
                    self.healthKitManager.allHealthGoals.remove(at: self.currentPage)
                    self.healthKitManager.saveData()
                    if self.healthKitManager.allHealthGoals.count == 0 {
                        let message = UIAlertController(title: "", message: "You have no more achievements. You must make a new one on the next screen!", preferredStyle: .alert)
                        
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            self.currentPage = 0
                            self.confettiView?.stopConfetti()
                            self.confettiView!.removeFromSuperview()
                            self.performSegue(withIdentifier: "goToCreatePage", sender: self)
                        })
                        message.addAction(ok)
                        self.present(message, animated: true, completion: nil)
                    }
                    if self.currentPage > 0 {
                        self.currentPage = self.currentPage - 1
                    }
                    
                })
                message.addAction(delete)
            
                
                self.present(message, animated: true, completion: nil)
            }
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.confettiView?.stopConfetti()
        self.confettiView!.removeFromSuperview()
    }
    
    @IBAction func unwindToFirstViewController(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        updateUI()
    }
    

    
    @objc func animateProgress() {
        let ref = healthKitManager.allHealthGoals[currentPage]
        let cp = self.view.viewWithTag(101) as! CircularProgress
        
        var floatValue: Float = 0.0
        if appSettings.circleProgressFromStart {
           floatValue = Float(ref.currentValue/ref.goalValues[ref.goalReached])
        } else {
            if ref.goalReached <= 0 {
                floatValue = Float(ref.currentValue/ref.goalValues[ref.goalReached])
            } else {
                floatValue = Float((ref.currentValue-ref.goalValues[ref.goalReached-1])/ref.goalValues[ref.goalReached])
            }
        }
        
        
        if floatValue != cpProgress {
            cp.setProgressWithAnimation(duration: 0.5, value: floatValue)
            cpProgress = floatValue
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

