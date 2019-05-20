//
//  EventoTableViewCell.swift
//  esportemais
//
//  Created by PUCPR on 15/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class EventoTableViewCell: UITableViewCell {

    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var local: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var modalidade: UILabel!
    
    @IBOutlet weak var btnAcao: UIButton!
    @IBOutlet weak var btnDetalhes: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  

    
}
