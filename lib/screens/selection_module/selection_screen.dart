import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/date_formates.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/widget/common_dropdown.dart';
import 'package:alekha/widget/common_text_field.dart';
import 'package:alekha/widget/get_date_function.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String? _selectedMeetingType;
  String? _selectedRegardsType;

  TextEditingController clientNameController = TextEditingController();
  TextEditingController projectNumberController = TextEditingController();
  TextEditingController selectionTimeController = TextEditingController();
  TextEditingController dateMeetingController = TextEditingController();

  TextEditingController description1Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PickColors.whiteColor,
      appBar: AppBar(
        backgroundColor: PickColors.whiteColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            backToScreen(context: context);
          },
          child: Icon(
            Icons.arrow_left_outlined,
            color: PickColors.hintColor,
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          'Selection',
          style: CommonTextStyle().appBarTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextFieldWithFocus(
                controller: clientNameController,
                labelText: "Client Name",
                hintText: "Client Name",
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: projectNumberController,
                labelText: "Project No.",
                hintText: "Project No.",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              CommonDropDownWithoutSearch(
                borderColor: PickColors.primaryColor,
                hintText: "Select project type",
                name: 'Project Type',
                items: GlobalList.projectCategory
                    .map((category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: CommonTextStyle().textFieldTitleTextStyle,
                          ),
                        ))
                    .toList(),
                isExpanded: false,
                initialValue: _selectedMeetingType,
                onChanged: (newValue) {
                  setState(
                    () {
                      _selectedMeetingType = newValue.toString();
                    },
                  );
                  debugPrint("----------$_selectedMeetingType");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithBorder(
                fillColor: Colors.transparent,
                filled: true,
                prefix: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Icon(Icons.calendar_month_outlined,
                      color: PickColors.primaryColor),
                ),
                isRequired: true,
                readOnly: true,
                hint: "Date",
                controller: dateMeetingController,
                textInputAction: TextInputAction.none,
                keyboardType: TextInputType.none,
                validator: (value) {
                  return null;
                },
                onTap: () async {
                  DateTime? pickedDate = await getDateFunction(
                    isOldDate: true,
                    context: context,
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormate.normalDateFormate.format(pickedDate);
                    dateMeetingController.text =
                        formattedDate; // Set the picked date
                  }
                },
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: selectionTimeController,
                labelText: "Selection Time",
                hintText: "Selection Time",
              ),
              const SizedBox(
                height: 20,
              ),
              CommonTextFieldWithFocus(
                controller: description1Controller,
                labelText: "Description",
                hintText: "Description",
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
