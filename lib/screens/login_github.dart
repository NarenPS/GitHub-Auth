// import 'package:flutter/material.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:github_sign_in/github_sign_in.dart';
// // import 'package:github_sign_in/github_sign_in.dart';

// import 'homepage.dart';

// class GithubSignInScreen extends StatefulWidget {
//   @override
//   _GithubSignInScreenState createState() => _GithubSignInScreenState();
// }

// class _GithubSignInScreenState extends State<GithubSignInScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final GitHubSignIn _gitHubLogin = GitHubSignIn(
//     clientId: 'f14e69838380427188b5',
//     clientSecret: 'd487df8866830d7b94a00b9355bb5ad32e463269',
//     redirectUrl: 'https://github-auth-4b700.firebaseapp.com/__/auth/handler',
//   );

//   bool _isSigningIn = false;
//   final box = GetStorage();

//   Future<UserCredential?> _signInWithGitHub() async {
//     try {
//       setState(() {
//         _isSigningIn = true;
//       });

//       final result = await _gitHubLogin.signIn(context);

//       final AuthCredential credential =
//           GithubAuthProvider.credential(result.token!);

//       final UserCredential userCredential =
//           await _auth.signInWithCredential(credential);

//       final User? user = userCredential.user;
//       box.write("email", user!.email);
//       Get.off(GithubRepositoriesPage());
//       print("User NAME ${userCredential.additionalUserInfo!.providerId}");

//       // setState(() {
//       //   _isSigningIn = false;
//       // });

//       return userCredential;
//     } catch (e) {
//       setState(() {
//         _isSigningIn = false;
//       });
//       print("ERROR message$e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('GitHub Sign-in'),
//       ),

//       body: Center(
//         child: _isSigningIn
//             ? CircularProgressIndicator()
//             : Padding(
//                 padding: const EdgeInsets.all(80.0),
//                 child: SignInButton(
//                   shape: RoundedRectangleBorder(),
//                   Buttons.GitHub,
//                   onPressed: _signInWithGitHub,
//                 ),
//               ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:github/github.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
      // setState(() {
      //   _isSigningIn = true;
      // });

      final result = await _gitHubLogin.signIn(context);

      final AuthCredential credential =
          GithubAuthProvider.credential(result.token!);

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      box.write("email", user!.email);

      print("User NAME ${userCredential.additionalUserInfo!.providerId}");

      // setState(() {
      //   _isSigningIn = false;
      // });

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
      // appBar: AppBar(
      //   title: Text('GitHub Sign-In'),
      // ),
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
                // Sign in with GitHub
                final UserCredential? userCredential = await _signInWithGitHub()
                    .then((value) => Get.off(GithubRepositoriesPage(value!)));

                // Navigate to the GitHub repositories page
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => GithubRepositoriesPage(userCredential),
                //   ),
                // );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GithubRepositoriesPage extends StatefulWidget {
  final UserCredential userCredential;

  GithubRepositoriesPage(this.userCredential);

  @override
  _GithubRepositoriesPageState createState() => _GithubRepositoriesPageState();
}

class _GithubRepositoriesPageState extends State<GithubRepositoriesPage> {
  final GitHub _github = GitHub(
      auth:
          Authentication.withToken('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'));
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List repositoriesDetails = [];
  List userDetails = [];
  bool isLoading = false;

  Future<List<dynamic>> getGitHubRepositories(String username) async {
    final response = await http
        .get(Uri.parse('https://api.github.com/users/${username}/repos'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  Future getGitHubUserDetails(String username) async {
    List myList = [];
    final response =
        await http.get(Uri.parse('https://api.github.com/users/${username}'));

    if (response.statusCode == 200) {
      myList.add(jsonDecode(response.body));
      print(myList);
      return myList;
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  fetchData() async {
    repositoriesDetails = await getGitHubRepositories(
        widget.userCredential.additionalUserInfo!.username.toString());
    //  userDetails.add(await getGitHubUserDetails(widget.userCredential.additionalUserInfo!.username.toString()));
    userDetails = await getGitHubUserDetails(
        widget.userCredential.additionalUserInfo!.username.toString());
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('GitHub Repositories'),
        ),
        body: isLoading
            ? Container(
                height: size.height,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipOval(
                              child: Image.network(
                                "${userDetails[0]["avatar_url"]}}",
                                height: 100,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name : ${userDetails[0]["name"]}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "User Name : ${userDetails[0]["login"]}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            "Repositories List",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       repositoriesDetails = await getGitHubRepositories(
                      //           widget
                      //               .userCredential.additionalUserInfo!.username
                      //               .toString());
                      //       //  userDetails.add(await getGitHubUserDetails(widget.userCredential.additionalUserInfo!.username.toString()));
                      //       userDetails = await getGitHubUserDetails(widget
                      //           .userCredential.additionalUserInfo!.username
                      //           .toString());
                      //     },
                      //     child: Text("c")),
                      Expanded(
                        child: ListView.builder(
                          itemCount: repositoriesDetails.length,
                          itemBuilder: (context, index) {
                            // return Text("${list[index]["name"]}");
                            return Column(
                              children: [
                                ListTile(
                                  // isThreeLine: true,
                                  // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  title: Text(
                                      "${repositoriesDetails[index]["name"]}"),
                                  trailing: ElevatedButton(
                                      onPressed: () async {
                                        //  userDetails =  await getGitHubUserDetails(widget.userCredential.additionalUserInfo!.username.toString());
                                        print(userDetails);
                                        final Uri _url = Uri.parse(
                                            'https://github.com/${repositoriesDetails[index]['full_name']}');
                                        if (!await launchUrl(_url)) {
                                          throw 'Could not launch $_url';
                                        }
                                      },
                                      child: Text("View")),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
