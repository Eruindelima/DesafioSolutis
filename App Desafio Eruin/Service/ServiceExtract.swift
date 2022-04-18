






import Foundation
import UIKit


protocol ExtractDelegate: NSObjectProtocol {
    func didExtract(extracts: [ValuesExtract])
}


class ServiceExtract {
    
    var delegateExtract: ExtractDelegate?
    
    // MARK: - EXTRACT REQUEST
    func requestExtract(token: String, delegate: ExtractDelegate) {
        
        var request = URLRequest(url: URL(string: "https://api.mobile.test.solutis.xyz/extrato")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error)
            }
            if let safeData = data {
                if let extracts = self.parseJSONExtract(safeData) {
                    self.onResponseStatement(extracts: extracts)
                }
            }
        }
        task.resume()
    }
    
    func parseJSONExtract(_ extractData: Data) -> [ValuesExtract]? {
        let decoder = JSONDecoder()
        var extracts: [ValuesExtract] = []
        do {
            let decodeData = try decoder.decode([ValuesExtract].self, from: extractData)
            for i in decodeData {
                let data = i.data
                let descricao = i.descricao
                let valor = i.valor
                let extract = ValuesExtract(data: data, descricao: descricao, valor: valor)
                extracts.append(extract)
            }
            return extracts
        } catch {
            print(error)
            return nil
        }
    }
    
    func onResponseStatement(extracts: [ValuesExtract]){
        DispatchQueue.main.async {
            self.delegateExtract?.didExtract(extracts: extracts)
        }
    }
}
