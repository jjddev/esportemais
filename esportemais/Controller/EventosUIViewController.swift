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
    var localDescricao = ""
    var localCoord : (lat: Double, lon: Double) = (0, 0)
    
    @IBOutlet weak var btnSalvar: UIButton!
    @IBOutlet weak var vNome: UITextField!
    @IBOutlet weak var vLocal: UITextField!
    @IBOutlet weak var vData: UIDatePicker!
    @IBOutlet weak var vVagas: UITextField!
    @IBOutlet weak var vModalidade: UIPickerView!
    
    @IBOutlet weak var vObservacoes: UITextField!
   
    override func viewWillAppear(_ animated: Bool) {
       self.navigationItem.title = "Novo Evento"
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vModalidade.delegate = self
        self.vModalidade.dataSource = self
        
        ModalidadeService.getModalidade(handler: { response in
            self.modalidades = response
            
            
            var indexModalidade =  self.modalidades.firstIndex(of: self.evento.modalidade)
            
            if indexModalidade != nil {
                self.vModalidade.selectRow(indexModalidade!, inComponent: 0, animated: true)
            }
            
            
            self.vModalidade.reloadAllComponents()
        })
        
        vNome.text = evento.nome
        vObservacoes.text = evento.observacoes
        vLocal.text = localDescricao
        vVagas.text = String(evento.vagas)
        vData.date = evento.data
        

        
        btnSalvar.layer.cornerRadius = 15
        btnSalvar.clipsToBounds = true
        
    }
    
    
    func salvarEvento() -> Bool {
       
        evento.nome = vNome.text ?? ""
        evento.data = vData.date
        evento.vagas = Int(vVagas.text!) ?? 0
        evento.observacoes = vObservacoes.text ?? ""
        evento.local = vLocal.text ?? ""
        
        let modalidadeIndex = vModalidade.selectedRow(inComponent: 0)
        evento.modalidade = modalidades[modalidadeIndex]
        
        acaoStatus = evento.isValid()

        
        return acaoStatus.error
    }
    
    
    @IBAction func salvar(_ sender: Any) {
        
        if salvarEvento() {
            alert = FactoryAlert.infoDialog(title: "Falha", messaage: acaoStatus.message, buttonText: "OK")
        }else{
            ref = Database.database().reference()
            let id = ref.child("Eventos").childByAutoId().key as! String
            evento.id = id
            let mod = evento.toMap()
            ref.child("Eventos").child(id).setValue(mod)
            
            ref.child("Eventos").child(id).updateChildValues(["participantes": ["123123123": ["id": "xxx", "nome": "nome 123"]]])
            
            
            alert = FactoryAlert.infoDialog(title: "Sucesso", messaage: "Evento criado", buttonText: "OK")
        }
        
        self.present(alert, animated: true)
        performSegue(withIdentifier: "voltarEventos", sender: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "definirLocalizacao" {
            let next = segue.destination as! LocalViewController
            salvarEvento() //apenas seta os valores da tela no objeto evento
            next.evento = evento
        }
        
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
