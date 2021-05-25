//
//  HealthKitManager.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 3/7/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import Foundation
import HealthKit
import MapKit

class HealthKitManager {
    
    let healthKitStore = HKHealthStore()
    

    var allHealthGoals = [HealthGoal]()
    static let singletonHealthKitManager = HealthKitManager()
    
    let userDefaults = UserDefaults.standard
    
    var getGoal: Bool = false
    var goalMeaning: String = ""
    
    // MARK: HEALTHGOAL METHODS
    
    func addNewHealthGoal(name: String, units: String, typeOfData: Int, goalValues: [Double], goalMeaning: [String]){
        
        allHealthGoals.append(HealthGoal(name: name, units: units, typeOfData: typeOfData, goalValues: goalValues, goalMeaning: goalMeaning))
        
        
        var dataToRead: HKObjectType = getHKObjectType(typeOfData: typeOfData)
        
        authorizeHealthKit(toRead: dataToRead) { (authorized, error) in
            if !authorized {
                print("Not authorized. The error is: \(error)")
            }
        }
        
        saveData()
        
        print("count of healthgoals \(allHealthGoals.count)")
        print("latest heathgoal \(allHealthGoals[allHealthGoals.count-1])")
    }
    
    func updateValues(){
        if allHealthGoals.count != 0 {
            for x in 0...(allHealthGoals.count-1) {
                
                var ref = allHealthGoals[x]
                
                var typeOfData = ref.typeOfData
                var dataToRead: HKObjectType = getHKObjectType(typeOfData: typeOfData)
                
                
                callHealthKit(dateStarted: ref.dateStarted, type: ref.typeOfData, sampleType: dataToRead as! HKSampleType) { (finalValue, error) in
                    if error != nil {
                        print("error \(error)")
                    } else {
                        self.allHealthGoals[x].setCurrentValue(value: finalValue)
                        //                    print("current value \(self.allHealthGoals[x].currentValue)")
                    }
                }
                
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.allHealthGoals.count > 0 {
                    for x in 0...(self.allHealthGoals.count-1) {
                        if self.allHealthGoals[x].goalReached < self.allHealthGoals[x].goalValues.count {
                            if self.allHealthGoals[x].currentValue > self.allHealthGoals[x].goalValues[self.allHealthGoals[x].goalReached] {
                                self.getGoal = true
                                self.goalMeaning = self.allHealthGoals[x].goalMeaning[self.allHealthGoals[x].goalReached]
                                self.allHealthGoals[x].setGoalReached(value: self.allHealthGoals[x].goalReached+1)
                                self.saveData()
                            }
                        }
                        
                    }
                }
                
                
            }
        }
        
        if mapGoal != nil {
            
            
            
            
            var dataToRead: HKObjectType = getHKObjectType(typeOfData: 1)
            
            
            callHealthKit(dateStarted: mapGoal!.dateStarted, type: 1, sampleType: dataToRead as! HKSampleType) { (finalValue, error) in
                if error != nil {
                    print("error \(error)")
                } else {
                    self.mapGoal?.setCurrentValue(value: finalValue)
                    //                    print("current value \(self.allHealthGoals[x].currentValue)")
                }
            }
        }
        
        
    }
    
    // MARK: HEALTHKIT METHODS
    
    func authorizeHealthKit(toRead: HKObjectType, completion: ((_ success: Bool, _ error: NSError) -> Void)!) {
          // State the health data type(s) we want to read from HealthKit.
        let healthDataToRead = Set([toRead])
              
              // State the health data type(s) we want to write from HealthKit.
              
              // Just in case OneHourWalker makes its way to an iPad...
              if !HKHealthStore.isHealthDataAvailable() {
                  print("Can't access HealthKit.")
              }
              
              // Request authorization to read and/or write the specific data.
        healthKitStore.requestAuthorization(toShare: Set(), read: healthDataToRead) { (success, error) in
            if !success{
                print(error as Any)
            } else {
                print("Success! You have permission to read and write!")
            }
        }
        
        
    }
    
    func callHealthKit(dateStarted: Date, type: Int, sampleType: HKSampleType , completion: ((Double, NSError?) -> Void)!) {
        
        // Predicate for the height query
        
        let distantPast = dateStarted
        let currentDate = NSDate()
        let lastHeightPredicate = HKQuery.predicateForSamples(withStart: distantPast as Date, end: currentDate as Date, options: [])
        
        // Get the single most recent height
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Query HealthKit for the last Height entry.
        let Query = HKSampleQuery(sampleType: sampleType, predicate: lastHeightPredicate, limit: 0, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
                
                if let queryError = error {
                    completion?(0, queryError as NSError)
                    return
                }
                
                // Set the first HKQuantitySample in results as the most recent height.
            let count = results!.count
            var total = 0.0
            
            
            
            if count > 0 {
                for n in 0...(count-1){
                    let distance = results![n] as? HKQuantitySample
                    if type == 0 {
                        total = total + Double((distance!.quantity.doubleValue(for: .count())))
                    } else if type == 1 {
                        total = total + Double((distance!.quantity.doubleValue(for: .mile())))
                    } else if type == 2 {
                        total = total + Double((distance!.quantity.doubleValue(for: .minute())))
                    } else if type == 3 {
                        total = total + Double((distance!.quantity.doubleValue(for: .hour())))
                    } else if type == 4 {
                        
                        total = total + Double((distance!.quantity.doubleValue(for: .count())))
                    } else if type == 5 {
                        // taken from https://medium.com/free-code-camp/read-write-mindful-minutes-from-healthkit-with-swift-232b65118fe2
                        
                        total = results?.map(self.calculateTotalTime).reduce(0, { $0 + $1 }) ?? 0
                    }
                    
                }
            }
            
            
            
                if completion != nil {
                    completion(total, nil)
                }
        }
        
        // Time to execute the query.
        self.healthKitStore.execute(Query)
    }
    
