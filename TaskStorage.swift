//
//  TaskStorage.swift
//  taskIo
//
//  Created by SwiftDev on 10/6/25.
//

import Foundation

class TaskStorage {
    static let shared = TaskStorage()
    private let fileName = "tareas.json"
    
    //identificar la ubicación del archivo JSON
    private var fileURL: URL{
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0].appending(path: fileName)
    }
    
    //almacenar tareas en el JSON
    func guardarTareas(_ tareas:[TaskModel]){
        let encoder = JSONEncoder()
        
        encoder.dateEncodingStrategy = .iso8601
        
        do{
            let data = try encoder.encode(tareas)
            try data.write(to: fileURL)
        }catch{
            print("Error al guardar tareas")
        }
    }//cierre guardar tareas
    
    //leer tareas desde el JSON
    func cargarTareas()->[TaskModel]{
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do{
            let data = try Data(contentsOf: fileURL)
            return try decoder.decode([TaskModel].self, from: data)
        }catch{
            print("Error al leer el archivo")
            return []
        }
    }//cierre de cargar tareas
}
