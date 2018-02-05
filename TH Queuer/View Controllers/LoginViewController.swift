//
//  LoginViewController.swift
//  TH Queuer
//
//  Created by Elliot Schrock on 2/3/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: - Properties and Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Functions and Methods
    @IBAction func loginpressed(_ sender: Any) {
        let completion = { (data: Data?) in
            if let _ = data {
                self.performSegue(withIdentifier: "projects", sender: self)
            }
        }

        let errorHandling = { (error: Error?) in
            if let error = error as? AppError {
                let errorMessage: String

                switch error {
                case .noData:
                    errorMessage = "Maybe check your internet?"
                case .wrongLoginCombo:
                    errorMessage = "Your username/password combo is incorect!"
                case.cannotParseJSON(let rawError):
                    errorMessage = "\(rawError)"
                default:
                    errorMessage = error.localizedDescription
                }

                ErrorMessage.manager.presentErrorMessage(errorMessage, self)
            }
        }

        if let username = usernameField.text, let password = passwordField.text {
            if username != "" && password != "" {
                LoginHelper.manager.makeRequest(username,
                                                password,
                                                completionHandler: completion,
                                                errorHandler: errorHandling)
            } else {
                ErrorMessage.manager.presentErrorMessage("Please enter in all fields!", self)
            }
        }

        //        var request = URLRequest(url: URL(string: AppDelegate.sessionURL)!)
        //
        //        request.httpMethod = "POST"
        //        request.httpBody = try? JSONSerialization.data(withJSONObject: ["username": usernameField.text, "password": passwordField.text], options: .prettyPrinted)
        //        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        //        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
        //            DispatchQueue.main.async {
        //                if let error = optError {
        //                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
        //                }
        //                if let code = (response as? HTTPURLResponse)?.statusCode {
        //                    if let jsonData = data {
        //                        do {
        //                            let dict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
        //                            UserDefaults.standard.set(dict?["api_key"], forKey: "apiKey")
        //                            self.performSegue(withIdentifier: "projects", sender: self)
        //                        } catch let jsonError as NSError {
        //
        //                        }
        //                    }
        //                }
        //            }
        //        }).resume()
    }

}
