//
//  Bill.swift
//  MoneyManager
//
//  Created by Student on 23/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import UIKit

class MoneyBill{
    
    var amount = 0.0
    var date: Date
    var name = ""
    var id = -1
    var catId = -1
    var image = UIImage(named: "placeholder.png")
    
    init(amount: Double, name: String, date: Date, id: Int, catId: Int, image: UIImage){
        
        self.amount = amount
        self.name = name
        self.date = date
        self.id = id
        self.catId = catId
        self.image = image
        
    }
    
    deinit {
        
    }
}
