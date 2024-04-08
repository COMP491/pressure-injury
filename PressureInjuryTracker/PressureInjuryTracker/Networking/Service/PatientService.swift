//
//  PatientService.swift
//  PressureInjuryTracker
//
//  Created by Eren Ergün on 31.03.2024.
//

import Foundation

class PatientService {
    
    var localIPAddress: String? {
            if let path = Bundle.main.path(forResource: "Property List", ofType: "plist"),
               let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                return dict["localIPAddress"] as? String
            }
            return nil
        }
    
    func getPatientDetails(barcode: String, completion: @escaping (Result<Patient, Error>) -> Void) {
        guard let ip = localIPAddress, let url = URL(string: "http://\(ip):8080/api/get-patient-details?barcode=\(barcode)") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 404 {
                    completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Patient not found"])))
                } else if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(Patient.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    
    func addPatient(_ patient: Patient, completion: @escaping (Result<String, Error>) -> Void) {
        guard let ip = localIPAddress, let url = URL(string: "http://\(ip):8080/api/add-patient") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(patient)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let message = String(data: data, encoding: .utf8)
                completion(.success(message ?? ""))
            }
        }.resume()
    }

}

