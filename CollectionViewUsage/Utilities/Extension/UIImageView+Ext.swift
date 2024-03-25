//
//  UIImageView+Ext.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 22.03.2024.
//

import Foundation
import UIKit

extension UIImageView {

    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }.resume()
    }
    
}
