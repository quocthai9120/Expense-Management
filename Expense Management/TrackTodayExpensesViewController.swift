//
//  TrackTodayExpensesViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import Charts

class TrackTodayExpensesViewController: UIViewController, UITableViewDataSource {
    let weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var todayTotalExpensesAmount: Double = 0

    @IBOutlet weak var todayTotalExpensesAmountLabel: UILabel!

    private var data: [String] = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let todayExpenses = getTodayExpenses()
        for i in 0..<todayExpenses.count {
            data.append("\(i + 1). \(todayExpenses[i])")
        }
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        todayTotalExpensesAmountLabel.text = "$" + String(todayTotalExpensesAmount)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

    func getTodayExpenses() -> [String] {
        let today: String = getCurrentTime()
        let tExpenses = ViewController.GlobalVariables.dates[today]
        
        var todayExpensesItems = [String]()
        if tExpenses != nil {
            let todayExpenses = tExpenses!
            for dict in todayExpenses {
                let key = Array(dict.keys)[0]
                todayExpensesItems.append(key + " - $" + String(dict[key]!))
                todayTotalExpensesAmount += dict[key]!
            }
        }

        return todayExpensesItems
    }

    // MARK: Actions

    @IBAction func allExpensesButton(_ sender: Any) {
    }
    
    @IBAction func expensesGraphButton(_ sender: Any) {
    }
    
    
}
