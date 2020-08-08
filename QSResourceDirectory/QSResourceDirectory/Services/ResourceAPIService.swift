//
//  ResourceAPIService.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import Foundation
protocol APIServiceInterface {
    func fetchCategories(result: @escaping (Result<[Category], ResourceAPIService.APIError>) -> Void)
    func fetchByCategoryType(_ categoryType: CategoryType, result: @escaping (Result<[Destination], ResourceAPIService.APIError>) -> Void)
}

struct ResourceAPIService: APIServiceInterface {
    enum EndPoint: String {
         case categories
         case restaurants
         case vacationSpots = "vacation-spot"
    }

    enum APIError: Error {
        case badURL
        case noData
        case invalidResponse(String)
        case invalidService(Error)
        case unableToParse(Error)
        case invalidEndpoint
    }

    func fetchCategories(result: @escaping (Result<[Category], APIError>) -> Void) {
        guard let data = getJSONData(.categories) else {
            result(.failure(.noData))
            return
        }
        decodeResult(data: data) { (res: Result<[Category], APIError>) in
            result(res)
        }
    }

    func fetchByCategoryType(_ categoryType: CategoryType, result: @escaping (Result<[Destination], APIError>) -> Void) {
        var responseData: Data?
        switch categoryType {
            case .restaurants:
                responseData = getJSONData(.restaurants)
            case .vacationSpots:
                responseData = getJSONData(.vacationSpots)
            case .unknown:
                debugPrint("Invalid type show error")
                result(.failure(.invalidEndpoint))
                return
        }
        guard let data = responseData else {
            result(.failure(.noData))
            return
        }
        decodeResult(data: data) { (res: Result<[Destination], APIError>) in
            result(res)
        }
    }
}

private extension ResourceAPIService {
    func getJSONData(_ filename: EndPoint) -> Data? {
        guard let filePath = Bundle.main.path(forResource: filename.rawValue, ofType: "json") else {
            fatalError("\(filename.rawValue).json not found")
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
            // simulate wait time
//            let randomTime = Int(arc4random_uniform(2))
//            sleep(UInt32(randomTime))
            return data
        } catch let e {
            print(e)
            return nil
        }
    }

    func decodeResult<T: Codable>(data: Data, result: @escaping (Result<T, APIError>) -> Void) {
        do {
            let dataDecoded = try JSONDecoder().decode(T.self, from: data)
            result(.success(dataDecoded))
        } catch let e {
            result(.failure(.unableToParse(e)))
        }
    }
}
