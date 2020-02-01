//
//  AddItemViewController.swift
//  RxSwift-Delegation
//
//  Created by Zafar on 2/1/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit
import RxSwift

class AddItemViewController: UIViewController {
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavItem()
        bindBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    let newTitle = PublishSubject<String>()
    
    private let doneBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: nil)
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New item"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.becomeFirstResponder()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
}

// MARK: - Binding
extension AddItemViewController {
    private func bindBarButton() {
        doneBarButton.rx.tap
            .filter { !self.textField.text!.isEmpty }
            .subscribe(onNext: { _ in
                self.newTitle.onNext(self.textField.text!)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI Setup
extension AddItemViewController {
    private func setupUI() {
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        
        self.view.addSubview(textField)
               
        NSLayoutConstraint.activate([
            textField.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.heightAnchor
                .constraint(equalToConstant: 50),
            textField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50),
            textField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50)
            
        ])
    }
    
    private func setupNavItem() {
        self.navigationItem.rightBarButtonItem = doneBarButton
    }
}
