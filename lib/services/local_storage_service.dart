import 'package:bitmark_health/models/user.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageService {
    static LocalStorage _storage;

    static init() async {
        _storage = new LocalStorage('BITMARK_HEALTH');
        await _storage.ready;
    }

    static User getUser() {
        User user;
        String bitmarkAccountNumber = _storage.getItem('bitmark_account_number');
        Map<String, dynamic> data = _storage.getItem('data');

        if (bitmarkAccountNumber != null && data != null && data[bitmarkAccountNumber] != null) {
            user = User.fromJson(data[bitmarkAccountNumber]);
            print(user);
        }

        return user;
    }

    static setUser(User user) async {
        await _storage.setItem('bitmark_account_number', user.bitmarkAccountNumber);

        // Set user info data if not existing
        Map<String, dynamic> data = _storage.getItem('data');
        if (data == null) data = new Map<String, User>();
        if (data[user.bitmarkAccountNumber] == null) {
            data[user.bitmarkAccountNumber] = user;
            await _storage.setItem('data', data);
        }
    }

    static logoutUser() async {
        await _storage.setItem('bitmark_account_number', null);
    }
}