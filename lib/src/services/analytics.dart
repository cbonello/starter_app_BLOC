import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> setUserProperties({@required String userId}) async {
    await _analytics.setUserId(userId);
  }

  Future<void> logSignIn(String loginMethod) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }

  Future<void> logSignUp(String signUpMethod) async {
    await _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  Future<void> logSignOut() async {
    await _analytics.logEvent(name: 'sign_out', parameters: <String, dynamic>{});
  }
}