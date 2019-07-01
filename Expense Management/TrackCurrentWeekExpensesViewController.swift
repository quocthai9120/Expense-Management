//
//  TrackCurrentWeekExpensesViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit

class TrackCurrentWeekExpensesViewController: UIViewController, UITableViewDataSource {
    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    var currentWeekExpensesAmount: Double = 0
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
        currentWeekExpensesAmountLabel.text = "$" + String(currentWeekExpensesAmount)
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
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        /*
         let hour = calendar.component(.hour, from: date)
         let minute = calendar.component(.minute, from: date)
         let second = calendar.component(.second, from: date)
         let dayInWeek = weekDays[(calendar.component(.weekday, from: date)) - 1]
         */
        return "\(month):\(day):\(year)"
    }
    
    func getCurrentWeekKeys() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:dd:yyyy"
        let calendar = Calendar.current
        let currentWeekDayIndex = calendar.component(.weekday, from: Date())
        var date = calendar.startOfDay(for: Date())

        let allDates = Array(ViewController.GlobalVariables.dates.keys)
        var currentWeekDates = [String]()

        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "mm:dd:yyyy"

        print("Hello today is", dateFormatterRes.string(from: date))
        for i in 1...currentWeekDayIndex {
            date = calendar.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            currentWeekDates.append(dateFormatterRes.string(from: date))
            print("Hello", i, dateFormatterRes.string(from: date))
        }

        print("all dates", allDates)
        print("Curr", currentWeekDates)
        return allDates
        
    }

    func getCurrentWeekExpenses() -> [String] {
        let today: String = getCurrentTime()
        let tExpenses = ViewController.GlobalVariables.dates[today]
        
        var todayExpensesItems = [String]()
        if tExpenses != nil {
            let todayExpenses = tExpenses!
            for dict in todayExpenses {
                let key = Array(dict.keys)[0]
                todayExpensesItems.append(key + " - $" + String(dict[key]!))
                currentWeekExpensesAmount += dict[key]!
            }
        }
        
        getCurrentWeekKeys()
        return todayExpensesItems
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
