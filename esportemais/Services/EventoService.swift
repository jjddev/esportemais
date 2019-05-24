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
    static func getEventos(handler: @escaping (([Evento]) -> Void)){
        let ref = Database.database().reference()
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
}
