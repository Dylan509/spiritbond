//
//  MyUINavigationController.swift
//  spiritbond
//
//  Created by 茂木匠 on 2020/11/3.
//

import UIKit

class MyUINavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = #colorLiteral(red: 0.03215095773, green: 0.4376096725, blue: 1, alpha: 1) // その他UIColor.white等好きな背景色
               // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
               navigationBar.tintColor = .white
               // ナビゲーションバーのテキストを変更する
               navigationBar.titleTextAttributes = [
                   // 文字の色
                   .foregroundColor: UIColor.white
               ]

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

}
