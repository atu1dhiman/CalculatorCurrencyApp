//
//  ViewController.swift
//  Assignment
//
//  Created by Atul Dhiman on 12/01/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    
    // MARK:  IBOutlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var currencyBT: UIButton!
    
    @IBOutlet weak var deleteBT: UIButton!
    @IBOutlet weak var tableVw: UITableView!
    // MARK:  DataModel Variables
    private var currencyData : CurrencyData?
    var conversionRecords: [CurrencyConversionRecord] = [] {
        didSet {
            tableVw.reloadData()
        }
    }
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UILoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        UILoad()
    }
}

// MARK: IBAction
extension ViewController {
    @IBAction func currencyNavAction(_ sender: Any) {
        Navigator.navigate(from: self, to: CurrencyViewController.self, with: "")
    }
    
    
    @IBAction func deleteAction(_ sender: Any) {
        // Clear records
        UserDefaults.standard.removeObject(forKey: "conversionRecords")
        // Optionally synchronize to make sure changes are saved immediately
        UserDefaults.standard.synchronize()
        tableVw.reloadData()
    }
}

// MARK: UI Methods
extension ViewController {
    private func UILoad() {
        currencyBT.layer.cornerRadius = 10
        tableVw.dataSource = self
        tableVw.delegate = self
        tableVw.register(UINib(nibName: "historyTableViewCell", bundle: nil), forCellReuseIdentifier: "historyTableViewCell")
        tableVw.reloadData()
        // Retrieve records
        if let data = UserDefaults.standard.data(forKey: "conversionRecords"),
           let decodedRecords = try? JSONDecoder().decode([CurrencyConversionRecord].self, from: data ) {
            conversionRecords = decodedRecords
            print("xzz", conversionRecords)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversionRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath) as? historyTableViewCell else{
            return UITableViewCell()
        }
        // Update the conversionRecords array with the filtered data
        let data =  conversionRecords[indexPath.row]
        let originalValue = data.amount
        let roundedValue = originalValue.rounded()
        cell.baseLbl.text = "\(roundedValue) \(data.sourceCurrency)"
        
        let originalValue2 = data.exchangeRate
        _ = originalValue2.rounded()
        cell.currentLbl.text = "\(originalValue2) \(data.targetCurrency)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
