import 'package:flutter/foundation.dart';
import 'view_state.dart';

abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;

  bool get isIdle => _state == ViewState.idle;
  bool get isLoading => _state == ViewState.loading;
  bool get isError => _state == ViewState.error;
  bool get isSuccess => _state == ViewState.success;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  void setIdle() => setState(ViewState.idle);
  void setLoading() => setState(ViewState.loading);
  void setSuccess() => setState(ViewState.success);
  
  void setError(String message) {
    _errorMessage = message;
    setState(ViewState.error);
  }

  void clearError() {
    _errorMessage = null;
    setIdle();
  }
}