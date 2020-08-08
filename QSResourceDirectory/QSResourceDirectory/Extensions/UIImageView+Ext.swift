//
//  UIImageView.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//


import UIKit

extension UIImageView {
    func rounded(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }

    func loadURLString(_ urlString: String?) {
        guard let str: String = urlString, let url: URL = URL(string: str) else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }

            var willAnimate = true
            var data: Data? = nil

            if let imgData: Data = ImageCachingService.retrieveImageData(url: url) {
                data = imgData
                willAnimate = false
            }

            if data == nil {
                data = try? Data(contentsOf: url)
            }

            guard let imageData = data, var image: UIImage = UIImage(data: imageData) else {
                return
            }

            ImageCachingService.saveImageData(imageData, url: url)

            if image.size.width != image.size.height {
                image = self.squareImageFromImage(image: image)
            }
            DispatchQueue.main.async {
                self.setImage(image, animated: willAnimate)
            }
        }
    }

    func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }

    //https://stackoverflow.com/questions/48701024/swift-how-to-crop-image-with-always-11-aspect-ratio
    private func squareImageFromImage(image: UIImage) -> UIImage{
        let minSize = min(image.size.width, image.size.height)
        let squareSize = CGSize.init(width: minSize, height: minSize)

        let dx = (minSize - image.size.width) / 2.0
        let dy = (minSize - image.size.height) / 2.0
        UIGraphicsBeginImageContext(squareSize)
        var rect = CGRect.init(x: 0, y: 0, width: minSize, height: minSize)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)

        rect = rect.insetBy(dx: dx, dy: dy)
        image.draw(in: rect, blendMode: CGBlendMode.normal, alpha: 1.0)
        let squareImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return squareImage!
    }
}


