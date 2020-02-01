//
//  ViewController.swift
//  RxSwift-Delegation
//
//  Created by Zafar on 2/1/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {

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
    private var titles: [String] = []
    
    private let addBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
}

// MARK: - Binding
extension ListViewController {
    private func bindBarButton() {
        
        addBarButton.rx.tap
            .debounce(.milliseconds(5), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] _ -> Observable<String> in
                let addItemVC = AddItemViewController()
                let navC = UINavigationController(rootViewController: addItemVC)
                self?.present(navC, animated: true, completion: nil)
                return addItemVC.newTitle
        }
        .do(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        .subscribe(onNext: { [weak self] (newTitle) in
            print(newTitle)
            self?.titles.append(newTitle)
            self?.tableView.reloadData()
        })
        .disposed(by: disposeBag)

    }
}

// MARK: - UITableView Data Source
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
}

// MARK: - UI Setup
extension ListViewController {
    private func setupUI() {
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }
    
    private func setupNavItem() {
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
}
