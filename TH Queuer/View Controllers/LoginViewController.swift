//
//  LoginViewController.swift
//  TH Queuer
//
//  Created by Elliot Schrock on 2/3/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - Properties and Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
    }

    // MARK: - Functions and Methods
    @IBAction func loginpressed(_ sender: Any) {
        let completion = { (data: Data?) in
            if let _ = data, let _ = UserDefaults.standard.string(forKey: "apiKey") {
                self.performSegue(withIdentifier: "projects", sender: self)
            } 
        }

        let errorHandling = { (error: Error?) in
            if let error = error as? AppError {
                ErrorMessage.manager.presentErrorMessage(error, self)
            }
        }

        if let username = usernameField.text, let password = passwordField.text {
            if username != "" && password != "" {
                LoginHelper.manager.makeRequest(username,
                                                password,
                                                completionHandler: completion,
                                                errorHandler: errorHandling)
            } else {
                ErrorMessage.manager.presentErrorMessage(.incompleteFields, self)
            }
        }
    }
}

// MARK: - TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameField:
            passwordField.becomeFirstResponder()
        case passwordField:
            loginpressed(self)
            fallthrough
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}
