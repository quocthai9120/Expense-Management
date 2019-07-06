//
//  PredictExpensesViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import Charts

class PredictExpensesViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var expensesTrendingCombinedChartView: CombinedChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dateKeys: [String] = Array(ViewController.GlobalVariables.dates.keys)
        let dailyTotalExpenses: [String : Double] = getTotalExpenses(expensesType: ViewController.GlobalVariables.expensesType)
        let sortedDateKeys: [String] = sortDate(dateKeys: dateKeys)
        plotExpensesLineChart(sortedDateKeys: sortedDateKeys, totalExpenses: dailyTotalExpenses)
    }
    

    // MARK: Supplemental Functions
    func sortDate(dateKeys: [String]) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        
        var dateObjects: [Date] = []
        
        for dateKey in dateKeys {
            dateObjects.append(dateFormatter.date(from: dateKey)!)
        }
        dateObjects.sort(){$0 < $1}
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEEE, MM:dd:yyyy"
        
        var sortedDateKeys: [String] = []

        for date in dateObjects {
            sortedDateKeys.append(dateFormatterRes.string(from: date))
        }
        
        return sortedDateKeys
    }

    func getTotalExpenses(expensesType: [String : [String : Double]]) -> [String : Double] {
        let dates: [String] = Array(expensesType.keys)
        var totalExpenses: [String : Double] = [:]
        
        for date in dates {
            let currentExpenses: [String : Double] = expensesType[date]!
            var currentTotalExpenses: Double = 0.0

            for type in Array(currentExpenses.keys) {
                currentTotalExpenses += currentExpenses[type]!
            }
            totalExpenses.updateValue(currentTotalExpenses, forKey: date)
        }
        
        return totalExpenses
    }

    func plotExpensesLineChart(sortedDateKeys: [String], totalExpenses: [String : Double]) {
        var scatterDataEntries: [ChartDataEntry] = []
        for i in 0 ..< totalExpenses.count {
            let currentDayExpensesAmount: Double = totalExpenses[sortedDateKeys[i]]!
            if currentDayExpensesAmount != 0 {
                let scatterDataEntry = ChartDataEntry(x: Double(i), y: currentDayExpensesAmount)
                scatterDataEntries.append(scatterDataEntry)
                print(sortedDateKeys[i], totalExpenses[sortedDateKeys[i]]!)
            }
        }
        let scatterDataSet = ScatterChartDataSet(entries: scatterDataEntries, label: "Daily Total Expenses")
        scatterDataSet.colors = ChartColorTemplates.colorful()

        let data: CombinedChartData = CombinedChartData(dataSets: [scatterDataSet])
        data.scatterData = ScatterChartData(dataSet: scatterDataSet)
        expensesTrendingCombinedChartView.data = data
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
