//
//  ViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/28/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    struct GlobalVariables {
        static var balance: Double = 0
        static var expensesType = [String : [String]]()
        static var dates = [String : [[String : Double]]]()
    }
    
    func readCSV(filename: String) -> String! {
        guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
            return nil
        }
        print(path)
        
        return path
    }
    
}

