import 'package:bapp/classes/firebase_structures/staff_time_off.dart';
import 'package:bapp/config/config_data_types.dart';
import 'package:bapp/helpers/extensions.dart';
import 'package:bapp/helpers/helper.dart';
import 'package:bapp/screens/business/booking_flow/select_a_professional.dart';
import 'package:bapp/screens/business/booking_flow/services_screen.dart';
import 'package:bapp/screens/business/toolkit/manage_services/add_a_service.dart';
import 'package:bapp/screens/business/toolkit/manage_staff/manage_staff.dart';
import 'package:bapp/stores/booking_flow.dart';
import 'package:bapp/stores/business_store.dart';
import 'package:bapp/super_strapi/my_strapi/bookingX.dart';
import 'package:bapp/super_strapi/my_strapi/persistenceX.dart';
import 'package:bapp/super_strapi/my_strapi/userX.dart';
import 'package:bapp/super_strapi/my_strapi/x_widgets/x_widgets.dart';
import 'package:bapp/widgets/bapp_calendar.dart';
import 'package:bapp/widgets/booking_timeline.dart';
import 'package:bapp/widgets/loading.dart';
import 'package:bapp/widgets/tiles/employee_tile.dart';
import 'package:bapp/widgets/tiles/error.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:super_strapi_generated/super_strapi_generated.dart';
import 'package:table_calendar/table_calendar.dart';

class BusinessBookingsTab extends StatefulWidget {
  @override
  _BusinessBookingsTabState createState() => _BusinessBookingsTabState();
}

