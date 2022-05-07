//
//  FavouritePhotoCollectionViewCell.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import UIKit

class FavouritePhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties
    
    static let identifier = "FavouritePhotoCell"
    
    var viewModel: FavouritePhotoCellViewModelProtocol! {
        didSet {
            viewModel.fetchPhoto { [unowned self] imageData in
                guard let imageData = imageData else {
                    photoImageView.image = nil
                    return
                }
                photoImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkMarkImageView.isHidden = false
                photoImageView.layer.opacity = 0.5
            } else {
                checkMarkImageView.isHidden = true
                photoImageView.layer.opacity = 1
            }
        }
    }
    
    //MARK: - View
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        checkMarkImageView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Private methods
    
    private func setConstraints() {
        contentView.addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        contentView.addSubview(checkMarkImageView)
        NSLayoutConstraint.activate([
            checkMarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            checkMarkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
