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
    
    // MARK:  DataModel Variables
    private var currencyData : CurrencyData?
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UILoad()
    }
}

// MARK: IBAction
extension ViewController {
    @IBAction func currencyNavAction(_ sender: Any) {
        Navigator.navigate(from: self, to: CurrencyViewController.self, with: "")
    }
}

// MARK: UI Methods
extension ViewController {
    private func UILoad() {
        currencyBT.layer.cornerRadius = 10
    }
}



