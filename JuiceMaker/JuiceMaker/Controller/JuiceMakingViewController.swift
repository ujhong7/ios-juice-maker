//
//  JuiceMaker - ViewController.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import UIKit

final class JuiceMakingViewController: UIViewController {
    
    @IBOutlet var numberOfStrawberry: UILabel!
    @IBOutlet var numberOfBanana: UILabel!
    @IBOutlet var numberOfPineApple: UILabel!
    @IBOutlet var numberOfKiwi: UILabel!
    @IBOutlet var numberOfMango: UILabel!
    
    @IBOutlet var orderStrawberryButton: UIButton!
    @IBOutlet var orderBananaButton: UIButton!
    @IBOutlet var orderPineAppleButton: UIButton!
    @IBOutlet var orderKiwiButton: UIButton!
    @IBOutlet var orderMangoButton: UIButton!
    @IBOutlet var orderStrawberryBananaButton: UIButton!
    @IBOutlet var orderMangoKiwiButton: UIButton!
    
    @IBOutlet var stockChangeButton: UIBarButtonItem!
    
    let juiceMaker = JuiceMaker(fruitStore: FruitStore())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNumberOnLabel(fruits: juiceMaker.fruitStore.inventory)
        setUpTargetActionOnButtons()
        registerObserver()
    }
    
    deinit {
        turnOffObserver()
    }
    
}

extension JuiceMakingViewController {
    func setUp(number: Int, on label:UILabel) {
        label.text = String(number)
    }
    
    func showNumberOnLabel(fruits: [Fruit: Int]) {
        for fruit in fruits {
            switch fruit.key {
            case .strawberry:
                setUp(number: fruit.value, on: numberOfStrawberry)
            case .banana:
                setUp(number: fruit.value, on: numberOfBanana)
            case .pineapple:
                setUp(number: fruit.value, on: numberOfPineApple)
            case .kiwi:
                setUp(number: fruit.value, on: numberOfKiwi)
            case .mango:
                setUp(number: fruit.value, on: numberOfMango)
            }
        }
    }
}

extension JuiceMakingViewController {
    func setUpTargetActionOnButtons() {
        orderStrawberryButton.addTarget(self, action: #selector(orderJuice(_:)), for: .touchUpInside)
        orderBananaButton.addTarget(self, action: #selector(orderJuice(_:)), for: .touchUpInside)
        orderPineAppleButton.addTarget(self, action: #selector(orderJuice(_:)), for: .touchUpInside)
        orderKiwiButton.addTarget(self, action: #selector(orderJuice(_:)), for: .touchUpInside)
        orderMangoButton.addTarget(self, action: #selector(orderJuice(_:)), for: .touchUpInside)
        orderStrawberryBananaButton.addTarget(self, action: #selector(orderJuice(_:)), for:.touchUpInside)
        orderMangoKiwiButton.addTarget(self, action: #selector(orderJuice(_:)), for: .touchUpInside)
        
        stockChangeButton.target = self
        stockChangeButton.action = #selector(stockChangeButtonTapped)
    }
    
    @objc func orderJuice(_ sender: UIButton) {
        let result: JuiceMaker.JuiceMakingResult
        
        switch sender {
        case orderStrawberryButton:
            result = juiceMaker.produce(.strawberry)
        case orderBananaButton:
            result = juiceMaker.produce(.banana)
        case orderPineAppleButton:
            result = juiceMaker.produce(.pineapple)
        case orderKiwiButton:
            result = juiceMaker.produce(.kiwi)
        case orderMangoButton:
            result = juiceMaker.produce(.mango)
        case orderStrawberryBananaButton:
            result = juiceMaker.produce(.strawberryBanana)
        case orderMangoKiwiButton:
            result = juiceMaker.produce(.mangoKiwi)
        default:
            let message = "???"
            result = .failure(description: message)
        }
        
        self.present(generateAlert(by: result), animated: true, completion: nil)
    }
    
    func generateAlert(by result: JuiceMaker.JuiceMakingResult) -> UIAlertController {
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        switch result {
        case .success(let message):
            alert.message = message
            alert.addAction(UIAlertAction(title: "확인", style: .default))
        case .failure(let message):
            alert.message = message
            alert.addAction(UIAlertAction(title: "예", style: .default, handler: transitionToStockManagement(_:)))
            alert.addAction(UIAlertAction(title: "아니오", style: .default))
        }
        return alert
    }
    
    @objc func stockChangeButtonTapped() {
        dataToStockManagementViewController()
    }
}

extension JuiceMakingViewController {
    func transitionToStockManagement(_ sender: UIAlertAction) {
        dataToStockManagementViewController()
    }
}

// MARK: - 설명 추가
extension JuiceMakingViewController {
    func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeFruitsAmount(_:)), name: Notification.Name("fruitsAmountDidChange"), object: nil)
    }
    
    @objc func didChangeFruitsAmount(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let fruitInfo = userInfo as? [Fruit : Int] else {
            return
        }
        self.showNumberOnLabel(fruits: fruitInfo)
    }
    
    func turnOffObserver() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("fruitsAmountDidChange"), object: nil)
    }
}

//
//extension JuiceMakingViewController {
//    func registerObserver2() {
//        NotificationCenter.default.addObserver(self, selector: #selector(didChangeFruitsComplete(_:)), name: Notification.Name("fruitsAmountChangeComplete"), object: nil)
//    }
//    
//    @objc func didChangeFruitsComplete(_ notification: Notification) {
//        guard let userInfo = notification.userInfo, let fruitInfo = userInfo as? [Fruit : Int] else {
//            return
//        }
//        juiceMaker.fruitStore.changeAmountAll(fruitInfo)
//        self.showNumberOnLabel(fruits: fruitInfo)
//        turnOffObserver2()
//    }
//    
//    func turnOffObserver2() {
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("fruitsAmountChangeComplete"), object: nil)
//    }
//    
//}

extension JuiceMakingViewController: StockManagementViewControllerDelegate {
    func changeAmount(_ fruit: [Fruit: Int]) {
        let a = juiceMaker.fruitStore.changeAmountAll(fruit)
        print(a)
        showNumberOnLabel(fruits: a)
    }
}

// 보통 뷰컨은 분리 잘 안함.
extension JuiceMakingViewController {
    func dataToStockManagementViewController() {
//        registerObserver2()
        if let stockManagementVC = self.storyboard?.instantiateViewController(withIdentifier: "StockManagementViewController") as? StockManagementViewController {
            stockManagementVC.receivedData = juiceMaker.fruitStore.inventory
            stockManagementVC.delegate = self
            
            let stockManagementNavigationController = UINavigationController(rootViewController: stockManagementVC)
            stockManagementNavigationController.modalPresentationStyle = .pageSheet
            stockManagementNavigationController.sheetPresentationController?.detents = [.large(), .medium()]
            stockManagementNavigationController.sheetPresentationController?.preferredCornerRadius = 30
            stockManagementNavigationController.sheetPresentationController?.prefersEdgeAttachedInCompactHeight = true
            
            self.present(stockManagementNavigationController, animated: true, completion: nil)
        }
    }
}
