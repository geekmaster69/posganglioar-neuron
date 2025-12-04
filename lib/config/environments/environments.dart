import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  static Future<void> initEnvironments() {
    return dotenv.load(fileName: '.env');
  }

  static String apiUrl = dotenv.get(
    'BASE_URL',
    fallback: 'No BASE_URL initialized',
  );

  static String locations = dotenv.get(
    'LOCATIONS_PATH',
    fallback: 'No LOCATIONS_PATH initialized',
  );
  
  static String loginPath = dotenv.get(
    'LOGIN_PATH',
    fallback: 'No LOGIN_PATH initialized',
  );
  
  static String locationsUserPath = dotenv.get(
    'LOCATIONS_USER',
    fallback: 'No LOCATIONS_USER initialized',
  );

  static String register = dotenv.get(
    'REGISTER_PATH',
    fallback: 'No REGISTER_PATH initialized',
  );

  static String checkStatus = dotenv.get(
    'CHECK_STATUS_PATH',
    fallback: 'No CHECK_STATUS_PATH initialized',
  );
}
