//
//  SpecialistPickerViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit
import WebKit

struct Specialist: Codable {
    var managerId: Int
    var url: String
}

final class SpecialistPickerViewController: WebViewController {
    
    // MARK: Properties
    
    private lazy var footer: SpecialistPickerViewFooter = {
        let footer = SpecialistPickerViewFooter()
        footer.refreshClosure = { [weak self] in
            self?.showToast(JKString("survey.specialist-picker.shake.enabled"), duration: 1.5)
            self?.isShakeEnabled = true
        }
        footer.acceptClosure = { [weak self] in
            self?.accept()
        }
        return footer
    }()
    
    private var specialists: [Specialist]?
    private var index: Int = 0
    private var isShakeEnabled: Bool = false
    private var shakeCount: Int = 3
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        
        loadSpecialists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.applicationSupportsShakeToEdit = true
        
        becomeFirstResponder()
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.applicationSupportsShakeToEdit = false
        
        resignFirstResponder()
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topInset: CGFloat
        let bottomInset: CGFloat
        if #available(iOS 11.0, *) {
            topInset = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? UIApplication.shared.statusBarFrame.height
            bottomInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        } else {
            topInset = UIApplication.shared.statusBarFrame.height
            bottomInset = 0
        }
        
        progressView.frame = CGRect(x: 0.0, y: topInset, width: view.frame.width, height: 2.0)
        
        footer.frame = CGRect(x: 0.0, y: view.frame.height - 60.0 - bottomInset, width: view.frame.width, height: 60.0 + bottomInset)
        webView.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height - footer.frame.height)
    }
    
    // MARK: Configuration
    
    private func configureSubviews() {
        view.addSubview(footer)
    }
    
    // MARK: Networking
    
    private func loadSpecialists() {
        showHUD()
        
        let _ = HTTPClient.shared.loadSpecialists { [weak self] (response, error) in
            self?.hideHUD()
            
            if response?.code == 1000 {
                self?.specialists = response?.data
                self?.index = 0
                self?.load(response?.data?.first?.url)
            } else {
                self?.showToast(response?.message ?? error?.localizedDescription ?? JKString("Error"), duration: 2.0)
            }
        }
    }
    
    private func refresh() {
        if let data = specialists, !data.isEmpty {
            guard isShakeEnabled else { return }
            guard shakeCount > 0 else {
                showToast(JKString("survey.specialist-picker.shake.count.error"), duration: 1.5)
                return
            }
            shakeCount -= 1
            index += 1
            if index == data.count {
                index = 0
            }
            if shakeCount == 0 {
                index = 0
            }
            load(data[index].url)
            showToast(NSString(format: JKString("survey.specialist-picker.shake.count") as NSString, String(shakeCount)) as String, duration: 1.5)
        } else {
            loadSpecialists()
        }
    }
    
    private func accept() {
        guard let data = specialists, !data.isEmpty else { return }
        
        navigationController?.showHUD()

        let _ = HTTPClient.shared.bindSpecialist(data[index].managerId) { [weak self] (response, error) in
            self?.navigationController?.hideHUD()

            if response?.code == 1000 {
                self?.signIn()
            } else {
                self?.showToast(response?.message ?? error?.localizedDescription ?? JKString("Error"), duration: 2.0)
            }
        }
    }
    
    // MARK: Helper
    
    private func signIn() {
        let signInViewController = SignInViewController()
        navigationController?.pushViewController(signInViewController, animated: true)
    }
    
}

// MARK: - UIResponder Motion Methods

extension SpecialistPickerViewController {
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
    }
    
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionCancelled(motion, with: event)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        
        if event?.subtype == UIEventSubtype.motionShake {
            refresh()
        }
    }
    
}
