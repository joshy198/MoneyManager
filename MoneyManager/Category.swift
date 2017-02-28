//
//  Category.swift
//  MoneyManager
//
//  Created by Student on 23/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation

class MoneyCategory{
    
    var name = ""
    var additionalInfo = ""
    var moneyAvailable = false
    var billList = [MoneyBill]()
    var total = 0.00
    var id = -1
    
    init(name: String, additionalInfo: String, moneyAvailable: Bool, id: Int){
        
        self.moneyAvailable = moneyAvailable
        self.name = name
        self.additionalInfo = additionalInfo
        self.billList = [MoneyBill]()
        self.total = 0.00
        self.id = id
    }
    
    deinit {
        
        self.billList.removeAll()
        
    }
    
    // Calculate total of category
    func calc() {
        
        var total = 0.00
        
        for bill in self.billList {
            
            total += bill.amount
        }
        
        self.total = total
    }
}
