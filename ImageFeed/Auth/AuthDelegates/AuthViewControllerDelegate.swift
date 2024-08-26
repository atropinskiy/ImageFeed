//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by alex_tr on 23.08.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(code: String)
}
