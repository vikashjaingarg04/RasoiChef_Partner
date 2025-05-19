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
    @State private var currentStep: Int = 0
    @State private var showSectionPage: Bool = false
    
    let steps: [StepData] = [
        StepData(icon: "bell", title: "Restaurant information", subtitle: "Name, location and contact number"),
        StepData(icon: "menucard", title: "Menu and operational details", subtitle: nil),
        StepData(icon: "folder", title: "Restaurant documents", subtitle: nil)
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                VerticalStepper(steps: steps, currentStep: $currentStep, showSectionPage: $showSectionPage)
                    .padding(.vertical)
                Spacer()
            }
            .padding()
            .background(Color.white.ignoresSafeArea())
            .navigationBarHidden(true)
            // Navigation destination for each section
            .background(
                NavigationLink(
                    destination: sectionDestination(for: currentStep),
                    isActive: $showSectionPage,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
    
    @ViewBuilder
    private func sectionDestination(for step: Int) -> some View {
        switch step {
        case 0:
            RestaurantInfoFormView()
        case 1:
            MenuDetailsFormView()
        case 2:
            DocumentsFormView()
        default:
            EmptyView()
        }
    }
}

struct StepData {
    let icon: String
    let title: String
    let subtitle: String?
}

struct VerticalStepper: View {
    let steps: [StepData]
    @Binding var currentStep: Int
    @Binding var showSectionPage: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<steps.count, id: \.self) { idx in
                StepperRow(
                    step: steps[idx],
                    isActive: idx == currentStep,
                    isCompleted: idx < currentStep,
                    showContinue: idx == currentStep,
                    onContinue: {
                        showSectionPage = true
                    }
                )
                if idx < steps.count - 1 {
                    VStack {
                        Rectangle()
                            .fill(Color(.systemGray4))
                            .frame(width: 3, height: 36)
                            .padding(.leading, 21)
                    }
                }
            }
        }
        .padding(.top, 24)
    }
}

struct StepperRow: View {
    let step: StepData
    let isActive: Bool
    let isCompleted: Bool
    let showContinue: Bool
    let onContinue: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(isActive ? Color.orange.opacity(0.15) : Color(.systemGray6))
                    .frame(width: 42, height: 42)
                Image(systemName: step.icon)
                    .font(.system(size: 22))
                    .foregroundColor(.orange)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(step.title)
                    .font(.system(size: 18, weight: isActive ? .semibold : .regular))
                    .foregroundColor(isActive ? Color(red: 0.36, green: 0.44, blue: 0.18) : Color(.systemGray))
                if isActive, let subtitle = step.subtitle {
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray))
                }
                if showContinue {
                    Button(action: onContinue) {
                        HStack(spacing: 2) {
                            Text("Continue")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.blue)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 2)
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// Dummy destination views for navigation
struct RestaurantInfoView: View {
    var body: some View {
        Text("Restaurant Info Details")
            .navigationTitle("Restaurant Info")
    }
}

struct MenuDetailsView: View {
    var body: some View {
        Text("Menu & Operational Details")
            .navigationTitle("Menu & Details")
    }
}

struct DocumentsView: View {
    var body: some View {
        Text("Restaurant Documents")
            .navigationTitle("Documents")
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

// Section 1: Restaurant Info Form
struct RestaurantInfoFormView: View {
    @State private var restaurantName = ""
    @State private var ownerName = ""
    @State private var ownerEmail = ""
    @State private var ownerPhone = ""
    @State private var getUpdatesOnWhatsapp = true
    @State private var primaryContact = ""
    @State private var sameAsOwnerMobile = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Restaurant Name Card
                VStack(alignment: .leading, spacing: 0) {
                    Text("Restaurant name")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(.label))
                        .padding(.bottom, 2)
                    Text("Customers will see this name on RasoiChef")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom, 16)
                    TextField("Restaurant name*", text: $restaurantName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .font(.system(size: 17))
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color(.systemGray4).opacity(0.18), radius: 8, x: 0, y: 2)
                
                // Owner Details Card
                VStack(alignment: .leading, spacing: 0) {
                    Text("Owner details")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(.label))
                        .padding(.bottom, 2)
                    Text("RasoiChef will use these details for all business communications and updates")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom, 16)
                    HStack(spacing: 12) {
                        TextField("Full name*", text: $ownerName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        TextField("Email address*", text: $ownerEmail)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                    .font(.system(size: 16))
                    .padding(.bottom, 12)
                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Text("🇮🇳 +91")
                                .font(.system(size: 16, weight: .medium))
                                .padding(.leading, 12)
                            Divider().frame(height: 24)
                            TextField("Phone number*", text: $ownerPhone)
                                .keyboardType(.numberPad)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 4)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    
                    
                    }
                    
                    
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color(.systemGray4).opacity(0.18), radius: 8, x: 0, y: 2)
            }
            .padding()
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Restaurant information")
    }
}

// Custom Checkbox Toggle Style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .onTapGesture { configuration.isOn.toggle() }
            configuration.label
        }
    }
}

// Section 2: Menu & Operational Details
struct MenuDetailsFormView: View {
    @State private var cuisineType = ""
    @State private var operationHours = ""
    @State private var avgMealCost = ""
    var body: some View {
        Form {
            Section(header: Text("Menu & Operations")) {
                TextField("Cuisine Type", text: $cuisineType)
                TextField("Operation Hours (e.g., 9AM-10PM)", text: $operationHours)
                TextField("Average Meal Cost", text: $avgMealCost)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Menu and operational details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Section 3: Documents Upload
struct DocumentsFormView: View {
    @State private var hasLicense = false
    @State private var hasFoodSafetyCert = false
    var body: some View {
        Form {
            Section(header: Text("Required Documents")) {
                Toggle("Restaurant License", isOn: $hasLicense)
                Toggle("Food Safety Certificate", isOn: $hasFoodSafetyCert)
                Button(action: {
                    // Document upload action
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Upload Documents")
                    }
                }
            }
        }
        .navigationTitle("Restaurant documents")
        .navigationBarTitleDisplayMode(.inline)
    }
}
