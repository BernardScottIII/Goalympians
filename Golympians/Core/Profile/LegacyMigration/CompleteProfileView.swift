//
//  CompleteProfileView.swift
//  Golympians
//
//  Created by Bernard Scott on 7/22/25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

struct CompleteProfileView: View {
    @State private var username: String = ""
    @State private var nickname: String = ""
    @State private var age: Int = 0
    @State private var birthday: Date = Date.now
    @State private var weight: Double = 0.0
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    @StateObject private var userAccountViewModel = UserAccountViewModel()
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 1970, month: 1, day: 1)
        return calendar.date(from:startComponents)! ... Date(timeIntervalSinceNow: 0)
    }()
    
    @StateObject private var viewModel: CompleteProvileViewModel

    @Binding var profileIncomplete: Bool
    let dataService: WorkoutManagerProtocol
    
    init(
        profileCompleted: Binding<Bool>,
        dataService: WorkoutManagerProtocol
    ) {
        _profileIncomplete = profileCompleted
        self.dataService = dataService
        
        _viewModel = StateObject(wrappedValue: CompleteProvileViewModel(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Update Notice")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            HStack {
                Text("""
If you are seeing this screen, thank you for being an early adopter! We've just added public profiles to Golympians, which means the app needs a little bit more info to work properly!
""")
                
                Spacer()
            }
            
            Spacer()
            
            Section("Profile Picture") {
                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    if url != nil {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 108, height: 108)
                                .clipShape(.circle)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 108, height: 108)
                        }
                    } else {
                        ZStack {
                            Text("Tap to upload profile picture")
                                .frame(width: 96)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 108))
                                .foregroundStyle(Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.3))
                        }
                    }
                }
            }
            
            Spacer()
            
            Section {
                TextField("Your Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .clipShape(.buttonBorder)
                    .onSubmit {
                        Task {
                            try await viewModel.checkUniqueness(username)
                            viewModel.checkFormCompletion()
                        }
                    }
            } header: {
                HStack {
                    Text("Username")
                        .font(.headline)
                    Spacer()
                }
            } footer: {
                if viewModel.usernameIsUnique {
                    HStack {
                        Image(systemName: "checkmark")
                        // Magic number here. My intention is for the icon to be the same height as text
                            .font(.system(size: 24))
                        
                        Text("This username is available")
                        
                        Spacer()
                    }
                    .foregroundStyle(.green)
                } else {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                        // Magic number here. My intention is for the icon to be the same height as text
                            .font(.system(size: 24))
                        
                        Text("This username has already been taken.")
                        
                        Spacer()
                    }
                    .foregroundStyle(.red)
                }
                
            }
            
            Section {
                TextField("What do you like to go by?", text: $nickname)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .clipShape(.buttonBorder)
            } header: {
                HStack {
                    Text("Nickname")
                        .font(.headline)
                    Spacer()
                }
            } footer: {
                HStack {
                    Image(systemName: "info.circle")
                    // Magic number here. My intention is for the icon to be the same height as text
                        .font(.system(size: 24))
                    
                    Text("This name will be publicly displayed on your profile.")
                    
                    Spacer()
                }
                .foregroundStyle(.yellow)
                
            }
            
            Section {
                DatePicker("Birthday", selection: $birthday, in: dateRange, displayedComponents: [.date])
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .clipShape(.buttonBorder)
            } header: {
                HStack {
                    Text("Age")
                        .font(.headline)
                    Spacer()
                }
            }
            
            Section {
                HStack {
                    TextField("How much do you weigh?", value: $weight, format: .number)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .clipShape(.buttonBorder)
                        .keyboardType(.numberPad)
                    
                    Menu("Units") {
                        ForEach(MeasurementUnits.allCases, id: \.self) { metric in
                            Button {
                                viewModel.setMeasurementUnit(metric)
                            } label: {
                                if metric == viewModel.measurementUnitSelection {
                                    Image(systemName: "checkmark")
                                }
                                Text(metric.prettyString)
                            }
                        }
                    }
                }
            } header: {
                HStack {
                    Text("Weight (Units: \(viewModel.measurementUnitDisplay))")
                        .font(.headline)
                    Spacer()
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                try await userAccountViewModel.loadCurrentUser()
            }
        }
        .onChange(of: selectedPhoto, { oldValue, newValue in
            if let newValue {
                Task {
                    try await userAccountViewModel.saveFirstProfileImage(item: newValue)
                    try await userAccountViewModel.loadCurrentUser()
                    if let photoURL = userAccountViewModel.user?.photoURL {
                        url = URL(string: photoURL)
                    }
                }
            }
        })
        
        Button {
            Task {
                let userId = userAccountViewModel.user!.userId
                
                let newProfile = Profile(
                    username: username,
                    nickname: nickname,
                    followers: [],
                    following: [],
                    photoURL: userAccountViewModel.user?.photoURL,
                    photoPath: userAccountViewModel.user?.photoImagePath
                )
                try await viewModel.setUserData(userId: userId, data: ["username":username])
                
                try await viewModel.createNewProfile(profile: newProfile)
            }
            profileIncomplete.toggle()
        } label: {
            Text("Continue")
                
        }
        .disabled(viewModel.formIsIncomplete)
    }
}

#Preview {
    @Previewable let dataService = ProdWorkoutManager(workoutCollection: Firestore.firestore().collection("workouts"))
    NavigationStack {
        CompleteProfileView(profileCompleted: .constant(false), dataService: dataService)
    }
}
