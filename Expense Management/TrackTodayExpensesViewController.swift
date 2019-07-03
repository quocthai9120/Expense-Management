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
    static var todayTotalExpensesAmount: Double = 0

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
        todayTotalExpensesAmountLabel.text = "$" + String(TrackTodayExpensesViewController.todayTotalExpensesAmount)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: Date())
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEEE, MM:dd:yyyy"
        
        return dateFormatterRes.string(from: date)
    }

    func getTodayExpenses() -> [String] {
        let today: String = getCurrentTime()
        let tExpenses = ViewController.GlobalVariables.dates[today]
        var amount: Double = 0
        
        var todayExpensesItems = [String]()
        if tExpenses != nil {
            let todayExpenses = tExpenses!
            for dict in todayExpenses {
                let key = Array(dict.keys)[0]
                todayExpensesItems.append(key + " - $" + String(dict[key]!))
                amount += dict[key]!
            }
        }
        TrackTodayExpensesViewController.todayTotalExpensesAmount = amount
        return todayExpensesItems
    }

    // MARK: Actions

    @IBAction func allExpensesButton(_ sender: Any) {
    }
    
    @IBAction func expensesGraphButton(_ sender: Any) {
    }
    
    
}
