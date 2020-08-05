//
//  GarageDoorProtocols.swift
//  GarageDoor
//
//  Created by Tommy Kardach on 8/4/20.
//  Copyright © 2020 Tommy Kardach. All rights reserved.
//

import Foundation

protocol IGarageDoorService {
    var device: ParticleDevice? { get }
    
    func openGarageDoor(completionHandler: @escaping  (Error?) -> Void) -> Void
    func closeGarageDoor(completionHandler: @escaping  (Error?) -> Void) -> Void
}
