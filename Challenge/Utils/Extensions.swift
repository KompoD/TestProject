//
//  Extensions.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(fromUrl url: URL) {
        print("Loading image")
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension UIImageView {
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        let imageCache = NSCache<NSString, UIImage>()
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}

extension UITextField {
    // Make textfield underlined
    func underlined() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension String {
    func htmlAttributedString(fontSize: CGFloat = 14.0) -> NSAttributedString? {
        let fontName = UIFont.systemFont(ofSize: fontSize).fontName
        let string = self.appending(String(format: "<style>body{font-family: '%@'; font-size:%fpx;}</style>", fontName, fontSize))
        guard let data = string.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        
        guard let html = try? NSMutableAttributedString (
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        return html
    }
}

