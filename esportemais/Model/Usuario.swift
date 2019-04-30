//
//  Usuario.swift
//  esportemais
//
//  Created by juliano jose dziadzio on 29/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation

class Usuario {
    let id: String
    let nome: String
    let senha: String
    
    required init(){
        id = ""
        nome = ""
        senha = ""
        
    }
    
    
    func setupProperties(){
        let types = ["String": "", "Int": 0, "Float": 0.0, "Boolean": false] as [String : Any]
        let x = type(of: self)
        
        print("====================== \(x) =========================")
        
        let mirror = Mirror(reflecting: x.init())
        
        print(mirror.children.flatMap({ $0.label })) // ["prop1", "prop2", "prop3"]
    }
    
}
