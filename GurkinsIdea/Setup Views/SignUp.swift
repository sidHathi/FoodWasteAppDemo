//
//  SignUp.swift
//  TODO
//
//  Created by Sebastian Esser on 9/19/19.
//  Copyright © 2019 Sebastian Esser. All rights reserved.
//

import SwiftUI

struct SignUp: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State var error = false
    
    @EnvironmentObject var session: FirebaseSession
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    var body: some View {
        Group {
            VStack {
                
                HStack{
                    Text("Sign Up")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding()
                    Spacer()
                }
                Text("")
                HStack {
                    Text("Email:")
                    .font(.subheadline)
                    .bold()
                    Spacer()
                }
                .padding(.leading)

                TextField("Enter Email Address", text: $email)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading)
                    .background(lightGreyColor)
                    .cornerRadius(5)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                
                Text("")
                HStack {
                    Text("Password:")
                        .font(.subheadline)
                        .bold()
                    Spacer()
                }
                .padding(.leading)
                
                SecureField("Enter Password", text: $password)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading)
                    .background(lightGreyColor)
                    .cornerRadius(5)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                
                Text("")
                
                if (error)
                {
                    Text("Invalid email or password")
                        .foregroundColor(.red)
                }
                Button(action: signUp) {
                    Text("Sign Up")
                        .font(.headline)
                        .bold()
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.leading, 120)
                        .padding(.trailing, 120)
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    
    func signUp() {
        if !email.isEmpty && !password.isEmpty {
            session.signUp(email: email, password: password) { (result, error) in
                if error != nil {
                    self.error = true
                    print("Error")
                    print(error.debugDescription)
                } else {
                    self.email = ""
                    self.password = ""
                }
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
