//
//  InjuryService.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 20.04.2024.
//

import Foundation

class InjuryService {
    
    var localIPAddress: String? {
        if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return dict["localIPAddress"] as? String
        }
        return nil
    }
    
    var backendPort: String? {
        if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return dict["backendPort"] as? String
        }
        return nil
    }
    
    func addInjury(injury: Injury, for patient: Patient, completion: @escaping (Result<String, Error>) -> Void) {
        guard let ip = localIPAddress, let port = backendPort, let url = URL(string: "http://\(ip):\(port)/api/add-injury") else {
            print("Invalid URL")
            return
        }
            
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: injury.date)
        let addInjuryRequest = AddInjuryRequest(barcode: patient.barcode, region:injury.region, location: injury.location, date: dateString)
            
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(addInjuryRequest)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode AddInjuryRequest: \(error)")
            return
        }
            
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let message = String(data: data, encoding: .utf8)
                completion(.success(message ?? "No response"))
            }
        }
        
        task.resume()
    }
    
    func fetchInjuries(patient: Patient, completion: @escaping (Result<[Injury], Error>) -> Void) {
        guard let ip = localIPAddress, let url = URL(string: "http://\(ip):8080/api/get-patient-injuries-by-barcode?barcode=\(patient.barcode)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                
                print(String(data: data, encoding: .utf8) ?? "")
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let injuries = try decoder.decode([Injury].self, from: data)
                    completion(.success(injuries))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func deleteInjury(_ injury: Injury, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let ip = localIPAddress, let url = URL(string: "http://\(ip):8080/api/delete-injury/\(injury.id ?? 0)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
            } else if let data = data {
                let message = String(data: data, encoding: .utf8)
                completion(.success(message ?? "No response"))
            }
        }

        task.resume()
    }
    
}
