//
//  DataPersistenceManager.swift
//  MobilliumProject
//
//  Created by Yarkın Gazibaba on 20.05.2022.
//

import Foundation
import UIKit
import CoreData

class DatapersistenceManager {
    
    enum DatabaseError : Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    
    static let shared = DatapersistenceManager()
    
    func saveRocket(model: LaunchesModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let item = RocketItem(context: context)
        
        item.name = model.name
        item.details = model.details
        item.date_local = model.date_local
        item.linkModel = model.links?.patch?.small
        item.articleLink = model.links?.article
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
            print(error.localizedDescription)
        }
    }
    
    func fetchingTitleItemFromDatabase(completion: @escaping(Result<[RocketItem], Error>) -> Void){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest <RocketItem>
        
        request = RocketItem.fetchRequest()
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: RocketItem, completion: @escaping(Result<Void, Error>) -> Void ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model) // asking the database manager to delete ceretain object
        
        do{
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
}
