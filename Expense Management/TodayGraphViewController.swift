//
//  TodayGraphViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 7/2/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import Charts

class TodayGraphViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var todayExpensesBarChartView: BarChartView!
    @IBOutlet weak var totalExpensesTodayLabel: UILabel!
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todayExpensesType = ViewController.GlobalVariables.expensesType[getCurrentTime()] {
            todayBarChartInit(expensesType: todayExpensesType)
            totalExpensesTodayLabel.text = "$" + String(round(TrackTodayExpensesViewController.todayTotalExpensesAmount * 100) / 100)
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: Supplemental functions
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MM:dd:yyyy"
        let calendar = Calendar.current
        let date = calendar.startOfDay(for: Date())
        let dateFormatterRes = DateFormatter()
        dateFormatterRes.dateFormat = "EEEE, MM:dd:yyyy"
        
        return dateFormatterRes.string(from: date)
    }

    func todayBarChartInit(expensesType: [String : Double]) {
        var todayBarChartEntry = [BarChartDataEntry]()
        let xs: [String] = Array(expensesType.keys)
        var ys = [Double]()

        for x in xs {
            ys.append(expensesType[x]!)
        }

        for i in 0 ..< xs.count {
            todayBarChartEntry.append(BarChartDataEntry(x: Double(i), y: ys[i]))
        }
        
        // set x label
        todayExpensesBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xs)
        todayExpensesBarChartView.xAxis.granularity = 1
        todayExpensesBarChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 12.0, weight: UIFont.Weight.semibold)
        todayExpensesBarChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        // hide all grids
        todayExpensesBarChartView.xAxis.drawGridLinesEnabled = false
        todayExpensesBarChartView.rightAxis.drawGridLinesEnabled = false
        todayExpensesBarChartView.leftAxis.drawGridLinesEnabled = false
        
        todayExpensesBarChartView.legend.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)

        // setup the view
        let chartDataSet = BarChartDataSet(entries: todayBarChartEntry, label: "Expenses Types")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        todayExpensesBarChartView.data = chartData
        chartDataSet.colors = ChartColorTemplates.colorful()
        
        todayExpensesBarChartView.noDataText = "No expense to display!"
        todayExpensesBarChartView.animate(xAxisDuration: 0.5, yAxisDuration: 1.0)
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
