//
//  Alertable.swift
//  Workouter
//
//  Created by 이종현 on 2023/07/06.
//

import UIKit

protocol Alertable {}
extension Alertable where Self: UIViewController {
    
    func showAlert(
        title: String,
        message: String,
        actions: [UIAlertAction]?,
        preferredStyle: UIAlertController.Style = .alert,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let actions { actions.forEach { alert.addAction($0) }}
        else { alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)) }
        self.present(alert, animated: true, completion: completion)
    }
}


