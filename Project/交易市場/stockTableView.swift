//
//  stockTableView.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/27.
//

import UIKit
import Alamofire

class stockTableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var showDate: UILabel!
    @IBOutlet var showTime: UILabel!
    @IBOutlet var navigationBar: UINavigationItem!
    @IBOutlet var cancelbutton: UIBarButtonItem!
    @IBOutlet var mysearchBar: UISearchBar!
    @IBOutlet var mytableView: UITableView!
    @IBOutlet var topgainTable: UITableView!
    @IBOutlet var toplossTable: UITableView!
    @IBOutlet var gainimage: UIImageView!
    @IBOutlet var lossimage: UIImageView!
    var date: Date?
    private var updateLabel = UpdateLabel()
    private let refreshControl = UIRefreshControl()
    private var dateFormatter = DateFormatter()
    private var relativeDateFormatter = RelativeDateTimeFormatter()
    
    var currentUser: CurrentUser? = nil
    var stockTest: Finnhub!
    let todoEndpoint: String = "https://api.iextrading.com/1.0/ref-data/symbols"
    var stockList: [String] = []
    var filteredStockList: [String] = []
    var searching = false
    var stockObjects: [String: Finnhub] = [:]
    var selectedStock: String = ""
    
    var orderedGainStocks: [String] = []
    var topGainStocks: [String:[String:Any]] = [:]
    
    var orderedLoseStocks: [String] = []
    var topLoseStocks: [String:[String:Any]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStockArray()
        setup()
        
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mysearchBar.delegate = self
        self.topgainTable.delegate = self
        self.topgainTable.dataSource = self
        self.toplossTable.delegate = self
        self.toplossTable.dataSource = self
        self.navigationBar.title = "市場交易"
        self.navigationBar.leftBarButtonItem = nil
        self.mytableView.alpha = 0.0
        self.mysearchBar.alpha = 0.0
        
        let gainersEndpoint: String = "https://sandbox.iexapis.com/stable/stock/market/list/gainers?token=Tsk_3caeac734b61409eb766566cd5c71159"
        Alamofire.request(gainersEndpoint)
            .responseJSON { response in
                guard let json = response.result.value as? [[String: Any]] else {
                    return
                }
                for stock in json{
                    let stockSymbol = stock["symbol"] as! String
                    self.topGainStocks[stockSymbol] = stock
                }
                
                self.orderedGainStocks = self.topGainStocks.keys.sorted{(self.topGainStocks[$0]!["changePercent"] as! Double) > (self.topGainStocks[$1]!["changePercent"] as! Double)}
                self.topgainTable.reloadData()
        }
        
        let losersEndpoint: String = "https://sandbox.iexapis.com/stable/stock/market/list/losers?token=Tsk_3caeac734b61409eb766566cd5c71159"
        Alamofire.request(losersEndpoint)
            .responseJSON { response in
                guard let json = response.result.value as? [[String: Any]] else {
                    return
                }
                for stock in json{
                    let stockSymbol = stock["symbol"] as! String
                    self.topLoseStocks[stockSymbol] = stock
                }
                
                self.orderedLoseStocks = self.topLoseStocks.keys.sorted{(self.topLoseStocks[$0]!["changePercent"] as! Double) < (self.topLoseStocks[$1]!["changePercent"] as! Double)}
                self.toplossTable.reloadData()
        }
        
        let increaseIcon: UIImage = UIImage(named: "increase.png")!
        let decreaseIcon: UIImage = UIImage(named: "decrease.png")!
        self.gainimage.image = increaseIcon
        self.lossimage.image = decreaseIcon
        
        self.topgainTable.layer.cornerRadius = 14
        self.topgainTable.layer.masksToBounds = true
        self.topgainTable.layer.borderColor = UIColor( red: 250/255, green: 250/255, blue:250/255, alpha: 1.0 ).cgColor
        self.topgainTable.layer.borderWidth = 2.0
        
        self.toplossTable.layer.cornerRadius = 14
        self.toplossTable.layer.masksToBounds = true
        self.toplossTable.layer.borderColor = UIColor( red: 250/255, green: 250/255, blue:250/255, alpha: 1.0 ).cgColor
        self.toplossTable.layer.borderWidth = 2.0
    }
    
    @IBAction func searchbuttonPressed(_ sender: Any) {
        self.toplossTable.alpha = 0.0
        self.topgainTable.alpha = 0.0
        self.mytableView.alpha = 1.0
        self.mysearchBar.alpha = 1.0
        self.navigationBar.titleView = self.mysearchBar
        self.navigationBar.leftBarButtonItem = self.cancelbutton
    }
    
    func setup() {
        
        
        var timer: Timer?
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            (_) in
            let daf = DateFormatter()
            daf.dateFormat = "EEEE, MMM d, yyyy"
            daf.locale = Locale(identifier:  "zh-Hant")
            let timing = daf.string(from: Date())
            
            let df = DateFormatter()
            df.dateFormat = "HH:mm:ss a"
            df.locale = Locale(identifier: "zh-Hant")
            let relative = df.string(from: Date())
            
            let state = "目前為交易時段"
            
            let clock = "\(state)\(Theme.separator)\(relative)"
            let string = "\(timing)"
            
            self.showDate.text = clock
            self.showTime.text = string
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar.leftBarButtonItem = nil
        self.navigationBar.titleView = nil
        self.mytableView.alpha = 0.0
        self.mysearchBar.alpha = 0.0
        self.toplossTable.alpha = 1.0
        self.topgainTable.alpha = 1.0
        self.toplossTable.reloadData()
        self.topgainTable.reloadData()
        self.mysearchBar.text = ""
        self.searching = false
        self.filteredStockList = []
        
        self.setup()
        self.showDate.reloadInputViews()
        
        DispatchQueue.main.async{
            self.mytableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CancelSearchButtonClicked(_ sender: Any) {
        self.mysearchBar.alpha = 0.0
        self.mytableView.alpha = 0.0
        self.toplossTable.alpha = 1.0
        self.topgainTable.alpha = 1.0
        self.navigationBar.titleView = nil
        self.navigationBar.leftBarButtonItem = nil
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredStockList = self.stockList.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.searching = true
        if searchText == ""{
            self.searching = false
        }
        mytableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.mytableView{
            if self.searching{
                return self.filteredStockList.count
            }else{
                return 0
            }
        }else if tableView == self.topgainTable{
            return self.orderedGainStocks.count
        }else if tableView == self.toplossTable{
            return self.orderedLoseStocks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.mytableView{
            return 55
        }else{
            return 44
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.mytableView{
            if searching{
                self.selectedStock = self.filteredStockList[indexPath.row]
            }
        }else if tableView == self.topgainTable{
            self.selectedStock = self.orderedGainStocks[indexPath.row]
        }else{
            self.selectedStock = self.orderedLoseStocks[indexPath.row]
        }
        performSegue(withIdentifier: "showStock", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.mytableView{
            if let stockCell = mytableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as? stockTableViewCell {
                var stockSymbol = ""
                if searching{
                    stockSymbol = self.filteredStockList[indexPath.row]
                }else{
                    stockSymbol = self.stockList[indexPath.row]
                }
                stockCell.StockSymbolLabel.text = stockSymbol
            
                let todoEndpoint: String = "https://cloud.iexapis.com/stable/stock/" + stockSymbol + "/quote?token=pk_ec0e74efcc1d4a62a7a13114d6af7c95"
                Alamofire.request(todoEndpoint).responseJSON { response in
                    guard let json = response.result.value as? [String: Any] else {
                        return
                    }
                    guard let companyName = json["companyName"] as? String else{
                        self.stockList.remove(at: indexPath.row)
                        return
                    }
                    if companyName == "" {
                        self.stockList.remove(at: indexPath.row)
                        return
                    }
                    guard let ch = json["changePercent"] as? Double else{
                        self.stockList.remove(at: indexPath.row)
                        return
                    }
                    stockCell.StockNameLabel.text = companyName
                    stockCell.StockPercentLabel.text = percentFormat(value: ch*100)
                    if ch < 0 {
                        stockCell.StockPercentLabel.textColor = UIColor( red: CGFloat(254/255.0), green: CGFloat(23/255.0), blue: CGFloat(7/255.0), alpha: CGFloat(1.0) )
                    }else{
                        stockCell.StockPercentLabel.textColor = UIColor( red: CGFloat(50/255.0), green: CGFloat(255/255.0), blue: CGFloat(50/255.0), alpha: CGFloat(1.0) )
                    }
                }
                return stockCell
            }
        }else if tableView == self.topgainTable{
            if let stockCell = topgainTable.dequeueReusableCell(withIdentifier: "topGainCell", for: indexPath) as? stockExploreCell {
                let symbol = self.orderedGainStocks[indexPath.row]
                stockCell.StockSymbolLabel.text = symbol
                
                let stockData = self.topGainStocks[symbol] as! [String:Any]
                stockCell.PriceLabel.text = currencyFormat(value: stockData["latestPrice"] as! Double)
                stockCell.ChangeLabel.text = percentFormat(value: (stockData["changePercent"] as! Double)*100.0)
                stockCell.ChangeLabel.textColor = UIColor( red: CGFloat(50/255.0), green: CGFloat(255/255.0), blue: CGFloat(50/255.0), alpha: CGFloat(1.0) )
                
                return stockCell
            }
        }else if tableView == self.toplossTable{
            if let stockCell = toplossTable.dequeueReusableCell(withIdentifier: "topLossCell", for: indexPath) as? stockExploreCell {
                let symbol = self.orderedLoseStocks[indexPath.row]
                stockCell.StockSymbolLabel.text = symbol
                
                let stockData = self.topLoseStocks[symbol] as! [String:Any]
                stockCell.PriceLabel.text = currencyFormat(value: stockData["latestPrice"] as! Double)
                stockCell.ChangeLabel.text = percentFormat(value: (stockData["changePercent"] as! Double)*100.0)
                stockCell.ChangeLabel.textColor = UIColor( red: CGFloat(254/255.0), green: CGFloat(23/255.0), blue: CGFloat(7/255.0), alpha: CGFloat(1.0) )
                
                return stockCell
            }
        }
        return UITableViewCell()
    }
    
    func getStockArray(){
            Alamofire.request(self.todoEndpoint)
                .responseJSON { response in
                    guard let json = response.result.value as? [[String:Any]] else {
                        return
                    }
                    for dict in json{
                        let symbol = dict["symbol"] as? String ?? ""
                        
    //                    self.getStockData(symbol: symbol)
                        self.stockList.append(symbol)
                    }
                    DispatchQueue.main.async{
                        self.mytableView.reloadData()
                    }
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? marketView {
            dest.symbol = self.selectedStock
            dest.currentUser = self.currentUser
        }
    }
}
