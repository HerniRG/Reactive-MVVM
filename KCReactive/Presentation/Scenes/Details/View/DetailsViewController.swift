//
//  DetailsViewController.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 19/11/24.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: DetailsViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var transformationsCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Initializer
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: DetailsViewController.self), bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupAnimations()
    }
}

// MARK: - UI Setup
extension DetailsViewController {
    private func setupUI() {
        self.title = viewModel.hero.name
        setupImageView()
        setupDescriptionLabel()
        setupFavoriteImage()
        setupCollectionView()
    }
    
    private func setupImageView() {
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        
        if let url = URL(string: viewModel.hero.photo) {
            self.imageView.loadImageRemote(url: url)
        }
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = viewModel.hero.description
    }
    
    private func setupFavoriteImage() {
        // Configura la imagen según el estado de `hero.favorite`
        let favoriteImageName = viewModel.hero.favorite ?? false ? "star.fill" : "star"
        let favoriteImage = UIImage(systemName: favoriteImageName)
        
        // Crea un UIImageView con la imagen
        let favoriteImageView = UIImageView(image: favoriteImage)
        favoriteImageView.contentMode = .scaleAspectFit
        favoriteImageView.tintColor = .systemYellow // Color de la estrella
        favoriteImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24) // Ajustar tamaño si es necesario

        // Crea un UIBarButtonItem con el UIImageView como customView
        let barButtonItem = UIBarButtonItem(customView: favoriteImageView)
        
        // Añade la imagen al lado derecho del UINavigationBar
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func setupCollectionView() {
        transformationsCollectionView.isHidden = true
        transformationsCollectionView.register(UINib(nibName: "TransformationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TransformationCell")
        transformationsCollectionView.dataSource = self
        transformationsCollectionView.delegate = self
    }
}

// MARK: - Bindings
extension DetailsViewController {
    private func setupBindings() {
        viewModel.$transformations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transformations in
                self?.updateCollectionView(transformations: transformations)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Animations
extension DetailsViewController {
    private func setupAnimations() {
        imageView.fadeInWithTranslation(yOffset: 20, duration: 0.6)
        descriptionLabel.fadeIn(duration: 0.4, delay: 0.3)
    }
}

// MARK: - CollectionView Updates
extension DetailsViewController {
    private func updateCollectionView(transformations: [Transformation]?) {
        let hasTransformations = transformations != nil && !(transformations?.isEmpty ?? true)
        transformationsCollectionView.reloadData()
        updateCollectionViewVisibility(hasTransformations: hasTransformations)
    }
    
    private func updateCollectionViewVisibility(hasTransformations: Bool) {
        guard hasTransformations else { return } // Si no hay transformaciones, no hacemos nada

        // Muestra la collectionView
        transformationsCollectionView.isHidden = false
        collectionViewHeightConstraint.constant = 250
        self.view.layoutIfNeeded()

        // Anima la entrada de la collectionView desde fuera de pantalla
        transformationsCollectionView.animateFromBottom(yOffset: transformationsCollectionView.bounds.height)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.transformations?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformationCell", for: indexPath) as? TransformationCollectionViewCell,
            let transformation = viewModel.transformations?[indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: transformation)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 10
        return CGSize(width: width, height: 250)
    }
}
