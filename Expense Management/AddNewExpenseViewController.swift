//
//  AddNewExpenseViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit

class AddNewExpenseViewController: UIViewController, UITextFieldDelegate {

    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    // MARKS: Properties
    @IBOutlet weak var expenseNameTextField: UITextField!
    
    @IBOutlet weak var expenseTypeTextField: UITextField!
    
    @IBOutlet weak var expenseAmountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseNameTextField.delegate = self
        expenseTypeTextField.delegate = self
        expenseAmountTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: Supplemental functions
    func getCurrentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let dayInWeek = weekDays[(calendar.component(.weekday, from: date)) - 1]
        /*
         let hour = calendar.component(.hour, from: date)
         let minute = calendar.component(.minute, from: date)
         let second = calendar.component(.second, from: date)
         */
        return "\(dayInWeek) \(month):\(day):\(year)"
    }

    // MARK: Actions

    @IBAction func addExpenseButton(_ sender: Any) {
        let expenseName: String = String(expenseNameTextField.text!)
        // let expenseType: String = String(expenseTypeTextField.text!)
        let expenseAmount: Double = Double(expenseAmountTextField.text!)!

        // add current date-expense to the dates dictionary
        let today: String = getCurrentTime()
        let todayExpenses = ViewController.GlobalVariables.dates[today]
        if todayExpenses == nil {
            ViewController.GlobalVariables.dates[today] = []
        }
        ViewController.GlobalVariables.dates[today]! += [[expenseName : expenseAmount]]

        // update balance
        ViewController.GlobalVariables.balance -= expenseAmount
        
        // print(ViewController.GlobalVariables.expensesType)
        print("Balance:", ViewController.GlobalVariables.balance)
        print(ViewController.GlobalVariables.dates)
    }
    
}
