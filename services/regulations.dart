import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:country_codes/country_codes.dart';

enum PrivacyRegulation {
  gdpr,   // EU, EEA, UK, Switzerland (Strict Opt-in)
  lgpd,   // Brazil (Strict Opt-in)
  usState, // California, Virginia, etc. (Opt-out / Link required)
  dpdp,   // India (Strict Opt-in)
  none    // Unregulated regions
}

class PrivacyService {
  static const _eea = {'AT','BE','BG','HR','CY','CZ','DK','EE','FI','FR','DE','GR','HU','IE','IT','LV','LT','LU','MT','NL','PL','PT','RO','SK','SI','ES','SE','IS','LI','NO','CH','GB'};

  static Future<PrivacyRegulation> getRegulation() async {
    await CountryCodes.init();
    final String? code = CountryCodes.detailsForLocale().alpha2Code?.toUpperCase();
    if (code != null) {
      final reg = _map(code);
      if (reg != PrivacyRegulation.none) return reg;
    }

    // SIM-less devices
    try {
      final res = await http.get(Uri.parse('https://ipapi.co/json/')).timeout(const Duration(seconds: 2));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return _map(data['country_code'] ?? '');
      }
    } catch (_) {}

    return PrivacyRegulation.none;
  }

  static PrivacyRegulation _map(String code) {
    if (_eea.contains(code)) return PrivacyRegulation.gdpr;
    if (code == 'BR') return PrivacyRegulation.lgpd;
    if (code == 'US') return PrivacyRegulation.usState;
    return PrivacyRegulation.none;
  }
}
