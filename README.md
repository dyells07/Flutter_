## Flutter Repository

### Overview
This Flutter repository hosts a comprehensive mobile application that combines weather forecasting functionality with real-time currency conversion capabilities. The app leverages various APIs to provide users with accurate weather forecasts based on their geographical location and enables them to convert any currency to Nepalese Rupees.

### Minimal Projects
1. **Weather Forecasting with Live Weather Map:**
   - Utilizes the Geolocator package to fetch the user's current location.
   - Retrieves live weather updates using a weather API.
   - Displays weather information such as temperature, humidity, wind speed, and conditions.
   - Offers a visually appealing interface with weather icons and descriptive text.
   - Integrates a live map feature to visualize weather conditions across different locations.
   - Provides users with an interactive map interface to explore weather forecasts worldwide.
   - Offers seamless navigation and zooming functionalities for enhanced user experience.

2. **Currency Converter:**
   - Accesses live currency exchange rates from an API.
   - Supports conversion of any currency to Nepalese Rupees (NPR).
   - Enables users to enter the desired amount in any currency and instantly convert it to NPR.
   - Offers accurate and up-to-date currency conversion rates for diverse currencies.

### Technologies Used
- **Flutter:** Cross-platform framework for building mobile applications.
- **Dart:** Programming language used for Flutter app development.
- **Geolocator Package:** Retrieves the user's geographical location.
- **Weather API:** Provides live weather updates and forecasts.
- **Maps SDK:** Renders live maps and weather overlays.
- **Currency Conversion API:** Fetches real-time currency exchange rates.

### Structure
- **lib/**: Contains the Dart code for the Flutter application.
  - **screens/**: Screens for different functionalities (e.g., WeatherScreen, CurrencyConverterScreen).
  - **components/**: Reusable UI components (e.g., WeatherCard, CurrencyConverter).
- **pubspec.yaml**: Specifies dependencies and metadata for the Flutter project.

### Usage
1. Clone the repository to your local machine.
2. Set up Flutter and Dart environment.
3. Install dependencies using `flutter pub get`.
4. Run the app on an emulator or physical device using `flutter run`.

### Future Improvements
- **Enhanced UI/UX:** Refine the user interface for improved aesthetics and usability.
- **Additional Features:** Integrate more features such as multiple currency conversions, weather alerts, etc.
- **Localization:** Support multiple languages and regions for broader accessibility.
- **Optimization:** Improve performance and efficiency for smoother app experience.

