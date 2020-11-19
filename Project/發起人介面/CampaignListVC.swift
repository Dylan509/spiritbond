//
//  CampaignListVC.swift
//  spiritbond
//
//  Created by lim jia le on 2020/11/15.
//

import UIKit

class CampaignListVC: UIViewController {
    @IBOutlet var tableview: UITableView!
    var campaigns = [Campaign]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let authService = AuthService()
        authService.authorizate(success: {
            self.getCampaigns()
            self.setupTableView()
        }) {
            self.setupNoData()
        }
    }
    
    func setupNoData() {
        
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 185
        CampaignListCell.registerNibToTableView(tableView: tableView)
    }
    
    func getCampaigns() {
        let campaignService = CampaignService()
        campaignService.getCampaigns(success: { (campaignsList) in
            self.campaigns = campaignsList
            self.tableView.reloadData()
            
        }) {
            //fail
        }
    }

}

extension CampaignListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return campaigns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CampaignListCell.cellReuseIdentifier(), for: indexPath) as! CampaignListCell
        let campaign = campaigns[indexPath.row]
        
        cell.setupWithVM(vm: CampaignDetailsVM(campaign: campaign))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let campaign = campaigns[indexPath.row]
        let navigator = CampaignListNavigationFactory()
        let nextVC = navigator.createCampaignDetails(campaign: campaign)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

protocol CampaignListNavigation {
    func createCampaignDetails(campaign: Campaign) -> CampaignDetailsVC
}

