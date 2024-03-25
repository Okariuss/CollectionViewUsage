//
//  WaterfallCollectionViewViewController.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 25.03.2024.
//

import UIKit
import Combine
import CHTCollectionViewWaterfallLayout

final class WaterfallCollectionViewController: UIViewController {
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func setupViews() {
        
        view.backgroundColor = .systemBackground
        
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubviews(collectionView)

        collectionView.register(CustomImageCollectionViewCell.self, forCellWithReuseIdentifier: CustomImageCollectionViewCell.identifier)
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

extension WaterfallCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomImageCollectionViewCell.identifier, for: indexPath) as? CustomImageCollectionViewCell else { fatalError() }
        
        let photo = photos[indexPath.item]
        cell.imageView.loadImage(from: photo.url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let randomHeight = CGFloat.random(in: 200...400)
        return CGSize(width: collectionView.bounds.width/2, height: randomHeight)
    }
}
