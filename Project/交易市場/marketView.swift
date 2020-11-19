//
//  marketView.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/27.
//

import UIKit
import Alamofire

class marketView: UIViewController {
    
    @IBOutlet var DataStackView: UIStackView!
    
    var currentUser: CurrentUser? = nil
    
    var tabChosen: Int = 0
    var symbol: String = ""
    var companyName: String = ""
    var stockPrice: Double = 0.0
    var close: Double = 0.0
    var data: [String: Any] = [:]
    
    @IBOutlet var companyNameLabel: UILabel!
    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var ChangeLabel: UILabel!
    
    @IBOutlet var OpenLabel: UILabel!
    @IBOutlet var CloseLabel: UILabel!
    @IBOutlet var VolumeLabel: UILabel!
    @IBOutlet var HighLabel: UILabel!
    @IBOutlet var LowLabel: UILabel!
    @IBOutlet var ChangedLabel: UILabel!
    @IBOutlet var ChangedPercentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DataStackView.alpha = 1

        let todoEndpoint: String = "https://cloud.iexapis.com/stable/stock/" + self.symbol + "/quote?token=pk_ec0e74efcc1d4a62a7a13114d6af7c95"
        Alamofire.request(todoEndpoint).responseJSON {response in guard let json = response.result.value as? [String: Any] else {
                print(todoEndpoint)
                self.companyNameLabel.text = "無法連結api"
                return
            }
            self.data["companyName"] = json["companyName"] as? String ?? ""
            self.data["open"] = json["open"] as? Double ?? 0.0
            self.data["close"] = json["close"] as? Double ?? 0.0
            self.data["high"] = json["high"] as? Double ?? 0.0
            self.data["low"] = json["low"] as? Double ?? 0.0
            self.data["LatestPrice"] = json["latestPrice"] as? Double ?? 0.0
            self.data["latestVolume"] = json["latestVolume"] as? Double ?? 0.0
            self.data["change"] = json["change"] as? Double ?? 0.0
            self.data["changePercent"] = json["changePercent"] as? Double ?? 0.0000
            
            self.CloseLabel.text = currencyFormat(value: self.data["close"] as! Double)
            self.OpenLabel.text = currencyFormat(value: self.data["open"] as! Double)
            self.LowLabel.text = currencyFormat(value: self.data["low"] as! Double)
            self.VolumeLabel.text = formatNumber(self.data["latestVolume"] as! Double)
            self.HighLabel.text = currencyFormat(value: self.data["high"] as! Double)
            self.ChangedLabel.text = String(self.data["change"] as! Double)
            self.ChangedPercentLabel.text = String(self.data["changePercent"] as! Double)
            
            self.symbolLabel.text = self.symbol
            self.companyNameLabel.text = self.data["companyName"] as? String
            self.companyName = (self.data["companyName"] as? String)!
            self.priceLabel.text = String(self.data["LatestPrice"] as! Double)
            self.stockPrice = self.data["LatestPrice"] as! Double
            let change = self.data["changePercent"] as! Double
            if change*100 < 0.0 {
                self.ChangeLabel.text = percentFormat(value: change*100)
                self.ChangeLabel.textColor = UIColor( red: CGFloat(254/255.0), green: CGFloat(23/255.0), blue: CGFloat(7/255.0), alpha: CGFloat(1.0) )
            }else if change*100 > 0.0 {
                self.ChangeLabel.text = percentFormat(value: change*100)
                self.ChangeLabel.textColor = UIColor( red: CGFloat(50/255.0), green: CGFloat(250/255.0), blue: CGFloat(50/255.0), alpha: CGFloat(1.0) )
            }
        }
    }
    
    @IBAction func unwindToStockView(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "buyStock" || segue.identifier == "sellStock"{
            if let dest = segue.destination as? buyViewController {
                dest.currentUser = self.currentUser
                dest.stockPrice = self.stockPrice
                dest.stockName = self.companyName
                dest.stockSymbol = self.symbol
                
                if segue.identifier == "buyStock"{
                    dest.type = 0
                }else{
                    dest.type = 1
                }
            }
        }
    }
}
