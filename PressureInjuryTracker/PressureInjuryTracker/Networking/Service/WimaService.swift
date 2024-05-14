//
//  WimaService.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 14.05.2024.
//

import Foundation

class WimaService {
    
    var localIPAddress: String? {
        if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return dict["localIPAddress"] as? String
        }
        return nil
    }
    
    var wimaPort: String? {
        if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return dict["wimaPort"] as? String
        }
        return nil
    }
    
    func classify(imageData: Data?, injuryPhase: InjuryPhase, completion: @escaping (Result<WimaClassificationDTO, Error>) -> Void) {
        
        guard let ip = localIPAddress, let port = wimaPort, let url = URL(string: "http://\(ip):\(port)/classify") else {
            print("Invalid URL")
            return
        }
        
        guard let imageData = imageData else { return }
        
        let encoder = JSONEncoder()
        guard let injuryPhaseData = try? encoder.encode(injuryPhase) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print("Error: \(error)")
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let wimaPrediction = try decoder.decode(WimaClassificationDTO.self, from: data)
                    completion(.success(wimaPrediction))
                } catch {
                    print("Error: \(error)")
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
