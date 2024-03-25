//
//  HomeViewController.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 22.03.2024.
//

import UIKit
import Combine

class CollectionViewController: UIViewController {
    private var collectionView: UICollectionView!
    private lazy var viewModel = CollectionViewModel()
    private lazy var cancellables = Set<AnyCancellable>()
    private lazy var photos: [PhotoElement] = []
    
    private var headerView: CustomHeaderCollectionViewCell!
    private var footerView: CustomFooterCollectionViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        observeViewModel()
        fetchData()
    }

    private func setupViews() {
        
        view.backgroundColor = .systemBackground
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubviews(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppConstants.SpaceConstants.normal.rawValue),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppConstants.SpaceConstants.normal.rawValue),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        ])

        collectionView.register(CustomImageCollectionViewCell.self, forCellWithReuseIdentifier: CustomImageCollectionViewCell.identifier)
        collectionView.register(CustomHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderCollectionViewCell.identifier)
        collectionView.register(CustomFooterCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CustomFooterCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat.deviceWidth/2-AppConstants.SpaceConstants.high.rawValue, height: CGFloat.deviceHeight/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomHeaderCollectionViewCell.identifier, for: indexPath) as? CustomHeaderCollectionViewCell else {
                fatalError()
            }
            self.headerView = headerView
            headerView.configure(with: "This is header")
            return headerView
        case UICollectionView.elementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomFooterCollectionViewCell.identifier, for: indexPath) as? CustomFooterCollectionViewCell else {
                fatalError()
            }
            self.footerView = footerView
            footerView.configure(with: "This is footer")
            return footerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}


