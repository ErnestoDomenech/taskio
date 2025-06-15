//
//  NewTaskViewController.swift
//  taskIo
//
//  Created by SwiftDev on 2/6/25
//

import Foundation
import UIKit
class NewTaskViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //número de imágenes que existen en el array
        selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let imageView = cell.contentView.viewWithTag(100) as? UIImageView{
            imageView.image = selectedImages[indexPath.item]
        }
        return cell
    }
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var fechaVencimientoPicker:UIDatePicker!
    
    //MARK: Datos a enviar
    var nuevaTarea: TaskModel?
    
    var tareaEditar: TaskModel?
    var indexTareaEditar: Int?
    
    //lista de las imágenes
    var selectedImages:[UIImage] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 10
        
        if let tarea = tareaEditar{
            titleTextField.text = tarea.Title
            descriptionTextView.text = tarea.Description
            fechaVencimientoPicker.date = tarea.FechaVencimiento
        }
    }
    
    //MARK: Acción guardar (pulsar en "Save")
    @IBAction func guardarTapped(_ sender: UIButton){
        guard let title = titleTextField.text, !title.isEmpty else {
            mostrarAlerta("El campo título es obligatorio")
            return
        }
        let description = descriptionTextView.text ?? ""
        let fechaVencimiento = fechaVencimientoPicker.date
       
        
        //crear la nueva tarea
        nuevaTarea = TaskModel(Id: "", Title: title, Description: description, Completada: false, FechaVencimiento: fechaVencimiento)
        let imageTask = ImageTask(selectedImage: selectedImages, idTask:"")
        
        performSegue(withIdentifier: "unwindSegueNewTask", sender: self)
    }//cierre guardarTapped
    
    //MARK: Mensaje Alerta
    func mostrarAlerta(_ mensaje: String){
        let alerta = UIAlertController(title:"Aviso", message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alerta, animated: true)
    }
    
    //MARK: Image Piker
    
    @IBAction func uploadImageTapped(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
    }//cierre del IBAction
    
    //delegado al seleccionar la imagen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]){
        if let image = info[.originalImage] as? UIImage{
            
            selectedImages.append(image)
        }
        picker.dismiss(animated: true)
        
        collectionView.reloadData()
        
    }//cierre delegado selección imagen
    
}
