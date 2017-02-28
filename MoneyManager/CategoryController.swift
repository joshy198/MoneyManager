//
//  CategoryController.swift
//  MoneyManager
//
//  Created by Student on 23/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Local variable to store categories
var categories = [MoneyCategory]()

var selectedRow = 0

/**
 * Custom Cell for Category overview
 *
 */
class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}

/**
 * Displaying category overview and money overview
 *
 */
class CategoryOverview: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var moneyAvailable: UILabel!
    @IBOutlet weak var moneyTotal: UILabel!
    
    // Local variable to store selected row value
    //var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTable.dataSource = self
        categoryTable.delegate = self
        
        categories.removeAll()
        loadCoredata()
        
        for category in categories {
            
            category.calc()
        }
        
        //viewDidAppear(true)
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
        
        // Actual money label values
        moneyAvailable.text = "€ " + String(format: "%.2f", moneyAvailableValue)
        moneyTotal.text = "€ " + String(format: "%.2f", moneyTotalValue)
        
        if moneyAvailableValue < 0.00 {
            moneyAvailable.textColor = UIColor.red
        }
        else if moneyAvailableValue == 0.00 {
            moneyAvailable.textColor = UIColor.black
        }
        else {
            moneyAvailable.textColor = UIColor.green
        }
        
        if moneyTotalValue < 0.00 {
            moneyTotal.textColor = UIColor.red
        }
        else if moneyTotalValue == 0.00 {
            moneyTotal.textColor = UIColor.black
        }
        else {
            moneyTotal.textColor = UIColor.green
        }
    }
    
    func loadCoredata() {
        print("Loading coredata...")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Category")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let name = result.value(forKey: "name") as? String {
                        if let info = result.value(forKey: "info") as? String {
                            if let available = result.value(forKey: "available") as? Bool {
                                if let id = result.value(forKey: "id") as? Int {
                                    categories.append(MoneyCategory(name: name, additionalInfo: info, moneyAvailable: available, id: id))
                                    print("Category \(name) was loaded form coredata")
                                }
                            }
                        }
                    }
                }
            } else {
                print("No categories found in coredata!")
            }
            
        } catch {
            
        }
    }
    
    // TableView method to pick cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    // TableView method to return cell for table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

        // Use custom cell's labels
        cell.nameLabel.text = categories[indexPath.row].name
        cell.valueLabel.text = "€ " + String(format: "%.2f", categories[indexPath.row].total)
        
        // Coloring text depening on balance
        if categories[indexPath.row].total < 0.00 {
            cell.valueLabel.textColor = UIColor.red
        }
        else if categories[indexPath.row].total == 0.00{
            cell.valueLabel.textColor = UIColor.black
        }
        else /*categories[indexPath.row].total > 0.00*/ {
            cell.valueLabel.textColor = UIColor.green
        }
        return cell
    }
    
    // TableView method to return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    // TableView method to enable swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            let name = categories[indexPath.row].name
            
            // LOCAL DELETE
            
            categories.remove(at: indexPath.row)
            
            
            //space for core data stuff - remove category from core data
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            var category: NSManagedObject?
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Category")
            request.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(request)
                category = results[indexPath.row] as? NSManagedObject
            } catch {
                
            }
            context.delete(category!)
            if (category?.isDeleted)! {
                do {
                    try context.save()
                    print("Category \(name) was permanently removed from coredata")
                    
                } catch {
                    print("Saving corrupted")
                }
            }
            
        }
        
        viewDidAppear(true)
        
    }
    
    // TableView method to pick sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // TableView method to edit header in table
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        
        title.text = "Category"
        title.textAlignment = NSTextAlignment.center
        title.backgroundColor = UIColor.yellow
        title.textColor = UIColor.black
        
        return title
    }
    
    // TableView method to perform action when item is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        categoryTable.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        selectedRow = row
        
        // Call CategoryDetail view
        self.performSegue(withIdentifier: "CategoryDetail", sender: self)
    }
    
    // Performs actions before segue is executed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Pass chosen category when showing CategoryDetail view
        if segue.identifier == "CategoryDetail" {
            
            let view = segue.destination as! CategoryDetail
            view.category = categories[selectedRow]
            print("CategoryDetail called")
        }
        else {
            print("Other segue called")
        }
    }
    
    // Rewind segue destination
    @IBAction func returnToOverview(unwinder: UIStoryboardSegue) {
        
    }
}

/**
 * Adding new categories to overview
 *
 */
