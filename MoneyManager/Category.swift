//
//  Category.swift
//  MoneyManager
//
//  Created by Student on 23/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
class Category{
    
    var Name="";
    var AdditionalInfo="";
    var MoneyAvailable=false;
    var BillList:[Bill]
    
    init(name:String,additionalInfo:String, moneyAvaiable:Bool){
        self.MoneyAvailable=moneyAvaiable
        self.Name=name
        self.AdditionalInfo=additionalInfo
        BillList=[Bill]()
    }
}
