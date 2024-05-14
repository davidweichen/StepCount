//
//  StepCountApp.swift
//  StepCount
//
//  Created by 陳加偉 on 5/3/24.
//

import SwiftUI

@main
struct StepCountApp: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
