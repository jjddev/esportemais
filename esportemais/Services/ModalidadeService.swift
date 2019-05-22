//
//  ModalidadeService.swift
//  esportemais
//
//  Created by PUCPR on 22/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class ModalidadeService {
    static func getModalidade(handler: @escaping (([String]) -> Void)){
        let ref = Database.database().reference()
        ref.child("Modalidades").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var response = [String]()
            
            for item in value {
                let i = JSON(item.value)
                response.append(i["descricao"].stringValue)
            }
            handler(response)
        })
    }
}
