//
//  buyViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/27.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class buyViewController: UIViewController {
    @IBOutlet var CompanynameLabel: UILabel!
    @IBOutlet var SlidingSharesLabel: UILabel!
    @IBOutlet var PriceLabel: UILabel!
    @IBOutlet var SharesLabel: UILabel!
    @IBOutlet var TotalLabel: UILabel!
    @IBOutlet var SliderObject: UISlider!
    
    let dbRef = Database.database().reference()
    var type = 0
    var stockName = ""
    var stockSymbol = ""
    var stockPrice = 0.0
    var balance = 0.0
    var shares = 0
    
    var currentUser: CurrentUser? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
  /*      let id = (Auth.auth().currentUser?.uid as String?)!
        dbRef.child("Users").child(id).observeSingleEvent(of: .value, with: { snapshot in guard let value = snapshot.value as? [Double: Any] else{
            return
        }
        print("value: \(value)")
        })*/
        self.CompanynameLabel.text = self.stockName
        self.SliderObject.maximumValue = 0
        
        if self.type == 0{
            self.title = "買" + self.stockSymbol
            self.balance = (self.currentUser?.balance)!
            
            self.SliderObject.maximumValue = Float(Double(floor((self.balance-10)/self.stockPrice)))
            
        }else{
            self.title = "賣" + self.stockSymbol
            if (self.currentUser?.owns(symbol: self.stockSymbol))!{
                self.shares = self.currentUser?.stocks[self.stockSymbol]!["shares"] as! Int
                self.SliderObject.maximumValue = Float(self.shares)
            }
        }
        
        self.PriceLabel.text = currencyFormat(value: self.stockPrice)
        self.TotalLabel.text = currencyFormat(value: 0.0)
        self.SlidingSharesLabel.text = "0 股"
        self.SharesLabel.text = "0"
        
        self.SliderObject.value = 0
        self.SliderObject.minimumValue = 0
        
 /*       self.dbRef.child("Users").child("\(String(describing: Auth.auth().currentUser?.uid))").child("balance").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! Double
            self.balance = value
            self.sliderObject.maximumValue = Float(Int(floor((value-10)/self.stockPrice)))
        }){ (error) in
            print(error.localizedDescription)
        }
*/
    }
    
    @IBAction func SliderValueChanged(_ sender: Any) {
        let roundedVal = Int(SliderObject.value)
        SliderObject.value = Float(roundedVal)
        self.SlidingSharesLabel.text = String(roundedVal) + " 股"
        self.SharesLabel.text = String(roundedVal)
        self.TotalLabel.text =  currencyFormat(value:(Double(roundedVal) * self.stockPrice)+10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OrderButtonPressed(_ sender: Any){
        if self.type == 0 && self.balance>0{
            self.currentUser?.buyStock(symbol: self.stockSymbol, shares: Int(self.SliderObject.value), price: self.stockPrice)
        }else if self.type == 1 && self.shares > 0 {
            self.currentUser?.sellStock(symbol: self.stockSymbol, shares: Int(self.SliderObject.value), price: self.stockPrice)
        }
        
        var action = ""
        if self.type == 0{
            action = "買進"
        }else{
            action = "賣出"
        }
        let alertController = UIAlertController(title: "完成下單", message: "你已" + action + " " + String(self.SliderObject.value) + "股 " + self.stockName + " 價值 " + currencyFormat(value: self.stockPrice) + "每一股." , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: {_ in self.performSegue(withIdentifier: "unwindToStockView", sender: self)})
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
