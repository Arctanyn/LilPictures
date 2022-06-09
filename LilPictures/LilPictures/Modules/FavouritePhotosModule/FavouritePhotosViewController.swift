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
            viewModel.fetchPhotos()
            setEnablingToOptionsButton()
            viewModel.viewModelDidChange = { [unowned self] changedViewModel in
                setEnablingToOptionsButton()
            }
        }
    }
        
    //MARK: - View
    
    private lazy var favouritePhotosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(FavouritePhotoCollectionViewCell.self, forCellWithReuseIdentifier: FavouritePhotoCollectionViewCell.identifier)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    private var menuItems: [UIAction] {
        return [
            UIAction(title: "Delete All", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { [weak self] _ in
                self?.showDeleteAllAlert()
            })
        ]
    }

    private var demoMenu: UIMenu {
        return UIMenu(title: "Options", children: menuItems)
    }
    
    private lazy var optionsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: demoMenu)
        return button
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
            optionsButton
        ]
    }
    
    private func setupCollectionView() {
        view.addSubview(favouritePhotosCollectionView)
        favouritePhotosCollectionView.dataSource = self
        favouritePhotosCollectionView.delegate = self
    }
    
    private func showDeleteAllAlert() {
        let alert = UIAlertController(title: "", message: "All photos will be deleted from favorites", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let delete = UIAlertAction(title: "Delete all", style: .destructive) { [unowned self] _ in
            viewModel.deleteAllPhotos {
                self.favouritePhotosCollectionView.reloadData()
            }
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
    
    private func sharePhoto(with image: UIImage) {
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)
    }
    
    private func setEnablingToOptionsButton() {
        optionsButton.isEnabled = viewModel.numberOfPhotos > 0
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? FavouritePhotoCollectionViewCell else { return }
        viewModel.showDetailedPhoto(with: cell.viewModel.imageData)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                guard
                    let cell = collectionView.cellForItem(at: indexPath) as? FavouritePhotoCollectionViewCell,
                    let image = cell.photoImage
                else { return }
                self?.sharePhoto(with: image)
            }
            let unlike = UIAction(title: "Delete from favorites", image: UIImage(systemName: "heart.slash"), attributes: .destructive) { _ in
                self?.viewModel.deletePhoto(at: indexPath) {
                    self?.favouritePhotosCollectionView.deleteItems(at: [indexPath])
                }
            }
            return UIMenu(title: "", image: nil, children: [share, unlike])
        }
        return configuration
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
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
