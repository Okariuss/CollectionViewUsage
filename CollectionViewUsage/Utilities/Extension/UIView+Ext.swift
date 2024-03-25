//
//  UIView+Ext.swift
//  CollectionViewUsage
//
//  Created by Okan Orkun on 24.03.2024.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
