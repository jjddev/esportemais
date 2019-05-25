//
//  EventoService.swift
//  esportemais
//
//  Created by PUCPR on 22/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON


class EventoService {
    
    private static func getConnection() -> DatabaseReference {
        return  Database.database().reference()
    }
    
    static func getEventos(handler: @escaping (([Evento]) -> Void)){
        let ref = getConnection()
        ref.child("Eventos").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var response = [Evento]()
            
            for item in value {
                let i = JSON(item.value)
                
                let e = Evento()
                
                e.id = i["id"].stringValue
                e.nome = i["nome"].stringValue
                e.modalidade = i["modalidade"].stringValue
                e.data = Date(timeIntervalSince1970: i["data"].doubleValue)
                e.local = i["local"].stringValue
                response.append(e)
            }
            handler(response)
        })
    }
    
    static func newEvento(_ evento: Evento, _ idUsuario: String) -> Evento{
        let ref = getConnection()
        let id = ref.child("Eventos").childByAutoId().key as! String
        evento.id = id
        let model = evento.toMap()
        ref.child("Eventos").child(id).setValue(model)
        ref.child("Eventos").child(id).updateChildValues(["participantes": [idUsuario: ["id": idUsuario]]])
        
        return evento
    }
    
    static func addParticipante(idEvento: String, idUsuario: String) {
        let ref = getConnection()
        ref.child("Eventos").child(idEvento).child("participantes").updateChildValues([idUsuario: ["id": idUsuario]])
    }
    
    static func removeParticipante(idEvento: String, idUsuario: String){
        let ref = getConnection()
        ref.child("Eventos").child(idEvento).child("participantes").child(idUsuario).removeValue()
    }
    
    static func saveEventosCache(_ eventosInscritos: [String]){
        let defaults = UserDefaults.standard
        defaults.set(eventosInscritos, forKey: "eventos")
    }
    
    
}
