import '../../core/base/base_view_model.dart';

class SettingsViewModel extends BaseViewModel {
  // Add any settings-related business logic here
  
  Future<void> clearCache() async {
    try {
      setLoading();
      // Implement cache clearing logic
      await Future.delayed(const Duration(seconds: 1));
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
}