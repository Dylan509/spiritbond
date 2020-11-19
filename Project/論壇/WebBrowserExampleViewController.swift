

import UIKit
import WebBrowser
import FirebaseAuth
import Firebase
import FirebaseDatabase

var db: Firestore!
private let kTBBlueColor = UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)
private let kWebBrowserExampleCellID = "WebBrowserExampleCell"
private var urlStrings: [String] = []
private var newsTitles: [String] = []
private var count: [String] = []
private var date: [String] = []
private var newsIndex:[Int] = []
private var type:[String] = []

private var urlStrings_popular: [String] = []
private var newsTitles_popular: [String] = []
private var count_popular: [String] = []
private var date_popular: [String] = []
private var newsIndex_popular:[Int] = []
private var type_popular:[String] = []

private var urlStrings_new: [String] = []
private var newsTitles_new: [String] = []
private var count_new: [String] = []
private var date_new: [String] = []
private var newsIndex_new:[Int] = []
private var type_new:[String] = []

class WebBrowserExampleViewController: UITableViewController,UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredData_url:[String]!
    var filteredData_title:[String]!
    var filteredData_count:[String]!
    var filteredData_date:[String]!
    var filteredData_type:[String]!
    @IBOutlet weak var typeOfNewsButton: UIBarButtonItem!
    var switch_flg:Bool = false
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupUI()
        //loadNews()
        
       

    }
    func loadNews() {
        if urlStrings_popular.isEmpty {}
        else{
            urlStrings_popular.removeAll()
            newsTitles_popular.removeAll()
            count_popular.removeAll()
            date_popular.removeAll()
            newsIndex_popular.removeAll()
            type_popular.removeAll()
        }
        if urlStrings_new.isEmpty {}
        else{
            urlStrings_new.removeAll()
            newsTitles_new.removeAll()
            count_new.removeAll()
            date_new.removeAll()
            newsIndex_new.removeAll()
            type_new.removeAll()
        }
        
        var a = ""
        var b = ""
        var c = ""
        var d = ""
        var e =  0
        var f = ""
        db = Firestore.firestore()
        db.collection("popular_news").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    a = document.get("title") as! String
                    b = document.get("URL") as! String
                    c = document.get("count") as! String
                    d = document.get("date") as! String
                    e = document.get("index") as! Int
                    f = document.get("type") as! String
                    urlStrings_popular.append(b)
                    newsTitles_popular.append(a)
                    count_popular.append(c)
                    date_popular.append(d)
                    newsIndex_popular.append(e)
                    type_popular.append(f)
                }
            }
        }
        db.collection("new_news").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    a = document.get("title") as! String
                    b = document.get("URL") as! String
                    c = document.get("count") as! String
                    d = document.get("date") as! String
                    e = document.get("index") as! Int
                    f = document.get("type") as! String
                    urlStrings_new.append(b)
                    newsTitles_new.append(a)
                    count_new.append(c)
                    date_new.append(d)
                    newsIndex_new.append(e)
                    type_new.append(f)
                    
                }
            }
        }
        
    }
    func allCellDelete(){
        urlStrings.removeAll()
        newsTitles.removeAll()
        count.removeAll()
        date.removeAll()
        newsIndex.removeAll()
    }
    @IBAction func reFresh(_ sender: Any) {
        loadNews()
        urlStrings = urlStrings_new
        newsTitles =  newsTitles_new
        count = count_new
        date = date_new
        newsIndex =  newsIndex_new
        tableView.reloadData()
    }
    //testmail@gmail.comabcd*1234
    @IBAction func ChangeTableTapped(_ sender: Any) {
        if ( switch_flg ) {
                typeOfNewsButton.title = "最新"
                urlStrings = urlStrings_popular
                newsTitles =  newsTitles_popular
                count = count_popular
                date = date_popular
                newsIndex =  newsIndex_popular
                type = type_popular
                tableView.reloadData()
                switch_flg = false
            }
            else {
                typeOfNewsButton.title = "熱門"
                urlStrings = urlStrings_new
                newsTitles =  newsTitles_new
                count = count_new
                date = date_new
                newsIndex =  newsIndex_new
                type = type_new
                tableView.reloadData()
                switch_flg = true
            }
        
    }
    // MARK: - Helper
    fileprivate func setupUI() {
    
        navigationItem.title = "論壇"
        tableView.tableFooterView = UIView()
        tableView.tintColor = kTBBlueColor

        let backButton = UIBarButtonItem()
        backButton.title = " "
        navigationItem.backBarButtonItem = backButton
    }

    // MARK: - Table view data source and delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlStrings.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: kWebBrowserExampleCellID)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: kWebBrowserExampleCellID)
        }
        cell?.textLabel?.text =  "<" + count[indexPath.row] + "> " + newsTitles[indexPath.row]
        cell?.textLabel?.textColor = UIColor(white: 38 / 255, alpha: 1)
        cell?.detailTextLabel?.text = date[indexPath.row] + " " + type[indexPath.row]
        cell?.detailTextLabel?.textColor = kTBBlueColor
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = URL(string: urlStrings[indexPath.row]) {
            let webBrowserViewController = WebBrowserViewController()
            webBrowserViewController.delegate = self

            webBrowserViewController.onOpenExternalAppHandler = { [weak self] _ in
                guard let `self` = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
            
            webBrowserViewController.language = .simplifiedChinese
            webBrowserViewController.tintColor = kTBBlueColor
            webBrowserViewController.loadURL(url)
            navigationController?.pushViewController(webBrowserViewController, animated: true)
        }
    }
    //MARK: searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        urlStrings = []
        newsTitles =  []
        count = []
        date = []
        type = []
        
        if searchText == "" {
            if ( typeOfNewsButton.title == "最新" ) {
                urlStrings = urlStrings_popular
                newsTitles =  newsTitles_popular
                count = count_popular
                date = date_popular
                type = type_popular
            }
            else {
                urlStrings = urlStrings_new
                newsTitles =  newsTitles_new
                count = count_new
                date = date_new
                type = type_new
            }
        }
        else{
            if ( typeOfNewsButton.title == "最新" ) {
                for (index,title) in newsTitles_popular.enumerated(){
                    if title.contains(searchText){
                        newsTitles.append(title)
                        urlStrings.append(urlStrings_popular[index])
                        count.append(count_popular[index])
                        date.append(date_popular[index])
                        type.append(type_popular[index])
                    }
                }
            }
            else {
                for (index,title) in newsTitles_new.enumerated(){
                    if title.contains(searchText){
                        newsTitles.append(title)
                        urlStrings.append(urlStrings_new[index])
                        count.append(count_new[index])
                        date.append(date_new[index])
                        type.append(type_new[index])
                    }
                }
                
            }
            
        }
        self.tableView.reloadData()
        
    }
    
  
    
  
   
    
}

extension WebBrowserExampleViewController: WebBrowserDelegate {
    func webBrowser(_ webBrowser: WebBrowserViewController, didStartLoad url: URL?) {
        print("Start loading...")
    }

    func webBrowser(_ webBrowser: WebBrowserViewController, didFinishLoad url: URL?) {
        print("Finish loading!")
    }

    func webBrowser(_ webBrowser: WebBrowserViewController, didFailLoad url: URL?, withError error: Error) {
        print("Failed to load! \n error: \(error)")
    }

    func webBrowserWillDismiss(_ webBrowser: WebBrowserViewController) {

    }

    func webBrowserDidDismiss(_ webBrowser: WebBrowserViewController) {

    }
}
