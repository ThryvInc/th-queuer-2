//
//  AppError.swift
//  TH Queuer
//
//  Created by Victor Zhong on 2/4/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import Foundation

enum AppError: Error {
    case badURL(url: String)
    case badData
    case noData
    case noInternet
    case badResponseCode(code: Int)
    case cannotParseJSON(rawError: Error)
    case wrongLoginCombo
    case incompleteFields
    case other(rawError: Error)
}
