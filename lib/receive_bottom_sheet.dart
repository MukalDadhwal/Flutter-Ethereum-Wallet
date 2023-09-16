import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

import './providers/wallet_provider.dart';

class ReceiveBottomSheet extends StatefulWidget {
  const ReceiveBottomSheet({Key? key}) : super(key: key);

  @override
  State<ReceiveBottomSheet> createState() => _ReceiveBottomSheetState();
}

class _ReceiveBottomSheetState extends State<ReceiveBottomSheet> {
  bool _isClicked = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Receive",
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 25),
            PrettyQr(
              typeNumber: 3,
              data: context.read<WalletServices>().myCredentials!.address,
              size: 200,
              elementColor: Colors.white,
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true,
            ),
            SizedBox(
              height: 20,
            ),
            Chip(
              label: Text(
                '${context.read<WalletServices>().myCredentials!.address.substring(0, 6)}...${context.read<WalletServices>().myCredentials!.address.substring(38, context.read<WalletServices>().myCredentials!.address.length)}',
                style: GoogleFonts.lato(fontSize: 18),
              ),
            ),
            Center(
              child: Container(
                height: 100,
                width: 400,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Copy to clipboard',
                      style: GoogleFonts.raleway(
                        fontSize: 20,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      curve: _isClicked ? Curves.bounceOut : Curves.ease,
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            _isClicked = true;
                          });
                          await Clipboard.setData(
                            ClipboardData(
                                text: context
                                    .read<WalletServices>()
                                    .myCredentials!
                                    .address),
                          );
                          Future.delayed(Duration(seconds: 2)).then((value) {
                            setState(() {
                              _isClicked = false;
                            });
                          });
                        },
                        child: Icon(
                          _isClicked ? Icons.done : Icons.copy_rounded,
                          color: Colors.grey.shade700,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
