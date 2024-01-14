//
//  BaseNetworkManager.swift
//  Assignment
//
//  Created by Atul Dhiman on 12/01/24.
//

import Foundation


// MARK: - Data Fetch
protocol Transport {
    func fetch(_ request: URLRequest?, successCallBack: @escaping (Data?, URLResponse?) -> Void, failureCallBack: @escaping (String?) -> Void)
}

// MARK: - API Response Update Delegate
protocol APIResponseUpdateDelegate: AnyObject {
    func success()
    func failed(with errorStr: String?)
}

// MARK: - App Environment Config
enum Environment: String {
    case dev = "APP_DEV"
}

// MARK: - Base URL
struct BaseURL {
    static let gateURL = "https://api.freecurrencyapi.com/"
}

// MARK: - Base URL String
var appBaseURL: String {
    return BaseURL.gateURL
}

// MARK: - HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

// MARK: - Configurable Request
protocol RequestConfigurable {
    var urlString: String { get }
    var request: URLRequest? { get }
    var params: [String: Any]? { get }
    var method: HTTPMethod? { get }
    var queryItems: [URLQueryItem]? { get }
}

// MARK: - API EndPoint
protocol APIEndPoint {}

// MARK: - Config Request Delegate
protocol ConfigRequestDelegate {
    var urlString: String { get }
    var params: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
    var header: String { get }
    var method: HTTPMethod { get }
    func getRequest(with endPoint: APIEndPoint) -> URLRequest?
}

// MARK: - Config Request
class ConfigRequest: RequestConfigurable {
    var endPoint: APIEndPoint
    var delegate: ConfigRequestDelegate?
    
    var request: URLRequest? {
        return createRequest()
    }
    
    init(_ endPoint: APIEndPoint) {
        self.endPoint = endPoint
    }
    
    private func createRequest() -> URLRequest? {
        guard let apiURL = URL(string: urlString) else { return nil }
        var request = URLRequest(url: apiURL)
        request.httpMethod = method?.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("ios", forHTTPHeaderField: "platform")
        request.timeoutInterval = 60.0
        request.httpBody = createRequestBody()
        return request
    }
    
    private func createRequestBody() -> Data? {
        do {
            if let params = params {
                let data = try JSONSerialization.data(withJSONObject: params, options: [])
                return data
            }
        } catch _ {
            debugPrint("Invalid params")
        }
        return nil
    }
}

// MARK: - API Method
extension ConfigRequest {
    internal var urlString: String {
        return BaseURL.gateURL + (delegate?.urlString ?? "")
    }
}

// MARK: - Params
extension ConfigRequest {
    internal var params: [String: Any]? {
        return delegate?.params
    }
}

// MARK: - QueryItems
extension ConfigRequest {
    internal var queryItems: [URLQueryItem]? {
        return delegate?.queryItems
    }
}

// MARK: - HTTP Method
extension ConfigRequest {
    internal var method: HTTPMethod? {
        return delegate?.method
    }
}

// MARK: - Header Method
extension ConfigRequest {
    internal var header: String {
        return delegate?.header ?? "application/json; charset=utf-8"
    }
}

// MARK: - Base Network Manager
class BaseNetworkManager: Transport {
    
    static let shared = BaseNetworkManager()
    let networkSession: URLSession
    
    fileprivate init(session: URLSession = .shared) {
        networkSession = session
    }
    
    func fetch(_ request: URLRequest?, successCallBack: @escaping (Data?, URLResponse?) -> Void, failureCallBack: @escaping (String?) -> Void) {
        guard let request = request else { return }
        
        networkSession.dataTask(with: request) { (resData, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    failureCallBack(error.localizedDescription)
                    return
                }
                guard let resp = response as? HTTPURLResponse, let respData = resData else { return }
                switch resp.statusCode {
                case 200:
                    successCallBack(respData, response)
                case 400:
                    self.handleErrorResponse(respData: respData, failureCallBack: failureCallBack)
                default:
                    failureCallBack("Unknown Failure Case,Server Down")
                }
            }
        }.resume()
    }
    private func handleErrorResponse(respData: Data, failureCallBack: @escaping (String?) -> Void) {
        do {
            let respDict = try JSONSerialization.jsonObject(with: respData, options: [])
            guard let resp = respDict as? [String: Any], let errorMsg = resp["error"] as? String else { return }
            failureCallBack(errorMsg)
        }catch {
            failureCallBack(error.localizedDescription)
        }
    }
}
