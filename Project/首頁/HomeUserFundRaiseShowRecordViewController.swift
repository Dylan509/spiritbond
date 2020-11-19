//
//  HomeUserFundRaiseShowRecordViewController.swift
//  spiritbond
//
//  Created by Fung Ying Hei on 1/11/2020.
//

import UIKit
import Firebase

class HomeUserFundRaiseShowRecordViewController: UIViewController {
    @IBOutlet weak var imagePhoto: UIImageView!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var userInfo : UserInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = userInfo{
            let imageURL = data.imageURL
            let storageName = data.storageName!
            reportLabel.text = data.report
            dateLabel.text = data.dateUpload
            downloadPictue(storageName: storageName)

        }
        
        }
    
    func downloadPictue(storageName: String){
        
        let gsReference = Storage.storage().reference().child("Upload_photo").child(storageName) //你storage上的參考位置 com/後面就是你想找的圖片位置
        gsReference.getData(maxSize: 2 * 1024 * 1024) { (data, error) -> Void in //withmaxSize很重要 他會取圖的最大範圍 如果過小就會取不到圖片 但是太大就會減慢速度 大小要自己爭酌
            if (error != nil) {
                //錯誤發生執行
                print("========="+error.debugDescription)//印出錯誤原因
            } else {
                let islandImage: UIImage! = UIImage(data: data!) //成功取得照片
                self.imagePhoto.image = islandImage //設定照片到你的imageView上
            }
        }
    }
    
}
    

