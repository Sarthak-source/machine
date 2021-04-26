import 'package:flutter/material.dart';

import 'package:machineweb/service/authservice.dart';
import 'package:machineweb/shared/laading.dart';
import 'package:machineweb/shared/style.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('sign up'),
              actions: [
                FlatButton.icon(
                  onPressed: () => widget.toggleView!(),
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text('sign in',
                      style: Theme.of(context).textTheme.bodyText2),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 100.0),
                        Text('new to e-kushi?',
                            style: Theme.of(context).textTheme.bodyText1),
                        SizedBox(height: 7.0),
                        Text('sign up to enjoy services'),
                        SizedBox(height: 40.0),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyText2,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'email',
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.white)),
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
                                  Icon(Icons.lock, color: Colors.white)),
                          validator: (val) => val!.length < 8
                              ? 'enter a password 8+ chars long'
                              : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 30.0),
                        RaisedButton(
                            child: Text('register',
                                style: Theme.of(context).textTheme.button),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                    error = 'please supply a valid email';
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
          );
  }
}
