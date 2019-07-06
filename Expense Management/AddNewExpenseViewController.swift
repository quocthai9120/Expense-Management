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

    // MARKS: Properties
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseTypeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
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
            print("Dates Saved!")
        } catch {
            print("Failed Saving Dates!")
        }
    }
    
    func saveExpensesType(expensesType: [String : [String : Double]]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ExpensesType", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        newEntity.setValue(expensesType, forKey: "expensesType")
        
        do {
            try context.save()
            print("ExpensesType Saved!")
        } catch {
            print("Failed Saving ExpensesType!")
        }
    }

    func saveBalance(balance: Double) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Balance", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        newEntity.setValue(balance, forKey: "balance")
        
        do {
            try context.save()
            print("Balance Saved!")
        } catch {
            print("Failed Saving Balance!")
        }
    }

    // MARK: Actions

    @IBAction func addExpenseButton(_ sender: Any) {
        let expenseName: String = String(expenseNameTextField.text!)
        let expenseType: String = String(expenseTypeTextField.text!)
        let amount: String = String(expenseAmountTextField.text!)
        var inputDate = String(dateTextField.text!)
        
        if let expenseAmount = Double(amount) {
            if inputDate == "" {
                inputDate = getCurrentTime()
            }
            // add current date-expense to the dates dictionary
            let inputDateExpenses = ViewController.GlobalVariables.dates[inputDate]
            if inputDateExpenses == nil {
                ViewController.GlobalVariables.dates[inputDate] = []
            }
            ViewController.GlobalVariables.dates[inputDate]! += [[expenseName : expenseAmount]]
            
            // add [date : [expenseType : Amount]]
            let inputDateExpensesType = ViewController.GlobalVariables.expensesType[inputDate]
            if inputDateExpensesType == nil {
                ViewController.GlobalVariables.expensesType[inputDate] = [String : Double]()
            }
            var currentExpense: Double? = ViewController.GlobalVariables.expensesType[inputDate]![expenseType]
            if currentExpense == nil {
                currentExpense = 0
            }
            ViewController.GlobalVariables.expensesType[inputDate]!.updateValue(currentExpense! + expenseAmount, forKey: expenseType)

            // update balance
            ViewController.GlobalVariables.balance -= expenseAmount
            
            // save "dates" dictionary, "expensesType" dictionary and "balance"
            saveDates(dates: ViewController.GlobalVariables.dates)
            saveExpensesType(expensesType: ViewController.GlobalVariables.expensesType)
            saveBalance(balance: ViewController.GlobalVariables.balance)
        }
    }
    
}