    // MARK: EXTRA METHODS

    func calculateTotalTime(sample: HKSample) -> TimeInterval {
        let totalTime = sample.endDate.timeIntervalSince(sample.startDate)
        let wasUserEntered = sample.metadata?[HKMetadataKeyWasUserEntered] as? Bool ?? false

        return totalTime
    }

    
    func getAllHealthGoals() -> [HealthGoal]{
        return allHealthGoals
    }
    
    func getHKObjectType(typeOfData: Int) -> HKObjectType {
        
        var dataToRead: HKObjectType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        if typeOfData==0 {
            dataToRead = HKObjectType.quantityType(forIdentifier: .stepCount)!
        } else if typeOfData==1 {
            dataToRead = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        } else if typeOfData == 2 {
            dataToRead = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        } else if typeOfData == 3 {
            dataToRead = HKObjectType.quantityType(forIdentifier: .appleStandTime)!
        } else if typeOfData == 4 {
            dataToRead = HKObjectType.quantityType(forIdentifier: .flightsClimbed)!
        } else if typeOfData == 5 {
            dataToRead = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        }
        
        return dataToRead
    }
    
    // MARK: SAVE AND LOAD CODE
    
    func saveData(){
        do {
            try userDefaults.setObject(allHealthGoals, forKey: "AllHealthGoals")
            try userDefaults.setObject(mapGoal, forKey: "mapGoal")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func loadData(){
        do {
            let allHealthGoalsSaved = try userDefaults.getObject(forKey: "AllHealthGoals", castTo: [HealthGoal].self)
            self.allHealthGoals = allHealthGoalsSaved
            
            let mapGoalSaved = try userDefaults.getObject(forKey: "mapGoal", castTo: MapGoal.self)
            mapGoal = mapGoalSaved
        } catch {
            print(error.localizedDescription)
        }
        

    }
    
   
    
    // MARK: ALL MAP STUFF
    var mapGoal: MapGoal?
    
    func createMapGoal(name: String, coor: [Annotations]) {
        mapGoal = MapGoal(name: name, coor: coor)
        
        let dataToRead: HKObjectType = getHKObjectType(typeOfData: 1)
        
        authorizeHealthKit(toRead: dataToRead) { (authorized, error) in
            if !authorized {
                print("Not authorized. The error is: \(error)")
            }
        }
        
        saveData()
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
    
    // MARK: ALL CUSTOM MAP STUFF
    var customMapCreationArray: [Annotations] = []
    
    func addToCustomMapCreationArray(name: String, address: CLLocationCoordinate2D, website: String?) {
        customMapCreationArray.append(Annotations(lat: address.latitude, long: address.longitude, name: name, webPage: website))
        print("Working addTo \(customMapCreationArray[0].lat)")
    }
    
    
}


// taken from https://medium.com/flawless-app-stories/save-custom-objects-into-userdefaults-using-codable-in-swift-5-1-protocol-oriented-approach-ae36175180d8
   
protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}


/*
 if (mapGoal?.distancesBetweenEachPoint.count)! < ((mapGoal?.coordinatesArray.count)!)-1 {
     mapGoal?.distancesBetweenEachPoint = []
     print("# in coor: \(mapGoal?.coordinatesArray.count)")
     for x in 0...((mapGoal?.coordinatesArray.count)!)-2 {
         print("THIS IS A TEST")
         guard let request = createRequest(coordinate: CLLocationCoordinate2D(latitude: mapGoal?.coordinatesArray[x].lat ?? 54.0336, longitude: mapGoal?.coordinatesArray[x].long ?? 48.6804), destinationCoordinate: CLLocationCoordinate2D(latitude: mapGoal?.coordinatesArray[x+1].lat ?? 54.0336, longitude: mapGoal?.coordinatesArray[x+1].long ?? 48.6804)) else { return }
         let directions = MKDirections(request: request)
         
         directions.calculate { [unowned self] (response, error) in
             guard let response = response else { return }
             let routes = response.routes
             
             
             let distance = response.routes.first?.distance // meters
             print("\(distance! / 1000)km")
             
             self.mapGoal?.distancesBetweenEachPoint.append((distance ?? 0.0) * 0.000621371192)  // miles
             
             
         }
         
         
     }
     
     
 }
 */
