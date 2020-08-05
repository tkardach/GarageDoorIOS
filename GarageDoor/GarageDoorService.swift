//
//  GarageDoorViewModel.swift
//  GarageDoor
//
//  Created by Tommy Kardach on 8/4/20.
//  Copyright © 2020 Tommy Kardach. All rights reserved.
//

import Foundation

class GarageDoorService: IGarageDoorService {
    var device: ParticleDevice?
    
    init() {
        self.device = nil
        getDeviceByName(Particle.garageDoorName, completionHandler: { (device: ParticleDevice?, error: Error?) in
            if device != nil {
                self.device = device
            }
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
    func closeGarageDoor(completionHandler: @escaping (Error?) -> Void) throws -> Void {
        self.device!.callFunction(Particle.garageDoorClose, withArguments: nil) { (resultCode : NSNumber?, error : Error?) -> Void in
            completionHandler(error)
        }
    }
}
