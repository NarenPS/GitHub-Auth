import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class GithubSignInPage extends StatefulWidget {
  @override
  _GithubSignInPageState createState() => _GithubSignInPageState();
}

class _GithubSignInPageState extends State<GithubSignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> _signInWithGithub() async {
    // Create a new GitHubAuthProvider
    final GithubAuthProvider githubProvider = GithubAuthProvider();

    // Sign in with GitHub credential
    final UserCredential userCredential =
        await _auth.signInWithPopup(githubProvider);

    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Sign-In'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign In with GitHub'),
          onPressed: () async {
            // Sign in with GitHub
            final UserCredential userCredential = await _signInWithGithub();

            // Navigate to the GitHub repositories page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GithubRepositoriesPage(userCredential),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GithubRepositoriesPage extends StatefulWidget {
  final UserCredential userCredential;

  GithubRepositoriesPage(this.userCredential);

  @override
  _GithubRepositoriesPageState createState() =>
      _GithubRepositoriesPageState();
}

class _GithubRepositoriesPageState extends State<GithubRepositoriesPage> {
  late String _accessToken;

  @override
  void initState() {
    super.initState();
    _getAccessToken();
  }

  Future<void> _getAccessToken() async {
    // Get the access token from Firebase
    int? accessToken = await widget.userCredential.credential!.token;
    setState(() {
      _accessToken = accessToken as String;
    });
  }

  Future<List<dynamic>> _fetchRepositories() async {
    final response = await http.get(
      Uri.https('api.github.com', '/user/repos', {'type': 'owner'}),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch repositories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Repositories'),
      ),
    );
  }}
