//
//  LoginViewController.swift
//  TH Queuer
//
//  Created by Elliot Schrock on 2/3/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameFiedl: UITextField!
    @IBOutlet weak var password_field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginpressed(_ sender: Any) {
        var request = URLRequest(url: URL(string: "https://queuer-production.herokuapp.com/api/v1/session")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["username": usernameFiedl.text, "password": password_field.text], options: .prettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError {
                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                }
                if let code = (response as? HTTPURLResponse)?.statusCode {
                    if let jsonData = data {
                        do {
                            let dict = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
                            UserDefaults.standard.set(dict?["api_key"], forKey: "apiKey")
                            self.performSegue(withIdentifier: "projects", sender: self)
                        }catch let jsonError as NSError {
                            
                        }
                    }else{
                    }
                }
            }
        }).resume()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
