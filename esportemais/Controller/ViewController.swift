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
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNovaConta: UIButton!
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()

        btnLogin.layer.cornerRadius = 15
        btnLogin.clipsToBounds = true
        
        btnNovaConta.layer.cornerRadius = 15
        btnNovaConta.clipsToBounds = true
    }


    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: vUsuario.text!, password: vSenha.text!) { (result, error) in
            
            guard let user = result?.user
                else {
        
                    let e = AuthErrorCode(rawValue: error!._code)
                    let errorCode = e?.rawValue ?? 0
                    let alert = FactoryAlert.infoDialog(title: "Falha", messaage: FireBaseErrors.codes[errorCode]!, buttonText: "OK")
                    alert.view.tintColor = UIColor.red
                    
                    let titFont = [ NSAttributedString.Key.foregroundColor : UIColor.red]

                    
                    let titAttrString = NSMutableAttributedString(string: "", attributes: titFont)

                    
                    alert.setValue(titAttrString, forKey: "attributedTitle")
                    
                    self.present(alert, animated: true)
                    print(error)
                    
                    return
            }
            
            print(error)
            
            Analytics.setUserProperty("sim", forName: "entrou")
            Analytics.logEvent("signed", parameters: ["nome": self.vUsuario.text!])
            
            let defaults = UserDefaults.standard
            
            let idUsuario = Auth.auth().currentUser?.uid
            defaults.set(idUsuario, forKey: "idUsuario")
            
            
            self.performSegue(withIdentifier: "eventos", sender: nil)
            
        }
    }
    
    
    @IBAction func novoUsuario(_ sender: Any) {
        
        
        Auth.auth().createUser(withEmail: vUsuario.text!, password: vSenha.text!) { (result, error) in
            
            guard let user = result?.user
                else {
                    print(error)
                    return
            }
            
            let alert = FactoryAlert.infoDialog(title: "Bem Vindo", messaage: "Conta criado com sucesso", buttonText: "OK")
            self.present(alert, animated: true)
        }
    }
    
    func modal(_ titulo: String, _ mensagem: String){
        let alert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        
        alert.setValue(UIColor.blue, forKey: "titleTextColor")
        alert.addAction(UIAlertAction(title: "Fechar", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

