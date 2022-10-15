//
//  CGSize+ScaledSize.swift
//
//  Created by Willy on 11/10/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
