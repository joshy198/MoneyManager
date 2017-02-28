//
//  LaunchController.swift
//  MoneyManager
//
//  Created by Student on 28/02/2017.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import UIKit

class LaunchController: UIViewController {
    
    @IBOutlet weak var passcodeField: UITextField!
    @IBOutlet weak var passcodeLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore {
            print("Not first launch!")
            
            passcodeLabel.text = "Enter passcode"
            passcodeField.text = ""
            
        }
        else {
            print("First launch! Setting UserDefaults...")
            
            UserDefaults.standard.setValue(true, forKey: "newPasscode")
            passcodeLabel.text = "Select Passcode"
        }
        
        
    }
    
    @IBAction func passcodeContinue(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "newPasscode") {
            
            //UserDefaults.standard.setValue(passcodeField.text, forKey: "passcode")
            
            KeychainWrapper.standard.set(passcodeField.text!, forKey: "passcode")
            
            UserDefaults.standard.setValue(true, forKey: "launchedBefore")
            if UserDefaults.standard.bool(forKey: "launchedBefore") {
                print("Set 'launchedBefore' key!")
            }
            
            UserDefaults.standard.setValue(0, forKey: "categoryCounter")
            if UserDefaults.standard.integer(forKey: "categoryCounter") == 0 {
                print("Set 'categoryCounter' key!")
            }
            
            UserDefaults.standard.setValue(0, forKey: "billCounter")
            if UserDefaults.standard.integer(forKey: "billCounter") == 0 {
                print("Set 'billCounter' key!")
            }
            
            UserDefaults.standard.setValue(false, forKey: "newPasscode")
            
            viewDidLoad()
            
        }
        else {
            
            if passcodeField.text == KeychainWrapper.standard.string(forKey: "passcode") {
                
                print("Starting manager...")
                self.performSegue(withIdentifier: "startManager", sender: self)

            }
            else {
                print("Wrong passcode...")
                passcodeLabel.text = "Wrong Passcode, retry!"
            }
        }
        
    }
}
