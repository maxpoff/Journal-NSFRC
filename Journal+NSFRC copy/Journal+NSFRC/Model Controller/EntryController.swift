//
//  EntryController.swift
//  Journal+NSFRC
//
//  Created by Karl Pfister on 5/9/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    static let sharedInstance = EntryController()
    
    //Create variable to access our fetched results controller, exepecting an Entry
    var fetchedResultsController: NSFetchedResultsController<Entry>
    
    //Create an initializer that gives our fetch results controller a value
    init() {
        
        //Create a fetch request in order to fulfill the parameter requirement of the resultControllers initializer
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        //Access the sort descrriptors property on our fetch request and told it we wanted our reults sorted by timestamp, descending order
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        //Create a constant called results controller that was a NSFetchedResults controller initialized from the available initializer
        let resultsController: NSFetchedResultsController<Entry> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch: \(error.localizedDescription)")
        }
    }
    
    //CRUD
    func createEntry(withTitle: String, withBody: String) {
        let _ = Entry(title: withTitle, body: withBody)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, newTitle: String, newBody: String) {
        entry.title = newTitle
        entry.body = newBody
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        entry.managedObjectContext?.delete(entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
             try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object. Items not saved!! \(#function) : \(error.localizedDescription)")
        }
    }
}//End of class
