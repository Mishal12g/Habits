import Foundation

protocol URLSessionProtocol {
    func objectTask<T: Codable>(for request: URLRequest,
                                completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask
    func objectTask<T: Encodable> (for url: URL,
                                   with body: T,
                                   completion: @escaping (Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    func objectTask<T: Encodable> (for url: URL,
                                   with body: T,
                                   completion: @escaping (Error?) -> Void) -> URLSessionDataTask {
        let completionInMainQueue: (Error?) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        var request = URLRequest(url: url)
        let encoder = JSONEncoder()
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            print("failure request http body")
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if (200..<300) ~= statusCode {
                    
                    completionInMainQueue(nil)
                } else {
                    completionInMainQueue(NetworkError.statusCodeError(statusCode))
                }
            } else if let error = error {
                completionInMainQueue(error)
            } else {
                completionInMainQueue(NetworkError.responseError)
            }
        }
        
        return task
    }
    
    func objectTask<T: Codable>(for request: URLRequest,
                                completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        let completionInMainQueue: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if (200..<300) ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        completionInMainQueue(.success(result))
                        
                    } catch {
                        completionInMainQueue(.failure(NetworkError.emptyDataError(data)))
                    }
                } else {
                    completionInMainQueue(.failure(NetworkError.statusCodeError(statusCode)))
                }
                
            } else if let error = error {
                completionInMainQueue(.failure(error))
            } else {
                completionInMainQueue(.failure(NetworkError.responseError))
            }
        }
        
        return task
    }
}

private enum NetworkError: Error {
    case emptyDataError(Data)
    case statusCodeError(Int)
    case responseError
}

enum Bools: String {
    case bool1 = "bool1"
    case bool2 = "bool2"
    case bool3 = "bool3"
}
