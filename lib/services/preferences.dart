import 'package:ipf_flutter_starter_pack/bases.dart';

class PrefKeys {
	PrefKeys._();

	static const String apiToken = "api_token";
	static const String language = "language";
	static const String darkMode = "dark_mode";
  static const String ownerId = "owner_id";

  
}

class Preferences extends BasePreferences {
	Preferences._();
	static final Preferences _instance = Preferences._();
	static Preferences get instance => _instance;

	Future<String?> get apiToken async => await fetch<String?>(PrefKeys.apiToken);

	Future<String?> get language async => await fetch<String?>(PrefKeys.language);

	Future<bool?> get darkMode async => await fetch<bool?>(PrefKeys.darkMode);

  Future<String?> get ownerId async => await fetch<String?>(PrefKeys.ownerId);


  Future<void> saveApiToken(String value) async => save(PrefKeys.apiToken, value);
  Future<void> removeApiToken() async => remove(PrefKeys.apiToken,);

  Future<void> saveOwnerId(String value) async => save(PrefKeys.ownerId, value);
  Future<void> removeOwnerId() async => remove(PrefKeys.ownerId,);
}