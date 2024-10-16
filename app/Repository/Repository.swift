//
//  Repository.swift
//  app
//
//  Created by Muune on 2023/03/07.
//

import Foundation
import Alamofire
import SwiftUI
import SwiftyJSON

class Repository{
    static let shared = Repository()
    
    func fetchProjects(viewModel: MainViewModel, callback:@escaping (ProjectResponse)->()) {
        let url = viewModel.baseUrl() + "/api/admin/app/\(Constants.API_VERSION)/projects"
        let doNetwork = AF.request(url, method: .get, headers: getHeaders())
        
        if(Constants.isDebug){
            //viewModel.log(value: url)
            //viewModel.log(value: getHeaders())
            
            doNetwork.validate(contentType: ["application/json"]).responseJSON{ response in switch response.result {
                case .success(let json):
                   viewModel.log(value: "fetchProjects" , json)
                case .failure(let error):
                   viewModel.log(value: "error", error)
                }
            }
        }
        
        doNetwork.validate(contentType: ["application/json"]).responseJSON{ response in
            switch response.result {
            case .success(let json):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let getInstanceData = try JSONDecoder().decode(ProjectResponse.self, from: dataJSON)
                    
                    callback(getInstanceData)
                }catch let error as NSError {
                    viewModel.log(value: "error, \(error.localizedDescription)")
                    //viewModel.errorModalOpen(subText: error.localizedDescription){}
                }
            case .failure(let error):
                viewModel.log(value: "error, \(error.localizedDescription)")
                //viewModel.errorModalOpen(subText: error.localizedDescription){}
            }
        }
    }
    
    
    func fetchQRCheck(viewModel: MainViewModel, id:Int, uuid:String, allows:[Allow], callback:@escaping (QRResultResponse)->()) {
        let url = viewModel.baseUrl() + "/api/admin/app/\(Constants.API_VERSION)/qr"

        let dict = try? DictionaryEncoder().encode(allows)
        if(dict == nil){
            viewModel.toastEventTop.send("allows JSON pasing에 실패하였습니다.")
            return
        }
       
        let parameters:[String: Any] = [
            "id": id,
            "uuid": uuid,
            "allows": dict!
        ]
        
        viewModel.log(value: "allows.asDictionary()" , dict)
        
        let doNetwork = AF.request(url, method: .post, parameters:parameters, encoding: JSONEncoding.default, headers: getHeaders())
        
        if(Constants.isDebug){
            doNetwork.validate(contentType: ["application/json"]).responseJSON{ response in switch response.result {
                case .success(let json):
                   viewModel.log(value: "fetchQRCheck" , json)
                case .failure(let error):
                   viewModel.log(value: "error0", error)
                }
            }
        }
        
        doNetwork.validate(contentType: ["application/json"]).responseJSON{ response in
            switch response.result {
            case .success(let json):
                do{
                    let dataJSON = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                    let getInstanceData = try JSONDecoder().decode(QRResultResponse.self, from: dataJSON)
                    
                    callback(getInstanceData)
                }catch let error as NSError {
                    viewModel.log(value: "error1, \(error.localizedDescription)")
                    //viewModel.errorModalOpen(subText: error.localizedDescription){}
                }
            case .failure(let error):
                viewModel.log(value: "error2, \(error.localizedDescription)")
                //viewModel.errorModalOpen(subText: error.localizedDescription){}
            }
        }
        
    }
    
    func getCouponDetail(uuid: String, callback: @escaping (Result<CouponModel, APIError>) -> Void) {
        let url = Constants.BASE_COUPON_DEV_URL + "/admin/coupons/usage/\(uuid)"
        let doNetwork = AF.request(url, method: .get, headers: getHeaders())
        
        doNetwork.validate(contentType: ["application/json"]).responseDecodable(of: CouponModel.self) { response in
            switch response.result {
                case .success(let res):
                callback(.success(res))
            case .failure:
                if let data = response.data {
                    let error = self.handelError(data: data)
                    callback(.failure(error))
                } else {
                    callback(.failure(.invalidResponse))
                }
            }
        }
    }
    
    func comfirmCoupon(uuid: String, callback: @escaping (Result<String, APIError>)->()) {
        let url = Constants.BASE_COUPON_DEV_URL + "/admin/coupons/checkout/\(uuid)"
        let doNetwork = AF.request(url, method: .post, encoding: JSONEncoding.default, headers: getHeaders())
        
        doNetwork.validate(contentType: ["application/json"]).responseDecodable(of: ErrorData.self) { response in
            if response.response?.statusCode == 200 {
                callback(.success("Coupon has been used successfully"))
            } else {
                switch response.result {
                    case .success(let res):
                    callback(.failure(.serverError(res)))
                case .failure:
                    callback(.failure(.invalidResponse))
                }
            }
        }
    }
    
    func getHeaders() -> HTTPHeaders{
        return ["Authorization": "Bearer " + Constants.API_TOKEN]
    }
    
    private func handelError(data: Data) -> APIError {
        do {
            let result = try JSONDecoder().decode(ErrorData.self, from: data)
            return .serverError(result)
        } catch _ as NSError {
            return .invalidResponse
        }
    }
}


class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    /// Encodes given Encodable value into an array or dictionary
    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

class DictionaryDecoder {
    private let jsonDecoder = JSONDecoder()

    /// Decodes given Decodable type from given array or dictionary
    func decode<T>(_ type: T.Type, from json: Any) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try jsonDecoder.decode(type, from: jsonData)
    }
}
