//
//  CatalogVC.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit

struct ButtonState {
    let context: AnyObject
    let notify: CellButtonStateNotify
    let productId: Int
}

final class CatalogVC<View: CatalogView>: BaseVC<View>, UISearchControllerDelegate {
    
    init(catalogProvider: CatalogProvider) {
        self.catalogProvider = catalogProvider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var favoriteState: [ButtonState] = []
    
    var productsFavoriteCache: [Int: CellButtonState] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        
        rootView.displayIndication(state: .loading)
        
        loadData()
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

}

// MARK: - Load data

private extension CatalogVC {
    
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.rootView.display(
                cellData: self.makeProducts(ids: Array(0...13)),
                animated: true
            )
            self.rootView.display(
                title: self.makeTitle(),
                animated: true
            )
            
            self.rootView.hideIndication()
        }
    }
    
}

// MARK: - Setup NavigationItem

private extension CatalogVC {
    
    func configureNavigationItem() {
        navigationItem.titleView = searchController.searchBar
        navigationItem.titleView?.contentMode = .topLeft
    }
    
}

// MARK: - Make

private extension CatalogVC {
    
    func makeProducts(ids: [Int]) -> [ProductCellData] {
        return ids.enumerated().map { item in
            let (item, _) = item
            
            return ProductCellData(
                title: "Я товар номер \(item)",
                rating: 4,
                price: "1234 р",
                onFavoriteSubscriber: { [weak self] cell, notify in
                    self?.subscribe(productId: item, cell: cell, notify: notify)
                },
                onFavoriteSelect: { [weak self] in
                    self?.setFavorite(productId: item)
                }
            ) { [weak self] in
                
                print("Select \(item) item")
                
                self?.onDisplayProduct?(item)
            }
        }
    }
    
    func makeTitle() -> String {
        let title = "Тонковки для женщин"
        return title
    }
    
}

private extension CatalogVC {
    
    func subscribe(
        productId: Int,
        cell: AnyObject,
        notify: @escaping CellButtonStateNotify
    ) {
        unsubscribe(cell: cell)
        
        favoriteState.append(
            .init(
                context: cell,
                notify: notify,
                productId: productId
            )
        )
        
        let cacheValue = productsFavoriteCache[productId] ?? .init(isSelected: false, isLoading: false)
        productsFavoriteCache.updateValue(cacheValue, forKey: productId)
        
        notify(cacheValue)
    }
    
    func unsubscribe(cell: AnyObject) {
        favoriteState = favoriteState.filter {
            $0.context !== cell
        }
    }
    
    func searchFavoriteStateIndex(productId: Int) -> Int? {
        favoriteState.firstIndex { ButtonState in
            ButtonState.productId == productId
        }
    }
    
    func setFavorite(productId: Int) {
        guard
            let cacheValue = updatedCellButtonState(productId: productId),
            let cellIndex = searchFavoriteStateIndex(productId: productId)
        else {
            return
        }
        
        productsFavoriteCache.updateValue(cacheValue, forKey: productId)
        
        favoriteState[cellIndex].notify(cacheValue)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard
                let self = self,
                let cacheValue = self.updatedCellButtonState(productId: productId)
            else {
                return
            }
            
            self.productsFavoriteCache.updateValue(cacheValue, forKey: productId)
            
            self.updateFavoriteState(productId: productId, cacheValue: cacheValue)
        }
    }
    
    func updateFavoriteState(productId: Int, cacheValue: CellButtonState) {
        guard let cellIndex = searchFavoriteStateIndex(productId: productId) else {
            return
        }
        
        self.favoriteState[cellIndex].notify(cacheValue)
    }
    
    func updatedCellButtonState(productId: Int) -> CellButtonState? {
        guard let cacheValue = productsFavoriteCache[productId] else {
            return nil
        }
        
        if !cacheValue.isSelected && !cacheValue.isLoading {
            return .init(isSelected: false, isLoading: true)
        }

        if !cacheValue.isSelected && cacheValue.isLoading {
            return .init(isSelected: true, isLoading: false)
        }

        if cacheValue.isSelected && !cacheValue.isLoading {
            return .init(isSelected: true, isLoading: true)
        }

        if cacheValue.isSelected && cacheValue.isLoading {
            return .init(isSelected: false, isLoading: false)
        }

        return nil
    }
    
}
