//
//  LoginViewController.swift
//  QuntumTest
//
//  Created by Rajeshwari Sharma on 29/11/23.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FirebaseAuth


class LoginViewController: UIViewController,ASAuthorizationControllerDelegate {

    @IBOutlet weak var Emailfield: UITextField!
    
    @IBOutlet weak var Passwordfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
            Emailfield.resignFirstResponder()
        Passwordfield.resignFirstResponder()
        }
    @IBAction func loginaction(_ sender: Any) {
        if Emailfield.text == "" || Passwordfield.text == "" {
            showAlert(title: "Message", message: "Fields can not be empty")
        } else {
            let email = Emailfield.text ?? ""
            let password = Passwordfield.text ?? ""
            
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    print("Firebase authentication error: \(error.localizedDescription)")
                    // Handle authentication error (e.g., show an alert)
                } else {
                    print("User signed in with email and password")
                    // You can access the user's information via authResult.user
                    
                    
                }
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let nextVC = storyboard.instantiateViewController(identifier: "NewsViewController") as! NewsViewController
                nextVC.hidesBottomBarWhenPushed = true
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true)
            }
        }
      
    }
    
    @IBAction func GoogleAction(_ sender: Any) {
        print("new")
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }

                let user = signInResult.user

                let emailAddress = user.profile?.email

                let fullName = user.profile?.name
                let givenName = user.profile?.givenName
                let familyName = user.profile?.familyName

                let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            print("new",fullName!,emailAddress!,signInResult)
            // If sign in succeeded, display the app's main content View.
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "NewsViewController") as! NewsViewController
            nextVC.hidesBottomBarWhenPushed = true
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
          }
    }
    
    @IBAction func AppleAction(_ sender: Any) {
        requestAppleIDAuthorization()
    }
    func requestAppleIDAuthorization() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(identifier: "NewsViewController") as! NewsViewController
            nextVC.hidesBottomBarWhenPushed = true
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
            // Use userIdentifier, fullName, and email as needed
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle errors
    }


}
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
