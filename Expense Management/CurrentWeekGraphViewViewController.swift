//
//  CurrentWeekGraphViewViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 7/3/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import Charts

class CurrentWeekGraphViewViewController: UIViewController {
    
    @IBOutlet weak var currentWeekExpensesAmountLabel: UILabel!
    // MARK: Properties
    @IBOutlet weak var currentWeekExpensesBarChartView: BarChartView!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentWeekExpensesType = getCurrentWeekExpensesType()
        
        if currentWeekExpensesType.isEmpty {
            print("No Expense this week")
        } else {
            currentWeekChartInit(currentWeekExpensesType: currentWeekExpensesType)
            currentWeekExpensesAmountLabel.text = "$" + String(TrackCurrentWeekExpensesViewController.currentWeekExpensesAmount)
        }
    }
    
    // MARK: Supplement Functions
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

    func getCurrentWeekExpensesType() -> [String: [String : Double]] {
        let currentWeekKeys: [String] = getCurrentWeekKeys()
        var currentWeekExpensesType = [String: [String : Double]]()

        for key in currentWeekKeys {
            let currentExpensesType = ViewController.GlobalVariables.expensesType[key]!
            currentWeekExpensesType.updateValue(currentExpensesType, forKey: key)
        }
        
        return currentWeekExpensesType
    }

    func currentWeekChartInit(currentWeekExpensesType: [String : [String : Double]]) {
        var currentWeekBarChartEntries: [BarChartDataEntry] = []
        let currentWeekKeys: [String] = Array(currentWeekExpensesType.keys)
        var allCurrentWeekExpenseTypes: Set<String> = []
        var currentWeekAmounts = [[Double]]()
        
        // get all expenses type for current Week
        for day in currentWeekKeys {
            let currentExpensesDict = currentWeekExpensesType[day]!
            allCurrentWeekExpenseTypes = allCurrentWeekExpenseTypes.union(Set(currentExpensesDict.keys))
        }

        // get all amounts into nested-array
        for day in currentWeekKeys {
            var currentAmounts = [Double]()
            let currentExpensesDict = currentWeekExpensesType[day]!
            let currentExpensesKeys = Set(currentExpensesDict.keys)

            for expenseType in allCurrentWeekExpenseTypes {
                if currentExpensesKeys.contains(expenseType) {
                    currentAmounts.append(currentExpensesDict[expenseType]!)
                } else {
                    currentAmounts.append(0.0)
                }
            }
            
            // append all amount for current day to the current week array
            currentWeekAmounts.append(currentAmounts)
        }

        for i in 0 ..< currentWeekKeys.count {
            let currentBarChartEntry = BarChartDataEntry(x: Double(i), yValues: currentWeekAmounts[i])
            currentWeekBarChartEntries.append(currentBarChartEntry)
        }

        let xAxisLabels: [String] = printDateFormat(datesList: currentWeekKeys)
        currentWeekExpensesBarChartView.xAxis.labelCount = xAxisLabels.count
        currentWeekExpensesBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)

        let chartDataSet = BarChartDataSet(entries: currentWeekBarChartEntries, label: "")
        chartDataSet.colors = ChartColorTemplates.colorful()
        chartDataSet.stackLabels = Array(allCurrentWeekExpenseTypes)
        chartDataSet.drawValuesEnabled = false
        let data = BarChartData(dataSet: chartDataSet)
        currentWeekExpensesBarChartView.data = data
    }
    
    func printDateFormat(datesList: [String]) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEEE"

        var datesRes: [String] = []
        for date in datesList {
            datesRes.append(dateFormatterRes.string(from: dateFormatter.date(from: date)!))
        }
        
        return datesRes
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
