import SwiftUI

struct ContentView: View {
    @StateObject var weatherviewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @StateObject var stepviewmodel = StepsViewModel()
    @StateObject var pointsViewModel = PointsViewModel()

    var body: some View {
        NavigationView{
            VStack {
                    // Display the weather information
                    if let weather = weatherviewModel.currentWeather {
                        Text("Temperature: \(weather.temperature, specifier: "%.1f")°C")
                        Text("Condition: \(weather.condition)")
                    } else {
                        Text("No weather data available")
                    }
                        NavigationLink(destination: detailview()){
                            Text("view details")
                        }
                    
                    Text("steps: \(stepviewmodel.steps)")
                    // Display the points information
                    Text("Points: \(pointsViewModel.points)")
                    
                    Button(action: {
                        pointsViewModel.resetPoints()
                    }) {
                        Text("Reset Points")
                    }
            }
        
        }
        .padding()
        .onAppear {
            locationManager.checkLocationAuthorization()
            fetchWeatherview()
            stepviewmodel.fetchSteps()
            fetchpoints()
        }
    }
    private func fetchWeatherview() {
        if let location = locationManager.lastKnownLocation {
            weatherviewModel.fetchWeather(longitude: location.longitude, latitude: location.latitude)
        }
    }
    private func fetchpoints(){
        pointsViewModel.setup(stepsViewModel: stepviewmodel, weatherViewModel: weatherviewModel)
    }
   

}
struct detailview: View {
    @StateObject var weatherviewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    var body: some View {
            VStack {
                
                // Display the weather information
                if let weather = weatherviewModel.currentWeather {
                    Text("Weather: \(weather.main)")
                    Text("Temperature: \(weather.temperature, specifier: "%.1f")°C")
                    Text("Feels like \(weather.feels_like, specifier: "%.1f")°C")
                    Text("Humidity: \(weather.humidity)%")
                    Text("Wind speed: \(weather.windSpeed)mph")
                    Text("Visibility: \(weather.visibility)metres")
                    Text("Condition: \(weather.condition)")
                    
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
            fetchWeatherview()

        }
    }
    private func fetchWeatherview() {
        if let location = locationManager.lastKnownLocation {
            weatherviewModel.fetchWeather(longitude: location.longitude, latitude: location.latitude)
        }
    }
}
struct otherlocationview: View {
    @StateObject var weatherviewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
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
                    Text("Visibility: \(weather.visibility)metres")
                    Text("Condition: \(weather.condition)")
                } else {
                    Text("No weather data available")
                }
        }
        .padding()
    }
}
