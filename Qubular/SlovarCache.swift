//
//  VocabulaireCache.swift
//  Qubular
//
//  Created by Oleg Dreyman on 27.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire
import CoreData

protocol SlovarCache: class {
    var vocabulary: Vocabulary? { get set }
}

class SlovarFileCache: SlovarCache {
    
    let fileLocation: NSURL
    private let file: NSFileHandle
    
    init(fileLocation: NSURL) {
        self.fileLocation = fileLocation
        self.file = try! NSFileHandle(forUpdatingURL: fileLocation)
        do {
            try loadVocabulary()
        } catch {
            debugPrint(error)
            storedVocabulary = []
        }
    }
    
    private func loadVocabulary() throws {
        let data = file.readDataToEndOfFile()
        if let representations = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [Structure] {
            let entries = representations.flatMap({ try? Entry(from: $0) })
            storedVocabulary = entries
        } else { print("Fail") }
    }
    
    private func saveVocabulary() throws {
        do {
            let representations = storedVocabulary.map({ $0.representation })
            let data = try NSJSONSerialization.dataWithJSONObject(representations, options: [])
            file.truncateFileAtOffset(0)
            file.writeData(data)
        } catch {
            debugPrint(error)
        }
    }
    
    private var storedVocabulary: Vocabulary = []
    
    var vocabulary: Vocabulary? {
        get {
            return storedVocabulary
        }
        set {
            if let newValue = newValue {
                storedVocabulary = newValue
                do { try saveVocabulary() } catch { }
            }
        }
    }
    
}

class SlovarCDCache: SlovarCache {
    
    let stack: CoreDataStack
    
    init(stack: CoreDataStack = CoreDataStack()) {
        self.stack = stack
        let request = NSFetchRequest(entityName: "Entry")
        do {
            let objects = try stack.managedObjectContext.executeFetchRequest(request) as! [NSManagedObject]
            if let binaries = objects.flatMap({ $0.valueForKey("entry") }) as? [NSData] {
                let representations = try binaries.flatMap({ try NSJSONSerialization.JSONObjectWithData($0, options: []) as? [String: AnyObject] })
                let entries = representations.flatMap({ try? Entry(from: $0) })
                storedVocabulary = entries
            }
        } catch {
            return
        }
    }
    
    private var storedVocabulary: Vocabulary = []
    
    var vocabulary: Vocabulary? {
        get {
            return storedVocabulary
        }
        set {
            if let newValue = newValue {
                let request = NSFetchRequest(entityName: "Entry")
                let batch = NSBatchDeleteRequest(fetchRequest: request)
                do { try stack.persistentStoreCoordinator.executeRequest(batch, withContext: stack.managedObjectContext) } catch { }
                storedVocabulary = newValue
                for entry in newValue {
                    do {
                        let binary = try NSJSONSerialization.dataWithJSONObject(entry.representation, options: [])
                        let object = NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: stack.managedObjectContext)
                        object.setValue(binary, forKey: "entry")
                    } catch {
                        continue
                    }
                }
                stack.saveContext()
            }
        }
    }
    
}

class SlovarNSCache: SlovarCache {
    
    private static let slovarKey = "slovar"
    private let cache = NSCache()
    
    init() {
        let book = Book(vocabulary: [])
        cache.setObject(book, forKey: SlovarNSCache.slovarKey)
    }
    
    var vocabulary: Vocabulary? {
        get {
            if let book = cache.objectForKey(SlovarNSCache.slovarKey) as? Book {
                return book.vocabulary
            }
            return nil
        }
        set {
            guard let vocabulary = newValue else { return }
            let book = Book(vocabulary: vocabulary)
            cache.setObject(book, forKey: SlovarNSCache.slovarKey)
        }
    }
    
}

private class Book {
    
    var vocabulary: Vocabulary
    
    init(vocabulary: Vocabulary) {
        self.vocabulary = vocabulary
    }
    
}
