import UIKit
import Combine
import Kingfisher

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
        title = viewModel.hero.name
        setupImageView()
        setupDescriptionLabel()
        setupFavoriteImage()
        setupCollectionView()
    }

    private func setupImageView() {
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.borderDarkAndLight.cgColor
        
        if let url = URL(string: viewModel.hero.photo) {
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "person"),
                options: [.transition(.fade(0.3)), .cacheOriginalImage]
            )
        }
    }

    private func setupDescriptionLabel() {
        descriptionLabel.text = viewModel.hero.description
    }

    private func setupFavoriteImage() {
        let favoriteButton = UIButton(type: .custom)
        updateFavoriteButtonAppearance(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        
        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateFavoriteButtonAppearance(favoriteButton)
            }
            .store(in: &subscriptions)
    }

    private func updateFavoriteButtonAppearance(_ button: UIButton) {
        button.backgroundColor = viewModel.isFavorite ? .systemOrange : .systemGray6
        button.setImage(UIImage(systemName: viewModel.isFavorite ? "star.fill" : "star"), for: .normal)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.layer.borderWidth = 0.2
        button.tintColor = .systemYellow
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        button.fadeIn(duration: 0.3)
    }

    @objc private func didTapFavoriteButton() {
        viewModel.toggleFavorite()
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
        let hasTransformations = !(transformations?.isEmpty ?? true)
        transformationsCollectionView.reloadData()
        updateCollectionViewVisibility(hasTransformations: hasTransformations)
    }

    private func updateCollectionViewVisibility(hasTransformations: Bool) {
        guard hasTransformations else { return }
        transformationsCollectionView.isHidden = false
        collectionViewHeightConstraint.constant = 250
        view.layoutIfNeeded()
        transformationsCollectionView.animateFromBottom(yOffset: transformationsCollectionView.bounds.height)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.transformations?.count ?? 0
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
