//
//  movie_list_searchable_apiApp.swift
//  movie_list_searchable_api
//
//  Created by 10683830 on 30/05/22.
//

import SwiftUI

@main
struct movie_list_searchable_apiApp: App {
    
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
                
            case .background:
                print("background")
                persistenceController.saveContext()
            case .inactive:
                print("inactive")
            case .active:
                print("active")
            @unknown default:
                print("apple changed something")
            }
        }
    }
}
