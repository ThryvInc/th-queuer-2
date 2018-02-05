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

    func presentErrorMessage(_ errorMessage: String, _ viewController: UIViewController) {
        let alertController = UIAlertController(title: "Ruh roh", message: errorMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: ":(", style: .default, handler: nil)
        alertController.addAction(alertAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
