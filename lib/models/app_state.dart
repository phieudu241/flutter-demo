import 'package:bitmark_health/models/user.dart';

class AppState {
    // Your app will use this to know when to display loading spinners.
    bool isLoading;
    User user;

    // Constructor
    AppState({
        this.isLoading = false,
        this.user,
    });

    // A constructor for when the app is loading.
    factory AppState.loading() => new AppState(isLoading: true);

    @override
    String toString() {
        return 'AppState{isLoading: $isLoading, user: ${user?.bitmarkAccountNumber ?? 'null'}}';
    }
}