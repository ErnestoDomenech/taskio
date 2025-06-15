//
//  TaskModel.swift
//  taskIo
//
//  Created by SwiftDev on 3/6/25.
//

import Foundation
import UIKit

struct TaskModel: Codable {
    var Id: String
    var Title: String
    var Description: String
    var Completada: Bool
    var FechaVencimiento: Date
    
    func toDictionary()->[String:Any]{
        return [
            "id": Id,
            "title":Title,
            "decription":Description,
            "completada":Completada,
            "fechaVencimiento":FechaVencimiento
        ]
    }//cierre toDictionary
    
    static func fromDictionary(_ dict:[String:Any])-> TaskModel?{
        guard let id = dict["id"] as? String,
              let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let completada = dict["completada"] as? Bool,
              let fechaVencimiento = dict["fechaVencimiento"] as? Date
        else {return nil}
        
        return TaskModel(Id: id, Title: title, Description: description, Completada: completada, FechaVencimiento: fechaVencimiento)
        
    }//cierre fromDictionary
}

struct ImageTask{
    var selectedImage:[UIImage]
    var idTask: String
}

