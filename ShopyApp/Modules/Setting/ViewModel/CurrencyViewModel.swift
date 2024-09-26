//
//  CurrencyViewModel.swift
//  ShopyApp
//
//  Created by sayed mansour on 25/09/2024.
//

import Foundation
class CurrencyViewModel{
    var networkManager: NetworkManager?
    let model = ReachabilityManager()
    var bindResultToViewController: (( _ result: ExchangeResult) -> Void) = {result in }
    var allCurrencies : [(short: String, full: String)]?
    enum ExchangeResult {
        case success
        case failure
    }
    
    var currenciesNames = ["AED": "United Arab Emirates Dirham",
                           "AFN": "Afghan Afghani",
                           "ALL": "Albanian Lek",
                           "AMD": "Armenian Dram",
                           "ANG": "Netherlands Antillean Guilder",
                           "AOA": "Angolan Kwanza",
                           "ARS": "Argentine Peso",
                           "AUD": "Australian Dollar",
                           "AWG": "Aruban Florin",
                           "AZN": "Azerbaijani Manat",
                           "BAM": "Bosnia-Herzegovina Convertible Mark",
                           "BBD": "Barbadian Dollar",
                           "BDT": "Bangladeshi Taka",
                           "BGN": "Bulgarian Lev",
                           "BHD": "Bahraini Dinar",
                           "BIF": "Burundian Franc",
                           "BMD": "Bermudan Dollar",
                           "BND": "Brunei Dollar",
                           "BOB": "Bolivian Boliviano",
                           "BRL": "Brazilian Real",
                           "BSD": "Bahamian Dollar",
                           "BTC": "Bitcoin",
                           "BTN": "Bhutanese Ngultrum",
                           "BWP": "Botswanan Pula",
                           "BYN": "New Belarusian Ruble",
                           "BYR": "Belarusian Ruble",
                           "BZD": "Belize Dollar",
                           "CAD": "Canadian Dollar",
                           "CDF": "Congolese Franc",
                           "CHF": "Swiss Franc",
                           "CLF": "Chilean Unit of Account (UF)",
                           "CLP": "Chilean Peso",
                           "CNY": "Chinese Yuan",
                           "COP": "Colombian Peso",
                           "CRC": "Costa Rican Colón",
                           "CUC": "Cuban Convertible Peso",
                           "CUP": "Cuban Peso",
                           "CVE": "Cape Verdean Escudo",
                           "CZK": "Czech Republic Koruna",
                           "DJF": "Djiboutian Franc",
                           "DKK": "Danish Krone",
                           "DOP": "Dominican Peso",
                           "DZD": "Algerian Dinar",
                           "EGP": "Egyptian Pound",
                           "ERN": "Eritrean Nakfa",
                           "ETB": "Ethiopian Birr",
                           "EUR": "Euro",
                           "FJD": "Fijian Dollar",
                           "FKP": "Falkland Islands Pound",
                           "GBP": "British Pound Sterling",
                           "GEL": "Georgian Lari",
                           "GGP": "Guernsey Pound",
                           "GHS": "Ghanaian Cedi",
                           "GIP": "Gibraltar Pound",
                           "GMD": "Gambian Dalasi",
                           "GNF": "Guinean Franc",
                           "GTQ": "Guatemalan Quetzal",
                           "GYD": "Guyanaese Dollar",
                           "HKD": "Hong Kong Dollar",
                           "HNL": "Honduran Lempira",
                           "HRK": "Croatian Kuna",
                           "HTG": "Haitian Gourde",
                           "HUF": "Hungarian Forint",
                           "IDR": "Indonesian Rupiah",
                           "ILS": "Israeli New Sheqel",
                           "IMP": "Manx pound",
                           "INR": "Indian Rupee",
                           "IQD": "Iraqi Dinar",
                           "IRR": "Iranian Rial",
                           "ISK": "Icelandic Króna",
                           "JEP": "Jersey Pound",
                           "JMD": "Jamaican Dollar",
                           "JOD": "Jordanian Dinar",
                           "JPY": "Japanese Yen",
                           "KES": "Kenyan Shilling",
                           "KGS": "Kyrgystani Som",
                           "KHR": "Cambodian Riel",
                           "KMF": "Comorian Franc",
                           "KPW": "North Korean Won",
                           "KRW": "South Korean Won",
                           "KWD": "Kuwaiti Dinar",
                           "KYD": "Cayman Islands Dollar",
                           "KZT": "Kazakhstani Tenge",
                           "LAK": "Laotian Kip",
                           "LBP": "Lebanese Pound",
                           "LKR": "Sri Lankan Rupee",
                           "LRD": "Liberian Dollar",
                           "LSL": "Lesotho Loti",
                           "LTL": "Lithuanian Litas",
                           "LVL": "Latvian Lats",
                           "LYD": "Libyan Dinar",
                           "MAD": "Moroccan Dirham",
                           "MDL": "Moldovan Leu",
                           "MGA": "Malagasy Ariary",
                           "MKD": "Macedonian Denar",
                           "MMK": "Myanma Kyat",
                           "MNT": "Mongolian Tugrik",
                           "MOP": "Macanese Pataca",
                           "MRU": "Mauritanian Ouguiya",
                           "MUR": "Mauritian Rupee",
                           "MVR": "Maldivian Rufiyaa",
                           "MWK": "Malawian Kwacha",
                           "MXN": "Mexican Peso",
                           "MYR": "Malaysian Ringgit",
                           "MZN": "Mozambican Metical",
                           "NAD": "Namibian Dollar",
                           "NGN": "Nigerian Naira",
                           "NIO": "Nicaraguan Córdoba",
                           "NOK": "Norwegian Krone",
                           "NPR": "Nepalese Rupee",
                           "NZD": "New Zealand Dollar",
                           "OMR": "Omani Rial",
                           "PAB": "Panamanian Balboa",
                           "PEN": "Peruvian Nuevo Sol",
                           "PGK": "Papua New Guinean Kina",
                           "PHP": "Philippine Peso",
                           "PKR": "Pakistani Rupee",
                           "PLN": "Polish Zloty",
                           "PYG": "Paraguayan Guarani",
                           "QAR": "Qatari Rial",
                           "RON": "Romanian Leu",
                           "RSD": "Serbian Dinar",
                           "RUB": "Russian Ruble",
                           "RWF": "Rwandan Franc",
                           "SAR": "Saudi Riyal",
                           "SBD": "Solomon Islands Dollar",
                           "SCR": "Seychellois Rupee",
                           "SDG": "South Sudanese Pound",
                           "SEK": "Swedish Krona",
                           "SGD": "Singapore Dollar",
                           "SHP": "Saint Helena Pound",
                           "SLE": "Sierra Leonean Leone",
                           "SLL": "Sierra Leonean Leone",
                           "SOS": "Somali Shilling",
                           "SRD": "Surinamese Dollar",
                           "STD": "São Tomé and Príncipe Dobra",
                           "SVC": "Salvadoran Colón",
                           "SYP": "Syrian Pound",
                           "SZL": "Swazi Lilangeni",
                           "THB": "Thai Baht",
                           "TJS": "Tajikistani Somoni",
                           "TMT": "Turkmenistani Manat",
                           "TND": "Tunisian Dinar",
                           "TOP": "Tongan Paʻanga",
                           "TRY": "Turkish Lira",
                           "TTD": "Trinidad and Tobago Dollar",
                           "TWD": "New Taiwan Dollar",
                           "TZS": "Tanzanian Shilling",
                           "UAH": "Ukrainian Hryvnia",
                           "UGX": "Ugandan Shilling",
                           "USD": "United States Dollar",
                           "UYU": "Uruguayan Peso",
                           "UZS": "Uzbekistan Som",
                           "VEF": "Venezuelan Bolívar Fuerte",
                           "VES": "Sovereign Bolivar",
                           "VND": "Vietnamese Dong",
                           "VUV": "Vanuatu Vatu",
                           "WST": "Samoan Tala",
                           "XAF": "CFA Franc BEAC",
                           "XAG": "Silver (troy ounce)",
                           "XAU": "Gold (troy ounce)",
                           "XCD": "East Caribbean Dollar",
                           "XDR": "Special Drawing Rights",
                           "XOF": "CFA Franc BCEAO",
                           "XPF": "CFP Franc",
                           "YER": "Yemeni Rial",
                           "ZAR": "South African Rand",
                           "ZMK": "Zambian Kwacha (pre-2013)",
                           "ZMW": "Zambian Kwacha",
                           "ZWL": "Zimbabwean Dollar"]
    
