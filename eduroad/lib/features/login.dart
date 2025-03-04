import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn =   GoogleSignIn();

    Future<auth.AuthClient?> signInWithGoogle() async {
        try {
            // initialize google sign in
            final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

            //canceled login
            if (googleUser == null) return null;

            // get authentication details
            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

            //create firebase credential
            final AuthCredential credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
            );

            // sign in to firebase
            UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

            User? user = userCredential.user;

            if(user != null ){
                await saveUserToFirestore(user);
            }

            //Create AuthClient using accessToken
            final auth.AccessCredentials credentials = auth.AccessCredentials(
                auth.AccessToken(
                    'Bearer',
                    googleAuth.accessToken!,
                    DateTime.now().add(Duration(hours: 1)), //Expiry time
                ),
                null, //No refresh token available
                ["https://www.googleapis.com/auth/calendar"],
            );

            final auth.AuthClient client = auth.authenticatedClient(http.Client(), credentials);
            return client;
        }
        catch (e) {
            print("Google Sign-In Error: $e");
            return null;
        }
    }
    Future<void> saveUserToFirestore(User user) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
        // Save the user only if it doesn't exist
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'timestamp': FieldValue.serverTimestamp(),
        });
    }
}

    Future<void> signOut() async {
        await _firebaseAuth.signOut();
        await _googleSignIn.signOut();
    }


}
