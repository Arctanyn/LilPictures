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
            viewModel.fetchPhoto { [weak self] imageData in
                guard let imageData = imageData else {
                    self?.photoImageView.image = nil
                    return
                }
                self?.photoImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    //MARK: - View
    
    var photoImage: UIImage? {
        photoImageView.image
    }
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
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
    }
}
