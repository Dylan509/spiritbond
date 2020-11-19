//
//  Extension.swift
//  spiritbond
//
//  Created by lim jia le on 2020/9/24.
//

import Foundation

extension Int {

    var display: String? {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = 0
        f.locale = Locale(identifier: "en_US")

        let number = NSNumber(value: self)
        return f.string(from: number)
    }
}

extension Double {
    
    var currency: String? {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        
        let number = NSNumber(value: self)
        
        return nf.string(from: number )
    }
    
    var display: String? {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        f.locale = Locale(identifier: "en_US")

        let number = NSNumber(value: self)
        return f.string(from: number)
    }

    var displaySign: String? {
        guard var string = display else { return nil }

        if self > 0 {
            string = "+\(string)"
        }

        return string
    }

}

extension URL {

    func get<T:Codable>(completion: @escaping (T?) -> Void) {
        let debug = true
        if debug {
            print("get: \(self.absoluteString)")
        }

        let session = URLSession.shared
        session.dataTask(with: self) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(T.self, from: data) {
                DispatchQueue.main.async {
                    completion(decoded)
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }

}
