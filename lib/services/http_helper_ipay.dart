
import 'dart:math';

import 'package:ipaycheckout/ipaycheckout.dart';

import '../models/env_constansts.dart';

class HttpHelper {
  Future<String> generateUrl(
      String phoneNumber, String email, String amount, String orderid, uidAccess) async {
    final ipay = IPay(vendorId: vendorId, vendorSecurityKey: securityKey);
    var oid = orderid;
    var inv = orderid;
    var url = ipay.checkoutUrl(
        live: live,
        oid: oid,
        inv: inv,
        ttl: amount,
        tel: phoneNumber,
        eml: email,
        curr: currency,
        cbk: callBackUrl,
        cst: cst,
        crl: crl,
        mpesa: mpesa,
        bonga: bonga,
        airtel: airtel,
        equity: equity,
        mobilebanking: mobilebanking,
        creditcard: creditcard,
        mkoporahisi: mkoporahisi,
        saida: saida,
        elipa: elipa,
        unionpay: unionpay,
        mvisa: mvisa,
        vooma: vooma,
        pesalink: pesalink,
        autopay: autopay,
        p4: uidAccess);

    return url;
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    var newOid = String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    return newOid;
  }
}