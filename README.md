# StepCount Weather App

This is a SwiftUI application that displays the user's step count and the current weather information.

## Features

- Displays the user's step count points and allows the user to reset their points.
- The points is calculated by mutiplying your steps with mutiplier, if it was a rainy day or a snowy day, the mutiplier would be 1.5x
- Fetches and displays the current weather information including temperature, condition, humidity, wind speed, and visibility. The weather condition is accompanied by an image.
- Allows the user to navigate to a detailed view for more weather information.
- Allows the user to search for weather information of other locations.

## How It Works

The application uses several view models to handle data:

- `WeatherViewModel`: Fetches and stores the current weather information.
- `LocationManager`: Checks location authorization and stores the last known location.
- `StepsViewModel`: Fetches the user's steps.
- `PointsViewModel`: Sets up and stores the user's points.

On launch, the application checks location authorization, fetches the weather information based on the user's location, fetches the user's steps, and sets up the user's points.

## How to test
- add steps: Open the Apple health, add Steps to favorite, after entered the steps, press add data at the right top corner
- search the weather: After enter the app, click view more details and click see other location, enter the city that you are looking for 

## Usage

To run the application, open the project in Xcode and run it on a simulator or a physical device.

Please note that this application requires location access to fetch the weather information based on the user's location.
