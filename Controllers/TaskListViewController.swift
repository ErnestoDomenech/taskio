//
//  TaskListViewController.swift
//  taskIo
//
//  Created by SwiftDev on 2/6/25.
//

import Foundation
import UIKit

class TaskListViewController:UITableViewController, UISearchBarDelegate{
    
    //Lista de tareas de ejemplo
    var task:[TaskModel] = []
    let taskManager = FirebaseTaskManager()
    
    //Lista de imagenes por tareas
    var imagenesPorTarea :[ImageTask] = []
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var contadorLabel: UILabel!
    @IBOutlet weak var filtroSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tareasFiltradas:[TaskModel] = []
    var textoBusqueda = ""
    static var ultimoId: Int!
        
    override func viewDidLoad(){
        super.viewDidLoad()
        title = "My Tasks"
        
        //leer las tareas desde el JSON
        //task = TaskStorage.shared.cargarTareas()
        
        tableView.register(UITableView.self, forCellReuseIdentifier: "TaskCell")
        searchBar.delegate = self
        //cargarTareas()
        task = CoreDataManager.shared.obtenerTareas().map{
            TaskModel(Id: $0.id ?? "", Title: $0.title ?? "", Description: $0.descripcion ?? "", Completada: $0.completada, FechaVencimiento: $0.fechaVencimiento ?? Date())
        }
        FirebaseSyncManager().sincronizarTareasLocales()
        tableView.reloadData()
    }//cierre del override
    
    func cargarTareas(){
        taskManager.cargarTareas(){
            task in self.task = task
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - DataSource
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)->Int{
        return tareasFiltradas.count
    }
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tareasFiltradas[indexPath.row]
        cell.textLabel?.text = task.Title
        cell.detailTextLabel?.text = task.Description
        cell.accessoryType = task.Completada ? .checkmark:.none
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        cell.detailTextLabel?.text = formatter.string(from: task.FechaVencimiento)
        
        return cell
        
    }
    //MARK: Tarea completada
    override func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        task[indexPath.row].Completada.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
        
        actualizarContador()
    }
    
    //MARK: Eliminar celdas
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
          let elementoEliminado = task.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            taskManager.eliminarTarea(id: elementoEliminado.Id)
        }
    }
    //MARK: Acción para crear nueva tarea
    @IBAction func unwindFromNewTask(segue: UIStoryboardSegue){
        if let sourceVC = segue.source as? NewTaskViewController, var nuevaTarea = sourceVC.nuevaTarea{
            if let index = sourceVC.indexTareaEditar{
                //significa que estamos editando
                task[index] = nuevaTarea
                 
                //guardar en el JSON
                //TaskStorage.shared.guardarTareas(task)
                
            }else{
                //significa que es tarea nueva
                var ultimoId = task.count + 1
                var nuevoId  = ultimoId as? String
                nuevaTarea.Id = nuevoId ?? ""
                
                task.append(nuevaTarea)
                taskManager.guardarTarea(nuevaTarea)
                
                //guardar en el JSON
                //TaskStorage.shared.guardarTareas(task)
                
                let idNotification = (task.count)-1
                
                TaskNotificationManager.shared.programarNotificacion(para: nuevaTarea, conID: idNotification as? String ?? "")
            }, var imageTask = sourceVC.selectedImages{
                
            }
           
            task.sort{ $0.FechaVencimiento < $1.FechaVencimiento}
            tableView.reloadData()
            actualizarContador()
            aplicarFiltro()
        }
    }
    
    //MARK: - Métodos propios
    func actualizarContador(){
        let pendientes = task.filter{!$0.Completada}.count
        contadorLabel.text = "Tareas pendientes: \(pendientes)"
    }
    
    func aplicarFiltro(){
        let tareasFiltradasPorEstado: [TaskModel]
        
        switch filtroSegmentedControl.selectedSegmentIndex{
            //para las pendientes
        case 1:
            tareasFiltradasPorEstado = task.filter{!$0.Completada}
            //para las completadas
        case 2:
            tareasFiltradasPorEstado = task.filter{$0.Completada}
            //para todas
        default:
            tareasFiltradasPorEstado = task
        }//cierre del switch
        
        //aplicar busqueda por estado de la tarea
        
        if textoBusqueda.isEmpty {
            tareasFiltradas = tareasFiltradasPorEstado
        }else{
            tareasFiltradas = tareasFiltradasPorEstado.filter{$0.Title.lowercased().contains(textoBusqueda.lowercased()) || $0.Description.lowercased().contains(textoBusqueda.lowercased())}
        }
        
        tableView.reloadData()
    }
    
    //MARK: Preparar Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "editTask",
            let destino = segue.destination as? NewTaskViewController,
           let indexPath = tableView.indexPathForSelectedRow{
            destino.tareaEditar = task[indexPath.row]
            destino.indexTareaEditar = indexPath.row
        }
    }
    
    //MARK: Filtro tareas segmentedControl
    @IBAction func filtroCambio(_ sender: UISegmentedControl){
        aplicarFiltro()
    }
    
    //MARK: Delegado searchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        textoBusqueda = searchText
        aplicarFiltro()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        //oculta el teclado
        searchBar.resignFirstResponder()
    }
}
