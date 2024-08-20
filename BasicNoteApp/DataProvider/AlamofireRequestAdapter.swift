//
//  AlamofireRequestAdapter.swift
//  BasicNoteApp
//
//  Created by Serkan Erkan on 18.07.2024.
//

import Alamofire

struct AlamofireRequestAdapter {
    
    let url: String
    let method: HTTPMethod
    let encoding: ParameterEncoding
    let parameters: Parameters
    let headers: HTTPHeaders
    
    init<T: RequestProtocol>(request: T) {
        self.url = request.url
        self.method = request.method.toAlamofireMethod
        self.parameters = request.parameters
        var headers: HTTPHeaders = [:]
        request.headers.forEach({ headers[$0.key] = $0.value })
        self.headers = headers
        self.encoding = request.encoding.toAlamofireEncoding
    }
}

private extension RequestMethod {
    var toAlamofireMethod: HTTPMethod {
        switch self {
        case .connect: return .connect
        case .delete: return .delete
        case .get: return .get
        case .head: return .head
        case .options: return .options
        case .patch: return .patch
        case .post: return .post
        case .put: return .put
        case .trace: return .trace
        }
    }
}

private extension RequestEncoding {
    var toAlamofireEncoding: ParameterEncoding {
        switch self {
        case .url: return URLEncoding.default
        case .json: return JSONEncoding.default
        }
    }
}
