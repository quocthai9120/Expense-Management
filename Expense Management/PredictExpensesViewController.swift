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
    func fitRegressionLine (xs: [Double], ys: [Double]) -> [Double] {
        var xTotal: Double = 0.0
        var yTotal: Double = 0.0
        var xySum: Double = 0.0
        var xxSum: Double = 0.0
        let count: Int = xs.count
        
        for i in 0 ..< count {
            xTotal += xs[i]
            yTotal += ys[i]
            xySum += xs[i] * ys[i]
            xxSum += xs[i] * xs[i]
        }
        
        let xMean: Double = xTotal / Double(count)
        let yMean: Double = yTotal / Double(count)
        
        let crossDeviation: Double = xySum - Double(count) * xMean * yMean
        let xDeviation: Double = xxSum - Double(count) * xMean * xMean
        
        let slope: Double = crossDeviation / xDeviation
        let yIntercept: Double = yMean - slope * xMean
        
        return [slope, yIntercept]
    }

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
        var xs: [Double] = []
        var ys: [Double] = []
        for i in 0 ..< totalExpenses.count {
            let currentDayExpensesAmount: Double = totalExpenses[sortedDateKeys[i]]!
            if currentDayExpensesAmount != 0 {
                let scatterDataEntry = ChartDataEntry(x: Double(i), y: currentDayExpensesAmount)
                scatterDataEntries.append(scatterDataEntry)
                xs.append(Double(i))
                ys.append(currentDayExpensesAmount)
            }
        }
        
        // initialize scatterplot
        let scatterDataSet = ScatterChartDataSet(entries: scatterDataEntries, label: "Daily Total Expenses")
        scatterDataSet.colors = ChartColorTemplates.colorful()
        
        // initialize line chart
        let slopeAndYIntercept: [Double] = fitRegressionLine(xs: xs, ys: ys)
        let slope: Double = slopeAndYIntercept[0]
        let yIntercept: Double = slopeAndYIntercept[1]

        var lineChartEntries: [ChartDataEntry] = []

        for i in 0 ..< totalExpenses.count + 5 {
            let yPred: Double = Double(i) * slope + yIntercept
            let lineChartEntry = ChartDataEntry(x: Double(i), y: yPred)
            lineChartEntries.append(lineChartEntry)
        }

        let lineDataSet = LineChartDataSet(entries: lineChartEntries, label: "Daily Expenses Trending")
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.drawValuesEnabled = false
        
        let data: CombinedChartData = CombinedChartData(dataSets: [scatterDataSet, lineDataSet])
        data.scatterData = ScatterChartData(dataSet: scatterDataSet)
        data.lineData = LineChartData(dataSet: lineDataSet)
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
