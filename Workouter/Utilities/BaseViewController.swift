//
//  BaseViewController.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/25.
//

import UIKit

class BaseViewController: UIViewController, BaseViewControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupDelegate()
        setupHierarchy()
        setupConstraints()
        setupRxBind()
    }
    
    func setupDelegate() {}
    func setupHierarchy() {}
    func setupConstraints() {}
    func setupRxBind() {}
    func setupUI() {}
}

protocol BaseViewControllerProtocol: AnyObject, BaseViewItemProtocol, DisposeBagProtocol {
    // delegate 설정
    func setupDelegate()
    
    func setupRxBind()
}


