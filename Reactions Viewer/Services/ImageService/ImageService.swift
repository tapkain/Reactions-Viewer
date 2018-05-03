//
//  ImageService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public protocol ImageService {
    typealias ImageServiceCompletion = (UIImage?) -> Void
    func downloadImage(withKey key: String, completion: @escaping ImageServiceCompletion)
    func cachedImage(withKey key: String) -> UIImage?
    func cancelDownload(withKey key: String)
}
