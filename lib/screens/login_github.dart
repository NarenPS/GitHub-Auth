import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:github/github.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'homepage.dart';

class GithubSignInPage extends StatefulWidget {
  @override
  _GithubSignInPageState createState() => _GithubSignInPageState();
}

class _GithubSignInPageState extends State<GithubSignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GitHubSignIn _gitHubLogin = GitHubSignIn(
    clientId: 'f14e69838380427188b5',
    clientSecret: 'd487df8866830d7b94a00b9355bb5ad32e463269',
    redirectUrl: 'https://github-auth-4b700.firebaseapp.com/__/auth/handler',
  );

  bool _isSigningIn = false;
  final box = GetStorage();

  Future<UserCredential?> _signInWithGitHub() async {
    try {
      final result = await _gitHubLogin.signIn(context);

      final AuthCredential credential =
          GithubAuthProvider.credential(result.token!);

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      box.write("email", user!.email);

      return userCredential;
    } catch (e) {
      setState(() {
        _isSigningIn = false;
      });
      print("ERROR message$e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "asset/GitHub-Logo.png",
              height: size.height * 0.35,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Text(
              "Vish Gyana Technology Solutions",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.brown),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Text(
              "LogIn to Continue",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            ElevatedButton(
              child: Text('Sign In with GitHub'),
              onPressed: () async {
                final UserCredential? userCredential = await _signInWithGitHub()
                    .then((value) => Get.off(GithubRepositoriesPage(value!)));
              },
            ),
          ],
        ),
      ),
    );
  }
}

