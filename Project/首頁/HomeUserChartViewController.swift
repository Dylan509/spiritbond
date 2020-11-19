//
//  HomeUserChartViewController.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 29/9/2020.
//

import UIKit
import Firebase
import Charts

class HomeUserChartViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    var currentUser: CurrentUser? = nil
    let db = Firestore.firestore()
    var tempFundRaise = [Int]()
    var investAmount: Int = 0
    var rasingAmount: Int = 0
    var temp: Int = 0
    var temp2: Int = 0
    var count: Int = 0
    var test: Double = 0
    var currentWorth: Double = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser?.getStockData{ success in
            guard success else { return }
            self.currentWorth = (self.currentUser?.currentWorth())! - (self.currentUser?.balance)!
            self.pieChartView.reloadInputViews()
        }
        
        self.currentUser?.loadForFundRaiserData{ [self] success in
            guard success else { return }
            self.rasingAmount = (self.currentUser?.temp2)!
            self.pieChartView.reloadInputViews()
        }
        
        self.currentUser?.loadForFundRaiseData{ [self] success in
            guard success else { return }
            self.investAmount = (self.currentUser?.temp)!
            self.pieChartView.reloadInputViews()
        }
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: false) { (timer) in
            let type = ["募資","發起募資","下單","可用餘額"]
            let invest = Double(self.investAmount)
            let raise = Double(self.rasingAmount)
            let balance = Double((self.currentUser?.balance)!)
            let amount = [invest,raise,self.currentWorth,balance]
            self.setPieChart(dataPoints: type, values: amount)
            }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        pieChartView.reloadInputViews()
    }
    
    func setPieChart(dataPoints: [String], values: [Double]){
        
        pieChartView.noDataText = "資料刷新中..."

        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
          let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
          dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)

        // 4. Assign it to the chart’s data
        pieChartView.data = pieChartData
    
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
      var colors: [UIColor] = []
      for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
      }
      return colors
    }
}
