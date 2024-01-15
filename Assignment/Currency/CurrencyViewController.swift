//
//  CurrencyViewController.swift
//  Assignment
//
//  Created by Atul Dhiman on 12/01/24.
//

import UIKit




class CurrencyViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: IB Outlets
    @IBOutlet weak var currencyVw: UIView!
    @IBOutlet weak var enterAmtTxtField: UITextField!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var fromBT: UIButton!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var toBT: UIButton!
    @IBOutlet weak var resultVw: UIView!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var CurrencyPicker: UIPickerView!
    @IBOutlet weak var pickerVw: UIView!
    @IBOutlet weak var doneBT: UIButton!
    
    // MARK: DataModel Variables
    private var selectedCountry = ""
    private let currencyArray = ["DKK", "BRL","PHP","HUF","ILS", "CHF", "ISK", "MXN", "AUD", "RUB", "NZD", "CNY", "INR", "CAD", "BGN", "CZK", "EUR", "RON" , "MYR", "TRY", "USD", "GBP", "JPY", "THB", "KRW", "IDR", "HKD", "NOK", "ZAR", "PLN", "SGD", "HRK"]
    private var currencyData : CurrencyData?
    private var flag = false
    private var sumAmt = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Api Methods Call.
        getCurrency()
        // UI Load.
        UILoad()
    }
}

// MARK: - IB Outlet Methods
extension CurrencyViewController {
    
    @IBAction func toAction(_ sender: Any) {
        pickerVw.isHidden = false
        flag = false
    }
    @IBAction func fromAction(_ sender: Any) {
        pickerVw.isHidden = false
        flag = true
    }
    @IBAction func doneAction(_ sender: Any) {
        pickerVw.isHidden = true
        let rateValue = rate(baseAmt: currencyData?.data?[fromLbl.text ?? ""] ?? 0.0, convertAmt: currencyData?.data?[toLbl.text ?? ""] ?? 0.0)
        resultLbl.text = "\(String(format: "%.2f", rateValue)) \(fromLbl.text ?? "")"
    }
}
// MARK: - UI Compement Methods...
extension CurrencyViewController {
    private func UILoad() {
        currencyVw.layer.cornerRadius = 10
        resultVw.layer.cornerRadius = 10
        doneBT.layer.cornerRadius = 10
        CurrencyPicker.delegate = self
        CurrencyPicker.dataSource = self
        pickerVw.isHidden = true
        CurrencyPicker.selectRow(5, inComponent:0, animated:false)
        navigationController?.navigationBar.isHidden = true
        enterAmtTxtField.addTarget(self,
                                   action: #selector(self.textFieldDidChange(_:)),
                                   for: UIControl.Event.editingChanged)
    }
    @objc func textFieldDidChange(_ textField: UITextField)  {
        guard let Amount = enterAmtTxtField.text else { return }
        if Double(Amount) ?? 0.0 < 0{
            showAlertError()
        }else{
            let rateValue = rate(baseAmt: currencyData?.data?[fromLbl.text ?? ""] ?? 0.0, convertAmt: currencyData?.data?[toLbl.text ?? ""] ?? 0.0)
            resultLbl.text = "\(String(format: "%.2f", rateValue)) \(fromLbl.text ?? "")"
        }
        
    }
    private func rate(baseAmt : Double, convertAmt : Double) -> Double{
        if flag {
            sumAmt = (baseAmt / convertAmt) * (Double(enterAmtTxtField.text ?? "" ) ?? 0.0)
            return sumAmt
        }else{
            sumAmt = (baseAmt / convertAmt) * (Double(enterAmtTxtField.text ?? "" ) ?? 0.0)
            return sumAmt
        }
    }
    
    private func showAlertError() {
        let alert = UIAlertController(title: AccessKeys.errorTitle, message: AccessKeys.errorMsg, preferredStyle: .alert)
            
        alert.addAction(UIAlertAction(title: AccessKeys.errorBT, style: UIAlertAction.Style.default, handler: { _ in
              self.dismiss(animated: true)
          }))
          DispatchQueue.main.async {
              self.present(alert, animated: false, completion: nil)
          }
            
      }
    
    
}
// MARK: - Picker Delgate Methods.
extension CurrencyViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = currencyArray[row]
        if flag {
            fromLbl.text = selectedCountry
        }else {
            toLbl.text = selectedCountry
        }
    }
}

// MARK: - Network Call to Fetch the Currency Rate of different Regions.
extension CurrencyViewController {
    private func getCurrency() {
        CurrencyNetworkFile.shared.getAllCurrencyRate { [weak self] response in
            print("response: ", response)
            self?.currencyData = response
        } failureCallBack: { errorStr in
            print(errorStr as Any)
        }
    }
}


