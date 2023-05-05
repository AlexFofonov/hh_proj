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
        
        rootView.onRefresh = { [weak self] in
            self?.loadData(force: true)
        }
        
        rootView.willDisplayProduct = { [weak self] item in
            self?.loadData(offset: item)
        }
        
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
    
    func loadData(offset: Int = 0, force: Bool = false) {
        
        catalogProvider.products(offset: offset, force: force) { [weak self] result in
            guard let self = self else {
                return
            }
            
            if let result = result {
                guard let products = result.products else {
                    return
                }
                
                self.rootView.display(
                    cellData: self.make(products: products),
                    append: offset != 0,
                    animated: true
                )
                self.rootView.display(
                    title: result.title,
                    animated: true
                )
                self.rootView.display(
                    count: result.count,
                    animated: true
                )
            } else {
                // Ошибка
            }
            
            if offset == 0 {
                self.rootView.hideIndication()
            }
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
    
    func make(products: [Product]) -> [ProductCellData] {
        products.enumerated().map { product in
            let (item, product) = product
            
            return ProductCellData(
                title: product.name,
                imageURL: product.imageURL,
                rating: product.rating,
                price: product.price,
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
    
}

// MARK: - ProductCellData logic

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
        
        notify(cellButtonState(productId: productId))
    }
    
    func unsubscribe(cell: AnyObject) {
        favoriteState = favoriteState.filter { $0.context !== cell }
    }
    
    func setFavorite(productId: Int) {
        let oldButtonState = cellButtonState(productId: productId)
        
        self.updateFavoriteState(
            productId: productId,
            isSelected: oldButtonState.isSelected,
            isLoading: true
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateFavoriteState(
                productId: productId,
                isSelected: !oldButtonState.isSelected,
                isLoading: false
            )
        }
    }
    
    func updateFavoriteState(productId: Int, isSelected: Bool, isLoading: Bool) {
        let newButtonState = CellButtonState(isSelected: isSelected, isLoading: isLoading)
        productsFavoriteCache[productId] = newButtonState
        
        if let cellState = favoriteButtonState(productId: productId) {
            cellState.notify(newButtonState)
        }
    }
    
    func favoriteButtonState(productId: Int) -> ButtonState? {
        favoriteState.first { $0.productId == productId }
    }
    
    func cellButtonState(productId: Int) -> CellButtonState {
        productsFavoriteCache[productId] ?? .init(isSelected: false, isLoading: false)
    }
    
}
