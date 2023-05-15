import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';

class GithubRepositoriesPage extends StatefulWidget {
  // final UserCredential userCredential;

  // GithubRepositoriesPage(this.userCredential);

  @override
  _GithubRepositoriesPageState createState() =>
      _GithubRepositoriesPageState();
}

class _GithubRepositoriesPageState extends State<GithubRepositoriesPage> {
  // var token;
  final GitHub _github = GitHub(auth: Authentication.withToken('${FirebaseAuth.instance.currentUser!.getIdToken()}'));
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // token=widget.userCredential.user!.refreshToken;
    print("Token ${_auth.currentUser!.displayName}");
     print("Token ${_auth.currentUser!.uid}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Repositories'),
      ),
      // body: Text("${_auth.currentUser!.uid}"),
      body: FutureBuilder<List<Repository>>(
        future: _github.repositories.listRepositories().toList(),
        builder: (BuildContext context, AsyncSnapshot<List<Repository>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No repositories found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final repository = snapshot.data![index];
                return ListTile(
                  title: Text(repository.name),
                  subtitle: Text(repository.description ?? ''),
                );
              },
            );
          }
        },
      ),
    );
  }
}
