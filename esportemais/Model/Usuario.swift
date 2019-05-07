//
//  Usuario.swift
//  esportemais
//
//  Created by juliano jose dziadzio on 29/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation

class Usuario {
    var id: String
    var nome: String
    var email: String
    var senha: String
    
    required init(){
        id = ""
        nome = ""
        senha = ""
        email = ""
        
    }
    
    
    func isValid() -> (error: Bool, message: String) {
        
        if nome.trimmingCharacters(in: .whitespaces).isEmpty {
            return (true, "Nome invalido")
        }
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            return (true, "Email invalido")
        }
        
        if senha.trimmingCharacters(in: .whitespaces).isEmpty {
            return (true, "Senha invalida")
        }
        
        if senha.count < 6 {
            return (true, "A senha deve ter no minimo 6 caractres")
        }
        
        return (false, "ok")
    }
    
    

    
    func setupProperties(){
        let types = ["String": "", "Int": 0, "Float": 0.0, "Boolean": false] as [String : Any]
        let x = type(of: self)
        
        print("====================== \(x) =========================")
        
        let mirror = Mirror(reflecting: x.init())
        
        print(mirror.children.flatMap({ $0.label })) // ["prop1", "prop2", "prop3"]
    }
    
}
