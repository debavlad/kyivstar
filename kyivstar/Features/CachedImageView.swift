//
//  CachedImageView.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

class CachedImageView: UIImageView {
    private var urlString: String?

    func load(from urlString: String) {
        self.urlString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil


        if let imageFromCache = Cache.shared.get(urlString) {
            self.image = imageFromCache
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                guard let data else { return }

                let imageToCache = UIImage(data: data)
                if self.urlString == urlString {
                    self.image = imageToCache
                }
                Cache.shared.set(imageToCache, key: urlString)
            }
        }.resume()
    }
}
