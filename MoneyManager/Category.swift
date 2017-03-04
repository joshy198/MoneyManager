//
//  Category.swift
//  MoneyManager
//
//  Created by Student on 23/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
        
        if self.additionalInfo == "" {
            self.additionalInfo = "no description available"
        }
    }
    
    deinit {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<Bill> = Bill.fetchRequest()
        let predicate = NSPredicate(format: "cat_id == %d", self.id)
        fetchRequest.predicate = predicate
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            
        }
        do {
            try context.save()
            print("Bills of \(name) were permanently removed from coredata")
        } catch {

        }
        
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
