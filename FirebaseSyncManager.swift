//
//  FirebaseSyncManager.swift
//  taskIo
//
//  Created by SwiftDev on 12/6/25.
//

import Foundation
import Firebase

class FirebaseSyncManager{
    private let ref = Database.database().reference().child("tareas")
    
    func sincronizarTareasLocales(){
        let tareasLocales = CoreDataManager.shared.obtenerTareas().filter{!$0.sincronizada}
        for tarea in tareasLocales {
            let task = TaskModel(Id: tarea.id ?? "", Title: tarea.title ?? "", Description: tarea.descripcion ?? "", Completada: tarea.completada, FechaVencimiento: tarea.fechaVencimiento ?? Date())
            
            ref.child(task.Id).setValue(task.toDictionary()){
                error, _ in
                if error == nil{
                    CoreDataManager.shared.marcarComoSincronizada(id: task.Id)
                }
            }
        }//cierre del for
    }//cierre de guardar tareas locales
    
    func descargarTareas(completion: @escaping([TaskModel])-> Void){
        ref.observeSingleEvent(of: .value){snapshot in
            var tareas: [TaskModel] = []
            for child in snapshot.children{
                if let snap = child as? DataSnapshot,
                   let dict = snap.value as? [String: Any],
                   let tarea = TaskModel.fromDictionary(dict){
                    tareas.append(tarea)
                }
            }//cierre del for
            completion(tareas)
        }
    }
}
