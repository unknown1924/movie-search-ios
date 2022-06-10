//
//  PersistenceController.swift
//  CoreDataTemp
//
//  Created by 10683830 on 05/06/22.
//

import CoreData

struct PersistenceController {
    let container: NSPersistentContainer
    
    static let shared = PersistenceController()
    
    // Convenience
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController()
        let viewContext = result.container.viewContext

        // Companies
        let newCompany = MovieData(context: viewContext)
        newCompany.name = "Appe"
        newCompany.imdbID = "tt0371746"
        newCompany.title = "Iron Man"
        newCompany.poster = ""

        // shared.saveContext()

        return result
    }()
    
    init() {
        container = NSPersistentContainer(name: "MovieDb")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // Better save
    func saveContext(completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
            
        }
    }
    
    func delete(_ object:NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
        let context = container.viewContext
        context.delete(object)
        saveContext(completion: completion)
    }
}
