import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
      String email, String password, String username, bool isLogin) submitFn;
  AuthForm(this.submitFn, this.isLoading);
  bool isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      print(_userEmail);
      print(_userName);
      print(_userPassword);
      widget.submitFn(_userEmail, _userPassword, _userName, _isLogin);
    }
  }

  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 30),
                TextButton.icon(
                    icon: Icon(Icons.image),
                    label: Text('Add Image'),
                    onPressed: () {}),
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value.toString();
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    label: Text('Email Address'),
                  ),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value != null && value.length < 8) {
                        return "Please enter username";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value.toString();
                    },
                    decoration: InputDecoration(
                      label: Text('Username'),
                    ),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value != null && value.length < 8) {
                      return "Password must be 7 characters long";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    label: Text('Password'),
                  ),
                  onSaved: (value) {
                    _userPassword = value.toString();
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                  ),
                if (!widget.isLoading)
                  TextButton(
                    child: Text(_isLogin
                        ? 'Create new account'
                        : 'I already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
