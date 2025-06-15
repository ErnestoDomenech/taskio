//
//  TaskNotificationManager.swift
//  taskIo
//
//  Created by SwiftDev on 5/6/25.
//

import UserNotifications

class TaskNotificationManager{
    static let shared = TaskNotificationManager()
    
    func programarNotificacion(para tarea:TaskModel, conID id:String){
        
        let contenido = UNMutableNotificationContent()
        contenido.title = "Tarea próximo vencimiento"
        contenido.body = "\(tarea.Title) vence en un dia"
        contenido.sound = .default
        
        let fechaNotificacion = tarea.FechaVencimiento.addingTimeInterval(-86400) //un dia en segundos
        if fechaNotificacion < Date(){
            return
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: fechaNotificacion.timeIntervalSinceNow, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: contenido, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){
            error in if let error = error{print("Error programación: \(error)")}
        }
    
    
        func cancelarNotificacion(id:String){
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
    }//cierre de programar notificación
}
