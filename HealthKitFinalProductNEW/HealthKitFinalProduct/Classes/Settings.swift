//
//  Settings.swift
//  HealthKitFinalProduct
//
//  Created by Tyler Calderwood on 3/23/21.
//  Copyright © 2021 Tyler Calderwood. All rights reserved.
//

import Foundation

struct Settings {
    static let singletonSettings = Settings(circleProgressSetting: false, isGuestureEnabled: true, guestureDirection: false)
    
    var circleProgressFromStart: Bool = false
    
    var isGuestureEnabled: Bool = true
    
    var guestureDirectionIsRightUp: Bool = false
    
    mutating func setCircleProgressFromStart(value: Bool) {
        circleProgressFromStart = value
    }
    
    init(circleProgressSetting: Bool, isGuestureEnabled: Bool, guestureDirection: Bool) {
        circleProgressFromStart = circleProgressSetting
        self.isGuestureEnabled = isGuestureEnabled
        guestureDirectionIsRightUp = guestureDirection
        
    }
}
