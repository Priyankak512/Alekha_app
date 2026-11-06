import 'dart:async';
import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/images_route.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/size_config.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/constant/toast_msg.dart';
import 'package:alekha/screens/home/home_view/home_screen.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:alekha/widget/common_material_button.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // 6 separate controllers & focus nodes for OTP boxes
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _isOtpSent = false;
  int _resendCountdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _showAppToast({required String message, required bool isSuccess}) {
    showToast(
      message: message,
      isPositive: isSuccess,
      context: context,
    );
  }

  String _getEnteredOtp() {
    return _otpControllers.map((c) => c.text.trim()).join();
  }

  void _clearOtpBoxes() {
    for (var c in _otpControllers) {
      c.clear();
    }
    if (_otpFocusNodes.isNotEmpty) {
      _otpFocusNodes[0].requestFocus();
    }
  }

  // Step 1: Send OTP to Email
  Future<void> _handleSendOtp() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text.trim();
      final name = _nameController.text.trim();

      final result = await AuthService.sendEmailOtp(
        email: email,
        name: name.isNotEmpty ? name : null,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showAppToast(
        message: result.message,
        isSuccess: result.isSuccess,
      );

      if (result.isSuccess) {
        setState(() {
          _isOtpSent = true;
        });
        _clearOtpBoxes();
        _startResendTimer();
      }
    }
  }

  // Step 2: Verify OTP
  Future<void> _handleVerifyOtp() async {
    FocusScope.of(context).unfocus();

    final otp = _getEnteredOtp();
    if (otp.length < 6) {
      _showAppToast(message: "Please enter the complete 6-digit OTP", isSuccess: false);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final name = _nameController.text.trim();

    final result = await AuthService.verifyEmailOtp(
      email: email,
      token: otp,
      name: name.isNotEmpty ? name : null,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    _showAppToast(
      message: result.message,
      isSuccess: result.isSuccess,
    );

    if (result.isSuccess) {
      changeScreenWithClearStack(
        context: context,
        widget: const HomeScreen(),
      );
    }
  }

  // Individual OTP Box Widget
  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 46,
      height: 52,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: _otpFocusNodes[index].hasFocus
              ? PickColors.secondaryBGColor
              : Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: PickColors.textfieldBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: _otpControllers[index].text.isNotEmpty
                  ? PickColors.primaryColor
                  : PickColors.textfieldBorderColor,
              width: _otpControllers[index].text.isNotEmpty ? 1.5 : 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: PickColors.primaryColor, width: 2.0),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              _otpFocusNodes[index + 1].requestFocus();
            } else {
              _otpFocusNodes[index].unfocus();
              _handleVerifyOtp(); // Auto trigger verification on 6th digit
            }
          } else {
            if (index > 0) {
              _otpFocusNodes[index - 1].requestFocus();
            }
          }
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: PickColors.whiteColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Brand Logo
                  Center(
                    child: Image.asset(
                      PickImages.alekhaArchitectsIcon,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  PickHeightAndWidth.height20,

                  // Title & Subtitle
                  Text(
                    _isOtpSent ? "Enter Verification Code" : "Welcome Back",
                    textAlign: TextAlign.center,
                    style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                          fontSize: 26,
                        ),
                  ),
                  PickHeightAndWidth.height10,
                  Text(
                    _isOtpSent
                        ? "Enter the 6-digit code sent to\n${_emailController.text.trim()}"
                        : "Enter your details to receive an OTP on your email",
                    textAlign: TextAlign.center,
                    style: CommonTextStyle().authSubTitleTextStyle,
                  ),
                  PickHeightAndWidth.height30,

                  if (!_isOtpSent) ...[
                    // Full Name (Required)
                    CommonTextFieldWithBorder(
                      controller: _nameController,
                      hint: "Enter your full name",
                      labelText: "Full Name",
                      isRequired: true,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(
                          Icons.person_outline,
                          color: PickColors.primaryColor,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your full name";
                        }
                        if (value.trim().length < 2) {
                          return "Name must be at least 2 characters";
                        }
                        return null;
                      },
                    ),
                    PickHeightAndWidth.height20,

                    // Email Field
                    CommonTextFieldWithBorder(
                      controller: _emailController,
                      hint: "Enter your email address",
                      labelText: "Email",
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Icon(
                          Icons.email_outlined,
                          color: PickColors.primaryColor,
                          size: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter email";
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value.trim())) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) => _handleSendOtp(),
                    ),
                    PickHeightAndWidth.height30,

                    // Send OTP Button
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CommonMaterialButton(
                            title: "Send OTP",
                            color: PickColors.buttonColor,
                            verticalPadding: 16,
                            borderRadius: 10,
                            onPressed: _handleSendOtp,
                          ),
                  ] else ...[
                    // 6 separate stylish OTP Boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (i) => _buildOtpBox(i)),
                    ),
                    PickHeightAndWidth.height30,

                    // Verify & Login Button
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CommonMaterialButton(
                            title: "Verify & Login",
                            color: PickColors.buttonColor,
                            verticalPadding: 16,
                            borderRadius: 10,
                            onPressed: _handleVerifyOtp,
                          ),
                    PickHeightAndWidth.height20,

                    // Resend OTP only (Change Email removed)
                    Center(
                      child: TextButton(
                        onPressed: _resendCountdown > 0 ? null : _handleSendOtp,
                        child: Text(
                          _resendCountdown > 0
                              ? "Resend OTP in ${_resendCountdown}s"
                              : "Resend OTP",
                          style: TextStyle(
                            color: _resendCountdown > 0 ? Colors.grey : PickColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
