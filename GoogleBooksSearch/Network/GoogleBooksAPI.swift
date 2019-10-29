//
//  NetworkAPI.swift
//  GoogleBooksSearch
//
//  Created by ParkHanul on 22/10/19.
//  Copyright © 2019 eeearl. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

struct GoogleBooksAPI {
    func request(searchText: String, startIndex: Int, resultCount: Int) -> Observable<[BookDisplayable]> {
        return RxAlamofire
            .requestJSON(GoogleBooksAPIRouter.volumes(searchText, startIndex, resultCount))
            .flatMap { (response, resData) -> Observable<[BookDisplayable]> in
                guard let dic = resData as? [String: Any], let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) else { return .never() }
                
                let decoder = JSONDecoder()
                do {
                    let booksVolumeResponse: BooksVolumeResponse = try decoder.decode(BooksVolumeResponse.self, from: data)
                    return .just(booksVolumeResponse.items?.map { $0.volumeInfo } ?? [])
                } catch {
                    return .error(error)
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

public enum GoogleBooksAPIRouter: URLRequestConvertible {
    
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
  
  var path: String {
    switch self {
    case .volumes:
      return "/volumes"
    }
  }
  
  var parameters: [String: Any] {
    switch self {
    case .volumes(let search, let startIndex, let results):
        return ["q": "\(search)", "startIndex":"\(startIndex)", "maxResults":"\(results)"]
    }
  }
  
  public func asURLRequest() throws -> URLRequest {
    let url = try Constants.baseURLPath.asURL()
    
    var request = URLRequest(url: url.appendingPathComponent(path))
    request.httpMethod = method.rawValue
    
    return try URLEncoding.default.encode(request, with: parameters)
  }
}
