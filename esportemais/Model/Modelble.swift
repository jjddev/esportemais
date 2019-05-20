//
//  Modelble.swift
//  esportemais
//
//  Created by juliano jose dziadzio on 20/05/19.
//  Copyright © 2019 PUCPR. All rights reserved.
//

import Foundation

protocol Modelble {
    func isValid() -> (error: Bool, message: String)
    func toMap() -> [String: Any]
}
