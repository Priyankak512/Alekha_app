import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/hight_width_picker.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageDevicesScreen extends StatefulWidget {
  const ManageDevicesScreen({super.key});

  @override
  State<ManageDevicesScreen> createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends State<ManageDevicesScreen> {
  List<Map<String, dynamic>> _devices = [];
  String _currentEmail = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDevicesData();
  }

  Future<void> _loadDevicesData() async {
    setState(() {
      _isLoading = true;
    });

    final currentEmail = await AuthService.getCurrentUserEmail();
    final devicesList = await AuthService.getLoggedInDevices();

    // If current email is not in the list, ensure it's shown
    if (currentEmail.isNotEmpty && !devicesList.any((d) => d['email'] == currentEmail)) {
      devicesList.insert(0, {
        'email': currentEmail,
        'lastLogin': DateTime.now().toIso8601String(),
      });
    }

    if (mounted) {
      setState(() {
        _currentEmail = currentEmail;
        _devices = devicesList;
        _isLoading = false;
      });
    }
  }

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "Recently";
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PickColors.whiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: PickColors.hintColor),
        centerTitle: true,
        backgroundColor: PickColors.whiteColor,
        elevation: 0,
        title: Text(
          "Manage Devices",
          style: CommonTextStyle().appBarTextStyle,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _devices.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.devices_other, size: 60, color: PickColors.primaryColor),
                      PickHeightAndWidth.height15,
                      Text(
                        "No logged in accounts found",
                        style: CommonTextStyle().authSubTitleTextStyle,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: _devices.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final device = _devices[index];
                    final email = device['email'] as String? ?? "Unknown";
                    final lastLogin = device['lastLogin'] as String?;
                    final isCurrent = email.toLowerCase() == _currentEmail.toLowerCase();

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? PickColors.secondaryBGColor
                            : PickColors.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCurrent
                              ? PickColors.primaryColor
                              : PickColors.textfieldBorderColor,
                          width: isCurrent ? 1.5 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent
                                  ? PickColors.primaryColor.withOpacity(0.15)
                                  : Colors.grey.shade100,
                            ),
                            child: Icon(
                              Icons.phone_android_rounded,
                              color: isCurrent ? PickColors.primaryColor : Colors.grey,
                              size: 26,
                            ),
                          ),
                          PickHeightAndWidth.width15,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        email,
                                        style: CommonTextStyle().textFieldTitleTextStyle.copyWith(
                                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    if (isCurrent)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: PickColors.successColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "Active",
                                          style: TextStyle(
                                            color: PickColors.successColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                PickHeightAndWidth.height5,
                                Text(
                                  "Last Login: ${_formatDate(lastLogin)}",
                                  style: CommonTextStyle().authSubTitleTextStyle.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

