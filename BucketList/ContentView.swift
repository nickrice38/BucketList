//
//  ContentView.swift
//  BucketList
//
//  Created by Nick Rice on 13/08/2021.
//

import LocalAuthentication
import MapKit
import SwiftUI

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        ZStack {
            if isUnlocked {
                FullScreenView()
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(Color.white)
                .clipShape(Capsule())
                .alert(isPresented: $showingError) {
                    Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.errorTitle = "Couldn't Unlock BucketList"
                        self.errorMessage = "Your face wasn't recognised."
                        self.showingError = true
                    }
                }
            }
        } else {
            self.errorTitle = "Couldn't Unlock BucketList"
            self.errorMessage = "Your device doesn't support biometric authentication."
            self.showingError = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
