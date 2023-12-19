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
        changeStock(fruits: receivedData)
//        sendNotification()
        delegate?.changeAmount(receivedData)
        self.dismiss(animated: true, completion: nil)
    }
    
    var receivedData: [Fruit:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNumberOnLabel(fruits: receivedData)
        setUpTargetActionOnStepper()
        setupStepper(fruits: receivedData)
    }
}


extension StockManagementViewController {
    func setUp(number: Int, on stepper: UIStepper) {
        stepper.minimumValue = -Double(number)
        stepper.maximumValue = 100
    }
    
    func setupStepper(fruits: [Fruit: Int]) {
        for fruit in fruits {
            switch fruit.key {
            case .strawberry:
                setUp(number: fruit.value, on: changeAmountOfStrawberry)
            case .banana:
                setUp(number: fruit.value, on: changeAmountOfBanana)
            case .pineapple:
                setUp(number: fruit.value, on: changeAmountOfPineApple)
            case .kiwi:
                setUp(number: fruit.value, on: changeAmountOfKiwi)
            case .mango:
                setUp(number: fruit.value, on: changeAmountOfMango)
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
        receivedData[fruit] = number
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
    func setUpTargetActionOnStepper() {
        changeAmountOfStrawberry.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
        changeAmountOfBanana.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
        changeAmountOfPineApple.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
        changeAmountOfKiwi.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
        changeAmountOfMango.addTarget(self, action: #selector(changeAmount(_:)), for: .valueChanged)
    }
    
    @objc func changeAmount(_ sender: UIStepper) {
        switch sender {
        case changeAmountOfStrawberry:
            if let result = receivedData[.strawberry] {
                numberOfStrawberry.text = (Int(sender.value) + result).description
            }
        case changeAmountOfBanana:
            if let result = receivedData[.banana] {
                numberOfBanana.text = (Int(sender.value) + result).description
            }
        case changeAmountOfPineApple:
            if let result = receivedData[.pineapple] {
                numberOfPineApple.text = (Int(sender.value) + result).description
            }
        case changeAmountOfKiwi:
            if let result = receivedData[.kiwi] {
                numberOfKiwi.text = (Int(sender.value) + result).description
            }
        case changeAmountOfMango:
            if let result = receivedData[.mango] {
                numberOfMango.text = (Int(sender.value) + result).description
            }
        default:
            return
        }
    }
}
