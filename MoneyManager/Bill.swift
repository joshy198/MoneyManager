//
//  Bill.swift
//  MoneyManager
//
//  Created by Student on 23/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
class Bill{
    var BillDate:Date
    var Description=""
    //var image
    
    init( d:Date, description:String/*, image*/){
        self.Description=description
        self.BillDate=d
    }
}
