import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import './check_login_screen.dart';
import './providers/auth_provider.dart';
import './providers/wallet_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WalletServices>(
          create: (BuildContext context) => WalletServices(),
        ),
        ChangeNotifierProvider<LoginRealm>(
          create: (BuildContext context) => LoginRealm(),
        ),
      ],
      child: MaterialApp(
        title: 'Web3 Wallet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            bodySmall: GoogleFonts.lato(),
            bodyMedium: GoogleFonts.lato(),
            bodyLarge: GoogleFonts.lato(),
            labelLarge: GoogleFonts.lato(fontSize: 17),
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: Colors.black,
            titleTextStyle: GoogleFonts.lato(
              fontSize: 25,
            ),
          ),
        ),
        home: CheckLoginScreen(),
      ),
    );
  }
}
