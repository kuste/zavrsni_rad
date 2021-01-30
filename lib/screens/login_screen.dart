import 'package:dungeon_master/models/auth_provider.dart';
import 'package:dungeon_master/models/user.dart';
import 'package:dungeon_master/models/user_provider.dart';
import 'package:dungeon_master/screens/home_screen.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

enum AuthMode { Signup, Login }

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();

    try {
      switch (_authMode) {
        case AuthMode.Login:
          Future<Map<String, dynamic>> resp = Provider.of<AuthProvider>(context, listen: false).signIn(
            _authData['email'],
            _authData['password'],
          );
          resp.then((response) {
            if (response['status']) {
              User user = response['user'];
              Provider.of<UserProvider>(context, listen: false).setUser(user);
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            } else {
              Flushbar(
                title: "Failed Login",
                message: response['message']['message'].toString(),
                duration: Duration(seconds: 3),
              ).show(context);
            }
          });
          break;
        case AuthMode.Signup:
          await Provider.of<AuthProvider>(context, listen: false)
              .signUp(
            _authData['email'],
            _authData['password'],
          )
              .then((response) {
            if (response['status']) {
              User user = response['data'];
              Provider.of<UserProvider>(context, listen: false).setUser(user);
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            } else {
              Flushbar(
                title: "Registration Failed",
                message: response.toString(),
                duration: Duration(seconds: 10),
              ).show(context);
            }
          });
          break;
        default:
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //var _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _authMode = AuthMode.Login;
                      });
                    },
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        _authMode = AuthMode.Signup;
                      });
                    },
                    child: Text(
                      'Register',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 8.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'E-Mail',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Icon(Icons.mail),
                                ),
                                labelStyle: TextStyle(color: Colors.black26),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Invalid email!';
                                }
                              },
                              onSaved: (value) {
                                _authData['email'] = value;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Icon(Icons.lock),
                                ),
                                labelStyle: TextStyle(color: Colors.black26),
                              ),
                              obscureText: true,
                              controller: _passwordController,
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty || value.length < 5) {
                                  return 'Password is too short!';
                                }
                              },
                              onSaved: (value) {
                                _authData['password'] = value;
                              },
                            ),
                            if (_authMode == AuthMode.Signup)
                              TextFormField(
                                enabled: _authMode == AuthMode.Signup,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: Icon(Icons.lock),
                                  ),
                                  labelStyle: TextStyle(color: Colors.black26),
                                ),
                                obscureText: true,
                                validator: _authMode == AuthMode.Signup
                                    // ignore: missing_return
                                    ? (value) {
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match!';
                                        }
                                      }
                                    : null,
                              ),
                            SizedBox(
                              height: 20,
                            ),
                            if (_isLoading)
                              CircularProgressIndicator()
                            else
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(top: 25.0),
                                child: RaisedButton(
                                  elevation: 8,
                                  child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                                  onPressed: _submit,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Theme.of(context).primaryTextTheme.button.color,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
