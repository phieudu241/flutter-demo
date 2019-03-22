import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:bitmark_health/configs/configs.dart' as CONFIG;

class BitmarkAPI {
  static get100Bitmarks(accountNumber, {lastOffset}) async {
      String bitmarkUrl = CONFIG.config["api_server_url"] + "/v1/bitmarks?issuer=$accountNumber&asset=true&pending=true&to=later" + (lastOffset != null ? "&at=$lastOffset" : "");
      final response = await http.get(bitmarkUrl);

      if (response.statusCode == 200) {
          return json.decode(response.body);
      } else {
          // If that response was not OK, throw an error.
          throw Exception('Failed to load post');
      }
  }
}