//
//  CatalogViewImp.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit

final class CatalogViewImp: UIView, CatalogView {
    
    private enum Constants {
        enum Size {
            static let groupHeight: CGFloat = 343
            static let itemWidth: CGFloat = 165
            
            static let headerContainerHeight: CGFloat = 56
            static let toolsContainerHeight: CGFloat = 44
        }
        
        enum Spacing {
            static let interItemSpacing: CGFloat = 13
            static let interGroupSpacing: CGFloat = 24
        }
        
        enum Insets {
            static let sectionTopContent: CGFloat = 20
            static let sectionBottomContent: CGFloat = 20
            static let sectionLeadingContent: CGFloat = 16
            static let sectionTrailingContent: CGFloat = 16
            
            static let horizontalContainer: CGFloat = 16
            static let horizontalSearchBar: CGFloat = 54
        }
    }
    
    enum SortingBy: String {
        case popularity = "По популярности"
        case priceIncrease = "По возрастанию цены"
        case descendingPrice = "По убыванию цены"
        case rating = "По рейтингу"
        case novelty = "По новизне"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        indicator = loadingIndicator
        
        backgroundColor = UIColor(named: "Colors/Background")
        
        addSubview(catalogCollectionView)
        
        catalogCollectionView.contentInset.top = Constants.Size.headerContainerHeight + Constants.Size.toolsContainerHeight
        
        addSubview(topContainer)
        
        topContainer.addSubview(headerContainer)
        headerContainer.addSubview(categoryLabel)
        headerContainer.addSubview(numberOfProductsLabel)
        
        topContainer.addSubview(toolsContainer)
        toolsContainer.addSubview(sortButton)
        toolsContainer.addSubview(compareButton)
        toolsContainer.addSubview(cardsButton)
        
        catalogCollectionView.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate(
            [
                topContainer.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                topContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                topContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                headerContainer.topAnchor.constraint(equalTo: topContainer.topAnchor),
                headerContainer.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
                headerContainer.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
                headerContainer.heightAnchor.constraint(equalToConstant: Constants.Size.headerContainerHeight),
                
                categoryLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
                categoryLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
                categoryLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: 102),
                
                numberOfProductsLabel.bottomAnchor.constraint(equalTo: categoryLabel.bottomAnchor),
                numberOfProductsLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -Constants.Insets.horizontalContainer),
                
                toolsContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
                toolsContainer.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
                toolsContainer.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
                toolsContainer.heightAnchor.constraint(equalToConstant: Constants.Size.toolsContainerHeight),
                
                sortButton.centerYAnchor.constraint(equalTo: toolsContainer.centerYAnchor),
                sortButton.leadingAnchor.constraint(equalTo: toolsContainer.leadingAnchor, constant: Constants.Insets.horizontalContainer),
                sortButton.trailingAnchor.constraint(equalTo: toolsContainer.trailingAnchor, constant: 196),
                
                cardsButton.centerYAnchor.constraint(equalTo: toolsContainer.centerYAnchor),
                cardsButton.trailingAnchor.constraint(equalTo: toolsContainer.trailingAnchor, constant: -Constants.Insets.horizontalContainer),
                
                compareButton.centerYAnchor.constraint(equalTo: toolsContainer.centerYAnchor),
                compareButton.trailingAnchor.constraint(equalTo: cardsButton.leadingAnchor, constant: -26),
                
                catalogCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                catalogCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                catalogCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                catalogCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                
                loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ]
        )
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var data: [ProductCellData] = []
    
    var indicator: UIActivityIndicatorView?
    
    var willDisplayProduct: ((_ item: Int) -> Void)?
    var onRefresh: (() -> Void)?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor(named: "Colors/Black")
        
        return refreshControl
    }()
    
    private lazy var topContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Colors/Background")
        
        return view
    }()
    
    private lazy var headerContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Colors/Background")
        
        return view
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .init(500))
        label.textColor = UIColor(named: "Colors/Black")
        label.numberOfLines = 2
        label.clipsToBounds = true

        return label
    }()
    
    private lazy var numberOfProductsLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .init(400))
        label.textColor = UIColor(named: "Colors/AdditionalText")
        label.numberOfLines = 1

        return label
    }()
    
    private lazy var toolsContainer: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Colors/Background")
        
        return view
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(SortingBy.popularity.rawValue, for: .normal)
        button.setTitleColor(UIColor(named: "Colors/Black"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .init(500))
        button.setImage(UIImage(named: "Catalog/Sort"), for: .normal)
        button.backgroundColor = UIColor(named: "Colors/Background")
        button.titleEdgeInsets.left = 8
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    private lazy var compareButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Catalog/RawCompare"), for: .normal)
        
        return button
    }()
    
    private lazy var cardsButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Catalog/Cards"), for: .normal)
        
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(named: "Colors/Black")
        
        return indicator
    }()
    
    private lazy var catalogCollectionViewLayout: UICollectionViewCompositionalLayout = {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .absolute(Constants.Size.itemWidth),
                heightDimension: .fractionalHeight(1.0)
            )
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Constants.Size.groupHeight)
            ),
            subitem: item,
            count: 2
        )
        
        group.interItemSpacing = .fixed(Constants.Spacing.interItemSpacing)
    
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = Constants.Spacing.interGroupSpacing
        section.contentInsets = .init(
            top: Constants.Insets.sectionTopContent,
            leading: Constants.Insets.sectionLeadingContent,
            bottom: Constants.Insets.sectionBottomContent,
            trailing: Constants.Insets.sectionTrailingContent
        )

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }()
    
    private lazy var catalogCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: frame,
            collectionViewLayout: catalogCollectionViewLayout
        )
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        
        return collectionView
    }()
    
    @objc
    func refresh(sender: UIRefreshControl) {
        onRefresh?()
    }
    
}

// MARK: - UICollectionViewDataSource

extension CatalogViewImp: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        data.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let cell = cell as? ProductCell {
            cell.update(with: data[indexPath.item])
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension CatalogViewImp: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        data[indexPath.item].onSelect()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        willDisplayProduct?(indexPath.item)
    }
    
}

// MARK: - UIScrollViewDelegate

extension CatalogViewImp: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let diff = scrollView.contentInset.top + scrollView.contentOffset.y
        if diff >= 0 {
            topContainer.transform = .init(
                translationX: 0,
                y: -min(diff, Constants.Size.headerContainerHeight)
            )
        } else {
            topContainer.transform = .init(
                translationX: 0,
                y: 0
            )
        }
    }
    
}

// MARK: - Implementation VerificationView functions

extension CatalogViewImp {
    
    func display(title: String, animated: Bool) {
        categoryLabel.text = title
    }
    
    func display(count: Int, animated: Bool) {
        numberOfProductsLabel.text = String(count) + " товаров"
    }
    
    func display(cellData: [ProductCellData], append: Bool, animated: Bool) {
        if append {
            data.append(contentsOf: cellData)
        } else {
            data = cellData
        }
        
        catalogCollectionView.refreshControl?.endRefreshing()
        catalogCollectionView.reloadData()
    }
    
}

// MARK: - IndicationView

extension CatalogViewImp {
    
    func displayLoadingIndicationState() {
        indicator?.startAnimating()
        toolsContainer.alpha = 0
        catalogCollectionView.isUserInteractionEnabled = false
    }
    
    func displayErrorIndicationState() {
        //
    }
    
    func displayEmptyIndicationState() {
        //
    }
    
    func hideIndication() {
        indicator?.stopAnimating()
        toolsContainer.alpha = 1
        catalogCollectionView.isUserInteractionEnabled = true
    }
    
}
