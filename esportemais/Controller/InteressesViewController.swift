//
//  InteressesViewController.swift
//  esportemais
//
//  Created by PUCPR on 10/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import UIKit

class InteressesViewController: UIViewController {

    @IBOutlet weak var vInteresses: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vInteresses.delegate = self as! UITableViewDelegate
        vInteresses.dataSource = self as! UITableViewDataSource
        
        // Do any additional setup after loading the view.
    }
    

    
}
