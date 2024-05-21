import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocab_app/data/models/guestuser_model.dart';

abstract class GuestRepository {
  Stream<GuestModel> loggedGuestStream(User loggedFirebaseUser);

  Future<void> addGuestData(GuestModel newGuest);

  Future<void> removeGuestData(String uid);


}
