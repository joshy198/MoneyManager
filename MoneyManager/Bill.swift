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
    var description = ""
    //var image
    
    init(amount: Double, date: Date, description: String/*, image*/){
        
        self.amount = amount
        self.description = description
        self.billDate = date
    }
}
