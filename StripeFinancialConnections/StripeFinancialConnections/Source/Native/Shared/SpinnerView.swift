//
//  SpinnerView.swift
//  StripeFinancialConnections
//
//  Created by Krisjanis Gaidis on 1/9/24.
//

import Foundation
@_spi(STP) import StripeUICore
import UIKit

final class SpinnerView: UIView {

    private let theme: FinancialConnectionsTheme?
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: Image.spinner.makeImage(template: true))
        imageView.tintColor = theme.spinnerColor
        return imageView
    }()
    private let animationKey = "animation_key"

    init(theme: FinancialConnectionsTheme?, shouldStartAnimating: Bool = true) {
        self.theme = theme
        super.init(frame: .zero)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        if shouldStartAnimating {
            startAnimating()
        }
    }

    func startAnimating() {
        let rotatingAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotatingAnimation.byValue = 2 * Float.pi
        rotatingAnimation.duration = 0.7
        rotatingAnimation.isAdditive = true
        rotatingAnimation.repeatCount = .infinity
        imageView.layer.add(rotatingAnimation, forKey: animationKey)
    }

    func stopAnimating() {
        imageView.layer.removeAnimation(forKey: animationKey)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if DEBUG

import SwiftUI

private struct SpinnerViewUIViewRepresentable: UIViewRepresentable {
    let theme: FinancialConnectionsTheme?

    func makeUIView(context: Context) -> SpinnerView {
        SpinnerView(theme: theme)
    }

    func updateUIView(_ uiView: SpinnerView, context: Context) {}
}

struct SpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SpinnerViewUIViewRepresentable(theme: .light)
            SpinnerViewUIViewRepresentable(theme: .linkLight)
            SpinnerViewUIViewRepresentable(theme: nil)
        }
    }
}

#endif
