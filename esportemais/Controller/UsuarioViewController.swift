//
//  UsuarioViewController.swift
//  esportemais
//
//  Created by PUCPR on 06/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase

class UsuarioViewController: UIViewController {
    var usuario =  Usuario()
    var ref: DatabaseReference!
    var acaoStatus = (error: false, message: "123")
    
    @IBOutlet weak var vNome: UITextField!
    @IBOutlet weak var vEmail: UITextField!
    @IBOutlet weak var vSenha: UITextField!
    @IBOutlet weak var vConfirmacaoSenha: UITextField!
    
    @IBOutlet weak var vNovaConta: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vNovaConta.layer.cornerRadius = 15
        vNovaConta.clipsToBounds = true
        
    }
    
    func salvarUsuario() -> Bool {
        usuario.nome = vNome.text ?? ""
        usuario.email = vEmail.text ?? ""
        usuario.senha = vSenha.text ?? ""
        
        acaoStatus = usuario.isValid()
        
        if usuario.senha != vConfirmacaoSenha.text {
            acaoStatus = (true, "As senhas nao conferem")
            return false
        }
        
        if acaoStatus.error {
            return false
        }
        
        
        
        return true
        
    }
    
    @IBAction func salvar(_ sender: Any) {
        if !salvarUsuario() {
            let alert = FactoryAlert.infoDialog(title: "Falha", messaage: acaoStatus.message, buttonText: "OK")
            self.present(alert, animated: true)
        }else{
            Auth.auth().createUser(withEmail: usuario.email, password: usuario.senha) { (result, error) in
                
                guard let user = result?.user
                    else {
                        
                        let e = AuthErrorCode(rawValue: error!._code)
                        let errorCode = e?.rawValue ?? 0
                        let descriptionError = FireBaseErrors.codes[errorCode] ?? "Erro desconhecido"
                        
                        print(error?.localizedDescription)
                        Analytics.logEvent("erro_desconhecido", parameters: ["msg": error?.localizedDescription])
                    
                        
                        let alert = FactoryAlert.infoDialog(title: "Falha", messaage: descriptionError , buttonText: "OK")
                        self.present(alert, animated: true)
                        return
                }
                print("===== uid criado: \(user.uid)")
            }
        }
    }
    
}
