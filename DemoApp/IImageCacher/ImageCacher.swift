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
    
    private init() {} // Prevent external instantiation
    
    // Fetch image from cache or download if not cached
    func fetchImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        // Check if image is in cache
        if let cachedImage = cache.object(forKey: url as NSString) {
            completion(cachedImage)
            return
        }
        
        // Download image if not in cache
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                // Cache the downloaded image
                self.cache.setObject(image, forKey: url as NSString)
                
                // Return the downloaded image
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                // If download fails
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    // Helper function to retrieve a cached image
    func getCachedImage(for url: String) -> UIImage? {
        return cache.object(forKey: url as NSString)
    }
}
