import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:github_sign_in/github_sign_in.dart';

import '../screens/homepage.dart';

class LogIn_GitHub_Controller extends GetxController{
  //  final FirebaseAuth _auth = FirebaseAuth.instance;

  // // final GitHubSignIn gitHubSignIn = GitHubSignIn(
  // //       clientId: clientId,
  // //       clientSecret: clientSecret,
  // //       redirectUrl: redirectUrl);
  // //   var result = await gitHubSignIn.signIn(context);
  // //   switch (result.status) {
  // //     case GitHubSignInResultStatus.ok:
  // //       print(result.token)
  // //       break;

  // //     case GitHubSignInResultStatus.cancelled:
  // //     case GitHubSignInResultStatus.failed:
  // //       print(result.errorMessage);
  // //       break;
  // //   }
  // final GitHubSignIn _gitHubLogin = GitHubSignIn(
  //   clientId: 'f14e69838380427188b5',
  //   clientSecret: 'd487df8866830d7b94a00b9355bb5ad32e463269',
  //   redirectUrl: 'https://github-auth-4b700.firebaseapp.com/__/auth/handler',
  // );

  // bool _isSigningIn = false;
  // final box = GetStorage();

  // Future<UserCredential?> _signInWithGitHub() async {
  //   try {
  //    _isSigningIn = true;

  //     final result = await _gitHubLogin.signIn();

  //     final AuthCredential credential =
  //         GithubAuthProvider.credential(result.token!);

  //     final UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     final User? user = userCredential.user;
  //     box.write("email", user!.email);
  //     Get.off(HomePage(userCredential: userCredential));
  //     // print("User NAME ${user!.}");

  //     // setState(() {
  //     //   _isSigningIn = false;
  //     // });

  //     return userCredential;
  //   } catch (e) {
     
  //     print("ERROR message$e");
  //     return null;
  //   }
  // }
}