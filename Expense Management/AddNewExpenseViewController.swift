//
//  AddNewExpenseViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import CoreData

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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: Date())
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEEE, MM:dd:yyyy"

        return dateFormatterRes.string(from: date)
    }

    func saveDates(dates: [String : [[String : Double]]]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Dates", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        newEntity.setValue(dates, forKey: "dates")
        
        do {
            try context.save()
            print("Saved!")
        } catch {
            print("Failed Saving!")
        }
    }
    
    func saveBalance(balance: Double) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Balance", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        newEntity.setValue(balance, forKey: "balance")
        
        do {
            try context.save()
            print("Saved!")
        } catch {
            print("Failed Saving!")
        }
    }

    // MARK: Actions

    @IBAction func addExpenseButton(_ sender: Any) {
        let expenseName: String = String(expenseNameTextField.text!)
        // let expenseType: String = String(expenseTypeTextField.text!)
        let amount = expenseAmountTextField.text
        
        if let expenseAmount = Double(amount!) {
            // add current date-expense to the dates dictionary
            let today: String = getCurrentTime()
            let todayExpenses = ViewController.GlobalVariables.dates[today]
            if todayExpenses == nil {
                ViewController.GlobalVariables.dates[today] = []
            }
            ViewController.GlobalVariables.dates[today]! += [[expenseName : expenseAmount]]
            
            // update balance
            ViewController.GlobalVariables.balance -= expenseAmount
            
            // save "dates" dictionary and "balance"
            saveDates(dates: ViewController.GlobalVariables.dates)
            saveBalance(balance: ViewController.GlobalVariables.balance)
            
            // print(ViewController.GlobalVariables.expensesType)
            print("Balance:", ViewController.GlobalVariables.balance)
            print(ViewController.GlobalVariables.dates)
        }
    }
    
}
