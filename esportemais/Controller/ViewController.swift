//
//  ViewController.swift
//  esportemais
//
//  Created by PUCPR on 10/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var vUsuario: UITextField!
     @IBOutlet weak var vSenha: UITextField!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: vUsuario.text!, password: vSenha.text!) { (result, error) in
            
            guard let user = result?.user
                else {
                    print(error)
                    
                    return
            }
            Analytics.setUserProperty("sim", forName: "entrou")
            Analytics.logEvent("signed", parameters: ["nome": self.vUsuario.text!])
            print("logo")
        }
    }
    
    
    @IBAction func novoUsuario(_ sender: Any) {
        
        
        Auth.auth().createUser(withEmail: vUsuario.text!, password: vSenha.text!) { (result, error) in
            
            guard let user = result?.user
                else {
                    print(error)
                    return
            }
            
            print("sucesso")
        }
       
        
    }
}

