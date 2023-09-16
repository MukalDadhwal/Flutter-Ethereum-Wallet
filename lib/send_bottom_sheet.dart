import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/wallet_provider.dart';

class SendBottomSheet extends StatefulWidget {
  const SendBottomSheet({Key? key}) : super(key: key);

  @override
  State<SendBottomSheet> createState() => _SendBottomSheetState();
}

class _SendBottomSheetState extends State<SendBottomSheet> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Send to",
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 500, minHeight: 50),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                      color: Color(0xffb0b3b8),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                      color: Color(0xffb0b3b8),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  fillColor: Colors.grey.shade400.withOpacity(0.5),
                  filled: false,
                  hintText: 'Amount',
                  hintStyle: GoogleFonts.raleway(),
                ),
                keyboardType: TextInputType.number,
                controller: _amountController,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 500, minHeight: 50),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                      color: Color(0xffb0b3b8),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                      color: Color(0xffb0b3b8),
                      style: BorderStyle.solid,
                      width: 1.0,
                    ),
                  ),
                  fillColor: Colors.grey.shade400.withOpacity(0.5),
                  filled: false,
                  hintText: 'To Address',
                  hintStyle: GoogleFonts.raleway(),
                ),
                controller: _addressController,
              ),
            ),
            SizedBox(
              height: 38,
            ),
            SizedBox(
              height: height * 0.05,
              width: width * 0.9,
              child: ElevatedButton(
                onPressed: () {
                  if (_addressController.text != '' &&
                      _amountController.text != '') {
                    context.read<WalletServices>().sendTransection(
                          _addressController.text.trim(),
                          _amountController.text.trim(),
                          context.read<WalletServices>().myCredentials!,
                        );
                  }
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Send",
                  style: GoogleFonts.raleway(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 7,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
