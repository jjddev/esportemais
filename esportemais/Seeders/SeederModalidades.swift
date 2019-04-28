//
//  SeederModalidades.swift
//  esportemais
//
//  Created by juliano jose dziadzio on 28/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation
import Firebase

class SeederModalidade {
    static func load(){
        
        let esportes = ["Futebol", "Volei", "Atletismo", "Triathlon", "Alongamentos", "Corrida", "Ciclismo", "Basquete"]
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        for item in esportes {
            let id = ref.child("Modalidades").childByAutoId().key as! String
            let mod = ["descricao": item]
            ref.child("Modalidades").child(id).setValue(mod)
        }  
    }
}





    

    

