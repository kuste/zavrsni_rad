import 'package:dungeon_master/models/auth.dart';
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
    print(
      _authData['email'],
    );
    print(
      _authData['password'],
    );
    try {
      switch (_authMode) {
        case AuthMode.Login:
          await Provider.of<Auth>(context, listen: false).signIn(
            _authData['email'],
            _authData['password'],
          );
          break;
        case AuthMode.Signup:
          await Provider.of<Auth>(context, listen: false).signUp(
            _authData['email'],
            _authData['password'],
          );
          break;
        default:
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;

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
