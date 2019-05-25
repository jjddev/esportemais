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

    let DESISTIR = "Desistir"
    let PARTICIPAR = "Participar"
    
    
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
        
         let defaults = UserDefaults.standard
         print(defaults.stringArray(forKey: "eventos") as! [String])

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
    
        
        let defaults = UserDefaults.standard
        let eventosInscritos = defaults.stringArray(forKey: "eventos") ?? [String]()
        
        for item in eventosInscritos {
            if item == evento.id {
                cell.btnAcao.setTitle(DESISTIR, for: .normal)
            }
        }
        
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
        
        let defaults = UserDefaults.standard
        let idUsuario = defaults.string(forKey: "idUsuario") ?? ""
        var eventosInscritos = defaults.array(forKey: "eventos") as! [String]
       
        let btnAcao = sender as! UIButton
        var btnTexto = ""
        if btnAcao.titleLabel?.text == PARTICIPAR {
            eventosInscritos.append(evento.id)
            EventoService.addParticipante(idEvento: evento.id, idUsuario: idUsuario)
            btnTexto = DESISTIR
        } else {
            EventoService.removeParticipante(idEvento: evento.id, idUsuario: idUsuario)
             let index = eventosInscritos.firstIndex{
                let s = $0 as! String
                return s == evento.id
            }
            
            if index != nil {
                eventosInscritos.remove(at: index!)
                print("index: \(index)")
            }
            
            btnTexto = PARTICIPAR
        }
        
        EventoService.saveEventosCache(eventosInscritos)
        btnAcao.setTitle(btnTexto, for: .normal)
        
        tableView.reloadData()
    }
    
    @objc func detalhes(_ sender: AnyObject){
        print("entrou em detalhes")
        performSegue(withIdentifier: "detalhesEvento", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detalhesEvento" {
            let next = segue.destination as! DetalhesViewController
            let btn = sender as! UIButton
            let evento = eventos[btn.tag]
            next.evento = evento
        }
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
