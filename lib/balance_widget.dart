import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'providers/wallet_provider.dart';

class BalanceWidget extends StatefulWidget {
  const BalanceWidget({Key? key}) : super(key: key);

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Material(
          elevation: 20,
          color: Colors.black,
          child: Container(
            width: size.width * 0.8,
            height: size.height * 0.4,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xff242526),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[600]!,
                  width: 2.0,
                )
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey,
                //     offset: Offset(0.0, 1.0), //(x,y)
                //     blurRadius: 6.0,
                //   ),
                // ],
                ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: FutureBuilder(
                      future: context.read<WalletServices>().getBalance(
                          context.read<WalletServices>().myCredentials),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('-');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return Text(
                          '${snapshot.data.toString().substring(0, 8)} ETH',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }),
                ),
                Positioned(
                  left: size.width * 0.15,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Color(0xff242526),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey[600]!,
                        width: 1.0,
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/ethereum-original.svg',
                      theme: SvgTheme(
                        currentColor: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
