import 'package:flutter/material.dart';
import 'package:machineweb/service/authservice.dart';
import 'package:machineweb/shared/laading.dart';

import 'package:machineweb/shared/style.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('sign in'),
              actions: [
                FlatButton.icon(
                  onPressed: () => widget.toggleView!(),
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  label: Text('register',
                      style: Theme.of(context).textTheme.bodyText2),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: (width + 50) / 8, vertical: 50),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width / 20, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 50.0),
                            Text('welcome to machine',
                                style: Theme.of(context).textTheme.bodyText1),
                            SizedBox(height: 7.0),
                            Text('sign in to view prices and more'),
                            SizedBox(height: 40.0),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText2,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'email',
                                  prefixIcon:
                                      Icon(Icons.email, color: Colors.black)),
                              validator: (val) =>
                                  val!.isEmpty ? 'enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val.trim());
                              },
                            ),
                            SizedBox(height: 30.0),
                            TextFormField(
                              style: Theme.of(context).textTheme.bodyText2,
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'password',
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.black)),
                              validator: (val) => val!.length < 8
                                  ? 'enter a password 8+ chars long'
                                  : null,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                            Row(
                              children: [
                                Spacer(),
                                TextButton(
                                  child: Text('forgot password?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2),
                                  onPressed: () {
                                    _showMyDialog();
                                    print('object');
                                  },
                                )
                              ],
                            ),
                            SizedBox(height: 30.0),
                            RaisedButton(
                                elevation: 15,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text('sign in',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(color: Colors.white)),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signInWithEmailAndPassword(
                                            email, password);
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error =
                                            'could not sign in with those credentials';
                                      });
                                    }
                                  }
                                }),
                            SizedBox(height: 12.0),
                            Text(error,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Future<void> _showMyDoneDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('check your email'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('check email for a link'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'back',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('enter your email'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  style: Theme.of(context).textTheme.bodyText2,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'email',
                      prefixIcon: Icon(Icons.email, color: Colors.black)),
                  validator: (val) => val!.isEmpty ? 'enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val.trim());
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'send email',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                AuthService().resetPassword(email);
                Navigator.of(context).pop();
                _showMyDoneDialog();
              },
            ),
            TextButton(
              child: Text(
                'cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
