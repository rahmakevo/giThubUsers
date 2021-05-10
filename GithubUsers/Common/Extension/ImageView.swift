//
//  ImageView.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 10/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import UIKit

extension UIImageView {
   func loadImageViewFromURL(withUrl url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
        .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
        .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                        width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        return self
    }
    
    func loadImageFromURL(withUrl url: URL) -> UIImage {
        if let imageData = try? Data(contentsOf: url) {
            return UIImage(data: imageData)!
        }
        return self
    }
    
}
