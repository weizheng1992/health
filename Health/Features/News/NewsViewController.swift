//
//  NewsViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/3/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import Alamofire
import DropDown

private let reuseIdentifier = "NewsViewCell"

final class NewsViewController: UICollectionViewController {
    
    // MARK: Properties
    
    private var channels: [NewsChannel] = []
    private var items: [NewsItem] = []
    private var selectedIndex: Int = 0
    private var selectedChannel: NewsChannel?
    
    private lazy var channelsView: DropDown = {
        let dropDown = DropDown()
        dropDown.width = 128.0
        dropDown.cellHeight = 35.0
        dropDown.cornerRadius = 5.0
        dropDown.bottomOffset = CGPoint(x: -100.0, y: 40.0)
        dropDown.backgroundColor = .white
        dropDown.textFont = UIFont.systemFont(ofSize: 14.0)
        dropDown.anchorView = navigationItem.rightBarButtonItem!
        dropDown.selectionAction = { [weak self] (index, item) in
            guard self?.selectedIndex != index else { return }
            
            self?.selectedIndex = index
            self?.selectedChannel = index == 0 ? nil : self?.channels[index - 1]
            self?.reloadItems(true)
        }
        return dropDown
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: Initialization
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        self.init(collectionViewLayout: layout)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureCollectionView()
        
        reloadChannels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "头条")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "头条")
    }
    
    // MARK: Configuration
    
    private func configureNavigationBar() {
        navBarTintColor = .black
        navBarBgAlpha = 0
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "NavigationBar-More"),
            style: .plain,
            target: self,
            action: #selector(channelsButtonTapped(_:))
        )
    }
    
    private func configureCollectionView() {
        collectionView?.register(NewsViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = true
        collectionView?.showsVerticalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
//        if #available(iOS 10.0, *) {
//            collectionView?.refreshControl = refreshControl
//        } else {
//            collectionView?.addSubview(refreshControl)
//        }
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.reloadItems(false)
        })
        footer?.isRefreshingTitleHidden = true
        footer?.stateLabel.isHidden = true
        collectionView?.mj_footer = footer
    }
    
    // MARK: Actions
    
    @objc
    private func channelsButtonTapped(_ sender: Any?) {
        if channels.isEmpty {
            reloadChannels()
        } else {
            channelsView.selectRow(at: selectedIndex)
            channelsView.show()
        }
    }
    
    @objc
    private func refreshControlValueChanged(_ sender: UIRefreshControl) {
        reloadItems(true)
    }
    
    // MARK: Networking
    
    private func reloadChannels() {
        showHUD()
        
        let _ = HTTPClient.shared.fetchNewsChannels { [weak self] (response, error) in
            self?.selectedChannel = nil
            self?.channels = response?.data ?? []
            self?.reloadChannelsView()
            self?.reloadItems()
            self?.hideHUD()
        }
    }
    
    private func reloadItems(_ isRefresh: Bool = true) {
        if !isRefresh, items.count % 20 != 0 {
            refreshControl.endRefreshing()
            collectionView?.mj_footer.endRefreshing()
            collectionView?.contentInset = .zero
            return
        }
        
        let _ = HTTPClient.shared.fetchNews(channelID: selectedChannel?.id, begin: isRefresh ? 0 : items.count, end: isRefresh ? 19 : items.count + 20, completion: { [weak self] (response, error) in
            if isRefresh { self?.items.removeAll() }
            self?.items.append(contentsOf: response?.data ?? [])
            self?.collectionView?.reloadData()
            self?.collectionView?.mj_footer.endRefreshing()
            self?.collectionView?.contentInset = .zero
            self?.refreshControl.endRefreshing()
            if isRefresh, let data = self?.items, !data.isEmpty {
                self?.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        })
    }
    
    private func reloadChannelsView() {
        var items: [String] = []
        items.append(" " + JKString("news.all"))
        
        channels.forEach { items.append(" " + ($0.name ?? "") + " ") }
        channelsView.dataSource = items
        channelsView.selectRow(0)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewsViewCell
        cell.item = items[indexPath.item]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = items[indexPath.item].url {
            let webViewController = NewsDetailViewController(url: url)
            navigationController?.pushViewController(webViewController, animated: true)
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
}
