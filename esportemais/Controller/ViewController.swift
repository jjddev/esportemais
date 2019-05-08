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
    
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        
        let d = Date()
        
        var df  = DateFormatter()
        
        df.dateFormat = "dd/MM/Y HH:mm:ss"
        
        print("aaaaaaaaaa")
        
        print(df.string(from: d))
        
        //let u = Usuario()
        //u.setupProperties()
        
        
        Analytics.setUserProperty("sim", forName: "entrou")
        //Analytics.logEvent("signed", parameters: ["nome": self.vUsuario.text!])
        Analytics.logEvent("novo", parameters: ["teste": "aquiiiiiiiii"])
        
        
        ref = Database.database().reference()
        
        let id = "3"
        
        let m = ref.child("Modalidades").childByAutoId().key as! String
       
        
        ref.child("teste").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let nome = value?["nome"] as? String ?? ""

           // print(nome)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: vUsuario.text!, password: vSenha.text!) { (result, error) in
            
            guard let user = result?.user
                else {
        
                    let e = AuthErrorCode(rawValue: error!._code)
                    let errorCode = e?.rawValue ?? 0
                    let alert = FactoryAlert.infoDialog(title: "Falha", messaage: FireBaseErrors.codes[errorCode]!, buttonText: "OK")
                    self.present(alert, animated: true)
                    print(error)
                    
                    return
            }
            
            Analytics.setUserProperty("sim", forName: "entrou")
            Analytics.logEvent("signed", parameters: ["nome": self.vUsuario.text!])
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

