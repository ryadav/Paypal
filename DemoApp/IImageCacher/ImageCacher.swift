//
//  ImageCacher.swift
//  DemoApp
//
//  Created by Apple on 23/10/2024.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func fetchImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSString) {
            completion(cachedImage)
            return
        }
        
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func getCachedImage(for url: String) -> UIImage? {
        return cache.object(forKey: url as NSString)
    }
}
