//
//  BaseViewController.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/25.
//

import UIKit
import RxSwift
class BaseViewController: UIViewController, BaseViewControllerProtocol {

    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupDelegate()
        setupRxBind()
    }
    
    func setupDelegate() {}
    func setupHierarchy() {}
    func setupConstraints() {}
    func setupRxBind() {}
    func setupUI() {}
}

protocol BaseViewControllerProtocol: AnyObject {
    // delegate 설정
    func setupDelegate()
    
    func setupRxBind()
    
    func setupUI()
}


