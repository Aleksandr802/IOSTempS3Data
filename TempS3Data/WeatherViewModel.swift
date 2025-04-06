import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var temperature: Double?
    @Published var humidity: Double?
    
    private var timer: Timer?
    
    func startFetchingData() {
        fetchData()
        // Fetch data every 10 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.fetchData()
        }
    }
    
    func stopFetchingData() {
        timer?.invalidate()
    }
    
    private func fetchData() {
        guard let url = URL(string: "https://ykugjza793.execute-api.us-east-2.amazonaws.com") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self?.temperature = weatherData.temperature
                    self?.humidity = weatherData.humidity
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
