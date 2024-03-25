//
//  HomeViewModel.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 22.03.2024.
//

import Foundation
import Combine

final class CollectionViewModel: Weakifiable {
    private var cancellables = Set<AnyCancellable>()
    private let networkManager = NetworkManager.shared
    
    @Published private(set) var photos: Photo?
    @Published private(set) var error: Error?
    
    func fetchData() {
        networkManager.request(endpoint: .getImages)
            .sink(receiveCompletion: weakify { (strongSelf, completion) in
                switch completion {
                case .failure(let error):
                    strongSelf.error = error
                case .finished:
                    break
                }
            }, receiveValue: weakify { (strongSelf, photos: [PhotoElement]) in
                strongSelf.photos = photos
            })
            .store(in: &cancellables)
    }
}
