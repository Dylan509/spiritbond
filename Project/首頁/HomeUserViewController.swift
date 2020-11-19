//
//  HomeUserViewController.swift
//  SpiritBond
//
//  Created by Fung Ying Hei on 9/9/2020.
//  Copyright © 2020 茂木匠. All rights reserved.
//

import UIKit
import Firebase

class HomeUserViewController: UIViewController {
    
    var userData = [UserInfo]()
    let db = Firestore.firestore()
    var currentUser: CurrentUser? = nil
    
    @IBOutlet weak var iconbutton: UIButton!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var totallabel: UILabel!
    @IBOutlet weak var ranklabel: UILabel!
    @IBOutlet var containerViews: [UIView]!
    @IBOutlet weak var segmented: UISegmentedControl!

    @IBAction func actionSegmentedControl(_ sender:UISegmentedControl) {
        switch segmented.selectedSegmentIndex {
            case 0:
                containerViews[0].isHidden = false
                containerViews[1].isHidden = true
                containerViews[2].isHidden = true
                containerViews[3].isHidden = true
               
            case 1:
                containerViews[0].isHidden = true
                containerViews[1].isHidden = false
                containerViews[2].isHidden = true
                containerViews[3].isHidden = true
                
            case 2:
                containerViews[0].isHidden = true
                containerViews[1].isHidden = true
                containerViews[2].isHidden = false
                containerViews[3].isHidden = true
                
            case 3:
                containerViews[0].isHidden = true
                containerViews[1].isHidden = true
                containerViews[2].isHidden = true
                containerViews[3].isHidden = false
            default:
                print("erro")
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser?.getStockData{ success in
            guard success else { return }
            let currentWorth: Double = (self.currentUser?.currentWorth())!
            let buyingPower: Double = (self.currentUser?.balance)!
            let portfolioValue: Double = (self.currentUser?.portfolioValue())!
            
            let initialWorth: Double = 100000.0
            let overallChange: Double = currentWorth - initialWorth
            let overallChangePercent: Double = getPercentage(value: initialWorth, change: overallChange)
            
            let name: String = (self.currentUser?.name)!
            let raisemoney = self.currentUser!.temp2 / 3
            let investmoney = self.currentUser!.temp / 3
            let total = Int(currentWorth) + raisemoney - investmoney
            
            self.namelabel.text = "嗨, " + name + "!"
            self.totallabel.text = "總資產: " + currencyFormat(value: Double(total))
            self.ranklabel.text = "等級: 菜鳥"
            
        }
        
        containerViews[0].isHidden = false
        containerViews[1].isHidden = true
        containerViews[2].isHidden = true
        containerViews[3].isHidden = true
        
        loadUserData()
            
    }
    func loadUserData(){
        let userId = (Auth.auth().currentUser?.email)!
       
        let ref =
            db.collection("users").document(userId).collection("detail").getDocuments {
                (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                   for document in querySnapshot.documents {
                    let data = document.data()
                    
                   }
                }
             }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? HomeUserStockViewController {
            //dest.symbol = self.selectedStock
            dest.currentUser = self.currentUser
        }
        if let dest = segue.destination as? HomeUserChartViewController {
            //dest.symbol = self.selectedStock
            dest.currentUser = self.currentUser
        }
    }
}
