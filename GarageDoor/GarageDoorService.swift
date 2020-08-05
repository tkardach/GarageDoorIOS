//
//  GarageDoorViewModel.swift
//  GarageDoor
//
//  Created by Tommy Kardach on 8/4/20.
//  Copyright © 2020 Tommy Kardach. All rights reserved.
//

import Foundation
import Combine

class GarageDoorService: ObservableObject, IGarageDoorService {
    var device: ParticleDevice?
    
    var initializing: Bool = true {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    var initialized: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    init() {
        self.initializing = true
        self.initialized = false
        self.device = nil
        getDeviceByName(Particle.garageDoorName, completionHandler: { (device: ParticleDevice?, error: Error?) in
            if device != nil {
                self.device = device
            }
            self.initializing = false
            self.initialized = true
        })
    }
    
    
    /**Trigger the open garage door function
     */
    func openGarageDoor(completionHandler: @escaping (Error?) -> Void) -> Void {
        self.device!.callFunction(Particle.garageDoorOpen, withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            completionHandler(error)
        }
    }
    
    /**Trigger the close garage door function
     */
    func closeGarageDoor(completionHandler: @escaping (Error?) -> Void) -> Void {
        self.device!.callFunction(Particle.garageDoorClose, withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            completionHandler(error)
        }
    }
}
