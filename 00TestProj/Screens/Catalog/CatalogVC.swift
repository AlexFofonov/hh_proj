//
//  CatalogVC.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit

final class CatalogVC<View: CatalogView>: BaseVC<View>, UISearchControllerDelegate {
    
    init(catalogProvider: CatalogProvider) {
        self.catalogProvider = catalogProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        
        rootView.displayIndication(state: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.rootView.display(cellData: self.makeProducts(ids: Array(0...12)), animated: true)
            self.rootView.display(title: self.makeTitle(), animated: true)
            
            self.rootView.hideIndication()
        }
    }
    
    private let catalogProvider: CatalogProvider
    
    var onDisplayProduct: ((_ id: Int) -> Void)?
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController()
        
        search.delegate = self
        search.hidesNavigationBarDuringPresentation = false
        
        configureSearchBar(searchController: search)
        
        return search
    }()
    
    private func configureSearchBar(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .search
        searchBar.placeholder = " Поиск"
        searchBar.setImage(UIImage(named: "Catalog/Search"), for: .search, state: .normal)
        searchBar.barTintColor = UIColor(named: "Colors/SearchBarBackground")
        searchBar.delegate = rootView

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = .systemFont(ofSize: 14, weight: .init(400))
            textField.layer.cornerRadius = 20
            textField.layer.masksToBounds = true
        }
    }
    
    @objc
    func onBack(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Setup NavigationItem

private extension CatalogVC {
    
    func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "NavigationBar/Arrow"),
            style: .done,
            target: self,
            action: #selector(onBack(sender:))
        )
        
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: "Colors/Black")
        
        navigationItem.titleView = searchController.searchBar
        navigationItem.titleView?.contentMode = .topLeft
    }
    
}

// MARK: - Make

private extension CatalogVC {
    
    func makeProducts(ids: [Int]) -> [ProductCellData] {
        return ids.map { id in
            ProductCellData(
                title: "Я товар номер \(id)",
                rating: 4,
                price: "1234 р"
            ) { [weak self] in
                
                print("Select \(id) item")
                
                self?.onDisplayProduct?(id)
            }
        }
    }
    
    func makeTitle() -> String {
        let title = "Тонковки для женщин"
        return title
    }
    
}
