//
//  EventosUIViewController.swift
//  esportemais
//
//  Created by juliano jose dziadzio on 14/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase

class EventosUIViewController: UIViewController {

    var evento = Evento()
    var acaoStatus = (error: false, message: "123")
    var ref: DatabaseReference!
    var alert: UIAlertController!
    
    @IBOutlet weak var vNome: UITextField!
    @IBOutlet weak var vLocal: UITextField!
    @IBOutlet weak var vData: UIDatePicker!
    @IBOutlet weak var vVagas: UITextField!
    @IBOutlet weak var vModalidade: UITextField!
    @IBOutlet weak var vObservacoes: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        ref = Database.database().reference()
        
        vNome.text = evento.nome
        vLocal.text = "Local"
        //vVagas.text = (evento?.vagas) as String
        //vModalidade = evento.modalidade
        vObservacoes.text = evento.observacoes

        // Do any additional setup after loading the view.
    }
    
    
    func salvarEvento() -> Bool {
        
        
        evento.nome = vNome.text ?? ""
        evento.data = vData.date
        evento.vagas = Int(vVagas.text!) ?? 0
        evento.observacoes = vObservacoes.text ?? ""
        
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
