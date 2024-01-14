//
//  GenericClass.swift
//  Assignment
//
//  Created by Atul Dhiman on 12/01/24.
//

import Foundation
import UIKit



// MARK: - This Generic Class has been used for Navigation Stack.

class DataReceivingViewController<U>: UIViewController {
    var receivedData: U?
}
class Navigator {
    static func navigate<T: UIViewController, U>(from sourceViewController: UIViewController, to destinationViewControllerType: T.Type, with data: U) {
        let destinationViewController = destinationViewControllerType.init()
        // If assuming your destination view controller has a property named "receivedData"
        if let destinationVC = destinationViewController as? DataReceivingViewController<U> {
            destinationVC.receivedData = data
        }
        sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

