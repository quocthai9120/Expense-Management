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
    @IBOutlet weak var currentWeekExpensesCombinedChartView: CombinedChartView!
    // MARK: Properties
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let currentWeekExpensesType = getCurrentWeekExpensesType()
        
        if currentWeekExpensesType.isEmpty {
            print("No Expense this week")
        } else {
            currentWeekChartInit(currentWeekExpensesType: currentWeekExpensesType)
            currentWeekExpensesAmountLabel.text = "$" + String(round(TrackCurrentWeekExpensesViewController.currentWeekExpensesAmount * 100) / 100)
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
        print(currentWeekKeys)
        var allCurrentWeekExpenseTypes: Set<String> = []
        var currentWeekAmounts = [[Double]]()
        var totalDailyExpenses: [Double] = []
        
        // get all expenses type for current Week
        for day in currentWeekKeys {
            let currentExpensesDict = currentWeekExpensesType[day]!
            allCurrentWeekExpenseTypes = allCurrentWeekExpenseTypes.union(Set(currentExpensesDict.keys))
        }

        // get all amounts into nested-array and compute total daily expenses
        for day in currentWeekKeys {
            var totalExpensesCurrentDay: Double = 0.0
            var currentAmounts = [Double]()
            let currentExpensesDict = currentWeekExpensesType[day]!
            let currentExpensesKeys = Set(currentExpensesDict.keys)

            for expenseType in allCurrentWeekExpenseTypes {
                if currentExpensesKeys.contains(expenseType) {
                    let amount: Double = currentExpensesDict[expenseType]!
                    currentAmounts.append(amount)
                    totalExpensesCurrentDay += amount
                } else {
                    currentAmounts.append(0.0)
                }
            }
            
            // append all amount for current day to the current week array
            currentWeekAmounts.append(currentAmounts)
            
            // append current day expenses amount to totalDailyExpenses
            totalDailyExpenses.append(totalExpensesCurrentDay)
        }

        for i in 0 ..< currentWeekKeys.count {
            let currentBarChartEntry = BarChartDataEntry(x: Double(i), yValues: currentWeekAmounts[i])
            currentWeekBarChartEntries.append(currentBarChartEntry)
        }

        // set x_axis customizations
        let xAxisLabels: [String] = printDateFormat(datesList: currentWeekKeys)
        currentWeekExpensesCombinedChartView.xAxis.labelCount = xAxisLabels.count
        currentWeekExpensesCombinedChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        currentWeekExpensesCombinedChartView.xAxis.granularity = 1
        currentWeekExpensesCombinedChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // hide all grids
        currentWeekExpensesCombinedChartView.xAxis.drawGridLinesEnabled = false
        currentWeekExpensesCombinedChartView.rightAxis.drawGridLinesEnabled = false
        currentWeekExpensesCombinedChartView.leftAxis.drawGridLinesEnabled = false

        let barChartDataSet = BarChartDataSet(entries: currentWeekBarChartEntries, label: "")
        barChartDataSet.colors = ChartColorTemplates.colorful()
        barChartDataSet.stackLabels = Array(allCurrentWeekExpenseTypes)
        barChartDataSet.drawValuesEnabled = false
        
        // set up line data
        var lineChartEntries = [ChartDataEntry]()
        for i in 0 ..< currentWeekKeys.count {
            let currentLineChartEntry = ChartDataEntry(x: Double(i), y: totalDailyExpenses[i])
            lineChartEntries.append(currentLineChartEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntries, label: "Daily Total Expenses")
        
        // setup combined data
        let data: CombinedChartData = CombinedChartData(dataSets: [barChartDataSet, lineChartDataSet])
        data.barData = BarChartData(dataSet: barChartDataSet)
        data.lineData = LineChartData(dataSet: lineChartDataSet)
        currentWeekExpensesCombinedChartView.data = data
        
        currentWeekExpensesCombinedChartView.animate(xAxisDuration: 0.5, yAxisDuration: 1.0)
    }
    
    func printDateFormat(datesList: [String]) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEE"

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
