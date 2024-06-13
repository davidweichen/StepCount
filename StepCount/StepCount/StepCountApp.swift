//
//  StepCountApp.swift
//  StepCount
//
//  Created by 陳加偉 on 5/3/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
@main
struct StepCountApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
