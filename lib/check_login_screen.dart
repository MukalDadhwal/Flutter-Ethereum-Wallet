import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './home_page.dart';
import './signin_page.dart';
import './providers/auth_provider.dart';

class CheckLoginScreen extends StatefulWidget {
  const CheckLoginScreen({Key? key}) : super(key: key);

  @override
  State<CheckLoginScreen> createState() => _CheckLoginScreenState();
}

class _CheckLoginScreenState extends State<CheckLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<LoginRealm>().anonymousRegister(),
      builder: (context, snapshot) {
        if (context.read<LoginRealm>().user != null) {
          return HomePage();
        }
        return SignIn2();
      },
    );
  }
}
