//
//  CurrencyNetworkFile.swift
//  Assignment
//
//  Created by Atul Dhiman on 12/01/24.
//

import Foundation

// MARK: - App APIs EndPoint
enum CurrencyAPIEndPoint : APIEndPoint {
    case getAllCurrency
    case getSingleCurrency(base_currency : String, currencies : String)
    case none
}
 
// MARK: - API URL
extension CurrencyNetworkFile {
    internal var urlString: String {
        switch endPoint {
        case .getAllCurrency : return "v1/latest?apikey=\(AccessKeys.apiKey)"
        case .getSingleCurrency(_, _) : return "v1/latest?apikey=\(AccessKeys.apiKey)"
        case .none: return ""
        }
    }
}
 
// MARK: - API Method
extension CurrencyNetworkFile {
    internal var method: HTTPMethod {
        switch endPoint {
            case .getAllCurrency : return .get
            case .getSingleCurrency(_, _) : return .get
            case .none: return .post
        }
    }
}
 
// MARK: - API Body Params
extension CurrencyNetworkFile {
    internal var params: [String: Any]? {
        switch endPoint {
            case .getSingleCurrency(let base_currency,let currencies) : return ["base_currency" : base_currency, "currencies" : currencies]
            default: return nil
        }
    }
}
 
// MARK: - API Query Params
extension CurrencyNetworkFile {
    internal var queryItems: [URLQueryItem]? {
        switch endPoint {
            default: return nil
        }
    }
}
 
// MARK: - API Header
extension CurrencyNetworkFile {
    internal var header: String {
        switch endPoint {
        default: return ""
        }
    }
}
 
// MARK: - CurrencyNetworkFile Manager
class CurrencyNetworkFile: ConfigRequestDelegate {
    static let shared = CurrencyNetworkFile()
    private var endPoint: CurrencyAPIEndPoint = .none
    private init() { }
 
    internal func getRequest(with endPoint: APIEndPoint) -> URLRequest? {
        self.endPoint = endPoint as? CurrencyAPIEndPoint ?? .none
        let configRequest = ConfigRequest(endPoint)
        configRequest.delegate = self
        return configRequest.request
    }
}
 
// MARK: - Currency API Calls
extension CurrencyNetworkFile {
    
    func getAllCurrencyRate(successCallBack: @escaping (CurrencyData) -> Void, failureCallBack: @escaping (_ errorStr: String?) -> Void) {
        let request = getRequest(with: CurrencyAPIEndPoint.getAllCurrency)
        BaseNetworkManager.shared.fetch(request) { resData, response in
            guard let resData = resData, let response = response else { return }
            guard response is HTTPURLResponse else { return }
            do {
                let model = try JSONDecoder().decode(CurrencyData.self, from: resData)
                successCallBack(model)
            }catch{
                failureCallBack(error.localizedDescription)
            }
        } failureCallBack: { errorStr in
            failureCallBack(errorStr)
        }
    }
    
    
    func getAllCurrencyRate(to : String, from : String, successCallBack: @escaping (CurrencyData) -> Void, failureCallBack: @escaping (_ errorStr: String?) -> Void) {
        
        let request = getRequest(with: CurrencyAPIEndPoint.getSingleCurrency(base_currency: to, currencies: from))
        BaseNetworkManager.shared.fetch(request) { resData, response in
            guard let resData = resData, let response = response else { return }
            guard response is HTTPURLResponse else { return }
            do {
                let model = try JSONDecoder().decode(CurrencyData.self, from: resData)
                successCallBack(model)
            }catch{
                failureCallBack(error.localizedDescription)
            }
        } failureCallBack: { errorStr in
            failureCallBack(errorStr)
        }
    }
    
}


