//
//  AlamofireApiLogger.swift
//  BasicNoteApp
//
//  Created by Serkan Erkan on 18.07.2024.
//

import Foundation
import Alamofire

class AlamofireApiLogger: EventMonitor {
    
    static let shared = AlamofireApiLogger()
    
    func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {
        print("---> Request Create Start <---")
        print(request)
        print(urlRequest)
        if let httpBody = urlRequest.httpBody {
            print(httpBody)
            do {
                let json = try JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: Any]
                print("httpBody")
                print(json as Any)
            } catch {
                print(error.localizedDescription)
            }
        }
        if let queryParameters = urlRequest.url?.queryParameters {
            print("Parameters")
            print(queryParameters)
        }
        print("---> Request Create End <---")
        
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    func requestDidFinish(_ request: Request) {
        print("---> Request Finished Start<---")
        print(request.description)
        print("---> Request Finished End<---")
        
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("---> Request JSONResponse <---")
        if let data = response.data, let json = String(data: data, encoding: .utf8) {
            print(json)
        }
    }
}

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
