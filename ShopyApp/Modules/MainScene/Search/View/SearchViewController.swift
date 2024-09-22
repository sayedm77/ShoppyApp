//
//  SearchViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 11/09/2024.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var resultTable: UITableView!
//    var data = [Product]()
//    var filteredData : [Product]
    var viewModel = SearchViewModel()
    var indicator : UIActivityIndicatorView?
    var searchWord : String = ""
    var searching : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        searchBar.delegate = self
        resultTable.delegate = self
        resultTable.dataSource = self
        setUpIndicator()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        resultTable.reloadData()

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWord = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        print("Search text: \(searchWord)")
        searchingResult()
    }
    
    
  
    func searchingResult(){
        if searching == false{
            viewModel.filteredItems = viewModel.results?.products
        }else{
            if searchWord.isEmpty{
                viewModel.filteredItems = viewModel.results?.products
            }else{
                viewModel.filteredItems = viewModel.results?.products.filter { $0.title.lowercased().contains(searchWord.lowercased()) }
            }
        }
        
        //checkIfNoItems()
        resultTable.reloadData()
    }
//    func checkIfNoItems(){
//        if (viewModel.filteredItems?.count  == 0) {
//            resultTable.setEmptyMessage("No Items Found")
//        } else {
//            resultTable.restor()
//        }
//    }
    
    func setUpIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .black
        indicator?.center = self.resultTable.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
    
    
    func loadData(){
        viewModel.loadData()
        viewModel.bindResultToViewcontoller = { [weak self] in
          
                DispatchQueue.main.async {
                    self?.displayData()
                    self?.viewModel.filteredItems = self?.viewModel.results?.products
                    self?.resultTable.reloadData()
                }
            }

    }
    
    func displayData(){
        indicator?.stopAnimating()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTable.dequeueReusableCell(withIdentifier: "cell",  for: indexPath) as UITableViewCell
        cell.textLabel?.text = viewModel.filteredItems?[indexPath.row].title.split(separator: "|").dropFirst().first.map(String.init)
        cell.detailTextLabel?.text = viewModel.filteredItems?[indexPath.row].vendor
        let url = URL(string:viewModel.filteredItems?[indexPath.row].image.src ?? "")
        cell.imageView?.kf.setImage(with: url,placeholder: UIImage(named: "placeHolder"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "ProductInfo", bundle: nil)
        let productInfovc = storyboard.instantiateViewController(withIdentifier: "prodInfo") as! ProductInfoViewController
       
        productInfovc.productId = viewModel.filteredItems?[indexPath.row].id
       print(productInfovc.productId ?? 0)
        self.present(productInfovc, animated: true)
    }

}
