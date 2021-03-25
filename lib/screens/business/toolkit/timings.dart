/* import 'package:bapp/classes/firebase_structures/business_timings.dart';
import 'package:bapp/helpers/helper.dart';
import 'package:bapp/stores/business_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_range_picker/time_range_picker.dart';

class BusinessManageWorkingHoursScreen extends StatefulWidget {
  @override
  _BusinessManageWorkingHoursScreenState createState() =>
      _BusinessManageWorkingHoursScreenState();
}

class _BusinessManageWorkingHoursScreenState
    extends State<BusinessManageWorkingHoursScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Manage working hours"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Builder(
          builder: (_) {
            return Observer(
              builder: (_) {
                final timings = [];
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.zero,
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            ...List.generate(
                              timings.length,
                              (index) => DayTimingsWidget(
                                dayName: timings[index].dayName + "s",
                                dayTiming: timings[index],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DayTimingsWidget extends StatefulWidget {
  final String dayName;
  final DayTiming dayTiming;

  const DayTimingsWidget(
      {Key? key, required this.dayName, required this.dayTiming})
      : super(key: key);
  @override
  _DayTimingsWidgetState createState() => _DayTimingsWidgetState();
}

class _DayTimingsWidgetState extends State<DayTimingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Theme.of(context).cardColor,
      child: Observer(
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.dayName,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Switch(
                        value: widget.dayTiming.enabled.value,
                        onChanged: (b) {
                          act(() {
                            widget.dayTiming.enabled.value = b;
                          });
                        })
                  ],
                ),
              ),
              if (widget.dayTiming.timings.value.isNotEmpty)
                Observer(
                  builder: (_) {
                    return IgnorePointer(
                      ignoring: !widget.dayTiming.enabled.value,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.dayTiming.timings.value.length,
                        itemBuilder: (_, index) {
                          return widget.dayTiming.timings.value[index] == null
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: DayTimingRowWidget(
                                    fromToTiming:
                                        widget.dayTiming.timings.value[index],
                                    onRemove: () {
                                      act(() {
                                        widget.dayTiming.timings.value[index] =
                                            null;
                                      });
                                    },
                                    onChange: (cd) {
                                      act(() {
                                        widget.dayTiming.timings.value[index] =
                                            cd;
                                      });
                                    },
                                  ),
                                );
                        },
                      ),
                    );
                  },
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Observer(
                  builder: (_) {
                    return IgnorePointer(
                      ignoring: !widget.dayTiming.enabled.value,
                      child: IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          act(
                            () {
                              widget.dayTiming.timings.value.add(
                                FromToTiming.fromDates(
                                  from: DateTime(2020, 1, 1, 9, 0, 0, 0, 0),
                                  to: DateTime(2020, 1, 1, 18, 0, 0, 0, 0),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }
}

class DayTimingRowWidget extends StatefulWidget {
  final FromToTiming fromToTiming;
  final VoidCallback? onRemove;
  final Function(FromToTiming) onChange;

  const DayTimingRowWidget(
      {Key? key,
      required this.fromToTiming,
      required this.onRemove,
      required this.onChange})
      : super(key: key);

  @override
  _DayTimingRowWidgetState createState() => _DayTimingRowWidgetState();
}

class _DayTimingRowWidgetState extends State<DayTimingRowWidget> {
  FromToTiming? _fromToTiming;
  @override
  void initState() {
    _fromToTiming = widget.fromToTiming;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          format(_fromToTiming?.from),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Text("To"),
        Text(
          format(_fromToTiming?.to),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          width: 8,
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () async {},
        ),
        IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: widget.onRemove,
        ),
      ],
    );
  }

  String format(DateTime? dt) {
    return DateFormat.jm().format(dt);
  }
}
 */