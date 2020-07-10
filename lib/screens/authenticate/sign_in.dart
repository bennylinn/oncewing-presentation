import 'package:OnceWing/services/auth.dart';
import 'package:OnceWing/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:OnceWing/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  var _controller1 = TextEditingController();
  var _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1],
                    colors: [Color(0xff2E2E38), Color(0xffC49859)])),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  title: Text(
                    'ONCEWING',
                    style: TextStyle(
                      color: Colors.blue[100],
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(
                        Icons.person,
                        color: Colors.blue[100],
                      ),
                      label: Text(
                        'Register',
                        style: TextStyle(color: Colors.blue[100]),
                      ),
                      onPressed: () {
                        widget.toggleView();
                      },
                    )
                  ],
                ),
                body: Column(children: <Widget>[
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/logo.png'),
                            fit: BoxFit.fitHeight)),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: _controller1,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          borderSide: BorderSide(
                                              color: Colors.blue[400])),
                                      labelText: 'Email',
                                      labelStyle:
                                          TextStyle(color: Colors.blue[100]),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.blue[100],
                                      ),
                                      suffixIcon: IconButton(
                                          icon: Icon(Icons.clear,
                                              color: Colors.blue[100]),
                                          onPressed: () =>
                                              _controller1.clear())),
                                  validator: (val) =>
                                      val.isEmpty ? 'Enter an email.' : null,
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  }),
                            ),
                            TextFormField(
                                style: TextStyle(color: Colors.white),
                                controller: _controller2,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide:
                                          BorderSide(color: Colors.blue[400]),
                                    ),
                                    labelText: 'Password',
                                    labelStyle:
                                        TextStyle(color: Colors.blue[100]),
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.blue[100],
                                    ),
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.blue[100],
                                        ),
                                        onPressed: () => _controller2.clear())),
                                obscureText: true,
                                validator: (val) => val.length < 6
                                    ? 'Enter a password 6+ characters long.'
                                    : null,
                                onChanged: (val) {
                                  setState(() => password = val);
                                }),
                            RaisedButton(
                                elevation: 0.0,
                                color: Colors.transparent,
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.blue[100]),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signInWithEmailAndPassword(
                                            email, password);
                                    if (result == null) {
                                      setState(() {
                                        error =
                                            'Credentials are incorrect. Please try again.';
                                        loading = false;
                                      });
                                    }
                                  }
                                }),
                            Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.blue[500]),
                            ),
                            Text(error,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0)),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                                elevation: 0.0,
                                color: Colors.transparent,
                                child: Text(
                                  'Create New Account',
                                  style: TextStyle(color: Colors.purple[300]),
                                ),
                                onPressed: () {
                                  widget.toggleView();
                                }),
                            RaisedButton(
                                elevation: 0.0,
                                color: Colors.transparent,
                                child: Text(
                                  'Anonymous Sign In',
                                  style: TextStyle(color: Colors.purple[100]),
                                ),
                                onPressed: () async {
                                  await AuthService().signInAnon();
                                }),
                          ],
                        )),
                  ),
                ])));
  }
}
