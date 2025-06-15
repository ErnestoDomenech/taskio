//
//  CoreDataManager.swift
//  taskIo
//
//  Created by SwiftDev on 11/6/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager{
    static let shared = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //método para guardar tarea en CoreData
    func guardarTarea(_ tarea: TaskModel){
        let nueva = TaskEntity(context: context)
        
        nueva.id = tarea.Id
        nueva.title = tarea.Title
        nueva.descripcion = tarea.Description
        nueva.completada = tarea.Completada
        nueva.fechaVencimiento = tarea.FechaVencimiento
        nueva.sincronizada = false
        
        guardarContexto()
    }//cierre de guardar tarea
    
    func guardarContexto(){
        do{
            try context.save()
        }catch{
            print("Error al guardar contexto: \(error)")
        }
    }//cierre de guardar contexto
    
    func obtenerTareas()-> [TaskEntity]{
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        do{
            return try context.fetch(request)
        }catch{
            print("Error al obtener tareas \(error)")
            return []
        }
    }//cierre de obtener tareas
    
    func marcarComoSincronizada(id:String){
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@",id)
        if let tarea = try? context.fetch(request).first{
            tarea.sincronizada = true
            
            guardarContexto()
        }
    }
}
