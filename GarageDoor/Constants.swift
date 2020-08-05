//
//  Constants.swift
//  GarageDoor
//
//  Created by Tommy Kardach on 8/4/20.
//  Copyright © 2020 Tommy Kardach. All rights reserved.
//

import Foundation

enum ParticleError: Error {
    case notLoggedIn(String)
    case credentialSaveError(String)
    case functionCallFailed(String)
    case deviceNotFound(String)
}

enum GarageDoorError: Error {
    case serviceNotInitialized(String)
    case particleCloudCredentialsDNE(String)
    case particleCloudLoginFailure(String)
    case garageDoorDeviceNotFound(String)
}

struct Particle {
    static let particleService = "particle-cloud"
    static let usernameKey = "ParticleUser"
    static let passwordKey = "ParticlePassword"
    static let garageDoorName = "GarageDoor"
    static let garageDoorOpen = "openGarageDoor"
    static let garageDoorClose = "closeGarageDoor"
}
