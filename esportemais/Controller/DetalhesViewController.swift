//
//  DetalhesViewController.swift
//  esportemais
//
//  Created by juliano jose dziadzio on 25/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class DetalhesViewController: UIViewController {

    var evento: Evento!
    
    @IBOutlet weak var vLocal: UILabel!
    @IBOutlet weak var vNome: UILabel!
    @IBOutlet weak var vData: UILabel!
    
    @IBOutlet weak var vModalidade: UILabel!
    @IBOutlet weak var vVagas: UILabel!
    @IBOutlet weak var vObservacoes: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Detalhes"
    }
    
    @IBAction func verMapa(_ sender: Any) {
   
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verLocalizacao" {
            let next = segue.destination as! LocalViewController
            
            //let lat = -25.45216037480428
            //let lon = -49.25463366666668
            
            next.lat = evento.localLat
            next.lon = evento.localLon
            next.localDescricao = evento.local
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vNome.text = evento.nome
        vLocal.text = evento.local
        vModalidade.text = evento.modalidade
        vVagas.text = String(evento.vagas)
        vObservacoes.text = evento.observacoes
        
        let df  = DateFormatter()
        df.dateFormat = "dd/MM/Y HH:mm"
        vData.text = df.string(from: evento.data)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
