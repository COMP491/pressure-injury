//
//  ImageService.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 20.04.2024.
//

import Foundation
import UIKit

class InjuryPhaseService {
    
    var localIPAddress: String? {
        if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return dict["localIPAddress"] as? String
        }
        return nil
    }
    
    func saveInjuryPhase(withImage image: UIImage?, drawingData: Data?, injuryPhase: InjuryPhase, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let ip = localIPAddress, let url = URL(string: "http://\(ip):8080/api/add-injury-phase") else {
            print("Invalid URL")
            return
        }
        
        guard let image = image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let uniqueID = UUID().uuidString
        
        let encoder = JSONEncoder()
        guard let injuryPhaseData = try? encoder.encode(injuryPhase) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(uniqueID).jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n".data(using: .utf8)!)
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"request\"\r\n\r\n".data(using: .utf8)!)
        data.append(injuryPhaseData)
        data.append("\r\n".data(using: .utf8)!)
        
        if let drawingData = drawingData {
            let uniqueDrawingID = UUID().uuidString
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"drawingData\"; filename=\"\(uniqueDrawingID).data\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            data.append(drawingData)
            data.append("\r\n".data(using: .utf8)!)
            data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        } else {
            data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        }
        
        request.httpBody = data

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let message = String(data: data, encoding: .utf8)
                completion(.success(message ?? "No response"))
            }
        }

        task.resume()
    }
    
    func getInjuryPhases(injury: Injury, completion: @escaping (Result<[InjuryPhaseDTO], Error>) -> Void) {
        guard let ip = localIPAddress, let url = URL(string: "http://\(ip):8080/api/get-injury-phases?id=\(injury.id ?? 0)") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let injuryPhases = try decoder.decode([InjuryPhaseDTO].self, from: data)
                    completion(.success(injuryPhases))
                } catch {
                    print("Error: \(error)")
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }

    func editInjuryPhase(withImage image: UIImage?, drawingData: Data?, injuryPhase: InjuryPhase, completion: @escaping (Result<String, Error>) -> Void) {
    }
    
    
}
