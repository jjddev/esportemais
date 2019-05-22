//
//  EventosUIViewController.swift
//  esportemais
//
//  Created by juliano jose dziadzio on 14/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class EventosUIViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var evento = Evento()
    var acaoStatus = (error: false, message: "123")
    var ref: DatabaseReference!
    var alert: UIAlertController!
    var modalidades = [String]()
    
    @IBOutlet weak var vNome: UITextField!
    @IBOutlet weak var vLocal: UITextField!
    @IBOutlet weak var vData: UIDatePicker!
    @IBOutlet weak var vVagas: UITextField!
    @IBOutlet weak var vModalidade: UIPickerView!
    
    @IBOutlet weak var vObservacoes: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vModalidade.delegate = self
        self.vModalidade.dataSource = self
        
        self.populateModalidade() { response in
            self.modalidades = response
            self.vModalidade.reloadAllComponents()
        }
        
        vNome.text = evento.nome
        vLocal.text = "Local"
        vObservacoes.text = evento.observacoes
    }
    
    
    func salvarEvento() -> Bool {
       
        evento.nome = vNome.text ?? ""
        evento.data = vData.date
        evento.vagas = Int(vVagas.text!) ?? 0
        evento.observacoes = vObservacoes.text ?? ""
        
        let modalidadeIndex = vModalidade.selectedRow(inComponent: 0)
        evento.modalidade = modalidades[modalidadeIndex]
        
        acaoStatus = evento.isValid()

        
        return acaoStatus.error
    }
    
    @IBAction func salvar(_ sender: Any) {
        
        if salvarEvento() {
            alert = FactoryAlert.infoDialog(title: "Falha", messaage: acaoStatus.message, buttonText: "OK")
        }else{
            let id = ref.child("Eventos").childByAutoId().key as! String
            evento.id = id
            let mod = evento.toMap()
            ref.child("Eventos").child(id).setValue(mod)
            
            alert = FactoryAlert.infoDialog(title: "Sucesso", messaage: "Evento criado", buttonText: "OK")
        }
        
        self.present(alert, animated: true)

    }
    
    
    func populateModalidade (handler: @escaping (([String]) -> Void)){
        ref = Database.database().reference()
        ref.child("Modalidades").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var response = [String]()
            
            for item in value {
                let i = JSON(item.value)
                //print(i["descricao"].stringValue)
                response.append(i["descricao"].stringValue)
           }
            handler(response)
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modalidades.count
    }
    
    
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let item = modalidades[row]
        evento.modalidade = item
        return item
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
