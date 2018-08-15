//
//  TodayViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/13/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

private let DefaultCellIdentifier = "TodayViewSpecialistCell"

final class TodayViewController: UITableViewController {
    
    // MARK: Properties
    
    private var data: [TodayDataModel] = []
    
    private lazy var titleView: UIView = {
        let dayLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 40.0))
        dayLabel.font = UIFont.systemFont(ofSize: 36.0)
        dayLabel.textColor = .white
        dayLabel.text = "27"
        
        let dateLabel = UILabel(frame: CGRect(x: 50.0, y: 0.0, width: 120.0, height: 40.0))
        dateLabel.font = UIFont.systemFont(ofSize: 14.0)
        dateLabel.numberOfLines = 2
        dateLabel.textColor = .white
        dateLabel.text = "2018 / 8\n戊戌年 六月 廿二"
        
        let titleView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 170.0, height: 40.0))
        titleView.backgroundColor = .clear
        
        titleView.addSubview(dayLabel)
        titleView.addSubview(dateLabel)
        return titleView
    }()
    
    private var header: TodayViewHeader?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        loadData(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "今日")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "今日")
    }
    
    // MARK: Configuration
    
    private func configureNavigationBar() {
        navBarBgAlpha = 0.0
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Today-Calendar"),
            style: .plain,
            target: self,
            action: #selector(calendarButtonTapped(_:))
        )
    }
    
    private func configureTableView() {
        tableView.register(TodayViewTextCell.self, forCellReuseIdentifier: TodayViewTextCellIdentifier)
        tableView.register(TodayViewArticleCell.self, forCellReuseIdentifier: TodayViewArticleCellIdentifier)
        tableView.register(TodayViewDrinkCell.self, forCellReuseIdentifier: TodayViewDrinkCellIdentifier)
        tableView.register(TodayViewAlarmCell.self, forCellReuseIdentifier: TodayViewAlarmCellIdentifier)
        tableView.register(TodayViewRecordCell.self, forCellReuseIdentifier: TodayViewRecordCellIdentifier)
        tableView.register(TodayViewTestCell.self, forCellReuseIdentifier: TodayViewTestCellIdentifier)
        tableView.register(TodayViewSuggestionCell.self, forCellReuseIdentifier: TodayViewSuggestionCellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: DefaultCellIdentifier)
        tableView.tableFooterView = TodayViewFooter(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: 20.0 + 28.0 * 2.0))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 239 / 255.0, alpha: 1.0)
        tableView.keyboardDismissMode = .interactive
    }
    
    // MARK: Actions
    
    @objc
    private func calendarButtonTapped(_ sender: Any?) {
        
    }
    
    @objc
    private func refreshControlValueChanged(_ sender: UIRefreshControl) {
        loadData(true)
    }
    
    // MARK: Networking
    
    private func loadData(_ isRefreshing: Bool = true) {
        let tip = "有规律的生活原是健康与长寿的秘诀有了金钱就能在这个世界上做很多事。\n\n   ——巴尔扎克"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        
        let attributedText = NSAttributedString(
            string: tip,
            attributes: [
                NSAttributedStringKey.paragraphStyle: paragraphStyle,
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16.0)
            ]
        )
        
        let tipHeight = attributedText.boundingRect(
            with: CGSize(width: view.frame.width - 28.0 * 2.0, height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin,
            context: nil).height
        
        header = TodayViewHeader(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: tipHeight + 20.0 + 2.0 + 16.0 * 2.0))
        header?.tip = tip
        header?.imageUrl = "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3978043660,4108011164&fm=27&gp=0.jpg"
        tableView.tableHeaderView = header
        
        for _ in 1...3 {
            let model = TodayDataModel()
            model.specialistInfo = TodaySpecialistInfo(id: 0, name: "李潇潇", avatarUrl: nil)
            model.items = [
                TodayItem(type: .text, title: nil, text: "笑企国，被次务够古座事性笔开简交们西联非子电因；数作服形包这动火中们可她世欢离心知可到。", date: nil, url: nil, imageUrl: nil),
                TodayItem(type: .suggestion, title: "饮食建议", text: "被次务够古座事数作服形包这动火中们可她世欢离心知可到。", date: nil, url: nil, imageUrl: nil),
                TodayItem(type: .article, title: "决地服读太传两明还一日理", text: "来生动她向够家向请传有容没的见也是他兴注人。", date: nil, url: nil, imageUrl: "https://inews.gtimg.com/newsapp_bt/0/4815506151/1000"),
                TodayItem(type: .alarm, title: "提醒1", text: nil, date: Date(), url: nil, imageUrl: nil),
                TodayItem(type: .drink, title: nil, text: "笑企国，被次务够古座事性笔开简交们西联非子电因；数作服形包这动火中们可她世欢离心知可到。", date: nil, url: nil, imageUrl: nil),
                TodayItem(type: .test, title: "睡眠质量测试", text: "测试时间： 约5分钟", date: nil, url: nil, imageUrl: "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3978043660,4108011164&fm=27&gp=0.jpg"),
                TodayItem(type: .record, title: nil, text: nil, date: nil, url: nil, imageUrl: nil),
            ]
            data.append(model)
        }
        
        tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = data[indexPath.section].items?[indexPath.row]
        guard let cellIdentifier = item?.cellIdentifier() else {
            return tableView.dequeueReusableCell(withIdentifier: DefaultCellIdentifier, for: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodayViewCell
        cell.item = item
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data[indexPath.section].items?[indexPath.row].rowHeight() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = TodayViewSectionHeader(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 72.0))
        header.info = data[section].specialistInfo
        return header
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header?.contentOffset = scrollView.contentOffset.y
        navBarBgAlpha = (scrollView.contentOffset.y + (navigationController?.navigationBar.frame.maxY ?? 0)) / (header?.frame.height ?? 1)
    }
    
}
