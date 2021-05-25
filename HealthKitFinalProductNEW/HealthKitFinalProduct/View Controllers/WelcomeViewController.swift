//
//  WelcomeViewController.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 5/18/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var confettiView: SAConfettiView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView?.type = .image(UIImage(named: "confetti")!)
        confettiView?.intensity = 0.2
        confettiView?.startConfetti()
        self.view.addSubview(confettiView!)
        self.view.sendSubviewToBack(confettiView!)
        // Do any additional setup after loading the view.
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
