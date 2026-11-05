import 'dart:convert';
import 'dart:developer';
import 'package:alekha/constant/share_pref_keys.dart';
import 'package:alekha/constant/share_preference.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthResult {
  final bool isSuccess;
  final String message;
  final User? user;

  AuthResult({
    required this.isSuccess,
    required this.message,
    this.user,
  });
}

class AuthService {
  static final SupabaseClient _client = Supabase.instance.client;
  static const String keyLoggedInDevices = "loggedInDevicesList";

  // Helper to record login history
  static Future<void> _recordDeviceLogin(String email, {String? name}) async {
    try {
      final String raw = await Shared_Preferences.prefGetString(keyLoggedInDevices, "[]");
      List<dynamic> list = [];
      try {
        list = jsonDecode(raw) as List<dynamic>;
      } catch (_) {
        list = [];
      }

      final nowStr = DateTime.now().toIso8601String();
      final existingIndex = list.indexWhere((item) => item['email'] == email);
      if (existingIndex != -1) {
        list[existingIndex]['lastLogin'] = nowStr;
        if (name != null && name.isNotEmpty) {
          list[existingIndex]['name'] = name;
        }
      } else {
        list.add({
          'email': email,
          'name': name ?? '',
          'lastLogin': nowStr,
        });
      }

      await Shared_Preferences.prefSetString(keyLoggedInDevices, jsonEncode(list));
    } catch (e) {
      log("Error recording device login: $e");
    }
  }

  // Get all logged in accounts / devices list
  static Future<List<Map<String, dynamic>>> getLoggedInDevices() async {
    try {
      final String raw = await Shared_Preferences.prefGetString(keyLoggedInDevices, "[]");
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      log("Error reading logged in devices: $e");
      return [];
    }
  }

  // Get current logged-in user email
  static Future<String> getCurrentUserEmail() async {
    final currentSessionEmail = _client.auth.currentUser?.email;
    if (currentSessionEmail != null && currentSessionEmail.isNotEmpty) {
      return currentSessionEmail;
    }
    return await Shared_Preferences.prefGetString(SharedP.userEmail, "");
  }

  // Get current logged-in user name
  static Future<String> getCurrentUserName() async {
    final metaName = _client.auth.currentUser?.userMetadata?['name'] ??
        _client.auth.currentUser?.userMetadata?['full_name'];
    if (metaName != null && metaName.toString().trim().isNotEmpty) {
      return metaName.toString().trim();
    }
    final prefName = await Shared_Preferences.prefGetString(SharedP.userName, "");
    if (prefName.trim().isNotEmpty) {
      return prefName.trim();
    }
    // If name is not stored, extract name from email (e.g. "priyanka" from "priyanka@gmail.com")
    final email = await getCurrentUserEmail();
    if (email.contains('@')) {
      final username = email.split('@').first;
      if (username.isNotEmpty) {
        return username[0].toUpperCase() + username.substring(1);
      }
    }
    return email.isNotEmpty ? email : "User";
  }

  // Sign in with email and password
  static Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final userName = response.user?.userMetadata?['name']?.toString() ??
            response.user?.userMetadata?['full_name']?.toString() ??
            "";

        await Shared_Preferences.prefSetBool(SharedP.isLoggedIn, true);
        await Shared_Preferences.prefSetString(SharedP.userEmail, email);
        if (userName.isNotEmpty) {
          await Shared_Preferences.prefSetString(SharedP.userName, userName);
        }
        await _recordDeviceLogin(email, name: userName);

        return AuthResult(
          isSuccess: true,
          message: "Login successful!",
          user: response.user,
        );
      } else {
        return AuthResult(
          isSuccess: false,
          message: "Login failed. Please try again.",
        );
      }
    } on AuthException catch (e) {
      log("AuthException in signIn: ${e.message} (status: ${e.statusCode})");
      String friendlyMessage = e.message;

      final msgLower = e.message.toLowerCase();
      if (msgLower.contains("invalid login credentials")) {
        friendlyMessage = "Incorrect email or password. If you don't have an account, please sign up first.";
      } else if (msgLower.contains("email not confirmed")) {
        friendlyMessage = "Email is not confirmed yet. Please verify your email from your inbox, or disable email confirmation in your Supabase project.";
      }

      return AuthResult(
        isSuccess: false,
        message: friendlyMessage,
      );
    } catch (e) {
      log("Generic error in signIn: $e");
      return AuthResult(
        isSuccess: false,
        message: "Network or connection error. Please check your internet connection.",
      );
    }
  }

  // Sign up with name, email and password
  static Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name.trim(),
          'full_name': name.trim(),
        },
      );

      if (response.user != null) {
        if (response.session != null) {
          await Shared_Preferences.prefSetBool(SharedP.isLoggedIn, true);
          await Shared_Preferences.prefSetString(SharedP.userEmail, email);
          await Shared_Preferences.prefSetString(SharedP.userName, name.trim());
          await _recordDeviceLogin(email, name: name.trim());

          return AuthResult(
            isSuccess: true,
            message: "Account created and logged in successfully!",
            user: response.user,
          );
        } else {
          await Shared_Preferences.prefSetString(SharedP.userName, name.trim());
          return AuthResult(
            isSuccess: true,
            message: "Account created! A confirmation link has been sent to $email. Please confirm your email to sign in.",
            user: response.user,
          );
        }
      } else {
        return AuthResult(
          isSuccess: false,
          message: "Sign up failed. Please try again.",
        );
      }
    } on AuthException catch (e) {
      log("AuthException in signUp: ${e.message} (status: ${e.statusCode})");
      String friendlyMessage = e.message;

      final msgLower = e.message.toLowerCase();
      if (msgLower.contains("user already registered")) {
        friendlyMessage = "This email is already registered. Please click 'Sign In' to log in.";
      } else if (msgLower.contains("password should be at least")) {
        friendlyMessage = "Password should be at least 6 characters long.";
      } else if (msgLower.contains("signup requires a valid password")) {
        friendlyMessage = "Please enter a valid password.";
      }

      return AuthResult(
        isSuccess: false,
        message: friendlyMessage,
      );
    } catch (e) {
      log("Generic error in signUp: $e");
      return AuthResult(
        isSuccess: false,
        message: "Failed to connect to server: ${e.toString()}",
      );
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      log("Error during signOut: $e");
    } finally {
      await Shared_Preferences.prefSetBool(SharedP.isLoggedIn, false);
      await Shared_Preferences.clearPref(SharedP.userEmail);
      await Shared_Preferences.clearPref(SharedP.userName);
    }
  }
}
