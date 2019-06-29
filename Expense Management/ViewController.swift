//
//  ViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/28/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    struct GlobalVariables {
        static var balance: Double = 0
        static var expenses: Dictionary<String, Double>?
        static var expensesType: Dictionary<String, String>?
    }
    
}

