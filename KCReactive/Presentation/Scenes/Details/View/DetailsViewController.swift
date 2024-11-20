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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var transformationsCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
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
        bindViewModel()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        self.title = vm.heroe.name
        if let url = URL(string: vm.heroe.photo) {
            self.imageView.loadImageRemote(url: url)
        }
        self.descriptionLabel.text = vm.heroe.description
        
        // Configuración inicial del CollectionView
        transformationsCollectionView.isHidden = true
        transformationsCollectionView.register(UINib(nibName: "TransformationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TransformationCell")
        transformationsCollectionView.dataSource = self
        transformationsCollectionView.delegate = self
    }
    
    private func bindViewModel() {
        // Observar cambios en `transformations`
        vm.$transformations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transformations in
                let hasTransformations = transformations != nil
                self?.updateCollectionViewVisibility(hasTransformations: hasTransformations)
                self?.transformationsCollectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    func updateCollectionViewVisibility(hasTransformations: Bool) {
        if hasTransformations {
            transformationsCollectionView.isHidden = false
            collectionViewHeightConstraint.constant = 250 // Altura deseada del CollectionView
        } else {
            transformationsCollectionView.isHidden = true
            collectionViewHeightConstraint.constant = 0 // Altura cero
        }
        
        // Animar los cambios en el layout
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.transformations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformationCell", for: indexPath) as? TransformationCollectionViewCell,
              let transformation = vm.transformations?[indexPath.item] else {
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
