//
//  CustomCollectionViewCell.swift
//  ListingAssignment2
//
//  Created by Hemant Sharma on 29/07/21.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    internal lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var categoryName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var radioImageView: UIImageView = {
        let radioButtonView = UIImageView()
        radioButtonView.translatesAutoresizingMaskIntoConstraints = false
        radioButtonView.image = UIImage(named: "ic_address_checkbox_off")
        return radioButtonView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        styleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterCollectionViewCell {
    
    private func styleView() {
        
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        containerView.addSubview(radioImageView)
        radioImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            radioImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            radioImageView.widthAnchor.constraint(equalToConstant: 24),
            radioImageView.heightAnchor.constraint(equalToConstant: 24),
            radioImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        containerView.addSubview(categoryName)
        NSLayoutConstraint.activate([
            
            categoryName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            categoryName.leadingAnchor.constraint(equalTo: radioImageView.trailingAnchor, constant: 8),
            categoryName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
            
        ])
    }
    
    public func configure(filterCategoryName: String?, isSelected: Bool = false) {
        categoryName.text = filterCategoryName
        if isSelected {
            radioImageView.image = UIImage(named: "ic_address_checkbox_on")
        } else {
            radioImageView.image = UIImage(named: "ic_address_checkbox_off")
        }
    }
}
