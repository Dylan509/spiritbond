//
//  HomeUserStockViewController.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 29/9/2020.
//

import UIKit
import Firebase

class HomeUserStockViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUser: CurrentUser? = nil
    
    @IBOutlet var stockTableView: UITableView!
    
    var selectedStock: String = ""
    var sortedKeys: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stockTableView.delegate = self
        self.stockTableView.dataSource = self
        
        self.stockTableView.layer.cornerRadius = 14
        self.stockTableView.layer.masksToBounds = true
        
        self.stockTableView.layer.borderColor = UIColor( red: 255/255, green: 255/255, blue:255/255, alpha: 1.0 ).cgColor
        self.stockTableView.layer.borderWidth = 2.0
        
        self.sortedKeys = (self.currentUser?.getOrderedList().sorted(by: <))!
        
        self.currentUser?.getStockData{ success in
            guard success else { return }
            
            let currentWorth: Double = (self.currentUser?.currentWorth())!
            let buyingPower: Double = (self.currentUser?.balance)!
            let portfolioValue: Double = (self.currentUser?.portfolioValue())!
            
   //         self.balanceLabel.text = currencyFormat(value: currentWorth)
   //         self.buyingPowerLabel.text = currencyFormat(value: buyingPower)
   //         self.portfolioValueLabel.text = currencyFormat(value: portfolioValue)
            
            let initialWorth: Double = 100000.0
            let overallChange: Double = currentWorth - initialWorth
            let overallChangePercent: Double = getPercentage(value: initialWorth, change: overallChange)
            
            self.stockTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
        stockTableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentUser?.stocks.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let pCell = stockTableView.dequeueReusableCell(withIdentifier: "portfolioCell", for: indexPath) as? PortfolioCell {
            let stockSymbol: String = self.sortedKeys[indexPath.row]
            pCell.symbollabel.text = stockSymbol
            let numShares = self.currentUser?.stocks[stockSymbol]!["shares"] as! Int
            pCell.shareslabel.text = String(numShares) + " 股"
            
            if !(self.currentUser?.stockData.isEmpty)! {
                let stockData = self.currentUser?.stockData[stockSymbol] as! [String:Any]
                let value = stockData["latestPrice"] as! Double
                pCell.valuelabel.text = currencyFormat(value: value * Double(numShares))
            }
            
            return pCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedStock = self.sortedKeys[indexPath.row]
        performSegue(withIdentifier: "showStock", sender: self)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? marketView {
            dest.symbol = self.selectedStock
            dest.currentUser = self.currentUser
        }
    }

}
