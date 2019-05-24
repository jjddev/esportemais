//
//  EventosTableViewController.swift
//  esportemais
//
//  Created by PUCPR on 12/04/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class EventosTableViewController: UITableViewController {
    var ref: DatabaseReference!
    
    func registerTableViewCells(){
        let textFieldCell = UINib(nibName: "EventoTableViewCell", bundle: nil)
        self.tableView.register(textFieldCell, forCellReuseIdentifier: "especial")
    }

    var eventos = [Evento]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        registerTableViewCells()
 
        EventoService.getEventos(handler: { response in
            self.eventos = response
            self.tableView.reloadData()
        })
        

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "especial", for: indexPath) as! EventoTableViewCell
        
        let evento = eventos[indexPath.row]
    
        var df  = DateFormatter()
        df.dateFormat = "dd/MM/Y HH:mm:ss"
        
        
        cell.nome.text = evento.nome
        cell.data.text = df.string(from: evento.data)
        cell.local.text = evento.local
        cell.modalidade.text = evento.modalidade
        
        cell.btnAcao.addTarget(self, action: #selector(acao), for: .touchUpInside)
        cell.btnDetalhes.addTarget(self, action: #selector(detalhes), for: .touchUpInside)
        
        cell.btnAcao.tag = indexPath.row
        cell.btnDetalhes.tag = indexPath.row

        return cell
    }
    
    
    @objc func acao(_ sender: AnyObject){
        
        let id =  (sender.tag)!
       
        
        
        let evento = eventos[id]
       
        ref = Database.database().reference()
      
        ref.child("Eventos").child(evento.id).child("participantes").updateChildValues(["009": ["id": "zzz", "nome": "nome 123"]])
        print("entrou em acao")
    }
    
    @objc func detalhes(_ sender: AnyObject){
        print("entrou em detalhes")
        
    }
    
    func populateEventos (handler: @escaping (([Evento]) -> Void)){
        ref = Database.database().reference()
        ref.child("Eventos").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var response = [Evento]()
        
            for item in value {
                let i = JSON(item.value)

                let e = Evento()
        
                e.id = i["id"].stringValue
                e.nome = i["nome"].stringValue
                e.modalidade = i["modalidade"].stringValue
                e.data = Date(timeIntervalSince1970: i["data"].doubleValue)
                e.local = i["local"].stringValue
                response.append(e)
            }
        handler(response)
        })
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
