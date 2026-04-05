import 'package:shared_preferences/shared_preferences.dart';

enum UserGender { female, male, unspecified }

class UserPrefs {
  UserPrefs._();

  static const String _genderKey = 'selected_gender';

  static Future<void> setGender(UserGender gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_genderKey, gender.name);
  }

  static Future<UserGender> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_genderKey);
    switch (raw) {
      case 'female':
        return UserGender.female;
      case 'male':
        return UserGender.male;
      case 'unspecified':
      default:
        return UserGender.unspecified;
    }
  }
}
