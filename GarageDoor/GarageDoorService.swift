//
//  GarageDoorViewModel.swift
//  GarageDoor
//
//  Created by Tommy Kardach on 8/4/20.
//  Copyright © 2020 Tommy Kardach. All rights reserved.
//

import Foundation
import Combine

/**
 Manages the GarageDoor device for the currently logged in particle user
 */
class GarageDoorService: ObservableObject, IGarageDoorService {
    ///GarageDoor particle device
    var device: ParticleDevice?
    
    ///True if the GarageDoorService is still being initialized
    var initializing: Bool = true {
        didSet {
            self.objectWillChange.send()
        }
    }
    ///True if the GarageDoorService successfully initialized, false otherwise
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
    
    /**
     Get a device by the given `name`, then return it in the `completionHandler`
     ```
     getDeviceByName(Particle.garageDoorName, completionHandler: { (device: ParticleDevice?, error: Error?) in
        if let _ = error {
            print(error!.localizedDescription)
        }
     })
     ```
     
     - Parameter name: Name of the device to return
     - Parameter completionHandler: Callback function which returns the particle device and any errors
    */
    private func getDeviceByName(_ name: String, completionHandler: @escaping (ParticleDevice?, Error?) -> Void) -> Void {
        ParticleCloud.sharedInstance().getDevices { (devices:[ParticleDevice]?, error:Error?) -> Void in
            if let _ = error {
                completionHandler(nil, error)
            }
            else {
                if let d = devices {
                    for device in d {
                        if device.name == name {
                            completionHandler(device, nil)
                            return
                        }
                    }
                }
                else {
                    completionHandler(nil, ParticleError.deviceNotFound("Could not find device with name \(name)"))
                }
            }
        }
    }
    
    /**
     Trigger the open garage door function
     
     - Parameter completionHandler: Callback function which returns any errors that may have occured
     */
    func openGarageDoor(completionHandler: @escaping (Error?) -> Void) -> Void {
        self.device!.callFunction(Particle.garageDoorOpen, withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            completionHandler(error)
        }
    }
    
    /**
     Trigger the close garage door function
     
     - Parameter completionHandler: Callback function which returns any errors that may have occured
     */
    func closeGarageDoor(completionHandler: @escaping (Error?) -> Void) -> Void {
        self.device!.callFunction(Particle.garageDoorClose, withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            completionHandler(error)
        }
    }
}
