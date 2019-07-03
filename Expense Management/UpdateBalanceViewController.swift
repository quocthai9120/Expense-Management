//
//  UpdateBalanceViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import CoreData

class UpdateBalanceViewController: UIViewController {

    @IBOutlet weak var currentBalanceLabel: UILabel!

    @IBOutlet weak var amountToAddTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentBalanceLabel.text = String(round(ViewController.GlobalVariables.balance * 100) / 100)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Supplement Functions
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

    @IBAction func addBalanceButton(_ sender: Any) {
        if let addAmount = Double(amountToAddTextField.text!) {
            ViewController.GlobalVariables.balance += addAmount
            currentBalanceLabel.text = String(round(ViewController.GlobalVariables.balance * 100) / 100)
            saveBalance(balance: ViewController.GlobalVariables.balance)
        }
    }
}
