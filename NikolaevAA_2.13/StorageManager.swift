//
//  StorageManager.swift
//  NikolaevAA_2.13
//
//  Created by Anton Nikolaev on 07.12.2021.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    private var taskList: [Task] = []
    
    //получить массив задач для представления в tableView
    func loadTaskStringInDB() -> [String] {
        fetchData()
        var tasksString: [String] = []
        
        for task in taskList {
            tasksString.append(task.title ?? "")
        }
        
        return tasksString
    }
    
    //добавить новую задачу в базу данных
    func saveInDB(_ taskName: String) {
        let task = Task(context: persistentContainer.viewContext)
        task.title = taskName
        taskList.append(task)
        
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
    
    //удалить задачу из базы данных
    func removeTaskInDB(_ taskIndex: Int) {
        persistentContainer.viewContext.delete(taskList[taskIndex])
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
        }
        taskList.remove(at: taskIndex)
    }
    
    //изменить задачу в базе данных
    func changeTaskInDB(task taskName: String, forIndex taskIndex: Int) {
        taskList[taskIndex].title = taskName
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }

    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NikolaevAA_2_13")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    private init(){}
}
