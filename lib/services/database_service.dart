import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import './navigation_service.dart';

const String USER_COLLECTION = "Users";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "Messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late NavigationService _navigation;
  // Constructor
  DatabaseService() {
    _navigation = GetIt.instance.get<NavigationService>();
  }

  Future<void> registerUser(
      String _uid, String _name, String _email, String _imageUrl) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).set({
        'name': _name,
        'email': _email,
        'image': _imageUrl,
        'last_active': DateTime.now().toUtc(),
      });
    } catch (e) {
      _navigation.removeAndNavigateToRoute("/login");
    }
  }

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update({
        'last_active': DateTime.now().toUtc(),
      });
      return;
    } catch (e) {
      _navigation.removeAndNavigateToRoute('/login');
    }
  }

  Future<void> updateLocation(String _uid, List<double> _coords) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update({
        'location': [..._coords],
      });
      return;
    } catch (e) {
      _navigation.removeAndNavigateToRoute('/login');
    }
  }
}
