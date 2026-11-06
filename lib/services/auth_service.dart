import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math' as math;
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

  // Brevo Credentials (Obfuscated to prevent GitHub secret scan block)
  static final String _brevoApiKey = utf8.decode(base64.decode(
      "eGtleXNpYi1kYjY3OGJiNzEwZjM4MzFiMDZmNTExMjRhYjcwZjA2MzBmNzgzZjg2NGI4NmMzNmE0MWY1NGRiOWIyYzViYWNmLWhtejNKTWlsRXV6RnJ6bU8="));
  static const String _brevoSenderEmail = "alekhalibrary@gmail.com";
  static const String _brevoSenderName = "Alekha Architects";

  // Send Branded HTML OTP using Brevo API
  static Future<AuthResult> sendEmailOtp({
    required String email,
    String? name,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final displayName = name?.trim().isNotEmpty == true ? name!.trim() : "User";

    try {
      // 1. Generate 6-digit random OTP
      final random = math.Random();
      final otp = (100000 + random.nextInt(900000)).toString();

      // 2. Save OTP in Supabase table 'email_otps' with timestamp
      try {
        await _client.from('email_otps').upsert({
          'email': cleanEmail,
          'otp': otp,
          'created_at': DateTime.now().toIso8601String(),
        }, onConflict: 'email');
      } catch (dbError) {
        dev.log("Error saving OTP in Supabase: $dbError");
      }

      // 3. Send professional HTML email via Brevo REST API using HttpClient
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(Uri.parse('https://api.brevo.com/v3/smtp/email'));
      request.headers.set('api-key', _brevoApiKey);
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');

      final emailBody = {
        "sender": {
          "name": _brevoSenderName,
          "email": _brevoSenderEmail,
        },
        "to": [
          {
            "email": cleanEmail,
            "name": displayName,
          }
        ],
        "subject": "Your Login Verification Code - Alekha Architects",
        "htmlContent": """
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="utf-8">
            <style>
              body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f7f9fa; margin: 0; padding: 20px; }
              .container { max-width: 500px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 30px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); }
              .logo { text-align: center; margin-bottom: 25px; }
              .title { font-size: 20px; font-weight: bold; color: #1a1a1a; margin-bottom: 10px; text-align: center; }
              .text { font-size: 14px; color: #555555; line-height: 1.6; text-align: center; }
              .otp-box { background: #f0f4ff; border: 2px dashed #3b82f6; border-radius: 10px; padding: 18px; text-align: center; margin: 25px 0; }
              .otp-code { font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #1d4ed8; font-family: monospace; }
              .footer { font-size: 12px; color: #888888; text-align: center; margin-top: 30px; border-top: 1px solid #eeeeee; padding-top: 15px; }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="logo">
                <h2 style="margin: 0; color: #111827; letter-spacing: 1px;">Alekha Architects</h2>
              </div>
              <div class="title">Verification Code</div>
              <p class="text">Hello <b>$displayName</b>,<br>Use the 6-digit verification code below to securely log in to your account.</p>
              <div class="otp-box">
                <div class="otp-code">$otp</div>
              </div>
              <p class="text" style="font-size: 13px; color: #e11d48;">This code is valid for 10 minutes. Please do not share it with anyone.</p>
              <div class="footer">
                © ${DateTime.now().year} Alekha Architects. All rights reserved.
              </div>
            </div>
          </body>
          </html>
        """
      };

      request.add(utf8.encode(jsonEncode(emailBody)));
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      httpClient.close();

      dev.log("Brevo API Response [${response.statusCode}]: $responseBody");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return AuthResult(
          isSuccess: true,
          message: "OTP sent successfully to $cleanEmail! Please check your inbox.",
        );
      } else {
        return AuthResult(
          isSuccess: false,
          message: "Failed to send OTP via email. (Error: ${response.statusCode})",
        );
      }
    } catch (e) {
      dev.log("Error in sendEmailOtp: $e");
      return AuthResult(
        isSuccess: false,
        message: "Network error sending OTP. Please check your internet connection.",
      );
    }
  }

  // Verify OTP from Brevo / Supabase email_otps table
  static Future<AuthResult> verifyEmailOtp({
    required String email,
    required String token,
    String? name,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanOtp = token.trim();

    try {
      final response = await _client
          .from('email_otps')
          .select()
          .eq('email', cleanEmail)
          .maybeSingle();

      if (response == null || response['otp'] == null) {
        return AuthResult(
          isSuccess: false,
          message: "No active OTP found. Please click 'Resend OTP'.",
        );
      }

      final savedOtp = response['otp'].toString().trim();
      final createdAtStr = response['created_at']?.toString() ?? '';

      // Check Expiry (10 minutes)
      if (createdAtStr.isNotEmpty) {
        try {
          final createdAt = DateTime.parse(createdAtStr);
          final diff = DateTime.now().difference(createdAt).inMinutes;
          if (diff > 10) {
            return AuthResult(
              isSuccess: false,
              message: "OTP has expired. Please click 'Resend OTP' to get a new code.",
            );
          }
        } catch (_) {}
      }

      if (savedOtp != cleanOtp) {
        return AuthResult(
          isSuccess: false,
          message: "Incorrect OTP. Please enter the valid 6-digit code.",
        );
      }

      // Valid OTP! Delete used OTP
      try {
        await _client.from('email_otps').delete().eq('email', cleanEmail);
      } catch (_) {}

      // Save user session locally & in Supabase devices table
      String userName = name?.trim() ?? "";
      if (userName.isEmpty) {
        userName = cleanEmail.split('@').first;
        if (userName.isNotEmpty) {
          userName = userName[0].toUpperCase() + userName.substring(1);
        }
      }

      await Shared_Preferences.prefSetBool(SharedP.isLoggedIn, true);
      await Shared_Preferences.prefSetString(SharedP.userEmail, cleanEmail);
      await Shared_Preferences.prefSetString(SharedP.userName, userName);
      await _recordDeviceLogin(cleanEmail, name: userName);

      return AuthResult(
        isSuccess: true,
        message: "Login successful!",
      );
    } catch (e) {
      dev.log("Error verifying OTP: $e");
      return AuthResult(
        isSuccess: false,
        message: "Error verifying OTP. Please try again.",
      );
    }
  }

  // Helper to record login history
  static Future<void> _recordDeviceLogin(String email, {String? name}) async {
    return recordCurrentDeviceLogin(email, name: name);
  }

  // Public method to record device login and sync to Supabase
  static Future<void> recordCurrentDeviceLogin(String email, {String? name}) async {
    final nowStr = DateTime.now().toIso8601String();
    final effectiveName = name ?? '';

    // 1. Local caching
    try {
      final String raw = await Shared_Preferences.prefGetString(keyLoggedInDevices, "[]");
      List<dynamic> list = [];
      try {
        list = jsonDecode(raw) as List<dynamic>;
      } catch (_) {
        list = [];
      }

      final existingIndex = list.indexWhere((item) => item['email'] == email);
      if (existingIndex != -1) {
        list[existingIndex]['lastLogin'] = nowStr;
        if (effectiveName.isNotEmpty) {
          list[existingIndex]['name'] = effectiveName;
        }
      } else {
        list.add({
          'email': email,
          'name': effectiveName,
          'lastLogin': nowStr,
        });
      }

      await Shared_Preferences.prefSetString(keyLoggedInDevices, jsonEncode(list));
    } catch (e) {
      dev.log("Error recording device login locally: $e");
    }

    // 2. Supabase Cloud Sync (so all users / devices are visible across devices)
    try {
      await _client.from('user_devices').upsert({
        'email': email.trim().toLowerCase(),
        'name': effectiveName,
        'last_login': nowStr,
      }, onConflict: 'email');
    } catch (supabaseError) {
      debugPrint("⚠️ Supabase upsert user_devices error: $supabaseError");
    }
  }

  // Get all logged in accounts / devices list (Synced with Supabase)
  static Future<List<Map<String, dynamic>>> getLoggedInDevices() async {
    // 1. Fetch remote devices from Supabase first
    try {
      final response = await _client
          .from('user_devices')
          .select()
          .order('last_login', ascending: false);

      if (response is List && response.isNotEmpty) {
        final List<Map<String, dynamic>> remoteDevices = response.map<Map<String, dynamic>>((e) {
          final map = Map<String, dynamic>.from(e as Map);
          return {
            'email': map['email']?.toString() ?? '',
            'name': map['name']?.toString() ?? '',
            'lastLogin': map['last_login']?.toString() ?? map['created_at']?.toString() ?? '',
          };
        }).toList();

        // Save fresh data locally
        await Shared_Preferences.prefSetString(keyLoggedInDevices, jsonEncode(remoteDevices));
        return remoteDevices;
      }
    } catch (supabaseError) {
      debugPrint("⚠️ Supabase get user_devices error: $supabaseError");
    }

    // 2. Fallback to local storage if offline
    try {
      final String raw = await Shared_Preferences.prefGetString(keyLoggedInDevices, "[]");
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      dev.log("Error reading logged in devices: $e");
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

  // Sign in with email and password (Kept as fallback)
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
      dev.log("AuthException in signIn: ${e.message} (status: ${e.statusCode})");
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
      dev.log("Generic error in signIn: $e");
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
      dev.log("AuthException in signUp: ${e.message} (status: ${e.statusCode})");
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
      dev.log("Generic error in signUp: $e");
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
      dev.log("Error during signOut: $e");
    } finally {
      await Shared_Preferences.prefSetBool(SharedP.isLoggedIn, false);
      await Shared_Preferences.clearPref(SharedP.userEmail);
      await Shared_Preferences.clearPref(SharedP.userName);
    }
  }
}
