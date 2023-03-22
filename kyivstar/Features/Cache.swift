//
//  Cache.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

class Cache {
    static let shared = Cache()

    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol?

    private init() {
        observer = NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }

    func set(_ image: UIImage?, key: String) {
        guard let image else { return }
        cache.setObject(image, forKey: key as NSString)
    }

    func get(_ key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    deinit {
        NotificationCenter.default.removeObserver(observer!)
    }
}
