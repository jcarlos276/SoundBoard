//
//  UIViewController + Helpers.swift
//  SoundBoard
//
//  Created by Juan Carlos Guillén Castro on 5/2/18.
//  Copyright © 2018 Juan Carlos Guillén. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate? {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlertWithTitle(title:String, withMessage message:String, withOkButtonTitle okButtonTitle:String = "OK", withOkHandler handler:((_ alertAction:UIAlertAction) -> Void)? = nil, inViewCont viewCont:UIViewController){
        let alertCont = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCont.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: handler))
        viewCont.present(alertCont, animated: true, completion: nil)
    }
}
