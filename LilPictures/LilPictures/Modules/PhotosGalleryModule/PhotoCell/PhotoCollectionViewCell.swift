//
//  PhotoCollectionViewCell.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 03.05.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: Properties

    static let identifier = "PhotoCell"
    
    var photoID: String!
    
    var viewModel: PhotoCollectionViewCellViewModelProtocol! {
        didSet {
            if viewModel.photoID == self.photoID {
                photoImageView.image = nil
                viewModel.fetchPhoto { [weak self] data in
                    guard let imageData = data else { return }
                    self?.photoImageView.image = UIImage(data: imageData)
                }
            } else {
                photoImageView.image = nil
            }
        }
    }
    
    //MARK: - View
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
        let photoImageViewConstraints = [
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(photoImageViewConstraints)
    }
}
