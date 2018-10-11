//
//  AuthController.swift
//  Challenge
//
//  Created by Nikita Merkel on 10/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import UIKit
import SVProgressHUD

class AuthController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTargetToTextFields()
    }
    
    override func viewDidLayoutSubviews() {
        setupTextFields()
    }
    
    private func setupTextFields() {
        loginTextField.underlined()
        passwordTextField.underlined()
    }
    
    private func addTargetToTextFields() {
        loginTextField.addTarget(self, action: #selector(observeTextField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(observeTextField), for: .editingChanged)
    }
    
    // Check for non empty text fields
    @objc private func observeTextField() {
        if let loginText = loginTextField.text,
            let passwordText = passwordTextField.text,
            loginText.count > 0 && passwordText.count > 0 {
            isButtonEnabled(true)
        } else {
            isButtonEnabled(false)
        }
    }
    
    private func isButtonEnabled(_ condition: Bool) {
        enterButton.alpha = condition ? 1.0 : 0.5
        enterButton.isUserInteractionEnabled = condition ? true : false
    }
    
    private func presentNewsController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsNavController = storyboard.instantiateViewController(withIdentifier: "newsNav") as! UINavigationController
        
        let snapshot = (UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true))!
        newsNavController.view.addSubview(snapshot)
        UIApplication.shared.keyWindow?.rootViewController = newsNavController
        
        Animations.scaleAndHide(view: snapshot)
    }
    
    @IBAction func loginButtonTapped() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.show()
        
        APIClient.shared().auth(email:loginTextField.text!, password: passwordTextField.text!) { (isSuccess, errorMessage, response) in
            
            if isSuccess {
                guard let accessToken = response?.accessToken else { return }
                
                UserDefaults.standard.set(accessToken, forKey: Constants.accessToken)
                
                SVProgressHUD.dismiss()
                
                self.presentNewsController()
            } else {
                SVProgressHUD.showError(withStatus: errorMessage)
            }
        }
        
        /*APIClient.shared().auth(login: loginTextField.text!, password: passwordTextField.text!) { (isSuccess, errorMessage, response) in
            if isSuccess {
                guard let accessToken = response?.accessToken else { return }
                
                UserDefaults.standard.set(accessToken, forKey: Constants.token)
                
                SVProgressHUD.dismiss()
                
                self.presentSMSController()
            } else {
                print("ERROR OCCURRED - \(errorMessage)")
                SVProgressHUD.showError(withStatus: errorMessage)
            }
        }*/
    }
}
