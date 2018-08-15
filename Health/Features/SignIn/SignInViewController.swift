//
//  SignInViewController.swift
//  Health
//
//  Created by Weichen Jiang on 8/6/18.
//  Copyright © 2018 J&K INVESTMENT HOLDING GROUP. All rights reserved.
//

import UIKit

final class SignInViewController: UIViewController {
    
    // MARK: Properties
    
    private var mobile: String?
    private var code: String?
    private var timer: Timer?
    private var timerCount = 60
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.text = JKString("sign-in.title")
        return label
    }()
    
    private lazy var mobileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .darkGray
        label.text = JKString("sign-in.mobile")
        return label
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .darkGray
        label.text = JKString("sign-in.code")
        return label
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .darkGray
        label.text = JKString("sign-in.terms-of-use")
        return label
    }()
    
    private lazy var mobileTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .phonePad
        textField.placeholder = JKString("sign-in.mobile.placeholder")
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 3.0
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var codeTextField: UITextField = {
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: codeButton.frame.width + 10.0, height: codeButton.frame.height))
        rightView.addSubview(codeButton)
        
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = JKString("sign-in.code.placeholder")
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 3.0
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10.0, height: 0))
        textField.leftViewMode = .always
        textField.rightView = rightView
        textField.rightViewMode = .always
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("sign-in.submit"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .main
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.layer.cornerRadius = 22.0
        button.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var codeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 115.0, height: 35.0)
        button.setTitle(JKString("sign-in.code.send"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray, for: .disabled)
        button.layer.cornerRadius = 4.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(codeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var termsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(JKString("sign-in.terms-of-use.link"), for: .normal)
        button.setTitleColor(UIColor(red: 77 / 255.0, green: 185 / 255.0, blue: 172 / 255.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        button.addTarget(self, action: #selector(termsButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var checkbox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Survey-Checkmark"), for: .selected)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(checkboxDidTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSubviews()
    }
    
    // MARK: Configuration
    
    private func configureNavigationBar() {
        navBarBgAlpha = 0.0
    }
    
    private func configureSubviews() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(mobileTextField)
        view.addSubview(mobileLabel)
        view.addSubview(codeTextField)
        view.addSubview(codeLabel)
        view.addSubview(submitButton)
        view.addSubview(checkbox)
        view.addSubview(termsLabel)
        view.addSubview(termsButton)
    }
    
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topInset: CGFloat
        let bottomInset: CGFloat
        if #available(iOS 11.0, *) {
            topInset = navigationController?.navigationBar.frame.maxY ?? max((UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 30.0), 30.0)
            bottomInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        } else {
            topInset = navigationController?.navigationBar.frame.maxY ?? 30.0
            bottomInset = 0
        }
        
        titleLabel.frame = CGRect(x: 24.0, y: topInset + 50.0, width: view.frame.width - 24.0 * 2.0, height: 30.0)
        mobileTextField.frame = CGRect(x: 24.0, y: titleLabel.frame.maxY + 54.0, width: view.frame.width - 24.0 * 2.0, height: 50.0)
        mobileLabel.frame = CGRect(x: 40.0, y: mobileTextField.frame.maxY + 3.0, width: view.frame.width - 40.0 * 2.0, height: 20.0)
        codeTextField.frame = CGRect(x: 24.0, y: mobileLabel.frame.maxY + 20.0, width: view.frame.width - 24.0 * 2.0, height: 50.0)
        codeLabel.frame = CGRect(x: 40.0, y: codeTextField.frame.maxY + 3.0, width: view.frame.width - 40.0 * 2.0, height: 20.0)
        submitButton.frame = CGRect(x: 24.0, y: codeLabel.frame.maxY + 50.0, width: view.frame.width - 24.0 * 2.0, height: 44.0)
        
        let termsWidth = termsLabel.text!.boundingRect(
            with: CGSize(width: view.frame.width - 24.0 * 2.0, height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedStringKey.font: termsLabel.font],
            context: nil
            ).width
        let termsLinkWidth = termsButton.title(for: .normal)!.boundingRect(
            with: CGSize(width: view.frame.width - 24.0 * 2.0, height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedStringKey.font: termsButton.titleLabel!.font],
            context: nil
            ).width
        let termsViewWidth = 18.0 + 10.0 + termsWidth + termsLinkWidth
        
        checkbox.frame = CGRect(x: (view.frame.width - termsViewWidth) / 2.0, y: view.frame.height - bottomInset - 30.0 - 30.0 + 6.0, width: 18.0, height: 18.0)
        termsLabel.frame = CGRect(x: checkbox.frame.maxX + 10.0, y: view.frame.height - bottomInset - 30.0 - 30.0, width: termsWidth, height: 30.0)
        termsButton.frame = CGRect(x: termsLabel.frame.maxX, y: termsLabel.frame.origin.y, width: termsLinkWidth, height: 30.0)
    }
    
    // MARK: Actions
    
    @objc
    private func submitButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        guard let mobile = mobileTextField.text, isValidePhoneNumber(mobile) else {
            showToast(JKString("sign-in.error.mobile.invalide"), duration: 2.0)
            return
        }
        
        guard let code = codeTextField.text, code.count > 0 else {
            showToast(JKString("sign-in.error.code.invalide"), duration: 2.0)
            return
        }
        
        guard checkbox.isSelected else {
            showToast(JKString("sign-in.error.terms-of-use.invalide"), duration: 2.0)
            return
        }
        
        signIn(with: mobile, code: code)
    }
    
    @objc
    private func codeButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        if let mobile = mobileTextField.text, isValidePhoneNumber(mobile) {
            sendCode(to: mobile)
        } else {
            showToast(JKString("sign-in.error.mobile.invalide"), duration: 2.0)
        }
    }
    
    @objc
    private func termsButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        
        let termsViewController = TermsOfUseViewController()
        termsViewController.acceptClosure = { [weak self] in
            self?.checkboxDidTapped(nil)
        }
        navigationController?.pushViewController(termsViewController, animated: true)
    }
    
    @objc
    private func checkboxDidTapped(_ sender: UIButton?) {
        checkbox.isSelected = !checkbox.isSelected
        checkbox.layer.borderColor = checkbox.isSelected ? UIColor.main.cgColor : UIColor.darkGray.cgColor
        checkbox.backgroundColor = checkbox.isSelected ? .main : .white
    }
    
    @objc
    private func timerFired(_ timer: Timer) {
        guard timerCount > 0 else {
            invalidateTimer()
            return
        }
        
        timerCount -= 1
        codeButton.setTitle(String(timerCount) + JKString("sign-in.code.timer"), for: .normal)
    }
    
    private func startTimer() {
        invalidateTimer()
        
        codeButton.isEnabled = false
        codeButton.setTitle(String(timerCount) + JKString("sign-in.code.timer"), for: .normal)
        
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
        timer?.fire()
        
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
        timerCount = 60
        codeButton.isEnabled = true
        codeButton.setTitle(JKString("sign-in.code.send"), for: .normal)
    }
    
    // MARK: Networking
    
    private func signIn(with mobile: String, code: String) {
        navigationController?.showHUD()
        
        let _ = HTTPClient.shared.signIn(with: mobile, code: code) { [weak self] (response, error) in
            self?.navigationController?.hideHUD()
            
            if response?.code == 1000, let user = response?.data {
                App.shared.user = user
                if let value = user.isFirstRegister, value {
                    let followUpViewController = SpecialistFollowUpViewController()
                    self?.navigationController?.pushViewController(followUpViewController, animated: true)
                } else {
                    UIApplication.shared.keyWindow?.rootViewController = TabBarController()
                }
            } else {
                self?.showToast(response?.message ?? error?.localizedDescription ?? JKString("Error"), duration: 2.0)
            }
        }
    }
    
    private func sendCode(to mobile: String) {
        navigationController?.showHUD()
        
        let _ = HTTPClient.shared.getVerifyCodeToken(with: mobile) { [weak self] (response, error) in
            self?.navigationController?.hideHUD()
            
            if let token = response?.data {
                self?.sendCode(to: mobile, with: token)
            } else {
                self?.showToast(response?.message ?? error?.localizedDescription ?? JKString("Error"), duration: 2.0)
            }
        }
    }
    
    private func sendCode(to mobile: String, with token: String) {
        navigationController?.showHUD()
        
        let _ = HTTPClient.shared.sendVerifyCode(to: mobile, token: token) { [weak self] (response, error) in
            self?.navigationController?.hideHUD()
            
            if response?.code == 1000 {
                self?.showToast(response?.message ?? JKString("sign-in.code.success"), duration: 2.0)
                self?.startTimer()
            } else {
                self?.showToast(response?.message ?? error?.localizedDescription ?? JKString("Error"), duration: 2.0)
            }
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - UIResponder Touches Methods

extension SignInViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
}
