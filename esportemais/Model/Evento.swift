//
//  Evento.swift
//  esportemais
//
//  Created by PUCPR on 22/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation

class Evento: Modelble {
    var id  = ""
    var nome  = ""
    var data  = Date()
    var vagas = 30
    var observacoes = ""
    var organizador = ""
    var modalidade = ""
    var local = ""
    var localLat = 0.0
    var localLon = 0.0
    
   
    func isValid() -> (error: Bool, message: String){
        
        if nome.trimmingCharacters(in: .whitespaces).isEmpty {
            return (true, "Nome inválido")
        }
        
        if vagas <= 1 {
            return (true, "Número de vagas inválido")
        }
        
        
        return (false, "Evento criado")
    }
    
    
    func toMap() -> [String: Any] {
        let map = ["id": id, "nome": nome, "data": data.timeIntervalSince1970, "vagas": vagas, "observacoes": observacoes, "organizador": organizador, "modalidade": modalidade, "local": local, "localLat": localLat, "localLon": localLon] as [String : Any]
        return map
    }
    
    

}
