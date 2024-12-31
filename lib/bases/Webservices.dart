class Webservice {
  static const String rootURL = "http://51.20.185.9:5000";
  static const String register = "api/auth/register";
  static const String login = "api/auth/login";
  static const String videoupload = "api/videos/upload";
  static const String news = "api/news";
  static const String profile = "api/users/profile";

  static String emergency(int userId) => "api/users/emergency-contacts/$userId";
  static String emergencydetails(int userId) => "api/users/$userId/emergency-contacts";
  static const String newpost = "api/news/create";
}
