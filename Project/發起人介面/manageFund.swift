//
//  manageFund.swift
//  spiritbond
//
//  Created by lim jia le on 2020/11/16.
//

import UIKit
import Firebase

class manageFund: UIViewController {
    
    var detailData2: UserInfo?
    
    @IBOutlet var showtime: UILabel!
    @IBOutlet var showword: UILabel!
    @IBOutlet var fundTitle: UILabel!
    @IBOutlet var fundBalance: UILabel!
    @IBOutlet var fundStock: UILabel!
    @IBOutlet var fundratio: UILabel!
    @IBOutlet var raiseFundamount : UILabel!
    @IBOutlet var raisePeople: UILabel!
    @IBOutlet var raiseRatio: UILabel!
    @IBOutlet var ratioGain: UIImageView!
    var picktime = Date()
    var timersche: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        timesche(repeats: true, runtime: 1)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/yyyy"
        let startdate = dateformatter.date(from: (detailData2?.deadlineDate)!)
        picktime = startdate!
        let  balance = currencyFormat(value: Double((detailData2?.amount)!))
        fundTitle.text = detailData2?.title ?? ""
        fundBalance.text = balance
        raiseFundamount.text =  currencyFormat(value: Double(detailData2?.amount as! Int))
        raiseRatio.text = percentFormat(value: (detailData2?.rateReturn)!)
        
        let increaseIcon: UIImage = UIImage(named: "increase.png")!
        let decreaseIcon: UIImage = UIImage(named: "decrease.png")!
        
  /*      if moneyChange < 0.0{
            self.ratioGain.image = decreaseIcon
        }else{
            self.ratioGain.image = increaseIcon
        }*/
    }
    
    func setup() {
        
        
        
        var timer: Timer?
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
            (_) in
            let df = DateFormatter()
            df.dateFormat = "HH:mm:ss a"
            df.locale = Locale(identifier: "zh-Hant")
            let relative = df.string(from: Date())
            
            let state = "距離專案結束還有"
            
            let string = "\(relative)"
            
            self.showword.text = state
          //  self.showtime.text = string
        }
    }
    
    func timesche(repeats: Bool, runtime: TimeInterval) {
        
        timersche = Timer.scheduledTimer(withTimeInterval: runtime, repeats: repeats, block: { (_) in
            
            let nowTime = Date()
            
            let doomsTime = self.picktime
            
            let interval = doomsTime.timeIntervalSince(nowTime)
            
            let secInt = Int(interval)%60
            let minsInt = Int(interval/60)%60
            let houtInt = Int(interval/3600)%24
            let dayInt = Int(interval/86400)
            
            self.showtime.text = "\(dayInt)天 \(houtInt)時 \(minsInt)分 \(secInt)秒"
        })
    }
}
 
