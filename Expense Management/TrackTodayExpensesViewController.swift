//
//  TrackTodayExpensesViewController.swift
//  Expense Management
//
//  Created by Hoang Quoc Thai  on 6/29/19.
//  Copyright © 2019 ThaiHoang. All rights reserved.
//

import UIKit
import Charts

class TrackTodayExpensesViewController: UIViewController {

    
    @IBOutlet weak var todayExpensesLineChart: LineChartView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Actions

    @IBAction func allExpensesButton(_ sender: Any) {
    }
    
    @IBAction func expensesGraphButton(_ sender: Any) {
    }
    
    
}
