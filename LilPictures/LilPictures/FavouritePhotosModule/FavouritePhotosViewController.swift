//
//  FavouritePhotosViewController.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 07.05.2022.
//

import UIKit

class FavouritePhotosViewController: UIViewController {
    
    //MARK: Properties
    
    var viewModel: FavouritePhotosViewModelProtocol! {
        didSet {
            viewModel.fetchPhotos { [unowned self] in
                favouritePhotosCollectionView.reloadData()
            }
        }
    }
        
    //MARK: - View
    
    private lazy var favouritePhotosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(FavouritePhotoCollectionViewCell.self, forCellWithReuseIdentifier: FavouritePhotoCollectionViewCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        favouritePhotosCollectionView.frame = view.bounds
    }
    
    //MARK: - Private methods
    
    private func setupNavigationBar() {
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [
            
        ]
    }
    
    private func setupCollectionView() {
        view.addSubview(favouritePhotosCollectionView)
        favouritePhotosCollectionView.dataSource = self
        favouritePhotosCollectionView.delegate = self
    }
}


//MARK: - UICollectionViewDataSource

extension FavouritePhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfPhotos
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritePhotoCollectionViewCell.identifier, for: indexPath) as? FavouritePhotoCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.viewModel = self.viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension FavouritePhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension FavouritePhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow = CGFloat(4)
        let paddingWidth = 10 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
