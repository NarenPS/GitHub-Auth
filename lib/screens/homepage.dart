import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


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

      return myList;
    } else {
      throw Exception('Failed to load repositories');
    }
  }

  fetchData() async {
    repositoriesDetails = await getGitHubRepositories(
        widget.userCredential.additionalUserInfo!.username.toString());
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
                      Expanded(
                        child: ListView.builder(
                          itemCount: repositoriesDetails.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                      "${repositoriesDetails[index]["name"]}"),
                                  trailing: ElevatedButton(
                                      onPressed: () async {
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
