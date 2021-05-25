//
//  MapViewController.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 4/18/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import UIKit
import MapKit
import WebKit
import SafariServices

class MapViewController: UIViewController, SFSafariViewControllerDelegate {
    
    let healthKitManager = HealthKitManager.singletonHealthKitManager
    
    var timer = Timer()
    
    var lastRoute: MKRoute = MKRoute()
    
    var vSpinner : UIView?
    
    
    
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func goBack(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SendToFirstViewControllerFromMap", sender: self)
    }
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var centerButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var distanceBetweenPoints: Float = 0.0
    
    let percentFormatter = NumberFormatter()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        goBackButton.layer.cornerRadius = 5.0
        progressBar.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        progressBar.layer.cornerRadius = 5.0
        progressBar.clipsToBounds = true
        
        
        percentFormatter.numberStyle = .percent
        
        let ref = healthKitManager.mapGoal
        let firstCoorLat = healthKitManager.mapGoal?.coordinatesArray[ref?.numberOfSpotsVisited ?? 0].lat ?? 54.0336
        
        let firstCoorLong = healthKitManager.mapGoal?.coordinatesArray[ref?.numberOfSpotsVisited ?? 0].long ?? 48.6804
        
        let initialLocation = CLLocation(latitude: firstCoorLat, longitude: firstCoorLong)
        
        mapView.centerToLocation(initialLocation)
        
        mapView.delegate = self as? MKMapViewDelegate
        
        updateMap()
        
        
        
        scheduledTimerWithTimeInterval()
    }
    
    
    
    func fetchAnnotations(){
        let ref = healthKitManager.mapGoal
        
        let value: Int = ref!.numberOfSpotsVisited
        
        for x in 0...value {
            let annotation = ref!.coordinatesArray[x]
            let newAnnotation = MKPointAnnotation()
            newAnnotation.title = annotation.name
            
            newAnnotation.coordinate = CLLocationCoordinate2D(latitude: annotation.lat, longitude: annotation.long)
            
            mapView.addAnnotation(newAnnotation)
            
        }
    }
    
    func createRequest(coordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        let origin = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: origin)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = false
        
        return request
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        if healthKitManager.mapGoal != nil {
            healthKitManager.updateValues()
            updateUI()
            
            fetchAnnotations()
            
            
            
            if getCurrentProgress() > Double(distanceBetweenPoints) {
                
                healthKitManager.mapGoal?.increaseSpots()
                
                let allPreviousDistances = Double(distanceBetweenPoints)+healthKitManager.mapGoal!.allPreviousDistances
                
                healthKitManager.mapGoal?.setAllPreviousDistances(value: allPreviousDistances)
                
                updateMap()
            }
        }
        
    }
    
    func updateMap(){
        
        self.showSpinner(onView: self.view)
        
        let ref = healthKitManager.mapGoal
        let firstCoorLat = healthKitManager.mapGoal?.coordinatesArray[ref?.numberOfSpotsVisited ?? 0].lat ?? 54.0336
        
        let firstCoorLong = healthKitManager.mapGoal?.coordinatesArray[ref?.numberOfSpotsVisited ?? 0].long ?? 48.6804
        
        let initialLocation = CLLocation(latitude: firstCoorLat, longitude: firstCoorLong)
        
        
        guard let request = createRequest(coordinate: CLLocationCoordinate2D(latitude: firstCoorLat, longitude: firstCoorLong), destinationCoordinate: CLLocationCoordinate2D(latitude: ref?.coordinatesArray[(ref?.numberOfSpotsVisited ?? 0)+1].lat ?? 54.0336, longitude: ref?.coordinatesArray[(ref?.numberOfSpotsVisited ?? 0)+1].long ?? 48.6804)) else { return }
        let directions = MKDirections(request: request)
        
        mapView.removeOverlays(mapView.overlays)
        
        directions.calculate { [unowned self] (response, error) in
            guard let response = response else { return }
            let routes = response.routes
            
            let distanceInMiles = (routes.first?.steps[2].distance)! * 0.000621371192
            
            
            print("The first step \(distanceInMiles)")
            
            let distance = response.routes.first?.distance // meters
            self.lastRoute = (response.routes.first)!
            
            print("\(distance! / 1000)km")
            
            self.distanceBetweenPoints = Float((distance ?? 0.0) * 0.000621371192) // miles
            
            for route in routes {
                print("test")
                self.mapView.addOverlay(route.polyline)
                print("should have added overlay")
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
            self.removeSpinner()
        }
    }
    
    func updateUI(){
        progressLabel.text = "\(String(format: "%.2f", getCurrentProgress() ?? 0))/\(String(format: "%.2f", distanceBetweenPoints)) Mi"
        
        let formattedValue = percentFormatter.string(from: NSNumber(value: Float(getCurrentProgress() ?? 0)/distanceBetweenPoints))
        
        percentLabel.text = "\(formattedValue ?? "")"
        
        progressBar.progress = Float(getCurrentProgress() ?? 0)/distanceBetweenPoints
    }
    
    func getCurrentProgress() -> Double {
        let ref = healthKitManager.mapGoal
        return (Double(ref!.currentValue) - Double(ref!.allPreviousDistances))
    }
    
    @IBAction func centerButtonPressed(_ sender: UIButton) {
        self.mapView.setVisibleMapRect(lastRoute.polyline.boundingMapRect, animated: true)
    }
    
    @IBAction func syncButtonPressed(_ sender: UIButton) {
        updateMap()
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        let message = UIAlertController(title: "Are you sure you want to delete this goal?", message: "", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) -> Void in
            
            self.healthKitManager.mapGoal = nil
            self.performSegue(withIdentifier: "SendToFirstViewControllerFromMap", sender: self)
            
        })
        message.addAction(delete)
        
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
            
        })
        message.addAction(cancel)
        
        self.present(message, animated: true, completion: nil)
        
        
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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .red
        renderer.lineWidth = 5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var found = false
        var x = -1
        
        while !found {
            x += 1
            if view.annotation?.title == healthKitManager.mapGoal?.coordinatesArray[x].name {
                found = true
                
                //                if let myUrl = self.healthKitManager.mapGoal?.coordinatesArray[x].webPage {
                //                    UIApplication.shared.open(URL(string: "\(myUrl)")!, options: [:], completionHandler: nil)
                //                }
                if self.healthKitManager.mapGoal?.coordinatesArray[x].webPage != "" {
                    
                    let message = UIAlertController(title: "Do you want to open this Wikipedia article?", message: "", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                        if let myUrl = self.healthKitManager.mapGoal?.coordinatesArray[x].webPage {
                            
                            if let url = URL(string: myUrl) {
                                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                                vc.delegate = self
                                self.present(vc, animated: true)
                            }
                            
                            //                        UIApplication.shared.open(URL(string: "\(myUrl)")!, options: [:], completionHandler: nil)
                        }
                        
                        
                    })
                    message.addAction(ok)
                    
                    let cancel = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
                        
                    })
                    message.addAction(cancel)
                    
                    self.present(message, animated: true, completion: nil)
                }
                
                
                
            }
            
        }
        
    }
}

// taken from https://brainwashinc.com/2017/07/21/loading-activity-indicator-ios-swift/
extension MapViewController {
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

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
    
}
