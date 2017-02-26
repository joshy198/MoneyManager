//
//  Bill.swift
//  MoneyManager
//
//  Created by Student on 23/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation

class MoneyBill{
    
    var amount = 0.0
    var billDate: Date
    var name = ""
    //var image
    
    init(amount: Double, name: String, date: Date /*, image*/){
        
        self.amount = amount
        self.name = name
        self.billDate = date
    }
}
