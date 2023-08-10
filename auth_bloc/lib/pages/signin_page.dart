import 'package:auth_bloc/pages/signup_page.dart';
import 'package:auth_bloc/blocs/signin/signin_cubit.dart';
import 'package:auth_bloc/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninPage extends StatefulWidget {
  static const String routeName = '/signin';
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('email: $_email, password: $_password');

    context.read<SigninCubit>().signin(email: _email!, password: _password!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SigninCubit, SigninState>(
          listener: (context, state) {
            if(state.signinStatus == SignStatus.error){
              errorDialog(context, state.error);
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidateMode,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            width: 250,
                            height: 250,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email required';
                              }
                              if (!isEmail(value.trim())) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _email = value;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                            ),
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Password required';
                              }
                              if (value.trim().length < 6) {
                                return 'password must be at least 6 characters long';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              _password = value;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ElevatedButton(
                            onPressed: state.signinStatus == SignStatus.submitting
                              ? null
                              : _submit,
                            child: Text(
                              state.signinStatus == SignStatus.submitting
                              ? 'Loading...'
                              : 'Signin',
                            ),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15.0),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextButton(
                            onPressed:  state.signinStatus == SignStatus.submitting
                              ? null
                              :() {
                              Navigator.pushNamed(context, SignupPage.routeName);
                            },
                            child: Text(
                              'Not a member? Sign Up',
                            ),
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(
                                fontSize: 20.0,
                                decoration: TextDecoration.underline,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
