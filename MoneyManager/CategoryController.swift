//
//  CategoryController.swift
//  MoneyManager
//
//  Created by Student on 23/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import UIKit

var categories = [MoneyCategory]()

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}

class CategoryOverview: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var moneyAvailable: UILabel!
    @IBOutlet weak var moneyTotal: UILabel!
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = "Overview"
        categoryTable.dataSource = self
        categoryTable.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // reloead table
        self.categoryTable.reloadData()
        
        // reload money label
        var moneyAvailableValue = 0.0
        var moneyTotalValue = 0.0
        
        for category in categories {
            
            if category.moneyAvailable {
                
                for bill in category.billList {
                    
                    moneyAvailableValue += bill.amount
                    moneyTotalValue += bill.amount
                }
            } else {
                
                for bill in category.billList {
                    
                    moneyTotalValue += bill.amount
                }
            }
        }
        
        moneyAvailable.text = "€ " + String(format: "%.2f", moneyAvailableValue)
        moneyTotal.text = "€ " + String(format: "%.2f", moneyTotalValue)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        //cell.textLabel?.text = categories[indexPath.row].name
        cell.nameLabel.text = categories[indexPath.row].name
        cell.valueLabel.text = "€ " + String(format: "%.2f", categories[indexPath.row].total)
        if categories[indexPath.row].total < 0.00 {
            cell.valueLabel.textColor = UIColor.red
        }
        if categories[indexPath.row].total == 0.00{
            cell.valueLabel.textColor = UIColor.black
        }
        else {
            cell.valueLabel.textColor = UIColor.green
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            //space for core data stuff
            
            categories.remove(at: indexPath.row)
        }
        
        viewDidAppear(true)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        
        title.text = "Category"
        title.textAlignment = NSTextAlignment.center
        title.backgroundColor = UIColor.yellow
        title.textColor = UIColor.black
        
        return title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        categoryTable.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        selectedRow = row
        
        self.performSegue(withIdentifier: "CategoryDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoryDetail" {
            
            let view = segue.destination as! CategoryDetail
            view.category = categories[selectedRow]
            print("CategoryDetail called")
        }
        else {
            print("Other segue called")
        }
    }
    
    @IBAction func returnToOverview(unwinder: UIStoryboardSegue) {
        
    }
}

class NewCategory: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var available: UISwitch!
    @IBOutlet weak var detailsField: UITextField!
    
    @IBAction func saveItem(_ sender: Any) {
        
        if nameField.text != "" {
            
            categories.append(MoneyCategory(name: nameField.text!, additionalInfo: detailsField.text!, moneyAvailable: available.isOn) )
        }
        
        self.performSegue(withIdentifier: "returnToOverview", sender: self)
    }
    
    override func viewDidLoad() {
        
        //navigationItem.title = "New Category"
    }
}

class CategoryDetail: UIViewController {
    
    var category: MoneyCategory? = nil
    
    @IBOutlet weak var categoryDetails: UILabel!
    
    override func viewDidLoad() {
        navigationItem.title = (category?.name)
        categoryDetails.text = (category?.additionalInfo)
        
    }
    
}
