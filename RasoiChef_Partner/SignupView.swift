//
//  SignupView.swift
//  RasoiChef_Partner
//
//  Created by Ankit Jain on 18/05/25.
//

import SwiftUI

// Enum to track registration steps
enum RegistrationStep: Int, CaseIterable {
    case restaurantInfo = 0
    case menuAndOperations = 1
    case restaurantDocuments = 2
    
    var title: String {
        switch self {
        case .restaurantInfo:
            return "Restaurant information"
        case .menuAndOperations:
            return "Menu and operational details"
        case .restaurantDocuments:
            return "Restaurant documents"
        }
    }
    
    var subtitle: String {
        switch self {
        case .restaurantInfo:
            return "Name, location and contact number"
        case .menuAndOperations:
            return "Menu details and operational hours"
        case .restaurantDocuments:
            return "Upload required documents"
        }
    }
    
    var iconName: String {
        switch self {
        case .restaurantInfo:
            return "building.2"
        case .menuAndOperations:
            return "list.clipboard"
        case .restaurantDocuments:
            return "doc.text"
        }
    }
}

struct SignupView: View {
    @State private var currentStep: RegistrationStep = .restaurantInfo
    
    // Restaurant Info
    @State private var restaurantName = ""
    @State private var location = ""
    @State private var contactNumber = ""
    
    // Menu & Operations
    @State private var cuisineType = ""
    @State private var operationHours = ""
    @State private var avgMealCost = ""
    
    // Documents
    @State private var hasLicense = false
    @State private var hasFoodSafetyCert = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress bar and step indicator
            progressView
            
            // Current step form
            formForCurrentStep
                .transition(.opacity)
                .animation(.easeInOut, value: currentStep)
            
            // Navigation buttons
            navigationButtons
        }
        .padding()
    }
    
    // MARK: - Components
    
    private var progressView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Complete your registration")
                .font(.title2)
                .fontWeight(.bold)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 4)
                    .foregroundColor(Color(.systemGray5))
                
                Rectangle()
                    .frame(width: progressWidth, height: 4)
                    .foregroundColor(.blue)
            }
            .cornerRadius(2)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 40) {
                    ForEach(RegistrationStep.allCases, id: \.self) { step in
                        StepIndicatorView(
                            step: step,
                            isActive: currentStep == step,
                            isCompleted: step.rawValue < currentStep.rawValue
                        )
                    }
                }
                .padding(.vertical)
            }
        }
        .padding(.bottom)
    }
    
    private var progressWidth: CGFloat {
        let totalSteps = CGFloat(RegistrationStep.allCases.count)
        let currentStepValue = CGFloat(currentStep.rawValue)
        
        // For first step, show some progress already
        let progress = (currentStepValue + 0.5) / totalSteps
        return UIScreen.main.bounds.width * 0.9 * progress
    }
    
    private var formForCurrentStep: some View {
        Group {
            switch currentStep {
            case .restaurantInfo:
                restaurantInfoForm
            case .menuAndOperations:
                menuOperationsForm
            case .restaurantDocuments:
                documentsForm
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var restaurantInfoForm: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Restaurant Details")
                .font(.headline)
                .padding(.top)
            
            TextField("Restaurant Name", text: $restaurantName)
                .textFieldStyle(RoundedTextFieldStyle())
            
            TextField("Location/Address", text: $location)
                .textFieldStyle(RoundedTextFieldStyle())
            
            TextField("Contact Number", text: $contactNumber)
                .keyboardType(.phonePad)
                .textFieldStyle(RoundedTextFieldStyle())
            
            Spacer()
        }
    }
    
    private var menuOperationsForm: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Menu & Operations")
                .font(.headline)
                .padding(.top)
            
            TextField("Cuisine Type", text: $cuisineType)
                .textFieldStyle(RoundedTextFieldStyle())
            
            TextField("Operation Hours (e.g., 9AM-10PM)", text: $operationHours)
                .textFieldStyle(RoundedTextFieldStyle())
            
            TextField("Average Meal Cost", text: $avgMealCost)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedTextFieldStyle())
            
            Spacer()
        }
    }
    
    private var documentsForm: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Required Documents")
                .font(.headline)
                .padding(.top)
            
            Toggle("Restaurant License", isOn: $hasLicense)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Toggle("Food Safety Certificate", isOn: $hasFoodSafetyCert)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Button(action: {
                // Document upload action
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Upload Documents")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
            }
            
            Spacer()
        }
    }
    
    private var navigationButtons: some View {
        HStack {
            if currentStep != .restaurantInfo {
                Button(action: { goToPreviousStep() }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
            }
            
            Button(action: { goToNextStep() }) {
                Text(currentStep == RegistrationStep.allCases.last ? "Complete" : "Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(.top)
    }
    
    // MARK: - Navigation Functions
    
    private func goToNextStep() {
        if let nextStepRaw = RegistrationStep(rawValue: currentStep.rawValue + 1) {
            currentStep = nextStepRaw
        } else {
            // Handle completion - Registration finished
            completeRegistration()
        }
    }
    
    private func goToPreviousStep() {
        if let prevStepRaw = RegistrationStep(rawValue: currentStep.rawValue - 1) {
            currentStep = prevStepRaw
        }
    }
    
    private func completeRegistration() {
        print("Registration completed with:")
        print("Restaurant: \(restaurantName)")
        print("Location: \(location)")
        print("Contact: \(contactNumber)")
        print("Cuisine: \(cuisineType)")
        print("Hours: \(operationHours)")
        print("Avg Cost: \(avgMealCost)")
        print("Has License: \(hasLicense)")
        print("Has Food Safety: \(hasFoodSafetyCert)")
    }
}

// MARK: - Supporting Views

struct StepIndicatorView: View {
    var step: RegistrationStep
    var isActive: Bool
    var isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundColor(backgroundColor)
                
                Image(systemName: step.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            }
            
            Text(step.title)
                .font(.system(size: 14))
                .fontWeight(isActive ? .bold : .regular)
            
            Text(step.subtitle)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
    }
    
    private var backgroundColor: Color {
        if isActive {
            return .blue
        } else if isCompleted {
            return .green
        } else {
            return Color(.systemGray3)
        }
    }
}

struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}
