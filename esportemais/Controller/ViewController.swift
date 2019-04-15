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
        
                    
                    let e = AuthErrorCode(rawValue: error!._code)
                    let errorCode = e?.rawValue ?? 0
                    
                    print("codigo",e!.rawValue)
                    
                    //var ab = AlertBuilder()
                    
                    //let ok = UIAlertAction(title: "Fechar", style: .default, handler: nil)
                    //let alert = ab.setTitle("Falha").setMessage(FireBaseErrors.codes[errorCode]!).addButton(ok).build()
                    
                    let alert = FactoryAlert.infoDialog(title: "Falha", messaage: FireBaseErrors.codes[errorCode]!, buttonText: "OK")
                    self.present(alert, animated: true)
                    
                    //self.modal("Falha", FireBaseErrors.codes[errorCode]!)
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
    
    func modal(_ titulo: String, _ mensagem: String){
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

