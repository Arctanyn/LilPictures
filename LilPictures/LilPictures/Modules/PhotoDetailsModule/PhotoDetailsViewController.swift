//
//  PhotoDetailsViewController.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 04.05.2022.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    //MARK: Properties
    
    var viewModel: PhotoDetailsViewModelProtocol! {
        didSet {
            updateUI()
            
            viewModel.viewModelDidChange = { [unowned self] changedViewModel in
                setupFavouriteButton(status: changedViewModel.isFavourite)
            }
        }
    }
    
    //MARK: - View
    
    private let containerView = UIView()
    private let scrollView = UIScrollView()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let photoContainerView: UIView = {
        let photoContainer = UIView()
        photoContainer.translatesAutoresizingMaskIntoConstraints = false
        photoContainer.layer.cornerRadius = 10
        return photoContainer
    }()
    
    private lazy var detailedPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var bluredPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.layer.masksToBounds = true
        blurView.layer.cornerRadius = 5
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: "heart",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal
        )
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(favouriteButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(systemName: "square.and.arrow.up",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 23)), for: .normal
        )
        button.tintColor = .label
        button.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var descriptionBlockLabel: UILabel = {
        let label = UILabel()
        label.text = "Description:"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var photoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2
        scrollView.contentSize = CGSize(
            width: containerView.bounds.width,
            height: containerView.bounds.height
        )
    }
    
    //MARK: - Ations
    
    @objc private func closeButtonTapped(_ sender: UIButton) {
        guard sender == closeButton else { return }
        self.dismiss(animated: true)
    }
    
    @objc private func shareButtonTapped(_ sender: UIButton) {
        guard sender == shareButton else { return }
        viewModel.fetchFullPhoto { [weak self] imageData in
            guard let imageData = imageData,
                  let fullImage = UIImage(data: imageData)
            else { return }
            self?.presentActivityController(with: fullImage)
        }
    }
    
    @objc private func favouriteButtonTapped(_ sender: UIButton) {
        guard sender == favouriteButton else { return }
        favouriteButton.dentAnimation()
        viewModel.toggleFavouriteStatus()
    }
    
    //MARK: - Private methods
    
    private func updateUI() {
        userNameLabel.text = viewModel.userName
        
        if let photoDescription = viewModel.photoDescription {
            photoDescriptionLabel.text = photoDescription
        } else {
            photoDescriptionLabel.text = "No description"
            photoDescriptionLabel.textColor = .lightGray
        }
        
        setupFavouriteButton(status: viewModel.isFavourite)
        
        updateImages()
    }
    
    private func updateImages() {
        viewModel.fetchDetailedPhoto { [unowned self] imageData in
            guard
                let imageData = imageData,
                let detailedImage = UIImage(data: imageData)
            else { return }
            detailedPhotoImageView.image = detailedImage
            bluredPhotoImageView.image = detailedImage
        }
        
        viewModel.fetchUserProfilePhoto { [unowned self] imageData in
            guard
                let imageData = imageData,
                let userImage = UIImage(data: imageData)
            else { return }
            userProfileImageView.image = userImage
        }
    }
    
    private func setupFavouriteButton(status: Bool) {
        if status {
            favouriteButton.tintColor = .systemRed
            favouriteButton.setImage(
                UIImage(systemName: "heart.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal
            )
        } else {
            favouriteButton.tintColor = .lightGray
            favouriteButton.setImage(
                UIImage(systemName: "heart",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)), for: .normal
            )
        }
    }
    
    private func presentActivityController(with image: UIImage) {
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share, animated: true)
    }
    
    //MARK: - Constraints
        
    private func setConstraints() {
        setScrollViewConstraints()
        setContainerViewConstraints()
        
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        ])
        
        setUserInfoBlockConstraints()
        setDetailedPhotoBlockConstraints()
        setPhotoActionButtonsBlockConstraints()
        setPhotoDescriptionBlockConstraints()

    }
    
    private func setScrollViewConstraints() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setContainerViewConstraints() {
        scrollView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setUserInfoBlockConstraints() {
        containerView.addSubview(userProfileImageView)
        let userProfileImageViewConstraints = [
            userProfileImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            userProfileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            userProfileImageView.heightAnchor.constraint(equalToConstant: 40),
            userProfileImageView.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        containerView.addSubview(userNameLabel)
        let userNameLabelConstraints = [
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            userNameLabel.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor),
            userNameLabel.heightAnchor.constraint(equalTo: userProfileImageView.heightAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(userProfileImageViewConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
    }
    
    private func setDetailedPhotoBlockConstraints() {
        containerView.addSubview(photoContainerView)
        let photoContainerViewConstraints = [
            photoContainerView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20),
            photoContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            photoContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            photoContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ]
        
        photoContainerView.addSubview(bluredPhotoImageView)
        let bluredPhotoImageViewConstraints = [
            bluredPhotoImageView.topAnchor.constraint(equalTo: photoContainerView.topAnchor),
            bluredPhotoImageView.leadingAnchor.constraint(equalTo: photoContainerView.leadingAnchor),
            bluredPhotoImageView.trailingAnchor.constraint(equalTo: photoContainerView.trailingAnchor),
            bluredPhotoImageView.bottomAnchor.constraint(equalTo: photoContainerView.bottomAnchor)
        ]
        
        photoContainerView.addSubview(blurEffectView)
        let bluredEffectViewConstraints = [
            blurEffectView.topAnchor.constraint(equalTo: photoContainerView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: photoContainerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: photoContainerView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: photoContainerView.bottomAnchor)
        ]
        
        containerView.addSubview(detailedPhotoImageView)
        let detailedPhotoImageViewConstraints = [
            detailedPhotoImageView.topAnchor.constraint(equalTo: photoContainerView.topAnchor),
            detailedPhotoImageView.leadingAnchor.constraint(equalTo: photoContainerView.leadingAnchor),
            detailedPhotoImageView.trailingAnchor.constraint(equalTo: photoContainerView.trailingAnchor),
            detailedPhotoImageView.bottomAnchor.constraint(equalTo: photoContainerView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(photoContainerViewConstraints)
        NSLayoutConstraint.activate(bluredPhotoImageViewConstraints)
        NSLayoutConstraint.activate(bluredEffectViewConstraints)
        NSLayoutConstraint.activate(detailedPhotoImageViewConstraints)
    }
    
    private func setPhotoActionButtonsBlockConstraints() {
        containerView.addSubview(favouriteButton)
        let favouriteButtonConstrains = [
            favouriteButton.topAnchor.constraint(equalTo: detailedPhotoImageView.bottomAnchor, constant: 12),
            favouriteButton.leadingAnchor.constraint(equalTo: detailedPhotoImageView.leadingAnchor),
        ]
        
        containerView.addSubview(shareButton)
        let shareButtonConstraints = [
            shareButton.bottomAnchor.constraint(equalTo: favouriteButton.bottomAnchor),
            shareButton.leadingAnchor.constraint(equalTo: favouriteButton.trailingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(favouriteButtonConstrains)
        NSLayoutConstraint.activate(shareButtonConstraints)
    }
    
    private func setPhotoDescriptionBlockConstraints() {
        containerView.addSubview(descriptionBlockLabel)
        let descriptionBlockLabelConstraints = [
            descriptionBlockLabel.topAnchor.constraint(equalTo: favouriteButton.bottomAnchor, constant: 10),
            descriptionBlockLabel.leadingAnchor.constraint(equalTo: favouriteButton.leadingAnchor),
            descriptionBlockLabel.trailingAnchor.constraint(equalTo: photoContainerView.trailingAnchor)
        ]
        
        containerView.addSubview(photoDescriptionLabel)
        let photoDescriptionLabelConstraints = [
            photoDescriptionLabel.topAnchor.constraint(equalTo: descriptionBlockLabel.bottomAnchor, constant: 5),
            photoDescriptionLabel.leadingAnchor.constraint(equalTo: descriptionBlockLabel.leadingAnchor),
            photoDescriptionLabel.trailingAnchor.constraint(equalTo: descriptionBlockLabel.trailingAnchor),
            photoDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(descriptionBlockLabelConstraints)
        NSLayoutConstraint.activate(photoDescriptionLabelConstraints)
    }

}
