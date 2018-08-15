//
//  MeViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/3/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MeViewCell"

final class MeViewController: UITableViewController {
    
    // MARK: Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100.0, height: 44.0))
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = .white
        label.text = JKString("me.title")
        return label
    }()
    
    private lazy var header: MeViewHeader = {
        let header = MeViewHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 130.0))
        return header
    }()
    
    private lazy var footer: MeViewFooter = {
        let footer = MeViewFooter(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 96.0))
        return footer
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "我的")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "我的")
    }
    
    // MARK: Configuration
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Me-Settings"),
            style: .plain,
            target: self,
            action: #selector(settingsButtonTapped(_:))
        )
    }
    
    private func configureTableView() {
        tableView.register(MeViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableHeaderView = header
        tableView.tableFooterView = footer
        tableView.rowHeight = 56.0
    }
    
    // MARK: Actions
    
    @objc
    private func settingsButtonTapped(_ sender: Any?) {
        Preferences().set(nil, for: PreferencesKey.user)
    }
    
    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(named: "Me-Trending")
            cell.textLabel?.text = JKString("me.trending")
        case 1:
            cell.imageView?.image = UIImage(named: "Me-Profile")
            cell.textLabel?.text = JKString("me.profile")
        case 2:
            cell.imageView?.image = UIImage(named: "Me-Orders")
            cell.textLabel?.text = JKString("me.orders")
        case 3:
            cell.imageView?.image = UIImage(named: "Me-Notifications")
            cell.textLabel?.text = JKString("me.notifications")
        case 4:
            cell.imageView?.image = UIImage(named: "Me-Feedback")
            cell.textLabel?.text = JKString("me.feedback")
        default:
            cell.accessoryView = nil
            cell.textLabel?.text = ""
        }

        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.contentOffset = scrollView.contentOffset.y
    }
    
}
