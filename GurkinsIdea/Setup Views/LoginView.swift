//
//  LoginView.swift
//  TODO
//
//  Created by Sebastian Esser on 9/18/19.
//  Copyright © 2019 Sebastian Esser. All rights reserved.
//

import SwiftUI
import UIKit

struct LoginView: View {
    
    //MARK: Properties
    @State var email: String = ""
    @State var password: String = ""
    
    @State var error = false
    
    @EnvironmentObject var session: FirebaseSession
    
    let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                
                HStack{
                    Text("Sign In")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding()
                    Spacer()
                }
                TextField("Email", text: $email)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading)
                    .background(lightGreyColor)
                    .cornerRadius(5)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                
                SecureField("Password", text: $password)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading)
                    .background(lightGreyColor)
                    .cornerRadius(5)
                    .padding(.leading)
                    .padding(.trailing)
                    .padding(.bottom)
                
                if (error)
                {
                    Text("Invalid email or password")
                    .foregroundColor(.red)
                }
                
                Button(action: logIn) {
                    Text("Sign In")
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
                .padding()
                
                HStack{
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                        .font(.caption)
                    NavigationLink(destination: SignUp()) {
                        Text("Sign Up")
                            .font(.caption)
                    }
                }
            }
        .padding()
        }
    }
    
    //MARK: Functions
    func logIn() {
        session.logIn(email: email, password: password) { (result, error) in
            if error != nil {
                print("Error")
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