class _BusinessBookingsTabState extends State<BusinessBookingsTab> {
  final _calendarController = CalendarController();
  final _selectedDay = Observable(DateTime.now());

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = UserX.i.user();
      if (user is! User) {
        return Text("no user");
      }
      final partner = user.partner;
      if (partner is! Partner) {
        return Text("No partner");
      }
      return Partners.listenerWidget(
          strapiObject: partner,
          sync: true,
          builder: (_, partner, loading) {
            if (loading) {
              return LoadingWidget();
            }
            final pickedBusiness = user.pickedBusiness;
            if (pickedBusiness is! Business) {
              return Text("No business selected");
            }
            final pickedEmployee = user.pickedEmployee;
            return Businesses.listenerWidget(
                strapiObject: pickedBusiness,
                sync: true,
                builder: (context, business, loading) {
                  return Scaffold(
                    floatingActionButton: pickedEmployee is! Employee
                        ? SizedBox()
                        : FloatingActionButton(
                            onPressed: () {
                              BappNavigator.dialog(
                                context,
                                BookingsTabAddOptions(
                                  business: business,
                                ),
                              );
                            },
                            child: Icon(FeatherIcons.plus),
                          ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    body: Builder(builder: (_) {
                      final employeeSelector = () async {
                        final e = await BappNavigator.push(
                          context,
                          SelectAProfessionalScreen(
                            forDay: DateTime.now(),
                            business: business,
                          ),
                        );
                        if (e is Employee) {
                          final user = UserX.i.user();
                          if (user is User) {
                            final copied = user.copyWIth(pickedEmployee: e);
                            final updated = await Users.update(copied);
                            UserX.i.user(updated);
                          }
                        }
                      };
                      return CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                if (pickedEmployee is Employee)
                                  EmployeeTile(
                                    employee: pickedEmployee,
                                    enabled: true,
                                    onTap: employeeSelector,
                                  ),
                                if (pickedEmployee is! Employee)
                                  ListTile(
                                    onTap: employeeSelector,
                                    title: Text("Staff"),
                                    subtitle: Text("Select a staff"),
                                    trailing: Icon(FeatherIcons.arrowRight),
                                  ),
                                TapToReFetch<List<Booking>>(
                                    fetcher: () => BookingX.i
                                        .getAllBookingsForDay(
                                            business, _selectedDay.value),
                                    onLoadBuilder: (_) => LoadingWidget(),
                                    onErrorBuilder: (_, e, s) =>
                                        ErrorTile(message: e.toString()),
                                    onSucessBuilder: (
                                      context,
                                      list,
                                    ) {
                                      return BappRowCalender(
                                        bookings:
                                            bookingsAsCalendarEvents(list),
                                        initialDate: DateTime.now(),
                                        holidays: holidaysAsCalendarEvents(
                                            business.holidays ?? []),
                                        controller: _calendarController,
                                        onDayChanged: (day, _, __) {
                                          act(() {
                                            _selectedDay.value = day;
                                          });
                                        },
                                      );
                                    })
                              ],
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                SizedBox(
                                  height: 0,
                                ),
                                Builder(
                                  builder: (_) {
                                    return pickedEmployee is! Employee
                                        ? Align(
                                            alignment: Alignment.center,
                                            child: Text("Select a enployee"),
                                          )
                                        : BookingTimeLineWidget(
                                            date: _selectedDay.value,
                                            list: pickedEmployee.bookings ?? [],
                                          );
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                });
          });
    });
  }
}

class BookingsTabAddOptions extends StatefulWidget {
  final Business business;

  const BookingsTabAddOptions({Key? key, required this.business})
      : super(key: key);
  @override
  _BookingsTabAddOptionsState createState() => _BookingsTabAddOptionsState();
}

class _BookingsTabAddOptionsState extends State<BookingsTabAddOptions> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("Add Walk-In"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              BappNavigator.push(
                context,
                BusinessProfileServicesScreen(
                  business: widget.business,
                ),
              );
            },
          ),
          ListTile(
            title: Text("Add Booking"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {},
          ),
          ListTile(
            title: Text("Block time"),
            trailing: Icon(Icons.arrow_forward),
            enabled: false,
            onTap: null,
          ),
          ListTile(
            title: Text("Time off"),
            trailing: Icon(Icons.arrow_forward),
            enabled: false,
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class BlockTimeScreen extends StatefulWidget {
  @override
  _BlockTimeScreenState createState() => _BlockTimeScreenState();
}

class _BlockTimeScreenState extends State<BlockTimeScreen> {
  final _calendarCtrl = CalendarController();
  var _saving = false;

  @override
  void dispose() {
    _calendarCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
    /* return Consumer<BookingFlow>(
      builder: (_, flow, __) {
        final _staffTimeOff = StaffTimeOff(
          myDoc: StaffTimeOff.newRef(),
          staff: flow.professional.value.staff,
          type: StaffTimeOffType.partial,
        );

        _staffTimeOff.from = DateTime.now();
        _staffTimeOff.to = DateTime.now().add(const Duration(hours: 1));

        return Scaffold(
          bottomNavigationBar: BottomPrimaryButton(
            label: "Update",
            onPressed: _saving
                ? null
                : () async {
                    if (_staffTimeOff.to.difference(_staffTimeOff.from) >
                        Duration(minutes: 15)) {
                      if (_staffTimeOff.reason.isNotEmpty) {
                        setState(() {
                          _saving = true;
                        });
                        await _staffTimeOff.save();
                        BappNavigator.pop(context, null);
                      } else {
                        Flushbar(
                          message: "Reason should not be empty",
                          duration: const Duration(seconds: 4),
                        ).show(context);
                        _saving = false;
                      }
                    } else {
                      setState(() {
                        _saving = false;
                      });
                      Flushbar(
                        message: "Block time must be atleast 15 minutes",
                        duration: const Duration(seconds: 4),
                      ).show(context);
                    }
                  },
          ),
          appBar: AppBar(
            centerTitle: true,
            title: Text("Block time"),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      BappRowCalender(
                        controller: _calendarCtrl,
                        initialDate: DateTime.now(),
                        holidays: flow.branch.businessHolidays.value
                            .holidaysForBappCalender(),
                        onDayChanged: (day, __, ___) {
                          _staffTimeOff.from = _staffTimeOff.from.toDay(day);
                          _staffTimeOff.to = _staffTimeOff.to.toDay(day);
                        },
                      )
                    ],
                  ),
                ),
              ];
            },
            body: ListView(
              shrinkWrap: true,
              children: [
                BusinessStaffListTile(
                  staff: flow.professional.value.staff,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: FromToDatePicker(
                    onChange: (from, to) {
                      _staffTimeOff.from = from.toDay(_staffTimeOff.from);
                      _staffTimeOff.to = to.toDay(_staffTimeOff.to);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    onChanged: (s) {
                      _staffTimeOff.reason = s;
                    },
                    maxLines: 5,
                    decoration: InputDecoration(labelText: "Reason"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
   */
  }
}

class FromToDatePicker extends StatefulWidget {
  final bool onlyTime;
  final DateTime from, to;
  final Function(DateTime, DateTime)? onChange;

  const FromToDatePicker(
      {Key? key,
      this.onlyTime = true,
      required this.from,
      required this.to,
      this.onChange})
      : super(key: key);
  @override
  _FromToDatePickerState createState() => _FromToDatePickerState();
}

class _FromToDatePickerState extends State<FromToDatePicker> {
  var fromTime = DateTime.now();
  var toTime = DateTime.now().add(const Duration(hours: 1));
  final timeFormatter = DateFormat.jm();
  final dateFormatter = DateFormat.yMd();

  final fromCtrl = TextEditingController();
  final toCtrl = TextEditingController();

  @override
  void initState() {
    fromTime = widget.from;
    toTime = widget.to;
    fromCtrl.text = timeFormatter.format(fromTime);
    toCtrl.text = timeFormatter.format(toTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "From",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextFormField(
                readOnly: true,
                controller: fromCtrl,
                onTap: () async {
                  final tod = await showTimePicker(
                      context: context, initialTime: fromTime.toTimeOfDay());
                  if (tod != null) {
                    fromTime = tod.toDateAndTime();
                    fromCtrl.text = timeFormatter.format(fromTime);
                    widget.onChange?.call(fromTime, toTime);
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "To",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextFormField(
                readOnly: true,
                controller: toCtrl,
                onTap: () async {
                  final tod = await showTimePicker(
                      context: context, initialTime: toTime.toTimeOfDay());
                  if (tod != null) {
                    toTime = tod.toDateAndTime();
                    if (toTime
                            .toTimeOfDay()
                            .compareTo(fromTime.toTimeOfDay()) ==
                        -1) {
                      toTime = fromTime.add(Duration(minutes: 1));
                    }
                    toCtrl.text = timeFormatter.format(toTime);
                    widget.onChange?.call(fromTime, toTime);
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
