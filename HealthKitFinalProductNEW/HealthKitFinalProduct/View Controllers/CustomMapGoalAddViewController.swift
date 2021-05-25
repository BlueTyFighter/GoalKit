//
//  CustomMapGoalAddViewController.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 5/20/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CustomMapGoalAddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var websiteTextField: UITextField!
    
    @IBOutlet weak var suggestButton: UIButton!
    
    private let completer = MKLocalSearchCompleter()

    
    
    let healthKitManager = HealthKitManager.singletonHealthKitManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completer.delegate = self
        addressTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.completer.queryFragment = textField.text ?? ""
        return true
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        completer.queryFragment = addressTextField.text ?? ""
            }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if addressTextField.text != "" && nameTextField.text != "" {
            let geocoder = CLGeocoder()
            
            var coordinates: CLLocationCoordinate2D?
            
            geocoder.geocodeAddressString(addressTextField.text!, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    self.showError(error: "Cannot find that address. Can you please double check to make sure it's typed in correctly?", message: "If it is, can you be more descripitive by adding a state and country.")
                }
                if let placemark = placemarks?.first {
                    coordinates = placemark.location!.coordinate
                    self.healthKitManager.addToCustomMapCreationArray(name: self.nameTextField.text!, address: coordinates!, website: self.websiteTextField.text)
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
        } else {
            showError(error: "You are missing the required fields. Please fill them out.", message: "")
        }
        
    }
    
    func showError(error: String, message: String){
        let message = UIAlertController(title: error, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: { (action) -> Void in
            
        })
        message.addAction(cancel)
        self.present(message, animated: true, completion: nil)
    }
    
    func showSuggestion(location: String) {
        
        suggestButton.setTitle(location, for: .normal)
        suggestButton.isEnabled = true
        print("suggest button: \(suggestButton.titleLabel?.text)")
        
        
    }
    
    @IBAction func suggestButtonPressed(_ sender: UIButton) {
        addressTextField.text = suggestButton.titleLabel?.text
        suggestButton.titleLabel?.text = ""
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

extension CustomMapGoalAddViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
      guard let firstResult = completer.results.first else {
        return
      }
        print("Location: \(firstResult.title)")
        showSuggestion(location: firstResult.title)
    }

    func completer(
      _ completer: MKLocalSearchCompleter,
      didFailWithError error: Error
    ) {
      print("Error suggesting a location: \(error.localizedDescription)")
    }
}
