import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class AnalyticsService {
  static FirebaseAnalytics? analytics;
  static late FirebaseAnalyticsObserver observer;

  static init() async {
    if (analytics != null) return;
    bool trackingAuthorized = await requestTrackingAuthorization();
    if (!trackingAuthorized && defaultTargetPlatform == TargetPlatform.iOS) {
      return;
    }
    analytics = FirebaseAnalytics.instance;
    observer = FirebaseAnalyticsObserver(analytics: analytics!);
  }

  static Future<bool> requestTrackingAuthorization() async {
    TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      status = await AppTrackingTransparency.requestTrackingAuthorization();
    }
    return status == TrackingStatus.authorized;
  }

  static logEvent(String name) async {
    if (analytics == null) await Future.delayed(const Duration(seconds: 4));
    if (analytics == null) return;
    analytics!.logEvent(name: name);
    // print('Logging event: $name');
  }
}