//
//  StockManagementViewController.swift
//  JuiceMaker
//
//  Created by yujaehong on 12/12/23.
//

import UIKit

protocol StockManagementViewControllerDelegate: AnyObject {
    func changeAmount(_ fruits: [Fruit: Int])
}

final class StockManagementViewController: UIViewController {
    // delegate 변수 선언 -> 항상 메모리에 올라가 있지 않게끔 weak로 선언을 함.
    weak var delegate: StockManagementViewControllerDelegate?
    
    @IBOutlet var numberOfStrawberry: UILabel!
    @IBOutlet var numberOfBanana: UILabel!
    @IBOutlet var numberOfPineApple: UILabel!
    @IBOutlet var numberOfKiwi: UILabel!
    @IBOutlet var numberOfMango: UILabel!
    
    @IBOutlet var changeAmountOfStrawberry: UIStepper!
    @IBOutlet var changeAmountOfBanana: UIStepper!
    @IBOutlet var changeAmountOfPineApple: UIStepper!
    @IBOutlet var changeAmountOfKiwi: UIStepper!
    @IBOutlet var changeAmountOfMango: UIStepper!
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonPressed(_ sender: UIBarButtonItem) {
        changeStock(fruits: receivedFruitInventoryData)
//        sendNotification()
        delegate?.changeAmount(receivedFruitInventoryData)
        self.dismiss(animated: true, completion: nil)
    }
    
    var receivedFruitInventoryData: [Fruit:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNumberOnLabel(fruits: receivedFruitInventoryData)
        setupTargetActionOnStepper()
        setupStepper(fruits: receivedFruitInventoryData)
    }
}


extension StockManagementViewController {
    func setup(number: Int, on stepper: UIStepper) {
        stepper.minimumValue = -Double(number)
        stepper.maximumValue = 100
    }
    
    func setupStepper(fruits: [Fruit: Int]) {
        for fruit in fruits {
            switch fruit.key {
            case .strawberry:
                setup(number: fruit.value, on: changeAmountOfStrawberry)
            case .banana:
                setup(number: fruit.value, on: changeAmountOfBanana)
            case .pineapple:
                setup(number: fruit.value, on: changeAmountOfPineApple)
            case .kiwi:
                setup(number: fruit.value, on: changeAmountOfKiwi)
            case .mango:
                setup(number: fruit.value, on: changeAmountOfMango)
            }
        }
    }
}

extension StockManagementViewController {
    func setUp(number: Int, on label: UILabel) {
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

extension StockManagementViewController {
    func changeAmount(_ fruit: Fruit, _ number: Int) {
        receivedFruitInventoryData[fruit] = number
    }
    
    func changeStock(fruits: [Fruit: Int]) {
        for fruit in fruits {
            switch fruit.key {
            case .strawberry:
                changeAmount(.strawberry, Int(numberOfStrawberry.text!)!)
            case .banana:
                changeAmount(.banana, Int(numberOfBanana.text!)!)
            case .pineapple:
                changeAmount(.pineapple, Int(numberOfPineApple.text!)!)
            case .kiwi:
                changeAmount(.kiwi, Int(numberOfKiwi.text!)!)
            case .mango:
                changeAmount(.mango, Int(numberOfMango.text!)!)
            }
        }
    }
}

extension StockManagementViewController {
    func setupTargetActionOnStepper() {
        changeAmountOfStrawberry.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
        changeAmountOfBanana.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
        changeAmountOfPineApple.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
        changeAmountOfKiwi.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
        changeAmountOfMango.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
    }
    
    @objc func changeAmount(_ sender: UIStepper) {
        switch sender {
        case changeAmountOfStrawberry:
            if let result = receivedFruitInventoryData[.strawberry] {
                numberOfStrawberry.text = (Int(sender.value) + result).description
            }
        case changeAmountOfBanana:
            if let result = receivedFruitInventoryData[.banana] {
                numberOfBanana.text = (Int(sender.value) + result).description
            }
        case changeAmountOfPineApple:
            if let result = receivedFruitInventoryData[.pineapple] {
                numberOfPineApple.text = (Int(sender.value) + result).description
            }
        case changeAmountOfKiwi:
            if let result = receivedFruitInventoryData[.kiwi] {
                numberOfKiwi.text = (Int(sender.value) + result).description
            }
        case changeAmountOfMango:
            if let result = receivedFruitInventoryData[.mango] {
                numberOfMango.text = (Int(sender.value) + result).description
            }
        default:
            return
        }
    }
}
