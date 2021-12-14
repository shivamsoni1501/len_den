import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_data.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  bool _isLogin = true;
  _toggle() => setState(() {
        _isLogin = !_isLogin;
      });

  String _email = 'NULL';
  String _password = 'NULL';
  String _name = 'NULL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN'),
        backgroundColor: Colors.blueGrey[800],
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (val) => _email = val,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (val) => _password = val,
                ),
                if (!_isLogin)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    onChanged: (val) => _name = val,
                  ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    UserData user =
                        Provider.of<UserData>(context, listen: false);
                    bool result = await user.loginToSystem(_email, _password,
                        isLoginT: _isLogin, nameT: _name);
                    if (!result) {
                      print('failed to login!');
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: (_isLoading)
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                      : Text(_isLogin ? 'Login' : 'Register'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('or'),
                TextButton(
                  onPressed: () {
                    _toggle();
                  },
                  child: Text(_isLogin ? 'Try Register!' : 'Try Login!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
