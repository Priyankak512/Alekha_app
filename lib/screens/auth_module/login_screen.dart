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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordObscure = true;
  bool _isLoading = false;
  bool _isSignUpMode = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearInputFields() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _formKey.currentState?.reset();
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignUpMode = !_isSignUpMode;
      _clearInputFields();
    });
  }

  void _showAppToast({required String message, required bool isSuccess}) {
    showToast(
      message: message,
      isPositive: isSuccess,
      context: context,
    );
  }

  Future<void> _handleAuthAction() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      AuthResult result;
      if (_isSignUpMode) {
        result = await AuthService.signUp(name: name, email: email, password: password);
      } else {
        result = await AuthService.signIn(email: email, password: password);
      }

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showAppToast(
        message: result.message,
        isSuccess: result.isSuccess,
      );

      if (result.isSuccess) {
        if (!_isSignUpMode || result.user?.identities?.isNotEmpty == true) {
          if (result.message.contains("logged in") || result.message.contains("successful")) {
            changeScreenWithClearStack(
              context: context,
              widget: const HomeScreen(),
            );
          } else {
            setState(() {
              _isSignUpMode = false;
              _clearInputFields();
            });
          }
        }
      }
    }
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
                  // App / Brand Logo
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
                    _isSignUpMode ? "Create Account" : "Welcome Back",
                    textAlign: TextAlign.center,
                    style: CommonTextStyle().mainHeadingTextStyle.copyWith(
                          fontSize: 26,
                        ),
                  ),
                  PickHeightAndWidth.height10,
                  Text(
                    _isSignUpMode
                        ? "Register with your details to get started"
                        : "Sign in to continue to your account",
                    textAlign: TextAlign.center,
                    style: CommonTextStyle().authSubTitleTextStyle,
                  ),
                  PickHeightAndWidth.height30,

                  // Name Field (Only on Sign Up mode)
                  if (_isSignUpMode) ...[
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
                          return "Please enter your name";
                        }
                        if (value.trim().length < 2) {
                          return "Name must be at least 2 characters";
                        }
                        return null;
                      },
                    ),
                    PickHeightAndWidth.height20,
                  ],

                  // Email Field
                  CommonTextFieldWithBorder(
                    controller: _emailController,
                    hint: "Enter your email",
                    labelText: "Email",
                    isRequired: true,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
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
                  ),
                  PickHeightAndWidth.height20,

                  // Password Field with Obscure toggle
                  CommonTextFieldWithBorder(
                    controller: _passwordController,
                    hint: _isSignUpMode ? "Create password (min 6 chars)" : "Enter your password",
                    labelText: "Password",
                    isRequired: true,
                    obscure: _isPasswordObscure,
                    onSuffixTap: () {
                      setState(() {
                        _isPasswordObscure = !_isPasswordObscure;
                      });
                    },
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    prefix: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(
                        Icons.lock_outline,
                        color: PickColors.primaryColor,
                        size: 20,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter password";
                      }
                      if (value.trim().length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {
                      _handleAuthAction();
                    },
                  ),
                  PickHeightAndWidth.height30,

                  // Action Button (Login / Sign Up)
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : CommonMaterialButton(
                          title: _isSignUpMode ? "Sign Up" : "Login",
                          color: PickColors.buttonColor,
                          verticalPadding: 16,
                          borderRadius: 10,
                          onPressed: _handleAuthAction,
                        ),
                  PickHeightAndWidth.height20,

                  // Switch between Login and Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isSignUpMode
                            ? "Already have an account? "
                            : "Don't have an account? ",
                        style: CommonTextStyle().authSubTitleTextStyle,
                      ),
                      InkWell(
                        onTap: _toggleAuthMode,
                        child: Text(
                          _isSignUpMode ? "Sign In" : "Sign Up",
                          style: CommonTextStyle().inkWellTextStyle.copyWith(
                                color: PickColors.blackColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
