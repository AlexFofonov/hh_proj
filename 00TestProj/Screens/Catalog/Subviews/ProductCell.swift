//
//  ProductCell.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit

final class ProductCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photoPlaceholderImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(compareButton)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(ratingStack)
        contentView.addSubview(priceLabel)
        contentView.addSubview(cartButton)

        NSLayoutConstraint.activate(
            [
                photoPlaceholderImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                photoPlaceholderImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                photoPlaceholderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                
                likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                likeButton.trailingAnchor.constraint(equalTo: photoPlaceholderImageView.trailingAnchor, constant: -5),
                
                compareButton.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8),
                compareButton.trailingAnchor.constraint(equalTo: photoPlaceholderImageView.trailingAnchor, constant: -5),
                
                productNameLabel.topAnchor.constraint(equalTo: photoPlaceholderImageView.bottomAnchor, constant: 12),
                productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                productNameLabel.trailingAnchor.constraint(equalTo: photoPlaceholderImageView.trailingAnchor),
                
                ratingStack.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 10),
                ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                
                priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                
                cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                cartButton.trailingAnchor.constraint(equalTo: photoPlaceholderImageView.trailingAnchor),
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private lazy var photoPlaceholderImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Catalog/PhotoPlaceholder")
        
        return imageView
    }()
    
    private lazy var likeButton = makeButton(imageName: "Catalog/Like")
    
    private lazy var compareButton = makeButton(imageName: "Catalog/Compare")
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .init(400))
        label.textColor = UIColor(named: "Colors/Black")
        label.numberOfLines = 2
        label.text = "Здесь могла быть реклама вашей толстовки"
        
        return label
    }()
    
    private var ratingStackSubviews: [UIView] = []
    
    private lazy var ratingStack: UIStackView = {
        createStars()
        ratingStackSubviews.append(ratingLabel)
        
        let stackView = UIStackView(arrangedSubviews: ratingStackSubviews)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 3
        stackView.setCustomSpacing(6, after: ratingStackSubviews[4])
        
        return stackView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .init(400))
        label.textColor = UIColor(named: "Colors/Black")
        
        return label
    }()
    
    private func createStars() {
        for _ in 0...4 {
            let imageView = UIImageView()
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "Catalog/RatingStar")
            imageView.contentMode = .center
            
            ratingStackSubviews.append(imageView)
        }
    }
    
    private func fillStars(count: Int) {
        for i in 0...4 {
            guard let stars = Array(ratingStackSubviews[...4]) as? [UIImageView] else {
                return
            }
            
            stars[i].image = i < count ? UIImage(named: "Catalog/FilledRatingStar") : UIImage(named: "Catalog/RatingStar")
        }
    }
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .init(700))
        label.textColor = UIColor(named: "Colors/Black")
        
        return label
    }()
    
    private lazy var cartButton = makeButton(imageName: "Catalog/Cart")
    
    private func makeButton(imageName: String) -> UIButton {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: imageName), for: .normal)
        
        return button
    }
    
}

extension ProductCell {
    
    func update(with data: ProductCellData) {
        productNameLabel.text = data.title
        ratingLabel.text = String(data.rating)
        fillStars(count: data.rating)
        priceLabel.text = data.price
    }
    
}
