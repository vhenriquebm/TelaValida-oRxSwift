//
//  ViewController.swift
//  RegisterFlowRxSwift
//
//  Created by vitor henrique on 22/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    //MARK: - Constants
    
    let bag = DisposeBag()
    
    let userNamePublishSubject = PublishSubject<String>()
    let passwordPublishSubject = PublishSubject<String>()
    
    //MARK: - Outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userNameMessageLabel: UILabel!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userPasswordMessageLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
        
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.becomeFirstResponder()
        configureUserName()
    }
    
    private func isValid() -> Observable<Bool> {
        Observable
            .combineLatest(userNamePublishSubject.asObservable().startWith(""), passwordPublishSubject.asObservable().startWith("")).map{userName, password in
            return userName.count > 3 && password.count > 3
            }.startWith(false)
    }
    
    private func isValidNumber() -> Observable<String> {
        Observable
            .combineLatest(userNamePublishSubject.asObservable().startWith(""), passwordPublishSubject.asObservable().startWith("")).map{userName, password in
                return userName.count > 3 && password.count > 3  ? "Sucesso" : "Erro"
            }.startWith("")
    }
    
    private func configureUserName () {
        
        userNameTextField
            .rx
            .text
            .map{($0 ?? "")}
            .bind(to: userNamePublishSubject)
            .disposed(by: bag)
        
        userPasswordTextField
            .rx
            .text
            .map{($0 ?? "")}
            .bind(to: passwordPublishSubject)
            .disposed(by: bag)
        
        isValid()
            .bind(to: registerButton.rx.isEnabled)
            .disposed(by: bag)
        
        isValid().map{$0 ? 1 : 0.7}
            .bind(to: registerButton.rx.alpha)
            .disposed(by: bag)
        
        isValidNumber().bind(to: userNameMessageLabel.rx.text)
            .disposed(by: bag)
        
        isValidNumber().bind(to: userPasswordMessageLabel.rx.text)
            .disposed(by: bag)
    }
    
}
