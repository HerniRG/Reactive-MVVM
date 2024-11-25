//
//  LocalizedStrings.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//


import Foundation

struct LocalizedStrings {
    struct Login {
        static let email = NSLocalizedString("Email", comment: "Placeholder for email field")
        static let password = NSLocalizedString("Password", comment: "Placeholder for password field")
        static let loginButton = NSLocalizedString("Login", comment: "Title for login button")
        static let loginSuccess = NSLocalizedString("LoginSuccess", comment: "Successful login message")
        static let welcomeBack = NSLocalizedString("WelcomeBack", comment: "Welcome back message")
    }
    
    struct Heroes {
        static let title = NSLocalizedString("Heroes", comment: "Title for Heroes screen")
        static let heroesError = NSLocalizedString("HeroesError", comment: "Error loading heroes")
    }
    
    struct Errors {
        static let invalidCredentials = NSLocalizedString("InvalidCredentials", comment: "Invalid credentials error")
        static let accessDenied = NSLocalizedString("AccessDenied", comment: "Access denied error")
        static let serverError = NSLocalizedString("ServerError", comment: "Server error with code")
        static let networkError = NSLocalizedString("NetworkError", comment: "Network connectivity error")
        static let unexpectedError = NSLocalizedString("UnexpectedError", comment: "Unexpected error")
    }
}
