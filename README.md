
# KCReactive

KCReactive is an iOS application showcasing advanced use of modern Swift technologies, including Combine, MVVM architecture, and reusable UI components. The app demonstrates features like authentication, hero management, toast notifications, and advanced animations, making it an excellent starting point for scalable and clean code projects.

---

## Features

### General
- **Combine Framework**: Used for managing asynchronous data streams.
- **MVVM Architecture**: Clean separation of concerns with ViewModel-driven UI logic.
- **Reusable Components**: Custom `ToastView`, animations, and modular UI elements.
- **Dependency Injection**: Easily swap implementations for testing purposes.

### Authentication
- Login functionality with `LoginUseCase` and `TokenManager`.
- Secure token storage using `KeychainSwift`.
- Simulated and real login flows with support for auto-login.

### Heroes Management
- Display heroes in a scrollable table view with a clean and animated UI.
- Filter heroes by name using the search functionality.
- Details view for each hero with transformations and favorite toggle.

### Animations
- Smooth transitions with reusable animations:
  - Fade-in
  - Translation with bounce effect
  - Button press effects

---

## Architecture

### Project Layers
- **Domain Layer**: Contains use cases like `HeroUseCase` and `LoginUseCase` to encapsulate business logic.
- **Data Layer**: Handles data fetching via repositories and services, e.g., `HeroRepository` and `TransformationService`.
- **Presentation Layer**: Manages UI components and their interaction with the ViewModels.

### MVVM Structure
Each feature follows the MVVM structure:
- **Model**: Encapsulates app data (e.g., `Hero`, `Transformation`).
- **ViewModel**: Processes data for display and interacts with use cases.
- **View**: Displays the data provided by the ViewModel.

---

## Technologies Used
- **Swift**: Primary programming language.
- **Combine**: Reactive programming.
- **UIKit**: UI development framework.
- **KeychainSwift**: Secure storage for tokens.
- **Kingfisher**: Image downloading and caching.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/HerniRG/Reactive-MVVM.git
   ```

2. Navigate to the project directory:
   ```bash
   cd KCReactive
   ```

3. Open the project in Xcode:
   ```bash
   open KCReactive.xcodeproj
   ```

4. Build and run the project:
   - Select your target device.
   - Press `Cmd + R` or click **Run** in Xcode.

---

## Testing

The project includes comprehensive unit tests for key components:
- **ViewModel Tests**: Validate logic for `LoginViewModel`, `HeroesViewModel`, and more.
- **Repository Tests**: Ensure proper data handling by repositories.
- **UI Tests**: Verify animations and UI interactions.

Run tests using:
```bash
Cmd + U
```
Or go to **Product > Test** in Xcode.

---

## Example Usage

### Login
1. Enter your email and password.
2. Tap the login button.
3. Upon success, navigate to the heroes list.

### Hero Management
- Scroll through the list of heroes.
- Tap a hero to view detailed information and transformations.
- Mark a hero as a favorite.

### Notifications
- Toast notifications display success or error messages with smooth animations.

---

## Code Samples

### ToastView Usage
```swift
let toast = ToastView()
toast.configure(message: "Hello Toast!", backgroundColor: .blue)
toast.show(in: view, duration: 2.0)
```

### HeroViewModel
```swift
let viewModel = HeroesViewModel()
await viewModel.loadHeroes(filter: "")
print(viewModel.heroes)
```

### Animations
```swift
view.fadeInWithTranslation(yOffset: 20, duration: 0.6)
```

---

## Contributions

Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeatureName`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeatureName`).
5. Open a pull request.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Contact

For questions or suggestions:
- Author: Hernán Rodríguez
- Email: hernanrg85@gmail.com
- GitHub: [@HerniRG](https://github.com/HerniRG)
