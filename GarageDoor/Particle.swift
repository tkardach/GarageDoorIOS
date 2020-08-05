//
//  Particle.swift
//  GarageDoor
//
//  Created by Tommy Kardach on 8/4/20.
//  Copyright © 2020 Tommy Kardach. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Combine


class ParticleAuth: ObservableObject {
    
    ///True if the signin process is currently in progress
    var signingIn: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    ///True if authorization is still initializing; false when intialization has completed
    var initializing: Bool = true {
        didSet {
            self.objectWillChange.send()
        }
    }
    ///True if the particle user is logged in
    var loggedIn: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    ///True if there are particle credentials saved
    var credentialsSaved: Bool = false {
        didSet {
            self.objectWillChange.send()
        }
    }
    
    init() {
        self.initializing = true
        if particleCredentialsStored() {
            signInToParticleCloud()
        } else {
            self.initializing = false
        }
    }
    
    /**
     Sign into the ParticleCloud using the given `username` and `password`
     ```
     signInToParticleCloud("username", "password", saveInfo: false)
     ```
     - Throws: `ParticleError.credentialSaveError` if credentials failed to save
     - Parameter username: Particle cloud username
     - Parameter password: Particle cloud password
     - Parameter saveInfo: If true, save credentials to be used later
     - Returns: true if the login was successful, false otherwise
     */
    func signInToParticleCloud(_ username: String, _ password: String, saveInfo: Bool = true, completion: ((Error?) -> Void)? = nil) -> Void {
        self.signingIn = true
        ParticleCloud.sharedInstance().login(withUser: username, password: password) { (error:Error?) -> Void in
            if let _ = error {
                self.loggedIn = false
            }
            else {
                self.loggedIn = true
            }

            if self.loggedIn && saveInfo {
                let successfulSave: Bool =
                    KeychainWrapper.standard.set(username, forKey: Particle.usernameKey) &&
                    KeychainWrapper.standard.set(password, forKey: Particle.passwordKey)
                
                if successfulSave {
                    self.credentialsSaved = true
                } else {
                    self.credentialsSaved = false
                }
            }
            
            self.initializing = false
            self.signingIn = false
            
            if completion != nil {
                completion!(error)
            }
        }.resume()
    }

    /**
     Sign into the ParticleCloud using the saved credentials
    ```
    signInToParticleCloud()
    ```
    - Throws: `ParticleError.credentialSaveError` if credentials failed to save
    - Returns: true if the login was successful, false otherwise
    */
    func signInToParticleCloud() -> Void {
        let username: String? = KeychainWrapper.standard.string(forKey: Particle.usernameKey)
        let password: String? = KeychainWrapper.standard.string(forKey: Particle.passwordKey)
        
        if username != nil && password != nil {
            self.signInToParticleCloud(username!, password!, saveInfo: false)
        }
    }

    /**
     Check if there are stored credentials for the Particle Cloud
     ```
     if (particleCredentialsStored()) {
        print("Particle credentials exist!")
     }
     ```
     - Returns: true if there are credentials stored for the Particle Cloud
     */
    func particleCredentialsStored() -> Bool {
        let username: String? = KeychainWrapper.standard.string(forKey: Particle.usernameKey)
        let password: String? = KeychainWrapper.standard.string(forKey: Particle.passwordKey)
        
        if username == nil || password == nil {
            return false
        }
        return true
    }
}
