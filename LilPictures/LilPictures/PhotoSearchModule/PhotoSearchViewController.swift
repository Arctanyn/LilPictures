//
//  PhotoSearchViewController.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import UIKit

class PhotoSearchViewController: UIViewController {
    
    //MARK: Properties
    
    var viewModel: PhotoSearchViewModelProtocol! {
        didSet {
            photoSearchResultCollectionView.reloadData()
        }
    }
    
    //MARK: - View
    
    private lazy var photoSearchResultCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
    }

    override func viewDidLayoutSubviews() {
        photoSearchResultCollectionView.frame = view.bounds
    }
    
    //MARK: - Private methods
    
    private func setupCollectionView() {
        view.addSubview(photoSearchResultCollectionView)
        photoSearchResultCollectionView.dataSource = self
        photoSearchResultCollectionView.delegate = self
    }
}

//MARK: - UICollectionViewDataSource

extension PhotoSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel != nil {
            return viewModel.numberOfPhotos
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.photoID = self.viewModel.photoIDForCell(at: indexPath)
        cell.viewModel = self.viewModel.photoForCell(at: indexPath)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PhotoSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = CGFloat(3)
        let paddingWidth = 20 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

//MARK: - UICollectionViewDelegate

extension PhotoSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showPhotoDetailsForCell(at: indexPath)
    }
}
