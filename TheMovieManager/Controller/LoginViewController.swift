//
//  LoginViewController.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        TMDBClient.getRequestToken(completion: handleRequestTokenResponse(_:_:))
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    @IBAction func loginViaWebsiteTapped() {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    func handleRequestTokenResponse(_ success: Bool, _ error: Error?) {
        if success {
            print(TMDBClient.Auth.requestToken)
            DispatchQueue.main.async {
                TMDBClient.validateLogin(userName: self.emailTextField.text!, password: self.passwordTextField.text!, completionHandler: self.handleLoginTapped(_:_:))
            }
        }
    }
    
    func handleLoginTapped(_ success: Bool, _ error: Error?) {
        print(TMDBClient.Auth.requestToken)
        TMDBClient.postNewSession(completion: handlePostNewSession)
    }
    
    func handlePostNewSession(_ successFull: Bool, _ error: Error?) {
        if successFull {
            print(TMDBClient.Auth.sessionId)
        }
        print(error)
    }
    
}
