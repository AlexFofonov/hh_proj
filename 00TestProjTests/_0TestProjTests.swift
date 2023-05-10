//
//  _0TestProjTests.swift
//  00TestProjTests
//
//  Created by Александр Фофонов on 09.05.2023.
//

import XCTest
@testable import _0TestProj

class CatalogViewMock: UIView, CatalogView {
    
    var willDisplayProduct: ((Int) -> Void)?
    var onRefresh: (() -> Void)?
    
    var indicator: UIActivityIndicatorView?
    
    var cellData: [_0TestProj.ProductCellData] = []
    
    func display(
        cellData: [_0TestProj.ProductCellData],
        append: Bool,
        animated: Bool
    ) {
        self.cellData = cellData
    }
    
    func display(title: String, animated: Bool) {

    }
    
    func display(count: Int, animated: Bool) {
        
    }
    
    func displayLoadingIndicationState() {
        indicator?.startAnimating()
    }
    
    func hideIndication() {
        indicator?.stopAnimating()
    }
    
}

class CatalogProviderMock: CatalogProvider {
    
    var products: _0TestProj.ProductResponseData?
    
    func products(
        offset: Int,
        force: Bool,
        completion: @escaping (_0TestProj.ProductResponseData?) -> Void
    ) {
        completion(products)
    }
    
    
}

final class CatalogVCTests: XCTestCase {

    func test_loading_success() {
        guard let imageURL = URL(string: "https://files.gifts.ru/reviewer/tb/72/7611.30_12_500.jpg") else {
            return
        }
        
        let products = _0TestProj.ProductResponseData(
            products: [
                .init(
                    id: 0,
                    imageURL: imageURL,
                    name: "name",
                    rating: 0,
                    price: "price"
                )
            ],
            count: 1,
            title: "title"
        )
        
        let catalogProvider = CatalogProviderMock()
        catalogProvider.products = products
        
        let catalogVC = CatalogVC<CatalogViewMock>(catalogProvider: catalogProvider)
        catalogVC.viewDidLoad()
        
        XCTAssertEqual(products.count, catalogVC.rootView.cellData.count)
    }
    
    func test_loading_success_empty_products() {
        let products = _0TestProj.ProductResponseData(
            products: [],
            count: 0,
            title: "title"
        )
        
        let catalogProvider = CatalogProviderMock()
        catalogProvider.products = products
        
        let catalogVC = CatalogVC<CatalogViewMock>(catalogProvider: catalogProvider)
        catalogVC.viewDidLoad()
        
        XCTAssertEqual(products.count, catalogVC.rootView.cellData.count)
    }
    
    func test_click_cell_success() {
        guard let imageURL = URL(string: "https://files.gifts.ru/reviewer/tb/72/7611.30_12_500.jpg") else {
            return
        }
        
        let products = _0TestProj.ProductResponseData(
            products: [
                .init(
                    id: 0,
                    imageURL: imageURL,
                    name: "name",
                    rating: 0,
                    price: "price"
                )
            ],
            count: 1,
            title: "title"
        )
        
        let catalogProvider = CatalogProviderMock()
        catalogProvider.products = products
        
        let catalogVC = CatalogVC<CatalogViewMock>(catalogProvider: catalogProvider)
        catalogVC.viewDidLoad()
        
        var isClicked: Bool = false
        
        catalogVC.onDisplayProduct = { id in
            if id == 0 {
                isClicked = true
            }
        }
        
        guard let firstProduct = catalogVC.rootView.cellData.first else {
            return
        }
        
        firstProduct.onSelect()
        
        XCTAssertTrue(isClicked)
    }

}
