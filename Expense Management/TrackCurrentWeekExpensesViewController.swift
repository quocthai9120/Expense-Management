//
//  TrackCurrentWeekExpensesViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit

class TrackCurrentWeekExpensesViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Global variables
    static var currentWeekExpensesAmount: Double = 0
    private var data: [String] = []

    // MARK: Properties
    @IBOutlet weak var currentWeekExpensesAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentWeekExpenses = getCurrentWeekExpenses()
        for i in 0..<currentWeekExpenses.count {
            data.append("\(i + 1). \(currentWeekExpenses[i])")
        }
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        currentWeekExpensesAmountLabel.text = "$" + String(TrackCurrentWeekExpensesViewController.currentWeekExpensesAmount)
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
    
    func getCurrentWeekKeys() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let calendar = Calendar.current
        let currentWeekDayIndex = calendar.component(.weekday, from: Date()) - 1
        var date = calendar.startOfDay(for: Date())

        let allDates = Set(ViewController.GlobalVariables.dates.keys)
        var currentWeekDates = [String]()

        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEEE, MM:dd:yyyy"
        // add today expenses
        currentWeekDates.append(dateFormatterRes.string(from: date))

        // add the remaining expenses
        for _ in 1...currentWeekDayIndex {
            date = calendar.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            currentWeekDates.append(dateFormatterRes.string(from: date))
        }

        return [String](Set<String>(currentWeekDates).intersection(allDates))
        
    }

    func getCurrentWeekExpenses() -> [String] {
        let currentWeekKeys: [String] = getCurrentWeekKeys()
        var totalExpenses = [String]()
        var amount: Double = 0
        
        for date in currentWeekKeys {
            if let currentDayExpenses = ViewController.GlobalVariables.dates[date] {
                for expense in currentDayExpenses {
                    let expenseName = Array(expense.keys)[0]
                    totalExpenses.append(expenseName + " - $" + String(expense[expenseName]!))
                    amount += expense[expenseName]!
                }
            }
        }
        TrackCurrentWeekExpensesViewController.currentWeekExpensesAmount = amount
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
