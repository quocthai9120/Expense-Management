//
//  TrackExpensesViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit

class TrackExpensesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fillRecent30Days()
        // Do any additional setup after loading the view.
    }
    
    // MARK: Supplemental functions
    func fillRecent30Days() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let calendar = Calendar.current
        var date = calendar.startOfDay(for: Date())
        var recent30Days = [String]()
        
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEEE, MM:dd:yyyy"
        // add today expenses
        recent30Days.append(dateFormatterRes.string(from: date))
        
        // add the remaining expenses
        for _ in 1...30 {
            date = calendar.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            recent30Days.append(dateFormatterRes.string(from: date))
        }
        
        for day in recent30Days {
            let currentExpenses = ViewController.GlobalVariables.dates[day]
            if currentExpenses == nil {
                ViewController.GlobalVariables.dates[day] = []
                ViewController.GlobalVariables.expensesType[day] = [:]
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
