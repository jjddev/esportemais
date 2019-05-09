//
//  Evento.swift
//  esportemais
//
//  Created by PUCPR on 22/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation

class Evento {
    var id  = ""
    var nome  = ""
    var data  = Date()
    var vagas = 30
    var observacoes = ""
    
   
    func isValid() -> (error: Bool, message: String){
        
        if nome.trimmingCharacters(in: .whitespaces).isEmpty {
            return (true, "Nome inválido")
        }
        
        if vagas <= 1 {
            return (true, "Número de vagas inválido")
        }
        
        
        return (false, "ok")
    }
    
    

}
