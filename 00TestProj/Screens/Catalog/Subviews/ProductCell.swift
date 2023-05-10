//
//  ProductCell.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit
import Kingfisher

final class ProductCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photorImageView)
        contentView.addSubview(likeButton)
        likeButton.addSubview(likeButtonLoadingIndicator)
        contentView.addSubview(compareButton)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(ratingStack)
        contentView.addSubview(priceLabel)
        contentView.addSubview(cartButton)

        NSLayoutConstraint.activate(
            [
                photorImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                photorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                photorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                
                likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                likeButton.trailingAnchor.constraint(equalTo: photorImageView.trailingAnchor, constant: -5),
                
                likeButtonLoadingIndicator.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor),
                likeButtonLoadingIndicator.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
                
                compareButton.topAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 8),
                compareButton.trailingAnchor.constraint(equalTo: photorImageView.trailingAnchor, constant: -5),
                
                productNameLabel.topAnchor.constraint(equalTo: photorImageView.bottomAnchor, constant: 12),
                productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                productNameLabel.trailingAnchor.constraint(equalTo: photorImageView.trailingAnchor),
                
                ratingStack.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 10),
                ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                
                priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                
                cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                cartButton.trailingAnchor.constraint(equalTo: photorImageView.trailingAnchor),
            ]
        )
        
        likeButton.addTarget(
            self,
            action: #selector(onLikeButton),
            for: .touchUpInside
        )
    }
    
    var onLike: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private lazy var photorImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var likeButton = makeButtonWithShadow(imageName: "Catalog/Like")
    
    private lazy var likeButtonLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(named: "Colors/Black")
        
        return indicator
    }()
    
    private lazy var compareButton = makeButtonWithShadow(imageName: "Catalog/Compare")
    
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
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Catalog/Cart"), for: .normal)
        
        return button
    }()
    
    private func makeButtonWithShadow(imageName: String) -> UIButton {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: imageName), for: .normal)

        button.layer.shadowColor = UIColor(named: "Colors/LightShadow")?.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 8

        return button
    }
    
    @objc
    func onLikeButton() {
        onLike?()
    }
    
}

extension ProductCell {
    
    func update(with data: ProductCellData) {
        productNameLabel.text = data.title
        photorImageView.kf.setImage(
            with: data.imageURL,
            placeholder: UIImage(named: "Catalog/PhotoPlaceholder"),
            options: [
                .transition(.fade(0.25)),
                .processor(
                    DownsamplingImageProcessor(
                        size: .init(width: 165, height: 220)
                    )
                )
            ]
        )
        
        ratingLabel.text = String(data.rating)
        fillStars(count: data.rating)
        priceLabel.text = data.price
        
        data.onFavoriteSubscriber(self) { [weak self] state in
            self?.updateLikeButtonState(state: state)
        }
        
        onLike = data.onFavoriteSelect
    }
    
    func updateLikeButtonState(state: CellButtonState) {
        likeButtonLoadingIndicator.stopAnimating()
        
        if state.isLoading {
            likeButton.setImage(UIImage(named: "Catalog/CircleButtonBlank"), for: .normal)
            likeButtonLoadingIndicator.startAnimating()
            return
        }
        
        if state.isSelected {
            likeButton.setImage(UIImage(named: "Catalog/FilledLike"), for: .normal)
            return
        }
        
        likeButton.setImage(UIImage(named: "Catalog/Like"), for: .normal)
    }
    
}
