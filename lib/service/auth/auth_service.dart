import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'admin-restricted-operation') {
        return 'error';
      }
    }
  }

  Future<Uri> getUrl() async {
    final user =  await FirebaseAuth.instance.currentUser!.email;
    final mail = user!.split('@');
      final url = Uri.https(
        'ac-flutter-poc-default-rtdb.europe-west1.firebasedatabase.app',
        'Reports/${mail.first}.json');
      return url;
  }
}
