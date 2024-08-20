//
//  AlamofireDataProvider.swift
//  BasicNoteApp
//
//  Created by Serkan Erkan on 18.07.2024.
//

import Alamofire
import Foundation
import DataProvider

final class AlamofireDataProvider: DataProviderProtocol {
    
    private let session: Session
    
    init(interceptor: RequestInterceptor? = nil) {
        self.session = Session( interceptor: interceptor, eventMonitors: [AlamofireApiLogger.shared])
    }
    
    func request<T: DecodableResponseRequest>(request: T,
                                              result: DataProviderDecodableResult<T.ResponseType>? = nil) {
        let adapter = AlamofireRequestAdapter(request: request)
        session.request(adapter.url,
                        method: adapter.method,
                        parameters: adapter.parameters,
                        encoding: adapter.encoding,
                        headers: adapter.headers)
        .responseDecodable(of: T.ResponseType.self) { response in
            switch response.result {
            case .success(let response):
                result?(.success(response))
            case .failure(let error):
                result?(.failure(error))
            }
        }
    }
}
