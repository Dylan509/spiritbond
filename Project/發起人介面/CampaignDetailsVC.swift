//
//  CampaignDetailsVC.swift
//  spiritbond
//
//  Created by lim jia le on 2020/11/15.
//

import UIKit


class CampaignDetailsVC: UIViewController {
    var campaign: Campaign!
    var isPresentedModally: Bool = false
    
    enum Section: Int {
        case galery
        case campaignDetails
        case authorDetails
        
        var numberOfRows: Int {
            switch self {
            case .campaignDetails:
                return 2
            default:
                return 1
            }
        }
        
        static var count: Int {
            return (Section.authorDetails.rawValue + 1)
        }
    }

    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isPresentedModally {
            setupNavigationBarForModal()
        } else {
            title = "Campaign Details"
        }
        
        setupTableView()
    }
    
    func setupNavigationBarForModal() {
        let barButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(tapDone))
        navigationItem.rightBarButtonItems = [barButton]
    }
    
    @objc func tapDone() {
        presentDashboard()
    }
    
    func presentDashboard() {
        let navigator = CampaignListNavigationFactory()
        let nextVC = navigator.createDashboard()
        
        UIApplication.shared.keyWindow?.rootViewController = nextVC
    }

    func setupTableView() {
        tableview.dataSource = self
        tableview.delegate = self
        GalleryCell.registerNibToTableView(tableView: tableView)
        CampaignDescriptionCell.registerNibToTableView(tableView: tableView)
        AuthorDetailsCell.registerNibToTableView(tableView: tableView)
        CampaignDetailedCell.registerNibToTableView(tableView: tableView)
    }
    
    @IBAction func tapdonate(_ sender: Any) {
        
    }
}

extension CampaignDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Section.galery.rawValue {
            return 250
        }
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { fatalError("Unexpected Section") }
        return section.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Unexpected Section") }
        let cell: BaseTableViewCell
        
        switch section {
        case .galery:
            cell = tableView.dequeueReusableCell(withIdentifier: GalleryCell.cellReuseIdentifier(), for: indexPath) as! GalleryCell
            cell.setupWithVM(vm: GaleryVM(campaign: campaign))
            
        case .campaignDetails:
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: CampaignDetailedCell.cellReuseIdentifier(), for: indexPath) as! CampaignDetailedCell
                cell.setupWithVM(vm: CampaignDetailsVM(campaign: campaign))
                
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: CampaignDescriptionCell.cellReuseIdentifier(), for: indexPath) as! CampaignDescriptionCell
                cell.setupWithVM(vm: CampaignDetailsVM(campaign: campaign))
            }
        case .authorDetails:
            cell = tableView.dequeueReusableCell(withIdentifier: AuthorDetailsCell.cellReuseIdentifier(), for: indexPath) as! AuthorDetailsCell
            (cell as! AuthorDetailsCell).delegate = self
            cell.setupWithVM(vm: AuthorDetailsVM(campaign: campaign))
        }
        return cell
    }
}

extension CampaignDetailsVC: AuthorDetailsDelegate {
    func didTapSocial(withLink link: URL) {
        if UIApplication.shared.canOpenURL(link) {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
}

