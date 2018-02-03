//
//  ProjectsViewController.swift
//  TH Queuer
//
//  Created by Elliot Schrock on 2/3/18.
//  Copyright © 2018 Thryv, Inc. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var projects: Array<Dictionary<String, AnyObject?>>?
    var selProj: Dictionary<String, AnyObject?>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
title = "Projects"
        var request = URLRequest(url: URL(string: "https://queuer-production.herokuapp.com/api/v1/projects")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        tableView.dataSource = self
        tableView.delegate = self
        request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError {
                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                }
                if let jsonData = data {
                    self.projects = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Array<Dictionary<String, AnyObject?>>
                    self.tableView.reloadData()
//                        }catch let jsonError as NSError {
//
//                        }
                }else{
                    
                }
            }
        }).resume()
        navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: Selector("promptProjCreate"))
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc func promptProjCreate() {
        let vc = UIAlertController(title: "Project name", message: nil, preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
            var request = URLRequest(url: URL(string: AppDelegate.PROJECTS_URL)!)
            request.httpBody = try? JSONSerialization.data(withJSONObject: ["project" : ["name": vc.textFields![0].text as? AnyObject, "color": -13508189 as AnyObject]], options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
            request.httpMethod="POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                DispatchQueue.main.async{
                    if let error = optError
                    {
                        UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                    }
                    var request = URLRequest(url: URL(string: "https://queuer-production.herokuapp.com/api/v1/projects")!)
                    request.addValue("application/json", forHTTPHeaderField: "Content-type")
                    request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                        DispatchQueue.main.async{
                            if let error = optError {
                                UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                            }
                            if let jsonData = data {
                                self.projects = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Array<Dictionary<String, AnyObject?>>
                                self.tableView.reloadData()
                                //                        }catch let jsonError as NSError {
                                //
                                //                        }
                            }
                            else{
                            }
                        }
                    }).resume()
                }
            }).resume()
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "project")
        cell?.textLabel?.text = (projects![indexPath.row])["name"]! as? String
        return cell!;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = projects?.count {
            return count
        }
        else
        {
            return 0;
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selProj = projects![indexPath.row];
        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "viewproject", sender: self)
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
