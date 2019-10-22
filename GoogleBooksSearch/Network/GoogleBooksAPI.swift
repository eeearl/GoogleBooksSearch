//
//  NetworkAPI.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

struct GoogleBooksAPI {
    
//    func request<T: Routeable>(_ req: T) -> Observable<T> {
//        let urlString = baseUrl.appending(req.path)
//        guard let url = URL(string: urlString) else { return .never() }
//
//        return RxAlamofire.request(req.method, url,
//                                       parameters: req.parameters,
//                                       encoding: req.encoding,
//                                       headers: req.headers)
////            .observeOn(ConcurrentDispatchQueueScheduler(queue: .main))
////            .map({ try JSONSerialization.data(withJSONObject: $0.1, options: []) })
////            .map(T.ResponseType.self)
////            .map(T.ResponseType.self, using: JSONDecoder())
//    }
    
    func request(searchText: String, startIndex: Int, resultCount: Int, callback: @escaping ([BooksItem]) -> Void ) {
        Alamofire.request(ImaggaRouter.volumes(searchText, startIndex, resultCount))
            .validate { req, res, data in
                return .success
            }
            .responseJSON { response in
                guard let data = response.data else {
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let booksVolumeResponse: BooksVolumeResponse = try decoder.decode(BooksVolumeResponse.self, from: data)
                    callback(booksVolumeResponse.items?.map { $0 } ?? [])
                } catch {
                    print(error)
                }
            }
    }
}

protocol Routeable: URLRequestConvertible {
    associatedtype ResponseType: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: [String: String]? { get }
}

public enum ImaggaRouter: URLRequestConvertible {
  enum Constants {
    static let baseURLPath = "https://www.googleapis.com/books/v1"
  }
  
  case volumes(String, Int, Int)
  
  var method: HTTPMethod {
    switch self {
    case .volumes:
      return .get
    }
  }
  
  // 4
  var path: String {
    switch self {
    case .volumes:
      return "/volumes"
    }
  }
  
  // 5
  var parameters: [String: Any] {
    switch self {
    case .volumes(let search, let startIndex, let results):
        return ["q": "search \(search)", "startIndex":"\(startIndex)", "maxResults":"\(results)", "projection":"lite"]
    }
  }
  
  // 6
  public func asURLRequest() throws -> URLRequest {
    let url = try Constants.baseURLPath.asURL()
    
    var request = URLRequest(url: url.appendingPathComponent(path))
    request.httpMethod = method.rawValue
    
    return try URLEncoding.default.encode(request, with: parameters)
  }
}
