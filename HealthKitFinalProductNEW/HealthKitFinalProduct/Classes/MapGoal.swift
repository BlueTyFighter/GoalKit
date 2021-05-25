//
//  MapGoal.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 4/18/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import Foundation
import MapKit

struct MapGoal: Codable {
    
    var name: String
    var coordinatesArray: [Annotations]
    var dateStarted: Date
    var numberOfSpotsVisited: Int
    var currentValue: Double
    var distancesBetweenEachPoint: [Double]
    var allPreviousDistances: Double
    
    init(name: String, coor: [Annotations]) {
        self.name = name
        self.coordinatesArray = coor
        self.dateStarted = Date()
        self.numberOfSpotsVisited = 0
        self.currentValue = 0
        distancesBetweenEachPoint = []
        allPreviousDistances = 0
    }
    
    mutating func setCurrentValue(value: Double){
        currentValue = value
    }
    
    mutating func increaseSpots(){
        numberOfSpotsVisited = numberOfSpotsVisited + 1
    }
    
    mutating func setAllPreviousDistances(value: Double){
        allPreviousDistances = value
    }
    
    
//    var listOfCoordinates: [CLLocationCoordinate2D]
    
}

struct Annotations: Codable {
    var lat: CLLocationDegrees
    var long: CLLocationDegrees
    var name: String
    var webPage: String?
}


