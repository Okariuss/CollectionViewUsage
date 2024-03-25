//
//  AdvanceCollectionViewController.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 24.03.2024.
//

import UIKit
import Combine

final class AdvanceCollectionViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private lazy var viewModel = CollectionViewModel()
    private lazy var cancellables = Set<AnyCancellable>()
    private lazy var photos: [PhotoElement] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
        fetchData()
    }

    private func setupViews() {
        
        view.backgroundColor = .systemBackground
        
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubviews(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppConstants.SpaceConstants.normal.rawValue),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        ])

        collectionView.register(CustomImageCollectionViewCell.self, forCellWithReuseIdentifier: CustomImageCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // Create item size for main item
        let mainItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3),
                                                  heightDimension: .fractionalHeight(1))
        let mainItem = NSCollectionLayoutItem(layoutSize: mainItemSize)
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Create item size for vertical stack item
        let verticalStackItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                           heightDimension: .fractionalHeight(0.5))
        let verticalStackItem = NSCollectionLayoutItem(layoutSize: verticalStackItemSize)
        verticalStackItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Create group size for vertical stack group
        let verticalStackGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                            heightDimension: .fractionalHeight(1))
        let verticalStackGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalStackGroupSize,
                                                                  subitem: verticalStackItem, count: 2)
        
        // Create item size for triplet item
        let tripletItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalWidth(0.3))
        let tripletItem = NSCollectionLayoutItem(layoutSize: tripletItemSize)
        
        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // Create group size for triplet horizontal group
        let tripletHorizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .fractionalWidth(0.3))
        let tripletHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: tripletHorizontalGroupSize,
                                                                        subitem: tripletItem, count: 3)
        
        // Create group size for main horizontal group
        let mainHorizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .fractionalWidth(0.7))
        let mainHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: mainHorizontalGroupSize,
                                                                     subitems: [mainItem, verticalStackGroup])
        
        // Create group size for vertical group
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalHeight(1))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize,
                                                             subitems: [mainHorizontalGroup, tripletHorizontalGroup])
        
        // Create section
        let section = NSCollectionLayoutSection(group: verticalGroup)
        
        // Create layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }


    private func observeViewModel() {
        
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: weakify({ strongSelf, photos in
                strongSelf.photos = photos ?? []
                strongSelf.collectionView.reloadData()
            }))
            .store(in: &cancellables)

        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: weakify({ strongSelf, error in
                if let error = error {
                    strongSelf.handleError(error)
                }
            }))
            .store(in: &cancellables)
    }

    private func fetchData() {
        viewModel.fetchData()
    }

    private func handleError(_ error: Error) {
        print("Error occurred: \(error.localizedDescription)")
    }
}


extension AdvanceCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomImageCollectionViewCell.identifier, for: indexPath) as? CustomImageCollectionViewCell else { fatalError() }
        
        let photo = photos[indexPath.item]
        cell.imageView.loadImage(from: photo.url)
        return cell
    }
}
