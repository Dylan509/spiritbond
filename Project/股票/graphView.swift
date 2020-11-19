//
//  graphView.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit
import HITChartSwift
import Charts

class graphView: UIViewController {
    
    var item: Item? {
        didSet {
            title = item?.symbol
        }
    }
    
    var provider: Provider?
    private let spinner = UIActivityIndicatorView(style: .large)
    private let tableview = UITableView(frame: .zero, style: .insetGrouped)
    var stock1w = [stock]()
    var absMaxPercentage = 0
    var dates = [Date]()
    var titles = [String]()
    func tapWeek(){
        
        let urlString1w = "https://cloud.iexapis.com/stable/stock/\(item?.symbol ?? "TSLA")/chart/5d?token=pk_8b225a62e6fb444488613e086a8ef9ef"
            
        let url1w = URL(string: urlString1w)
            
        guard url1w != nil else{
            return
        }
            
        let session1w = URLSession.shared
            
        let dataTask1w = session1w.dataTask(with: url1w!) { (data, response, error) in
                
            if error == nil && data != nil {
                    

                let decoder = JSONDecoder()
                    
                do {
                     
                    let Stock = try decoder.decode([stock].self, from: data!)
                    DispatchQueue.main.async{
                        self.stock1w = Stock
                        self.drawChart()
                        self.tapCandlestickChartLandscape()
                    }
                    
                }
                catch {
                        
                    print("error in json parsing \(error.localizedDescription)")
                }
            }
        }
        dataTask1w.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        tapWeek()
    }
    
    
}

private extension graphView {

    @objc
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func drawChart() {
        let maxChange = abs(stock1w.map{ ($0.change ) }.max() ?? 0.0).rounded(.up)
        let minChange = abs(stock1w.map{ ($0.change ) }.min() ?? 0.0).rounded(.up)
        absMaxPercentage = Int(maxChange > minChange ? maxChange : minChange)

        /// date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+9:00")
        dates = stock1w.map { return dateFormatter.date(from: $0.date) ?? Date() }
        titles = stock1w.map { "  \(item?.symbol ?? "TSLA"): \($0.close)   百分比變化: \($0.change.roundTo(places: 2))%" }
        let chart = HITLineChartView(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.width, height: tableview.bounds.height/3))
        tableview.addSubview(chart)
        let max = String((stock1w.map{ $0.close }.max() ?? 0.0).rounded(.up))
        let min = String((stock1w.map{ $0.close }.min() ?? 0.0).rounded(.down))
        chart.draw(absMaxPercentage,
                   values: stock1w.map{ $0.change},
                   label: (max: max, center: "", min: min),
                   dates: dates,
                   titles: titles)
        
    }
    
    func tapCandlestickChartLandscape() {
        let chart = HITCandlestickChartView(frame: CGRect(x: 0, y: tableview.bounds.height*1/3+50, width: UIScreen.main.bounds.width, height: tableview.bounds.height/3))
        tableview.addSubview(chart)
        chart.draw(absMaxPercentage,
                   values: stock1w.map{ (close: $0.close, open: $0.open, high: $0.high, low: $0.low) },
                   label: (max: "+\(absMaxPercentage)%", center: "", min: "-\(absMaxPercentage)%"),
                   dates: dates,
                   titles: ["K線"])
    }
    
    func fetchData(_ symbol: String?) {

        spinner.startAnimating()

        //let priceItems = item?.items

        provider?.getDetail(symbol, completion: { (sections, image) in
            self.spinner.stopAnimating()

            if let image = image {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                imageView.image = image

                var frame = self.view.bounds
                frame.size = image.size
                imageView.frame = frame

                self.tableview.tableHeaderView = imageView
            }


            self.tableview.reloadData()
        })

    }
    private func addCloseEvent(_ chart: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeChart(_:)))
        chart.addGestureRecognizer(tapGesture)
    }
    
    @objc func closeChart(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        view.removeFromSuperview()
    }
    func setup() {
        view.backgroundColor =  .white

        let button = Theme.closeButton
        button.target = self
        button.action = #selector(close)
        navigationItem.rightBarButtonItem = button

       
        tableview.frame = view.bounds
        tableview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableview)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

}
