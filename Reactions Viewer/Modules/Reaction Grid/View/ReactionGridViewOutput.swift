//
//  ReactionGridViewOutput.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public protocol ReactionGridViewOutput {
    func handleViewDidAppear()
    
    func handleViewDidDisappear()
    
    func handleViewDidLoad()
}

