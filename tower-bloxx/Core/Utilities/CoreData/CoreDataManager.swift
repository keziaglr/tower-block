//
//  CoreDataManager.swift
//  tower-bloxx
//
//  Created by Kezia Gloria on 23/05/23.
//

import SwiftUI
import CoreData

class CoreDataManager: ObservableObject{
    let container: NSPersistentContainer
    @Published var savedEntities: [Scoreboard] = []
    
    init() {
        container = NSPersistentContainer(name: "TowerBlock")
        container.loadPersistentStores{(description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error) ")
            }
        }
        fetch()
        if savedEntities.isEmpty{
            addData(name: "N/A", score: 0)
            addData(name: "N/A", score: 0)
            addData(name: "N/A", score: 0)
            addData(name: "N/A", score: 0)
            addData(name: "N/A", score: 0)
        }
    }
    
    func fetch(){
        let request = NSFetchRequest<Scoreboard>(entityName: "Scoreboard")
        
        do{
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
        
        savedEntities.sort { $0.score > $1.score }
    }
    
    func addData(name: String, score: Int){
        let newData = Scoreboard(context: container.viewContext)
        newData.id = UUID()
        newData.name = name
        newData.score = Int64(score)
        saveData()
    }
    
    func saveData(){
        do{
            try container.viewContext.save()
        }catch let error{
            print("Error fetching. \(error)")
        }
    }
}
