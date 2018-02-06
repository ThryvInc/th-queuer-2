//
//  ErrorMessage.swift
//  TH Queuer
//
//  Created by Victor Zhong on 2/4/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import UIKit

class ErrorMessage {
    private init () {}
    static let manager = ErrorMessage()

    func presentErrorMessage(_ errorType: AppError, _ viewController: UIViewController) {
        var errorMessage: String

        // All the errors we care about here!
        switch errorType {
        case .noData:
            errorMessage = "Maybe check your internet?"
        case .noInternet:
            errorMessage = "Maybe check your internet?"
        case .wrongLoginCombo:
            errorMessage = "Your username/password combo is incorect!"
        case .cannotParseJSON(let rawError):
            errorMessage = "\(rawError)"
        case .incompleteFields:
            errorMessage = "Please enter in all fields"
        default:
            errorMessage = errorType.localizedDescription
        }

        let alertController = UIAlertController(title: "Ruh roh", message: errorMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: ":(", style: .default, handler: nil)

        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
