//
//  ContentView.swift
//  GarageDoor
//
//  Created by Tommy Kardach on 8/4/20.
//  Copyright © 2020 Tommy Kardach. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: ParticleAuth
    
    var body: some View {
        if !auth.loggedIn {
            return AnyView(LoginView(auth))
        } else {
            return AnyView(GarageButtonView(GarageDoorService()))
        }
    }
}


struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    
    var auth: ParticleAuth
    
    init(_ auth: ParticleAuth) {
        self.auth = auth
    }
    
    func attemptLogin() -> Void {
        self.auth.signInToParticleCloud(self.username, self.password)
    }
    
    var body: some View {
        return VStack {
            Image("particle")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(150)
                .padding(.top, 75)
            Text("Login to Particle")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.top, 20)
                .padding()
            TextField("Username", text: $username)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: { self.attemptLogin() }) {
                Text("LOGIN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            Text(self.error)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.top, 20)
                .padding()
        }
        .padding()
    }
}


struct GarageButtonView: View {
    var service: IGarageDoorService
    let defaultIcon: String = "garage-door"
    let pressedIcon: String = "garage-door-pressed"
    
    @State private var pressed = false
    @State private var error: String = ""

    init(_ service: IGarageDoorService) {
        self.service = service
    }
    
    func openGarageDoor() -> Void {
        do {
            try self.service.openGarageDoor(completionHandler: { (error: Error?) -> Void in
                if error != nil {
                    self.error = error!.localizedDescription
                }
            })
        } catch ParticleError.functionCallFailed {
            self.error = "Open Garage Door function failed."
        } catch GarageDoorError.serviceNotInitialized {
            self.error = "Garage Door Service is not initialized"
        } catch {
            self.error = "Unknown error occured during open garage door"
        }
    }
    
    func closeGarageDoor() -> Void {
        do {
            try self.service.closeGarageDoor(completionHandler: { (error: Error?) -> Void in
                if error != nil {
                    self.error = error!.localizedDescription
                }
            })
        } catch ParticleError.functionCallFailed {
            self.error = "Close Garage Door function failed."
        } catch GarageDoorError.serviceNotInitialized {
           self.error = "Garage Door Service is not initialized"
       } catch {
            self.error = "Unknown error occured during close garage door"
        }
    }
    
    var body: some View {
        return VStack {
            Image(self.pressed ? self.pressedIcon : self.defaultIcon)
                .resizable()
                .frame(width: 180.0, height: 180.0)
                .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.pressed = pressing
                        if self.pressed {
                            self.openGarageDoor()
                        } else {
                            self.closeGarageDoor()
                        }
                    }
                }, perform: { })
            Text(self.error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
