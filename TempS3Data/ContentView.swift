//
//  ContentView.swift
//  TempS3Data
//
//  Created by Oleksandr Seminov on 2/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var progress: Double = 0.0
    @State private var timer: Timer?
    @State private var isFahrenheit = false

    var body: some View {
        ZStack {
            // Background 3D Effect Rectangle (Light Gray Base)
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 300, height: 600)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 5, y: 5) // 3D Shadow

            // Smooth 3D Progress Bar
            RoundedRectangle(cornerRadius: 50)
                .trim(from: 0.0, to: CGFloat(progress / 60))
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.orange.opacity(1.0)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .frame(width: 600, height: 300)
                .rotationEffect(.degrees(-90)) // Start from the top
                .shadow(color: .orange.opacity(0.6), radius: 5, x: 2, y: 2) // 3D Highlight
            
            // Temperature & Humidity Section
            VStack(spacing: 40) {
                // Temperature
                VStack {
                    Image("tempIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text(isFahrenheit ? "\(convertToFahrenheit(viewModel.temperature)) °F" : "\(viewModel.temperature?.formatted() ?? "Loading...") °C")
                        .font(.custom("Chalkboard SE", size: 28))
                        .bold()
                    
                    Toggle("Fahrenheit", isOn: $isFahrenheit)
                        .toggleStyle(SwitchToggleStyle())
                        .labelsHidden()
                        .foregroundColor(.blue)
                }

                // Humidity
                VStack {
                    Image("humidityIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                    
                    Text("\(viewModel.humidity?.formatted() ?? "Loading...") %")
                        .font(.custom("Chalkboard SE", size: 28))
                        .bold()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground)) // Light/Dark mode adaptive
        .onAppear {
            startProgressBar()
            viewModel.startFetchingData()
        }
        .onDisappear {
            stopProgressBar()
            viewModel.stopFetchingData()
        }
    }
    
    func convertToFahrenheit(_ celsius: Double?) -> String {
        guard let celsius = celsius else { return "Loading..." }
        let fahrenheit = (celsius * 9/5) + 32
        return String(format: "%.1f", fahrenheit)
    }
    
    private func startProgressBar() {
        progress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(.linear(duration: 1.0)) { // Smooth animation
                if progress >= 60 {
                    progress = 0
                } else {
                    progress += 1
                }
            }
        }
    }
    
    private func stopProgressBar() {
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







