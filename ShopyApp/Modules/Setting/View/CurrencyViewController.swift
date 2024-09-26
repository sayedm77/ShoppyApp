//
//  CurrencyViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 25/09/2024.
//

import UIKit

class CurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var selectedCurrency: UILabel!
    @IBOutlet weak var currencyTableIndicator: UIActivityIndicatorView!
    @IBOutlet weak var currencySearchBar: UISearchBar!
    @IBOutlet weak var currenciesTable: UITableView!
    var viewModel = CurrencyViewModel()
    
    var filterdCurrencies : [(short: String, full: String)]?{
        didSet {
            currencyTableIndicator.stopAnimating()
            currencyTableIndicator.isHidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currenciesTable.delegate = self
        currenciesTable.dataSource = self
        
        currencyTableIndicator.startAnimating()
        
        selectedCurrency.text = UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD"
        
        setCurrencyViewModel()
        // Do any additional setup after loading the view.
    }
    func setCurrencyViewModel() {
        self.filterdCurrencies  = self.viewModel.allCurrencies
        viewModel.bindResultToViewController = { [weak self] result in
            self?.loadingView.isHidden = true
            
            switch result {
            case .success:
                self?.selectedCurrency.text = UserDefaults.standard.string(forKey: "currencyTitle") ?? "USD"
                // Testing"
                print(UserDefaults.standard.string(forKey: "currencyTitle") ?? "no value")
                print(UserDefaults.standard.string(forKey: "factor") ?? "no value")
            case .failure:
                self?.showGenericAlert(title: "Error..!", message: "Couldn't change currency please try again")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.checkNetworkReachability{ isReachable in
            if !isReachable {
                self.showAlert()
            }
            }
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
            self.viewWillAppear(true)
        }
        
        alertController.addAction(doneAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func showGenericAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdCurrencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currenciesTable.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyTableViewCell
        
        cell.currencyShort.text = filterdCurrencies?[indexPath.row].short
        cell.currencyFullTerm.text = filterdCurrencies?[indexPath.row].full
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.checkNetworkReachability{ isReachable in
            if !isReachable {
                self.showAlert()
            }
            }
            let alert = UIAlertController(title: filterdCurrencies?[indexPath.row].short, message: "App currency will be changed to \(filterdCurrencies?[indexPath.row].short ?? "")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "change", style: .destructive, handler: { action in
                // Chang app currency
                self.loadingView.isHidden = false
                print((self.filterdCurrencies?[indexPath.row].short)!)
                self.viewModel.getExchageRates(currency: (self.filterdCurrencies?[indexPath.row].short)!)
            }))
            alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        currenciesTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterdCurrencies = viewModel.allCurrencies
            } else {
                filterdCurrencies = viewModel.allCurrencies?.filter { $0.full.lowercased().contains(searchText.lowercased())
                    || $0.short.lowercased().contains(searchText.lowercased())
                }
            }
        
        currenciesTable.reloadData()
    }
    }



