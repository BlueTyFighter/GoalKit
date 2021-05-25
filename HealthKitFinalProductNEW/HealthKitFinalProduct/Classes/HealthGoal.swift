//
//  HealthGoal.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 3/7/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import Foundation
import HealthKit

struct HealthGoal: Codable {
    
    var name: String = ""
    var units: String = ""
//    var typeOfData: HKObjectType
    var typeOfData: Int
    var goalValues: [Double]
    var goalMeaning: [String]
    var dateStarted: Date
    
    
    
    // this will be 1 if they have completed the first goal, 2 if they have completed the second, etc.
    var goalReached: Int
    var currentValue: Double
    
    init(name: String, units: String, typeOfData: Int, goalValues: [Double], goalMeaning: [String]) {
        
        
        self.name = name
        self.units = units
        self.typeOfData = typeOfData
        self.goalValues = goalValues
        self.goalReached = 0
        self.goalMeaning = goalMeaning
        self.dateStarted = Date()
        self.currentValue = 0.0
    }
    
    mutating func setCurrentValue(value: Double){
        currentValue = value
    }
    mutating func setGoalReached(value: Int){
        goalReached = value
    }
    
    mutating func setNewTitle(value: String){
        name = value
    }
    
    
    
    
}
