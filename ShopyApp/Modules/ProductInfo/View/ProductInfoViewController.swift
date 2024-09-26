//
//  ProductInfoViewController.swift
//  ShopyApp
//
//  Created by sayed mansour on 18/09/2024.
//

import UIKit
import Kingfisher

class ProductInfoViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var productsImageArray = [ProductImage]()
    @IBOutlet weak var color: UIButton!
    
    @IBOutlet weak var size: UIButton!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var reviewsTableView: UITableView!
    
    @IBOutlet weak var productNameText: UITextView!
    
    @IBOutlet weak var productRateText: UILabel!
    
    @IBOutlet weak var productPriceText: UILabel!
    
    @IBOutlet weak var productCurrencyText: UILabel!
    
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var addToFavButton: UIButton!
    
    @IBOutlet weak var star1: UIImageView!
    
    @IBOutlet weak var star2: UIImageView!
    
    @IBOutlet weak var star3: UIImageView!
    
    @IBOutlet weak var star4: UIImageView!
    
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var cover: UIView!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    var productInfoViewModel = ProductInfoViewModel()
    var url:[URL] = []
    var product : Product!
    var productId : Int?
    
    
    var indicator : UIActivityIndicatorView?
    
    var reviews : Reviews?
    
    var Allreviews : [Reviews.Review]?
    
    var userDefaults = Utilities()
    
    var wishList: [[String: Any]]?
    
    var indexOfSize = 0
    
    var indexOfColor = 0
    var sizes : [String]?{
        didSet{
            let actionClosure = { (action: UIAction) in
                print(action.title)
                self.indexOfSize = self.sizes?.firstIndex(of: action.title) ?? 0
                if self.productInfoViewModel.isInCart(variantId: self.productInfoViewModel.getProductDetails()?.variants[self.indexOfSize].id ?? 0) == true {
                    self.addToCartButton.isEnabled = false
                } else {
                    self.addToCartButton.isEnabled = true
                }
            }
            
            var menuChildren: [UIMenuElement] = []
            for size in sizes ?? ["0"] {
                menuChildren.append(UIAction(title: size, handler: actionClosure))
            }
            
            size.menu = UIMenu(options: .displayInline, children: menuChildren)
            
            size.showsMenuAsPrimaryAction = true
            size.changesSelectionAsPrimaryAction = true
        }
    }
    var colors: [String]?{
        didSet{
            let actionClosure = { (action: UIAction) in
                print(action.title)
                self.indexOfColor = self.colors?.firstIndex(of: action.title) ?? 0
            }
            
            var menuChildren: [UIMenuElement] = []
            for color in colors ?? ["--"] {
                menuChildren.append(UIAction(title: color, handler: actionClosure))
            }
            
            color.menu = UIMenu(options: .displayInline, children: menuChildren)
            
            color.showsMenuAsPrimaryAction = true
            color.changesSelectionAsPrimaryAction = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reviews = Reviews()
        Allreviews = reviews?.getReviews()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        productInfoViewModel.checkNetworkReachability{ isReachable in
            if isReachable {
                self.cover.isHidden = true
                self.configureReviewsTableView()
                self.configureCollectionView()
                self.configureLoadingData()
            } else {
                DispatchQueue.main.async {
                    self.cover.isHidden = false
                    self.showAlert()
                }
            }
        }
        
    }
    @IBAction func allReviewsButton(_ sender: Any) {
        reviewsTableView.reloadData()
    }
    
    func showAlert(flag:Bool = false){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Check your network and try again", preferredStyle: .alert)
        if flag {
            
            let doneAction = UIAlertAction(title: "Ok", style: .cancel) { _ in
                
            }
            alertController.addAction(doneAction)
        }else{
            let doneAction = UIAlertAction(title: "Retry", style: .cancel) { _ in
                self.viewWillAppear(true)
            }
            alertController.addAction(doneAction)
        }
        
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func addingToCart(_ sender: Any) {
        productInfoViewModel.checkNetworkReachability{ isReachable in
            if isReachable {
                if self.userDefaults.isLoggedIn() == true{
                    print("added")
                    let item : [String: Any] = [
                        "variant_id": self.productInfoViewModel.getProductDetails()?.variants[self.indexOfSize].id ?? "",
                        "quantity" : 1,
                        "properties":[["name":"image","value":self.productInfoViewModel.getProductDetails()?.image.src ?? ""],["name":"inventoryQuantity","value":String(self.productInfoViewModel.getProductDetails()?.variants.first?.inventoryQuantity ?? 0)]]
                    ]
                    
                    self.productInfoViewModel.addToCart(item: item)
                    print("added")
                    self.addToCartButton.setTitle("AddedToCart", for: .normal)
                    self.addToCartButton.isEnabled = false
                    self.addToCartButton.alpha = 0.5
                    
                }else{
                    let alert = UIAlertController(title: "Not Registered", message: "You need to register to be able to add to cart", preferredStyle: .alert)
                    let signUp = UIAlertAction(title: "Sign Up", style: .default) { UIAlertAction in
                        self.performSegue(withIdentifier: "toSignUp", sender: nil)
                    }
                    let gotIt = UIAlertAction(title: "Got It", style: .cancel)
                    
                    alert.addAction(signUp)
                    alert.addAction(gotIt)
                    self.present(alert, animated: true)
                }
                
            } else {
                DispatchQueue.main.async {
                    
                    self.showAlert(flag: true)
                }
            }
        }
    }
    @IBAction func addingToWishlist(_ sender: Any) {
        productInfoViewModel.checkNetworkReachability{ isReachable in
            if isReachable {
                if self.userDefaults.isLoggedIn() == true{
                    let item : [String: Any] = [
                        "variant_id": (self.productInfoViewModel.getProductDetails()?.variants.first?.id) ?? 0,
                        "quantity" : 1,
                        "properties":[["name":"image","value":self.productInfoViewModel.getProductDetails()?.image.src ?? ""],["name":"inventoryQuantity","value":String(self.productInfoViewModel.getProductDetails()?.variants.first?.inventoryQuantity ?? 0)]]
                    ]
                    if self.productInfoViewModel.isInLocalWishList(wishList: self.wishList ?? [], productId: self.productInfoViewModel.getProductDetails()?.id ?? 0) == false {
                        self.addToFavButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        self.wishList?.append(item)
                        print(self.wishList ?? "")
                        self.productInfoViewModel.updateWishList(wishList: self.wishList)
                        
                        print("added")
                    } else {
                        self.addToFavButton.setImage(UIImage(systemName: "heart"), for: .normal)
                        // TODO: remove from wishlist
                        self.wishList?.removeAll(where: { product in
                            product["product_id"] as! Int == (self.productInfoViewModel.getProductDetails()?.id) ?? 0
                        })
                        self.productInfoViewModel.updateWishList(wishList: self.wishList)
                        
                    }
                    
                    
                    
                    
                }else{
                    let alert = UIAlertController(title: "Not Registered", message: "You need to register to add to wishlist", preferredStyle: .alert)
                    let gotIt = UIAlertAction(title: "Got It", style: .cancel)
                    let signUp = UIAlertAction(title: "Sign Up", style: .default) { UIAlertAction in
                        self.performSegue(withIdentifier: "toSignUp", sender: nil)
                    }
                    alert.addAction(signUp)
                    alert.addAction(gotIt)
                    self.present(alert, animated: true)
                }
            }else {
                DispatchQueue.main.async {
                    
                    self.showAlert(flag: true)
                }
            }
        }
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Indicator initializing
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
    
    func configureLoadingData(){
        
        productInfoViewModel.loadData(productId: self.productId ?? 0 )
        //print("productId\(productId)")
        
        productInfoViewModel.bindResultToViewController = { [weak self] in
            DispatchQueue.main.async {
                self?.indicator?.stopAnimating()
                self?.productNameText.text = self?.productInfoViewModel.getProductDetails()?.title ?? ""
                let factor = UserDefaults.standard.value(forKey: "factor")as! Double
                let price = Double(self?.productInfoViewModel.getProductDetails()?.variants.first?.price ?? "0.0")
                let currency = UserDefaults.standard.value(forKey: "currencyTitle") as! String
                self?.productPriceText.text = String(format: "%.2f" ,factor * (price ?? 0.0))
                self?.productCurrencyText.text = currency
                self?.descriptionText.text = self?.productInfoViewModel.getProductDetails()?.bodyHTML
                
                self?.sizes = self?.productInfoViewModel.getProductDetails()?.options[0].values
                self?.colors = self?.productInfoViewModel.getProductDetails()?.options[1].values
                
                self?.wishList = self?.productInfoViewModel.extractLineItemsPostData(lineItems: self?.productInfoViewModel.getWishlist() ?? [])
                
                self?.myCollectionView.reloadData()
                if self?.productInfoViewModel.isInLocalWishList(wishList: self?.wishList ?? [], productId: self?.productInfoViewModel.getProductDetails()?.id ?? 0) == false {
                    self?.addToFavButton.imageView?.image = UIImage(systemName: "heart")
                } else {
                    self?.addToFavButton.imageView?.image = UIImage(systemName: "heart.fill")
                }
            }
        
            
            if self?.productInfoViewModel.isInCart(variantId: self?.productInfoViewModel.getProductDetails()?.variants[(self?.indexOfSize)!].id ?? 0) == true {
                self?.addToCartButton.isEnabled = false
            } else {
                self?.addToCartButton.isEnabled = true
            }
        }
    }
    
    
    //MARK: - Configure the CollectionView (source,delegate,nib cell)
    
    func configureCollectionView(){
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        myCollectionView.register(UINib(nibName: "ProductPositionsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "myDetCell")
        
        if let layout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    //MARK: - Configure the TableView (source,delegate,nib cell)

    func configureReviewsTableView(){
        reviewsTableView.dataSource = self
        reviewsTableView.delegate = self
        
        reviewsTableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewCell")
    }

    // MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productInfoViewModel.getProductDetails()?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myDetCell", for: indexPath) as! ProductPositionsCollectionViewCell
        let url = URL(string:productInfoViewModel.getProductDetails()?.images[indexPath.row].src ?? "hey")
        cell.productPositions.kf.setImage(with: url)
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 20
        return cell
    }
    
    
   
        func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    
    
  
    
}

// MARK: - Table View
extension ProductInfoViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        cell.customerName.text = Allreviews?[indexPath.row].customerName
        cell.CreatedAt.text = Allreviews?[indexPath.row].createdAt
        cell.rating.text = String(Allreviews?[indexPath.row].rating ?? 5.0)
        cell.feedback.text = Allreviews?[indexPath.row].massage
        cell.customerImage.image = UIImage(named: Allreviews?[indexPath.row].customerImage ?? "PlaceHolder")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}

