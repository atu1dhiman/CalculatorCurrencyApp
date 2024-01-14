//
//  ViewController.swift
//  Assignment
//
//  Created by Atul Dhiman on 12/01/24.
//

import UIKit

class ViewController: UIViewController {

    // MARK:  IBOutlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var currencyBT: UIButton!
    @IBOutlet weak var calculatorBT: UIButton!
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: IBAction
extension ViewController {
    @IBAction func currencyNavAction(_ sender: Any) {
        Navigator.navigate(from: self, to: CurrencyViewController.self, with: "")
    }
    @IBAction func calculatorNavAction(_ sender: Any) {
        
    }
}

// MARK: UI Methods
extension ViewController {
}
