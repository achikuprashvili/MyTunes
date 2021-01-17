//
//  BackendManager.swift
//  MyTunes
//
//  Created by Archil on 1/18/21.
//

import Foundation
import RxSwift
import Alamofire

protocol BackendManagerProtocol {
    
    func sendRequest(requestRouter: RequestRouter) -> Observable<Data>
    func sendDecodableRequest<T>(requestRouter: RequestRouter) -> Observable<T> where T : Decodable
}

class BackendManager: BackendManagerProtocol {
    
    let disposeBag = DisposeBag()
    
    func sendRequest(requestRouter: RequestRouter) -> Observable<Data> {
        return Observable<Data>.create { observer in
            let request = AF.request(requestRouter)
            
            request.validate().responseJSON { response in
                self.parseResult(response: response).subscribe(onNext: { (data) in
                    observer.onNext(data)
                }, onError: { (error) in
                    observer.onError(error)
                }).disposed(by: self.disposeBag)
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func sendDecodableRequest<T>(requestRouter: RequestRouter) -> Observable<T> where T : Decodable {
        return Observable<T>.create { observer in
            self.sendRequest(requestRouter: requestRouter).subscribe(onNext: { (jsonData) in
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
                    observer.onNext(decodedObject)
                } catch {
                    observer.onError(NSError(domain: "parse error", code: 1, userInfo: nil))
                }
            }, onError: { (error) in
                observer.onError(error)
            }).disposed(by: self.disposeBag)
            
            return Disposables.create {
            
            }
        }
    }
    
    private func parseResult(response: AFDataResponse<Any>) -> Observable<Data> {
        return Observable<Data>.create { observer in
            switch response.result {
            case .success(let value):
                guard let dict = value as? [String : Any] else {
                    observer.onError(NSError(domain: "parse error", code: 1, userInfo: nil))
                    return Disposables.create {
                    }
                }
            
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    observer.onNext(jsonData)
                } catch {
                    observer.onError(NSError(domain: "parse error", code: 1, userInfo: nil))
                }
                
            case .failure(let error):
                observer.onError(error)
            }
            
            return Disposables.create {
            
            }
        }
    }
}
