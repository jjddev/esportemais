//
//  FactoryAlert.swift
//  esportemais
//
//  Created by PUCPR on 15/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation
import UIKit


class FactoryAlert {
    
    
    
    static func infoDialog(title: String, messaage: String, buttonText: String) -> UIAlertController {
        let ab = AlertBuilder(title, messaage)
        let button = UIAlertAction(title: buttonText, style: .default, handler: { action in print("adsfasdf") } )
        return ab.addButton(button).build()
    }
    
    static func warningDialog(){
        
    }
    
    static func errorDialog(){
        
    }
    
    static func custom(){
        
    }
}
