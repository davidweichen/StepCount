import SwiftUI
import Combine

// Define a structure for the weather data
struct Weather{
    let main: String
    let temperature: Double
    let condition: String
    let windSpeed: Double
    let humidity: Int
    let feels_like: Double
    let visibility: Int
    let icon: String
}

// Define a service to fetch the weather data
class WeatherService {
    private let apiKey = "YOUR_API_KEY"
    
    //produce by microsoft copilot
    func fetchCurrentWeatherByName(location: String) -> AnyPublisher<Weather, Error> {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(location)&appid=\(apiKey)&units=metric")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: OpenWeatherMapResponse.self, decoder: JSONDecoder())
            .map { response in
                Weather(
                    main: response.weather[0].main,
                    temperature: response.main.temp,
                    condition: response.weather[0].description.capitalized,
                    windSpeed: response.wind.speed,
                    humidity: response.main.humidity,
                    feels_like: response.main.feels_like,
                    visibility: response.visibility,
                    icon: response.weather[0].icon
                    
                )
            }
            .eraseToAnyPublisher()
    }

}

// Define the response structure based on OpenWeatherMap API
struct OpenWeatherMapResponse: Codable {
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let humidity: Int
    }
    
    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct Wind: Codable {
        let speed: Double
   }
    
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let visibility: Int

}


// Define the ViewModel
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: Weather?
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherService


    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
      }
    func fetchWeatherByName(location: String) {
        weatherService.fetchCurrentWeatherByName(location: location)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] weather in
                    self?.currentWeather = weather
                  })
            .store(in: &cancellables)
    }
    
}