class NewCategory: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var available: UISwitch!
    @IBOutlet weak var detailsField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Saving item new category to list if filled in correctly
    @IBAction func saveItem(_ sender: Any) {
        
        if nameField.text != "" {
            
            // LOCAL SAVE
            
            let id = UserDefaults.standard.integer(forKey: "categoryCounter")
            
            categories.append(MoneyCategory(name: nameField.text!, additionalInfo: detailsField.text!, moneyAvailable: available.isOn, id: id) )
            
            UserDefaults.standard.setValue(id + 1, forKey: "categoryCounter")
            
            
            // Space for core data stuff - add category to core data
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context)
            let category = categories.last
            
            newCategory.setValue(category?.name, forKey: "name")
            newCategory.setValue(category?.additionalInfo, forKey: "info")
            newCategory.setValue(category?.moneyAvailable, forKey: "available")
            newCategory.setValue(category?.id, forKey: "id")
            
            do {
                
                try context.save()
                print("Category \((category?.name)!) was added to coredata")
                
            } catch {
                
            }
            
            
        }
        
        // rewind segue to overview
        self.performSegue(withIdentifier: "returnToOverview", sender: self)
    }
    
}

class CategoryDetailCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}

/**
 * Bill overview for current category
 *
 */
class CategoryDetail: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var category: MoneyCategory? = nil
    
    @IBOutlet weak var categoryDetails: UILabel!
    @IBOutlet weak var billTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billTable.dataSource = self
        billTable.delegate = self
        
        navigationItem.title = category?.name
        categoryDetails.text = category?.additionalInfo
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.billTable.reloadData()
    }
    
    // TableView method to pick cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = billTable.dequeueReusableCell(withIdentifier: "CategoryDetailCell", for: indexPath) as! CategoryDetailCell
        
        cell.nameLabel.text = categories[selectedRow].billList[indexPath.row].name
        cell.valueLabel.text = "€ " + String(format: "%.2f", categories[selectedRow].billList[indexPath.row].amount)
        
        // Coloring text depening on balance
        if categories[selectedRow].billList[indexPath.row].amount < 0.00 {
            cell.valueLabel.textColor = UIColor.red
        }
        else if categories[selectedRow].billList[indexPath.row].amount == 0.00{
            cell.valueLabel.textColor = UIColor.black
        }
        else /*categories[selectedRow].billList[indexPath.row].amount > 0.00*/ {
            cell.valueLabel.textColor = UIColor.green
        }
        return cell
    }
    
    // TableView method to return number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[selectedRow].billList.count
    }
    
    // TableView method to enable swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            //space for core data stuff - remove bill from core data
            
            
            categories[selectedRow].total -= categories[selectedRow].billList[indexPath.row].amount
            
            categories[selectedRow].billList.remove(at: indexPath.row)
            
        }
        
        viewDidAppear(true)
        
    }
    
    // TableView method to pick sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // TableView method to edit header in table
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        
        title.text = "Bills"
        title.textAlignment = NSTextAlignment.center
        title.backgroundColor = UIColor.yellow
        title.textColor = UIColor.black
        
        return title
    }
    
    // TableView method to perform action when item is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        billTable.deselectRow(at: indexPath, animated: true)
    }
    
    // Rewind segue destination
    @IBAction func returnToCategoryDetail (unwinder: UIStoryboardSegue) {
        
    }
    
}

/**
 * Adding new bills to categories
 *
 */
class NewBill: UIViewController {
    
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        amountField.keyboardType = UIKeyboardType.numberPad
    }
    
    @IBAction func addPhoto (_ sender: Any) {
        
        // Implement Camera API here
    }
 
    @IBAction func saveBill(_ sender: Any) {
        
        if amountField.text != "" {
            
            if nameField.text != "" {
                
                if let value = Double(amountField.text!) {
                    
                    // Space for core data stuff - add bill to core data
                    
                    
                    let id = UserDefaults.standard.integer(forKey: "billCounter")
                    
                    categories[selectedRow].billList.append(MoneyBill(amount: value, name: nameField.text!, date: datePicker.date, id: id))
                    
                    categories[selectedRow].total += value
                        
                    UserDefaults.standard.setValue(id + 1, forKey: "billCounter")
                    
                    self.performSegue(withIdentifier: "returnToCategoryDetail", sender: self)
                } else {
                    print("Invalid bill amount value")
                }
            } else {
                print("Invalid bill name")
            }
        } else {
            print ("Invalid bill amount entry")
        }
    }
    
}
