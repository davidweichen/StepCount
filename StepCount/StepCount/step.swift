import Foundation
import Combine
import HealthKit

//work with microsoft copilot
class StepsViewModel: ObservableObject {
    private var healthStore: HKHealthStore?
    private var query: HKAnchoredObjectQuery?
    @Published var steps: Int = 0

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func requestAuthorization() {
        let readTypes: Set = [HKObjectType.quantityType(forIdentifier: .stepCount)!]

        healthStore?.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            if success {
                print("success")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchSteps() {
        let type = HKObjectType.quantityType(forIdentifier: .stepCount)!
        var startDate = Date().addingTimeInterval(-10) //10 seconds ago
        let timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [self] timer in
            let endDate = Date() // Current time
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            // Execute the query with the updated predicate
            self.query = HKAnchoredObjectQuery(type: type, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { _, samples, _, _, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                self.updateSteps(samples: samples)
            }

            self.query?.updateHandler = { _, samples, _, _, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                self.updateSteps(samples: samples)
            }

            if let query = self.query {
                healthStore?.execute(query)
            }
            startDate = endDate // Update the startDate for the next interval
        }


        
    }


    private func updateSteps(samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample] else { return }

        DispatchQueue.main.async {
            self.steps = samples.reduce(0) { $0 + Int($1.quantity.doubleValue(for: .count())) }
        }
    }
}


class PointsViewModel: ObservableObject {
    @Published var points: Double
   {
        didSet {
            UserDefaults.standard.set(points, forKey: "Points")
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Load the stored points from UserDefaults
        self.points = UserDefaults.standard.double(forKey: "Points")
    }
    //work with microsoft copilot
    func setup(stepsViewModel: StepsViewModel, weatherViewModel: WeatherViewModel) {
        // Subscribe to steps publisher
        stepsViewModel.$steps
            // Ensure the sink closure is run on the main thread
            .receive(on: DispatchQueue.main)
            // Subscribe to the publisher
            .sink { steps in
                // Determine the multiplier based on the weather condition
                let multiplier: Double
                if let weather = weatherViewModel.currentWeather, ["Rain", "Snow"].contains(weather.main) {
                    multiplier = 1.5
                } else {
                    multiplier = 1.0
                }
                // Add the new points (steps * multiplier) to the existing points
                self.points += Double(steps) * multiplier
            }
            // Store the cancellable in the set of cancellables for future cancellation if needed
            .store(in: &cancellables)
    }

    
    // Function to reset the points to zero
    func resetPoints() {
        self.points = 0
    }
}

