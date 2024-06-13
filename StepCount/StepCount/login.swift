import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isSignUpComplete = false
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .padding(.top, 20)
        }
        .padding()
        .alert(isPresented: $isSignUpComplete) {
            Alert(title: Text("Sign Up Successful"), message: Text("You have successfully signed up."), dismissButton: .default(Text("OK")))
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let user = result?.user else {
                self.errorMessage = "User creation failed."
                return
            }

            // Add user to Firestore
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "email": self.email,
                "createdAt": Timestamp()
            ]) { error in
                if let error = error {
                    self.errorMessage = "Failed to save user: \(error.localizedDescription)"
                } else {
                    self.errorMessage = nil
                    self.isSignUpComplete = true
                    self.isAuthenticated = true
                }
            }
        }
    }
}

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @Binding var isAuthenticated: Bool

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                login()
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
            }
            .padding(.top, 20)
        }
        .padding()
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }

            // Successfully logged in
            self.errorMessage = nil
            self.isAuthenticated = true
        }
    }
}


struct MainView: View {
    @State private var isAuthenticated = false
    @State private var isCheckingAuth = true

    var body: some View {
        Group {
            if isCheckingAuth {
                ProgressView()
                Text("Checking authentication...")
                .padding(.top, 10)
            } else if isAuthenticated {
                ContentView(isAuthenticated: $isAuthenticated)
            } else {
                AuthSelectionView(isAuthenticated: $isAuthenticated)
            }
        }
        .onAppear {
            checkAuthState()
        }
    }

    func checkAuthState() {
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
        isCheckingAuth = false
    }
}

struct AuthSelectionView: View {
    @Binding var isAuthenticated: Bool

    var body: some View {
        NavigationView {
            HStack{
                NavigationLink(destination: LoginView(isAuthenticated: $isAuthenticated)) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(5)
                }
                .padding()
                
                NavigationLink(destination: SignUpView(isAuthenticated: $isAuthenticated)) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(5)
                }
                .padding()
            }
            .navigationBarTitle("Welcome")
        }
    }
}


