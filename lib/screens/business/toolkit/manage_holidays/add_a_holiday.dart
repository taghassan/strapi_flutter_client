import 'package:bapp/config/constants.dart';
import 'package:bapp/helpers/extensions.dart';
import 'package:bapp/screens/business/toolkit/manage_services/add_a_service.dart';
import 'package:bapp/stores/business_store.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BusinessAddAHolidayScreen extends StatefulWidget {
  @override
  _BusinessAddAHolidayScreenState createState() =>
      _BusinessAddAHolidayScreenState();
}

class _BusinessAddAHolidayScreenState extends State<BusinessAddAHolidayScreen> {
  List<DateTime> _pickedDates = [
    DateTime.now(),
    DateTime.now().add(
      Duration(days: 1),
    ),
  ];
  String _name = "";
  String _type = "";
  String _details = "";
  final _firstDate = DateTime.now().subtract(Duration(days: 1));
  final _lastdate = DateTime(2040);
  final _initialFirstDay = DateTime.now();
  final _initialLastDay = DateTime.now().add(
    Duration(days: 1),
  );

  final f = DateFormat("dd");
  final f2 = DateFormat("dd MMMM, yyyy");

  final _controller = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
    /* return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Add Holiday"),
      ),
      bottomNavigationBar: BottomPrimaryButton(
        title: "",
        subTitle: "",
        label: "Add",
        onPressed: () async {
          if (_key.currentState?.validate()??false) {
            final businessStore =
                Provider.of<BusinessStore>(context, listen: false);
            if (businessStore
                .business.selectedBranch.value.businessHolidays.value.all
                .contains(_name)) {
              Flushbar(
                message: "The holiday with that name exists",
                duration: const Duration(seconds: 2),
              ).show(context);
              return;
            }
            var b = false;
            businessStore
                .business.selectedBranch.value.businessHolidays.value.all
                .forEach(
              (businessHoliday) {
                if (businessHoliday.dates == _pickedDates) {
                  b = true;
                }
              },
            );
            if (b) {
              Flushbar(
                message: "The holiday range exists",
                duration: const Duration(seconds: 2),
              ).show(context);
              return;
            }
            await businessStore
                .business.selectedBranch.value.businessHolidays.value
                .addHoliday(
              name: _name,
              type: _type,
              details: _details,
              fromToDate: _pickedDates,
            );
            BappNavigator.pop(context, null);
          }
        },
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Form(
                      key: _key,
                      child: Column(
                        children: [
                          ButtonTheme(
                            buttonColor: Colors.teal,
                            child: GestureDetector(
                              onTap: () async {
                                _pickedDates =
                                    await DateRagePicker.showDatePicker(
                                  context: context,
                                  firstDate: _firstDate,
                                  lastDate: _lastdate,
                                  initialFirstDate: _initialFirstDay,
                                  initialLastDate: _initialLastDay,
                                );
                                if (_pickedDates == null) {
                                  return;
                                }
                                _controller.text = f.format(_pickedDates[0]) +
                                    " to " +
                                    f2.format(_pickedDates[1]);
                              },
                              child: Builder(
                                builder: (_) {
                                  _controller.text = f.format(_pickedDates[0]) +
                                      " to " +
                                      f2.format(_pickedDates[1]);
                                  return TextFormField(
                                    enabled: false,
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      labelText: "Select Dates",
                                      suffixIcon: Icon(
                                        Icons.calendar_today_outlined,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Name",
                              hintText: "Some Holiday",
                            ),
                            onChanged: (s) {
                              _name = s;
                            },
                            validator: (s) {
                              if (s?.isEmpty??false) {
                                return "Add a name for the holiday";
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField<String>(
                            decoration:
                                InputDecoration(labelText: "Holiday Type"),
                            validator: (s) {
                              if (s == null) {
                                return "Select holiday type";
                              }
                              return null;
                            },
                            items: <DropdownMenuItem<String>>[
                              ...List.generate(
                                kHolidayTypes.length,
                                (index) => DropdownMenuItem(
                                  value: kHolidayTypes[index],
                                  child: Text(
                                    kHolidayTypes[index],
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (v) {
                              _type = v??"";
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            maxLength: 60,
                            maxLengthEnforced: true,
                            maxLines: 2,
                            decoration:
                                InputDecoration(labelText: "Enter Details"),
                            onChanged: (s) {
                              _details = s;
                            },
                            validator: (s) {
                              if ((s?.length??0) < 5) {
                                return "Enter valid detail";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
   */
  }
}
