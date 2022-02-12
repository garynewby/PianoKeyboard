//
//  FasciaView.swift
//  Example
//
//  Created by Gary Newby on 14/08/2020.
//

import UIKit

class FasciaView: UIView {
    private lazy var fasciaLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [UIColor.darkGray.cgColor, UIColor.lightGray.cgColor, UIColor.black.cgColor]
        layer.startPoint = CGPoint(x: 0.0, y: 0.92)
        layer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(fasciaLayer, at: 0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.insertSublayer(fasciaLayer, at: 0)
    }

    override func layoutSubviews() {
        fasciaLayer.frame = bounds
    }
}
