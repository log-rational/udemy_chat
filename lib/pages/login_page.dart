import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Widgets
import '../widgets/custom_input_fields.dart';
import '../widgets/rounded_button.dart';

// Providers
import 'package:udemy_chat/providers/authentication_provider.dart';
import '../providers/beacon_state_provider.dart';

// Services
import 'package:udemy_chat/services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  String? _email;
  String? _password;
  late AuthenticationProvider _auth;
  late NavigationService _navigation;
  late BeaconProvider _beaconProvider;

  final _loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    _beaconProvider = Provider.of<BeaconProvider>(context);
    _beaconProvider.cancelTimer();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03, vertical: _deviceHeight * 0.02),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * .97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            _loginForm(),
            SizedBox(
              height: _deviceHeight * 0.04,
            ),
            _loginButton(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            _registerAccountLink()
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return SizedBox(
      height: _deviceHeight * 0.1,
      child: const Text(
        "Force Tracker",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 28),
      ),
    );
  }

  Widget _loginButton() => RoundedButton(
      name: "Login",
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPress: () {
        if (_loginFormKey.currentState!.validate()) {
          _loginFormKey.currentState!.save();
          _auth.loginUsingEmailAndPassword(_email!, _password!);
        }
      });

  Widget _registerAccountLink() {
    return GestureDetector(
        onTap: () {
          _navigation.navigateToRoute('/register');
        },
        child: const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.blue),
        ));
  }

  Widget _loginForm() {
    return SizedBox(
      height: _deviceHeight * 0.25,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (_vlaue) {
                  setState(() {
                    _email = _vlaue;
                  });
                },
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: "Email",
                obscureText: false),
            CustomTextFormField(
                onSaved: (_vlaue) {
                  _password = _vlaue;
                },
                regEx: r".{8,}",
                hintText: "Password",
                obscureText: true),
          ],
        ),
      ),
    );
  }
}
