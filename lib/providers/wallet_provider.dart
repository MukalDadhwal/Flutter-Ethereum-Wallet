import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web3dart/crypto.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:realm/realm.dart';

import '../const.dart';
import '../transaction_model.dart';
import '../wallet_realm_model.dart';

class WalletServices extends ChangeNotifier {
  var priateKeyHex = '';
  var address1 = '';
  double balance = 0.00;

  late final Realm localRealm;
  Transect? list;

  MyCredentials? myCredentials;

  Future<void> getABI(User user) async {
    var rng = Random.secure();
    web3.EthPrivateKey random = web3.EthPrivateKey.createRandom(rng);

    var address = random.address;
    var priateKey = random.privateKey;

    priateKeyHex = bytesToHex(priateKey).split('').reversed.join('');
    print(priateKeyHex.length);
    if (priateKeyHex.length > 64) {
      priateKeyHex = priateKeyHex.substring(0, priateKeyHex.length - 2);
      print(priateKeyHex.length);
    }
    priateKeyHex = priateKeyHex.split('').reversed.join('');
    address1 = address.hex;

    print(address1 + " --- " + bytesToHex(priateKey));
    print(priateKeyHex);

    notifyListeners();
  }

  void create(String priateKey, String address, User user) async {
    if (myCredentials == null) {
      await getABI(user);
      localRealm.write(() {
        localRealm.add(
          MyCredentials(
              ObjectId.fromHexString(user.id), priateKeyHex, address1),
        );
      });
      myCredentials =
          localRealm.find<MyCredentials>(ObjectId.fromHexString(user.id));
    }
  }

  void intialize(User user) {
    final configLocal = Configuration.local([MyCredentials.schema],
        fifoFilesFallbackPath: "./wallet");
    localRealm = Realm(configLocal);

    myCredentials =
        localRealm.find<MyCredentials>(ObjectId.fromHexString(user.id));
    create(Keys.privateKey, Keys.publicKeyHex, user);
  }

  Future<double> getBalance(MyCredentials? myCredentials) async {
    try {
      if (myCredentials == null) {
        return -1;
      }
      final client = web3.Web3Client(Keys.rpcUrl, Client());
      final credentials = web3.EthPrivateKey.fromHex(Keys.privateKey);
      final address = credentials.address;
      final val = await client.getBalance(address);
      balance = val.getInWei / BigInt.from(1000000000000000000);
      return balance;
    } catch (e) {
      rethrow;
    }
  }

  void sendTransection(
      String toAdress, String value, MyCredentials data) async {
    try {
      final client = web3.Web3Client(Keys.rpcUrl, Client());
      final credentials = web3.EthPrivateKey.fromHex(myCredentials!.address);
      final address = credentials.address;
      final BigInt amo = BigInt.from(double.parse(value) * 1000000000000000000);

      var transaction = web3.Transaction(
          to: web3.EthereumAddress.fromHex(toAdress),
          value: web3.EtherAmount.fromBigInt(web3.EtherUnit.wei, amo));
      final supply = await client.signTransaction(credentials, transaction,
          chainId: 11155111);
      final result = await client.sendRawTransaction(supply);
      // getTransections();
      print(result);
      await client.dispose();
    } catch (e) {
      print(e);
    }
  }

  void getTransections() async {
    final url =
        'https://deep-index.moralis.io/api/v2/${myCredentials!.address}/verbose?chain=sepolia';

    try {
      // Send the HTTP GET request with the required headers
      final response = await get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'X-API-Key': Keys.MORALIS_KEY,
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        list = Transect.fromJson(json.decode(response.body));
        // notifyListeners();
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }
}
