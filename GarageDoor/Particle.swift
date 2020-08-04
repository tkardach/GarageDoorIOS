//
//  Particle.swift
//  GarageDoor
//
//  Created by Tommy Kardach on 8/4/20.
//  Copyright © 2020 Tommy Kardach. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


func signInToParticleCloud(_ username: String, password: String, saveInfo: Bool = true) -> Bool {
    var returnValue: Bool = false
    ParticleCloud.sharedInstance().login(withUser: username, password: password) { (error:Error?) -> Void in
        if let _ = error {
            returnValue = false
        }
        else {
            returnValue = true
        }
    }
    
    if returnValue && saveInfo {
        let successfulSave: Bool =
            KeychainWrapper.standard.set(username, forKey:  Particle.usernameKey) &&
            KeychainWrapper.standard.set(password, forKey:  Particle.passwordKey)
    }
    
    return returnValue
}

func signInToParticleCloud() -> Bool {
    return true
}
