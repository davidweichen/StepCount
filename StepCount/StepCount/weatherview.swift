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

}

// Define a service to fetch the weather data
class WeatherService {
    private let apiKey = "35e57bc8efeff5e8c2a253b80196d678"
    
    func fetchCurrentWeather(longitude: Double, latitude: Double) -> AnyPublisher<Weather, Error> {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric")!
        
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
                    visibility: response.visibility
                )
            }
            .eraseToAnyPublisher()
    }
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
                    visibility: response.visibility
                    
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

    func fetchWeather(longitude: Double, latitude: Double) {
        weatherService.fetchCurrentWeather(longitude: longitude, latitude: latitude)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] weather in
                    self?.currentWeather = weather
                  })
            .store(in: &cancellables)
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