    init(){
        networkManager = NetworkManager()
        allCurrencies = currenciesNames.map({ (key, value) in
                (short: key, full: value)
            })
//        currencyRate = ["USDEGP": 30.847114,
//                        "USDAED": 3.673042,
//                        "USDEUR": 0.921604,
//                        "USDKWD": 0.307804,
//                        "USDQAR": 3.64075,
//                        "USDSAR": 3.750254,
//                        "USDJPY": 150.09504]
        
    }

  func checkNetworkReachability(completion: @escaping (Bool) -> Void) {
      model.checkNetworkReachability { isReachable in
          completion(isReachable)
      }
  }
    func getExchageRates(currency: String) {
        if currency == "USD" {
            UserDefaults.standard.setValue(1, forKey: "factor")
            UserDefaults.standard.setValue(currency, forKey: "currencyTitle")
            self.bindResultToViewController(.success)
            
            return
        }
        networkManager?.fetchData(url: APIHandler.currenciesUrl(.liveCurrencies(wantedCurrencies: "\(currency),")), type: ExchangeRates.self, complitionHandler: { container in
            guard let container = container else {
                self.bindResultToViewController(.failure)
                return
            }
            UserDefaults.standard.setValue(container.quotes.first?.value, forKey: "factor")
            UserDefaults.standard.setValue(currency, forKey: "currencyTitle")
            self.bindResultToViewController(.success)
        }, headers: ["apiKey":APIHandler.currencyApiKey])
    }
//    func loadCurrencies() {
//        networkManager?.fetchData(url: APIHandler.currenciesUrl(.liveCurrencies(wantedCurrencies: "egp,aed,eur,kwd,qar,sar,jpy")), type: ExchangeRates.self, complitionHandler: { container in
//            self.currencyRate = container?.quotes
//        }, headers: ["apiKey":APIHandler.currencyApiKey])
    
//    MARK: - NOT NECESSARY TO FETCH ALL NAMES FROM API (wastes requests)
//        networkManager?.fetch(url: APIHandler.currenciesUrl(.fullNames), type: CurrenciesNames.self, complitionHandler: { container in
//            currencyRate = container?.currencies
//        }, headers: ["apiKey":APIHandler.currencyApiKey])
    
//    
//    func getCurrencyRates() -> [String: Double]{
//        return currencyRate ?? [:]
//    }
//    
    struct CurrencyResponse: Codable {
        let currencies : [String: String]
    }
    
    
    
}
