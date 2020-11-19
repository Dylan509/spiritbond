//
//  DetailViewController.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import UIKit
import HITChartSwift

class DetailViewController: UIViewController {

    var item: Item? {
        didSet {
            title = item?.symbol
            fetchData(item?.symbol)
        }
    }

    var provider: Provider?
    
    private var dataSource: [DetailSection] = []

    private let tableview = UITableView(frame: .zero, style: .insetGrouped)

    private let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

}

private extension DetailViewController {

    @objc
    func close() {
        self.dismiss(animated: true, completion: nil)
    }

    func fetchData(_ symbol: String?) {

        spinner.startAnimating()

        let priceItems = item?.items

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

            var s = sections
            let priceSection = DetailSection(items: priceItems)
            let index = s.count > 1 ? 1 : 0
            s.insert(priceSection, at: index)

            self.dataSource = s
            self.tableview.reloadData()
        })

    }

    func setup() {
        view.backgroundColor = .systemBackground

        let button = Theme.closeButton
        button.target = self
        button.action = #selector(close)
        navigationItem.rightBarButtonItem = button

        tableview.dataSource = self
        tableview.delegate = self
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

extension DetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = dataSource[indexPath.section]

        guard
            let item = section.items?[indexPath.row],
            item.url != nil else { return false }

        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)

        let section = dataSource[indexPath.section]
        if
            let item = section.items?[indexPath.row],
            let url = item.url {
                UIApplication.shared.open(url)
        }
    }

}

extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let s = dataSource[section]

        return s.header
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let s = dataSource[section]
        return s.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "detail")

        let section = dataSource[indexPath.section]
        if let item = section.items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.textColor = .secondaryLabel
            cell.detailTextLabel?.numberOfLines = 0
            
            if item.title == "歷史價格表與K線" {
                cell.accessoryType = UITableViewCell.AccessoryType.detailButton
            }else{
                cell.accessoryType = item.url == nil ? .none : .disclosureIndicator
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //navigateTo your viewController
        
        let d = graphView()
        d.provider = provider
        d.item = item
        d.modalPresentationStyle = .formSheet
        let n = UINavigationController(rootViewController: d)
        n.navigationBar.prefersLargeTitles = true
        n.navigationBar.largeTitleTextAttributes = Theme.attributes
        present(n, animated: false, completion: nil)
        
    }
    
    @objc
    func addStock() {
        let s = AddStockViewController()
        s.modalPresentationStyle = .formSheet
        s.provider = provider

        let n = UINavigationController(rootViewController: s)
        n.navigationBar.prefersLargeTitles = true
        n.navigationBar.largeTitleTextAttributes = Theme.attributes

        present(n, animated: true, completion: nil)
    }

}

struct DetailSection {

    var header: String?
    var items: [DetailItem]?

}

struct DetailItem {

    var subtitle: String?
    var title: String?
    var graph: UITableViewCell?
    var url: URL?
}

private extension Item {


    var items: [DetailItem] {
        var items: [DetailItem] = []
        
        items.append(
            DetailItem(subtitle: "價格", title: quote?.price.currency)
        )

        items.append(
            DetailItem(subtitle: "價格變化", title: quote?.change.displaySign)
        )

        items.append(
            DetailItem(subtitle: "百分比變化", title: quote?.percent.displaySign)
        )

        return items
    }
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(100.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
