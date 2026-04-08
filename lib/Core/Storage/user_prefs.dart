import 'package:shared_preferences/shared_preferences.dart';

enum UserGender { female, male, unspecified }
enum UserMood { tired, energetic, strong }

class UserPrefs {
  UserPrefs._();

  static const String _genderKey = 'selected_gender';
  static const String _moodKey = 'selected_mood';

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

  static Future<void> setMood(UserMood mood) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_moodKey, mood.name);
  }

  static Future<UserMood> getMood() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_moodKey);
    switch (raw) {
      case 'tired':
        return UserMood.tired;
      case 'strong':
        return UserMood.strong;
      case 'energetic':
      default:
        return UserMood.energetic;
    }
  }
}
