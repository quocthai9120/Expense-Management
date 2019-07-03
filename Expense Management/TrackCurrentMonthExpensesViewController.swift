//
//  TrackCurrentMonthExpensesViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit

class TrackCurrentMonthExpensesViewController: UIViewController, UITableViewDataSource {

    // MARK: Global variables
    static var currentMonthExpensesAmount: Double = 0
    private var data: [String] = []

    // MARK: Properties
    @IBOutlet weak var currentMonthExpensesAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let currentMonthExpenses = getCurrentMonthExpenses()
        for i in 0..<currentMonthExpenses.count {
            data.append("\(i + 1). \(currentMonthExpenses[i])")
        }
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        currentMonthExpensesAmountLabel.text = "$" + String(TrackCurrentMonthExpensesViewController.currentMonthExpensesAmount)
    }

    // MARK: TableView methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        
        let text = data[indexPath.row]
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // MARK: Supplement Methods
    
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: Date())
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEEE, MM:dd:yyyy"
        
        return dateFormatterRes.string(from: date)
    }
    
    func getCurrentMonthKeys() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let calendar = Calendar.current
        var date = calendar.startOfDay(for: Date())
        let currentDay: Int = calendar.component(.day, from: Date())
        let allDates = Set(ViewController.GlobalVariables.dates.keys)
        var currentMonthDates = [String]()
        
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEEE, MM:dd:yyyy"
        // add today expenses
        currentMonthDates.append(dateFormatterRes.string(from: date))
        
        // add the remaining expenses
        for _ in 1...(currentDay - 1) {
            date = calendar.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            currentMonthDates.append(dateFormatterRes.string(from: date))
        }

        return [String](Set<String>(currentMonthDates).intersection(allDates))
        
    }
    
    func getCurrentMonthExpenses() -> [String] {
        let currentMonthKeys: [String] = getCurrentMonthKeys()
        var totalExpenses = [String]()
        var amount: Double = 0
        
        for date in currentMonthKeys {
            if let currentDayExpenses = ViewController.GlobalVariables.dates[date] {
                for expense in currentDayExpenses {
                    let expenseName = Array(expense.keys)[0]
                    totalExpenses.append(expenseName + " - $" + String(expense[expenseName]!))
                    amount += expense[expenseName]!
                }
            }
        }
        
        TrackCurrentMonthExpensesViewController.currentMonthExpensesAmount = amount
        
        return totalExpenses
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
