//
//  ViewController.swift
//  FallInLink
//
//  Created by Jeonhui on 09/26/2023.
//  Copyright (c) 2023 Jeonhui. All rights reserved.
//

import UIKit
import FallInLink

class ViewController: UIViewController {
    var exampleUrlString = "https://apple.com"
    lazy var url = URL(string: exampleUrlString)!
    
    private lazy var linkViewController: LinkViewController = {
        let linkView = LinkViewController(url: url)
        return linkView
    }()
    
    private var urlInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var urlTextField: UITextField = {
        let textField = InsetTextField()
        textField.keyboardType = .URL
        textField.placeholder = exampleUrlString
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(changeUrlLink), for: .primaryActionTriggered)
        return textField
    }()
    
    private lazy var urlButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitle("change", for: .normal)
        button.addTarget(self, action: #selector(changeUrlLink), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubviews()
        makeConstraints()
    }
    
    private func configure() {
        self.view.backgroundColor = .black
    }
    
    private func addSubviews() {
        self.view.addSubview(linkViewController.view)
        self.addChild(linkViewController)
        
        self.urlInputContainer.addSubview(urlTextField)
        self.urlInputContainer.addSubview(urlButton)
        self.view.addSubview(urlInputContainer)
    }
    
    private func makeConstraints() {
        let views = [linkViewController.view,
                     urlInputContainer,
                     urlTextField,
                     urlButton]
        views.forEach{ view in
            view?.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints: [NSLayoutConstraint] = [
            linkViewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            linkViewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            linkViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            linkViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            urlInputContainer.heightAnchor.constraint(equalToConstant: 60),
            urlInputContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            urlInputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            urlInputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            urlTextField.topAnchor.constraint(equalTo: urlInputContainer.topAnchor),
            urlTextField.bottomAnchor.constraint(equalTo: urlInputContainer.bottomAnchor),
            urlTextField.leadingAnchor.constraint(equalTo: urlInputContainer.leadingAnchor),
            urlTextField.trailingAnchor.constraint(equalTo: urlButton.leadingAnchor),
            
            urlButton.centerYAnchor.constraint(equalTo: urlInputContainer.centerYAnchor),
            urlButton.heightAnchor.constraint(equalToConstant: 40),
            urlButton.widthAnchor.constraint(equalToConstant: 60),
            urlButton.trailingAnchor.constraint(equalTo: urlInputContainer.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc
    func changeUrlLink() {
        guard var urlString = self.urlTextField.text  else { return }
        urlString = urlString.prefix(4) == "http" ? urlString : "https://\(urlString)"
        if let url = URL(string: urlString) {
            self.linkViewController.updateURL(url: url)
        }
    }
}

