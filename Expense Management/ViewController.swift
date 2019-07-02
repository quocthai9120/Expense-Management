//
//  ViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/28/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        getDates()
        getExpensesType()
        getBalance()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    struct GlobalVariables {
        static var balance: Double = 0
        static var expensesType = [String : [String : Double]]() //   map date to [expenseType : amount]
        static var dates = [String : [[String : Double]]]()   //   map date to [[expenseName : amount]]
    }
    
    // additional functions
    func getDates() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Dates")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                GlobalVariables.dates = data.value(forKey: "dates") as! [String : [[String : Double]]]
            }
        } catch {
            print("Failed to get Dates!")
        }
    }
    
    func getExpensesType() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpensesType")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                GlobalVariables.expensesType = data.value(forKey: "expensesType") as! [String : [String : Double]]
            }
        } catch {
            print("Failed to get ExpensesType!")
        }
    }

    func getBalance() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Balance")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                GlobalVariables.balance = data.value(forKey: "balance") as! Double
            }
        } catch {
            print("Failed to get Balance!")
        }
    }
}

