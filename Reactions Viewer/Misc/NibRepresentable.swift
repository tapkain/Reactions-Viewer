//
//  NibRepresentable.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public protocol NibRepresentable: class {
    static var nib: UINib { get }
    static var nibName: String { get }
}

extension NibRepresentable {
    public static var nib: UINib {
        return UINib(nibName: Self.nibName, bundle: nil)
    }
    
    public static var nibName: String {
        return String(describing: self)
    }
}

public protocol IdentifierRepresentable: class {
    static var identifier: String { get }
}

extension IdentifierRepresentable {
    public static var identifier: String {
        return String(describing: self)
    }
}
