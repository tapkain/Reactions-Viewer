//
//  DefaultImageService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation
import Kingfisher

public final class DefaultImageService: ImageService {
    private let kCloudFrontURL = "https://d3a2qf8x1qfhhp.cloudfront.net/"
    public var _tasks: [String : RetrieveImageDownloadTask] = [:]
    
    public func downloadImage(withKey key: String, completion: @escaping ImageServiceCompletion) {
        let cacheType = ImageCache.default.imageCachedType(forKey: key)
        guard cacheType == .none else {
            ImageCache.default.retrieveImage(forKey: key, options: nil) { (image, _) in
                completion(image)
            }
            
            return
        }
        
        guard _tasks[key] == nil, !key.isEmpty else {
            return
        }
        let urlPath = kCloudFrontURL + key
        if let url = URL(string: urlPath) {
            let task = ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
                (image, error, url, data) in
                if let image = image {
                    ImageCache.default.store(image, forKey: key,
                                             toDisk: false)
                }
                self._tasks[key] = nil
                completion(image)
            }
            _tasks[key] = task
        } else {
            completion(nil)
        }
    }
    
    public func cachedImage(withKey key: String) -> UIImage? {
        return ImageCache.default.retrieveImageInMemoryCache(forKey: key)
    }
    
    public func cancelDownload(withKey key: String) {
        _tasks[key]?.cancel()
        _tasks[key] = nil
    }
}
