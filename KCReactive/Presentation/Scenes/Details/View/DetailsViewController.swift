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
    private var vm: DetailsViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var transformationsCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Initializer
    init(viewModel: DetailsViewModel) {
        self.vm = viewModel
        super.init(nibName: "DetailsViewController", bundle: nil)
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
    
    // MARK: - Private Methods
    private func setupUI() {
        self.title = vm.hero.name
        // Configuración de la imagen
        setupImageView()
        // Configuración de la descripción
        setupDescriptionLabel()
        // Configuración del CollectionView
        setupCollectionView()
    }
    
    private func setupImageView() {
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray4.cgColor
        
        if let url = URL(string: vm.hero.photo) {
            self.imageView.loadImageRemote(url: url)
        }
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = vm.hero.description
    }
    
    private func setupCollectionView() {
        transformationsCollectionView.isHidden = true
        transformationsCollectionView.register(UINib(nibName: "TransformationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TransformationCell")
        transformationsCollectionView.dataSource = self
        transformationsCollectionView.delegate = self
    }
    
    private func setupBindings() {
        // Observar cambios en `transformations`
        vm.$transformations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transformations in
                self?.updateCollectionView(transformations: transformations)
            }
            .store(in: &subscriptions)
    }
    
    private func setupAnimations() {
        // Animación de la imagen
        imageView.alpha = 0
        imageView.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.imageView.alpha = 1
            self.imageView.transform = .identity
        }, completion: nil)
        
        // Animación de la descripción
        descriptionLabel.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseOut, animations: {
            self.descriptionLabel.alpha = 1
        }, completion: nil)
    }
    
    private func updateCollectionView(transformations: [Transformation]?) {
        let hasTransformations = transformations != nil && !(transformations?.isEmpty ?? true)
        transformationsCollectionView.reloadData()
        updateCollectionViewVisibility(hasTransformations: hasTransformations)
    }
    
    private func updateCollectionViewVisibility(hasTransformations: Bool) {
        if hasTransformations {
            transformationsCollectionView.isHidden = false
            collectionViewHeightConstraint.constant = 250
            self.view.layoutIfNeeded()
            
            transformationsCollectionView.transform = CGAffineTransform(translationX: 0, y: self.transformationsCollectionView.bounds.height)
            
            UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseOut, animations: {
                self.transformationsCollectionView.transform = .identity
            }, completion: nil)
        } else {
            // Animar el collectionView para que se desplace hacia abajo y luego ocultarlo
            UIView.animate(withDuration: 0.6, animations: {
                self.transformationsCollectionView.transform = CGAffineTransform(translationX: 0, y: self.transformationsCollectionView.bounds.height)
            }, completion: { _ in
                self.transformationsCollectionView.isHidden = true
                self.transformationsCollectionView.transform = .identity
                self.collectionViewHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
}
// MARK: - UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.transformations?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformationCell", for: indexPath) as? TransformationCollectionViewCell,
            let transformation = vm.transformations?[indexPath.item]
        else {
            return UICollectionViewCell()
        }
        
        // Configurar celda
        cell.configure(with: transformation)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Tamaño de las celdas
        let width = collectionView.frame.width / 2 - 10
        return CGSize(width: width, height: 250)
    }
}
