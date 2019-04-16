//
//  ModalBuilder.swift
//  esportemais
//
//  Created by PUCPR on 12/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation
import UIKit

class AlertBuilder {
    private var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    
    init(_ title: String = "", _ message: String = ""){
        alert.title = title
        alert.message = message
    }
    
    func setTitle(_ title: String) -> AlertBuilder {
        alert.title = title
        return self
    }
    
    func setMessage(_ message: String) -> AlertBuilder {
        alert.message = message
        return self
    }
    
    func addButton(_ button: UIAlertAction) -> AlertBuilder {
        alert.addAction(button) 
        return self
    }
    
    func build() -> UIAlertController {
        return alert
    }
    
    func reset(){
        alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    }
    
}
