import SwiftUI

struct ContentView: View {
    @StateObject var weatherviewModel = WeatherViewModel(weatherService: WeatherService())
    @StateObject private var locationManager = LocationManager()
    @StateObject var stepviewmodel = StepsViewModel()
    @StateObject var pointsViewModel = PointsViewModel()
    @State private var cityName: String = "Unknown"
    var body: some View {
        NavigationView{
            VStack {
                    Text("Welcome to StepCount")
                                .font(.title)
                                .padding()

                    // Display the points information
                    Text("Your Points: \(pointsViewModel.points)")
                    Button(action: {
                        pointsViewModel.resetPoints()
                    }) {
                        Text("Reset Points")
                    }
                    Text("Current City: \(cityName)")
                               .padding()
                    // Display the weather information
                if let weather = weatherviewModel.currentWeather {
                        Text("Temperature: \(weather.temperature, specifier: "%.1f")°C")
                        HStack {
                            Text("Condition: \(weather.condition)")
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                    }
                } else {
                    Text("No weather data available")
                }


                        NavigationLink(destination: detailview()){
                            Text("view details")
                        }
            }
        
        }
        .padding()
        .onAppear {
            locationManager.checkLocationAuthorization()
            locationManager.cityNameChanged = {
                            self.cityName = self.locationManager.locationName ?? "Unknown"
                            weatherviewModel.fetchWeatherByName(location: cityName)
                        }
            stepviewmodel.fetchSteps()
            pointsViewModel.setup(stepsViewModel: stepviewmodel, weatherViewModel: weatherviewModel)
        }
    }
}
struct detailview: View {
    @StateObject var weatherviewModel = WeatherViewModel(weatherService: WeatherService())
    @StateObject private var locationManager = LocationManager()
    @State private var cityName: String = "Unknown"
    var body: some View {
            VStack {
                
                // Display the weather information
                if let weather = weatherviewModel.currentWeather {
                    Text("Weather: \(weather.main)")
                    Text("Temperature: \(weather.temperature, specifier: "%.1f")°C")
                    Text("Feels like \(weather.feels_like, specifier: "%.1f")°C")
                    Text("Humidity: \(weather.humidity)%")
                    Text("Wind speed: \(weather.windSpeed)mph")
                    Text("Visibility: \(weather.visibility) metres")
                    HStack {
                        Text("Condition: \(weather.condition)")
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                    }
                    
                } else {
                    Text("No weather data available")
                }
                
                NavigationLink(destination: otherlocationview()){
                    Text("see other location")
                }
        }
        .padding()
        .onAppear {
            locationManager.checkLocationAuthorization()
            locationManager.cityNameChanged = {
                            self.cityName = self.locationManager.locationName ?? "Unknown"
                            weatherviewModel.fetchWeatherByName(location: cityName)
                        }
        }
    }
}
struct otherlocationview: View {
    @StateObject var weatherviewModel = WeatherViewModel(weatherService: WeatherService())
    @State private var city = ""
    var body: some View {
        VStack {

                TextField("Enter the city to look for the weather", text: $city)
                                .padding()
                                .border(Color.gray, width: 0.5)

                            Button(action: {
                                weatherviewModel.fetchWeatherByName(location: city)
                            }) {
                                Text("Search")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                // Display the weather information
                if let weather = weatherviewModel.currentWeather {
                    Text("Weather: \(weather.main)")
                    Text("Temperature: \(weather.temperature, specifier: "%.1f")°C")
                    Text("Feels like \(weather.feels_like, specifier: "%.1f")°C")
                    Text("Humidity: \(weather.humidity)%")
                    Text("Wind speed: \(weather.windSpeed)mph")
                    Text("Visibility: \(weather.visibility) metres")
                    HStack {
                        Text("Condition: \(weather.condition)")
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                    }
                } else {
                    Text("No weather data available")
                }
        }
        .padding()
    }
}
