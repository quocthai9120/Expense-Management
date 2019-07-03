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

    // MARK: Properties
    @IBOutlet weak var currentMonthExpensesAmountLabel: UILabel!
    @IBOutlet weak var currentMonthExpensesCombinedChartView: CombinedChartView!
    
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
        var totalDailyExpenses: [Double] = []

        // get all expenses type for current month
        for day in currentMonthKeys {
            let currentExpensesDict = currentMonthExpensesType[day]!
            allCurrentMonthExpenseTypes = allCurrentMonthExpenseTypes.union(Set(currentExpensesDict.keys))
        }
        
        // get all amounts into nested-array and compute total daily expenses
        for day in currentMonthKeys {
            var totalExpensesCurrentDay: Double = 0.0
            var currentAmounts = [Double]()
            let currentExpensesDict = currentMonthExpensesType[day]!
            let currentExpensesKeys = Set(currentExpensesDict.keys)
            
            for expenseType in allCurrentMonthExpenseTypes {
                if currentExpensesKeys.contains(expenseType) {
                    let amount: Double = currentExpensesDict[expenseType]!
                    currentAmounts.append(amount)
                    totalExpensesCurrentDay += amount
                } else {
                    currentAmounts.append(0.0)
                }
            }
            
            // append all amount for current day to the current week array
            currentMonthAmounts.append(currentAmounts)

            // append current day expenses amount to totalDailyExpenses
            totalDailyExpenses.append(totalExpensesCurrentDay)
        }
        
        for i in 0 ..< currentMonthKeys.count {
            let currentBarChartEntry = BarChartDataEntry(x: Double(i), yValues: currentMonthAmounts[i])
            currentMonthBarChartEntries.append(currentBarChartEntry)
        }
        
        // set x_axis customizations
        let xAxisLabels: [String] = printDateFormat(datesList: currentMonthKeys)
        currentMonthExpensesCombinedChartView.xAxis.labelCount = xAxisLabels.count
        currentMonthExpensesCombinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        currentMonthExpensesCombinedChartView.xAxis.granularity = 1
        currentMonthExpensesCombinedChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // hide all grids
        currentMonthExpensesCombinedChartView.xAxis.drawGridLinesEnabled = false
        currentMonthExpensesCombinedChartView.rightAxis.drawGridLinesEnabled = false
        currentMonthExpensesCombinedChartView.leftAxis.drawGridLinesEnabled = false
        
        let barChartDataSet = BarChartDataSet(entries: currentMonthBarChartEntries, label: "")
        barChartDataSet.colors = ChartColorTemplates.colorful()
        barChartDataSet.stackLabels = Array(allCurrentMonthExpenseTypes)
        barChartDataSet.drawValuesEnabled = false

        // set up line data
        var lineChartEntries = [ChartDataEntry]()
        for i in 0 ..< currentMonthKeys.count {
            let currentLineChartEntry = ChartDataEntry(x: Double(i), y: totalDailyExpenses[i])
            lineChartEntries.append(currentLineChartEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntries, label: "Daily Total Expenses")
        
        // setup combined data
        let data: CombinedChartData = CombinedChartData(dataSets: [barChartDataSet, lineChartDataSet])
        data.barData = BarChartData(dataSet: barChartDataSet)
        data.lineData = LineChartData(dataSet: lineChartDataSet)
        currentMonthExpensesCombinedChartView.data = data

        
        currentMonthExpensesCombinedChartView.noDataText = "No expense to display!"
        currentMonthExpensesCombinedChartView.animate(xAxisDuration: 0.5, yAxisDuration: 1.0)
        
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
