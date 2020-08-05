//
//  ContentView.swift
//  GarageDoor
//
//  Created by Tommy Kardach on 8/4/20.
//  Copyright © 2020 Tommy Kardach. All rights reserved.
//

import SwiftUI

extension Color {

    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return Color.black
        } else {
            return Color.white
        }
    }
    
    static func foregroundColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return Color.white
        } else {
            return Color.black
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var auth: ParticleAuth
    @Environment(\.colorScheme) var colorScheme: ColorScheme


    var body: some View {
        if auth.initializing {
            return AnyView(
                    VStack {
                      ActivityIndicator()
                        .frame(width: 50, height: 50)
                    }.foregroundColor(Color.foregroundColor(for: self.colorScheme))
                )
                .background(Color(UIColor.systemBackground))
        }  else if !auth.loggedIn {
            return AnyView(LoginView().environmentObject(auth))
            .background(Color(UIColor.systemBackground))
        } else {
            return AnyView(GarageButtonView().environmentObject(GarageDoorService()))
                .background(Color(UIColor.systemBackground))
        }
    }
}

struct ActivityIndicator: View {
  @State private var isAnimating: Bool = false

  var body: some View {
    GeometryReader { (geometry: GeometryProxy) in
      ForEach(0..<5) { index in
        Group {
          Circle()
            .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
            .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
            .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
          }.frame(width: geometry.size.width, height: geometry.size.height)
            .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
            .animation(Animation
              .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
              .repeatForever(autoreverses: false))
        }
      }.aspectRatio(1, contentMode: .fit)
        .onAppear {
          self.isAnimating = true
        }
  }
}


struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var auth: ParticleAuth
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var error: String = ""
    
    func attemptLogin() -> Void {
        self.error = ""
        self.auth.signInToParticleCloud(self.username, self.password, completion: {(error: Error?) in
            if let _ = error {
                self.error = error!.localizedDescription
            }
        })
    }
    
    var body: some View {
        var chunk: AnyView
        
        if auth.signingIn {
            chunk = AnyView(VStack {
              ActivityIndicator()
                .frame(width: 50, height: 50)
              }
              .foregroundColor(Color.foregroundColor(for: self.colorScheme)))
        } else {
            chunk = AnyView(
                VStack {
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
                }
            )
        }
        
        
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
            chunk
            Text(self.error)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.top, 20)
                .padding()
                .lineLimit(3)
                .foregroundColor(Color.foregroundColor(for: self.colorScheme))
        }
        .padding()
    }
}


struct GarageButtonView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var service: GarageDoorService
    
    @State private var pressed = false
    @State private var error: String = ""
    
    let defaultIcon: String = "garage-door"
    let pressedIcon: String = "garage-door-pressed"
    
    func openGarageDoor() -> Void {
        self.service.openGarageDoor(completionHandler: { (error: Error?) -> Void in
            if error != nil {
                self.error = error!.localizedDescription
            }
        })
    }
    
    func closeGarageDoor() -> Void {
        self.service.closeGarageDoor(completionHandler: { (error: Error?) -> Void in
            if error != nil {
                self.error = error!.localizedDescription
            }
        })
    }
    
    var body: some View {
        if service.initializing {
            return AnyView(
                VStack {
                    ActivityIndicator()
                      .frame(width: 50, height: 50)
                    }
                    .foregroundColor(Color.foregroundColor(for: self.colorScheme)))
        } else if service.initialized && service.device == nil {
            return AnyView(
                Text("Device was not initialized. You must have a GarageDoor particle device.")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                    .padding()
                    .lineLimit(3)
                    .foregroundColor(Color.foregroundColor(for: self.colorScheme)))
        } else {
            return AnyView(
                VStack {
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
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
