//
//  UpdateBalanceViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit

class UpdateBalanceViewController: UIViewController {

    @IBOutlet weak var currentBalanceLabel: UILabel!

    @IBOutlet weak var amountToAddTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentBalanceLabel.text = String(ViewController.GlobalVariables.balance)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addBalanceButton(_ sender: Any) {
        if let addAmount = Double(amountToAddTextField.text!) {
            ViewController.GlobalVariables.balance += addAmount
            currentBalanceLabel.text = String(ViewController.GlobalVariables.balance)
        }
    }
}
