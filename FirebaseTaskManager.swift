//
//  FirebaseTaskManager.swift
//  taskIo
//
//  Created by SwiftDev on 11/6/25.
//

import Foundation
import FirebaseDatabase

class FirebaseTaskManager{
    private let ref = Database.database().reference().child("tareas")
    
    func guardarTarea(_ tarea: TaskModel){
        ref.child(tarea.Id).setValue(tarea.toDictionary())
    }
    
    func cargarTareas(completion: @escaping([TaskModel])-> Void){
        ref.observeSingleEvent(of: .value){
            snapshot in var tareas:[TaskModel]=[]
            for child in snapshot.children{
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String:Any],
                   let tarea = TaskModel.fromDictionary(dict){
                    tareas.append(tarea)
                }
            }
            completion(tareas)
        }
    }//cierre cargar tareas
    
    func eliminarTarea(id:String){
        ref.child(id).removeValue()
    }
}
