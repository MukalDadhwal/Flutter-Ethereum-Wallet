import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './balance_widget.dart';
import './providers/wallet_provider.dart';
import './receive_bottom_sheet.dart';
import './send_bottom_sheet.dart';
import './const.dart';
import './list_widget.dart';
import './providers/auth_provider.dart';
import './transaction_model.dart';
import './wallet_realm_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = -1.0;

  @override
  void initState() {
    super.initState();
    intializeWallet();
  }

  void intializeWallet() {
    context.read<WalletServices>().intialize(context.read<LoginRealm>().user!);
  }

  void logout() {
    context.read<LoginRealm>().logout();
  }

  Future<void> addWallet() async {
    final wallet = context.read<WalletServices>();
    wallet.create(
      Keys.privateKey,
      Keys.publicKeyHex,
      context.read<LoginRealm>().user!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    MyCredentials? data = context.watch<WalletServices>().myCredentials;
    context.read<WalletServices>().getTransections();
    Transect? listTransection = context.watch<WalletServices>().list;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wallet'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              data == null
                  ? TextButton(
                      onPressed: addWallet,
                      child: const Text('Add Wallet'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black87,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.1),
                        BalanceWidget(),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => ReceiveBottomSheet(),
                                  barrierColor: Colors.black38,
                                  backgroundColor: Color(0xff242526),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                );
                              },
                              child: const Text('Receive ETH'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  barrierColor: Colors.black38,
                                  backgroundColor: Color(0xff242526),
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  builder: (BuildContext context) {
                                    return SendBottomSheet();
                                  },
                                );
                              },
                              child: const Text('Send ETH'),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Text(
                              'Transactions',
                              style: TextStyle(fontSize: 20),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (listTransection == null) ...[
                          CircularProgressIndicator.adaptive(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ] else if (listTransection.result.isEmpty) ...[
                          Text('No transections to show')
                        ] else
                          ...listTransection.result.map((element) {
                            return GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: element.hash!),
                                );
                              },
                              child: ListWidget(
                                  data: element, address: data.address),
                            );
                          }).toList()
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
