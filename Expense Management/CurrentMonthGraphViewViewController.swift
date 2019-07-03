//
//  CurrentMonthGraphViewViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 7/3/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import Charts

class CurrentMonthGraphViewViewController: UIViewController {

    @IBOutlet weak var currentMonthExpensesAmountLabel: UILabel!
    // MARK: Properties
    @IBOutlet weak var currentMonthExpensesBarChartView: BarChartView!

    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentMonthExpensesType = getCurrentMonthExpensesType()
        
        if currentMonthExpensesType.isEmpty {
            print("No Expense this month")
        } else {
            currentMonthChartInit(currentMonthExpensesType: currentMonthExpensesType)
            currentMonthExpensesAmountLabel.text = "$" + String(round(TrackCurrentMonthExpensesViewController.currentMonthExpensesAmount * 100) / 100)
        }

    }
    
    // MARK: Supplement Functions !!!FIX
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
    
    func getCurrentMonthExpensesType() -> [String: [String : Double]] {
        let currentMonthKeys: [String] = getCurrentMonthKeys()
        var currentMonthExpensesType = [String: [String : Double]]()
        
        for key in currentMonthKeys {
            let currentExpensesType = ViewController.GlobalVariables.expensesType[key]!
            currentMonthExpensesType.updateValue(currentExpensesType, forKey: key)
        }
        
        return currentMonthExpensesType
    }
    
    func currentMonthChartInit(currentMonthExpensesType: [String : [String : Double]]) {
        var currentMonthBarChartEntries: [BarChartDataEntry] = []
        let currentMonthKeys: [String] = Array(currentMonthExpensesType.keys)
        var allCurrentMonthExpenseTypes: Set<String> = []
        var currentMonthAmounts = [[Double]]()
        
        // get all expenses type for current Week
        for day in currentMonthKeys {
            let currentExpensesDict = currentMonthExpensesType[day]!
            allCurrentMonthExpenseTypes = allCurrentMonthExpenseTypes.union(Set(currentExpensesDict.keys))
        }
        
        // get all amounts into nested-array
        for day in currentMonthKeys {
            var currentAmounts = [Double]()
            let currentExpensesDict = currentMonthExpensesType[day]!
            let currentExpensesKeys = Set(currentExpensesDict.keys)
            
            for expenseType in allCurrentMonthExpenseTypes {
                if currentExpensesKeys.contains(expenseType) {
                    currentAmounts.append(currentExpensesDict[expenseType]!)
                } else {
                    currentAmounts.append(0.0)
                }
            }
            
            // append all amount for current day to the current week array
            currentMonthAmounts.append(currentAmounts)
        }
        
        for i in 0 ..< currentMonthKeys.count {
            let currentBarChartEntry = BarChartDataEntry(x: Double(i), yValues: currentMonthAmounts[i])
            currentMonthBarChartEntries.append(currentBarChartEntry)
        }
        
        // set x_axis customizations
        let xAxisLabels: [String] = printDateFormat(datesList: currentMonthKeys)
        currentMonthExpensesBarChartView.xAxis.labelCount = xAxisLabels.count
        currentMonthExpensesBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        currentMonthExpensesBarChartView.xAxis.granularity = 1
        currentMonthExpensesBarChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // hide all grids
        currentMonthExpensesBarChartView.xAxis.drawGridLinesEnabled = false
        currentMonthExpensesBarChartView.rightAxis.drawGridLinesEnabled = false
        currentMonthExpensesBarChartView.leftAxis.drawGridLinesEnabled = false
        
        let chartDataSet = BarChartDataSet(entries: currentMonthBarChartEntries, label: "")
        chartDataSet.colors = ChartColorTemplates.colorful()
        chartDataSet.stackLabels = Array(allCurrentMonthExpenseTypes)
        chartDataSet.drawValuesEnabled = false
        let data = BarChartData(dataSet: chartDataSet)
        currentMonthExpensesBarChartView.data = data
        
        currentMonthExpensesBarChartView.noDataText = "No expense to display!"
        currentMonthExpensesBarChartView.animate(xAxisDuration: 0.5, yAxisDuration: 1.0)
    }
    
    func printDateFormat(datesList: [String]) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "MMM dd"
        
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
