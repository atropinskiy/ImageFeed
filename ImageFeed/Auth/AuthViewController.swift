//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by alex_tr on 22.08.2024.
//

import UIKit

final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    
    @IBOutlet private var loginButton: UIButton!
    private let oauth2Service = OAuth2Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        print("AuthViewController loaded.")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowWebView" {
            let authView = segue.destination as? WebViewViewController
            if let unwrappedView = authView {
                unwrappedView.delegate = self
            }
        }
        
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.didAuthenticate(code: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
