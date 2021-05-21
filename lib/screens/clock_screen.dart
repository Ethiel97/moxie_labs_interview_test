import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/route_manager.dart';
import 'package:moxie_labs_test/providers/clock_manager.dart';
import 'package:moxie_labs_test/utils/colors.dart';
import 'package:moxie_labs_test/utils/text_styles.dart';
import 'package:provider/provider.dart';

class ClockScreen extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  DateTime displayDate = DateTime.now();

  ClockManager clockManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    clockManager = Provider.of<ClockManager>(context);
  }

  showAddAlarmDialog() async {
    TimeOfDay selectedTime;
    selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (selectedTime != null) {
      clockManager.saveAlarm(selectedTime);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${selectedTime.format(context)} added to alarms",
            style: textStyle.apply(
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
  }

  removeAlarm(TimeOfDay timeOfDay) {
    clockManager.removeAlarm(timeOfDay);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${timeOfDay.format(context)} removed to alarms",
          style: textStyle.apply(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  showAlarmsModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => clockManager.myAlarms.isEmpty
          ? Container(
              padding: EdgeInsets.all(24),
              child: Text(
                "No alarms",
                style: textStyle.apply(
                  fontSizeDelta: 3,
                ),
              ),
            )
          : StatefulBuilder(
              builder: (context, setState) => ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                padding: EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                itemCount: clockManager.myAlarms.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        clockManager.myAlarms[index]["display"],
                        style: textStyle.apply(
                          fontSizeDelta: 2,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          removeAlarm(clockManager.myAlarms[index]["time"]);
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: screenBackgroundColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: showAddAlarmDialog,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "My Clock",
            style: textStyle.apply(
              fontSizeDelta: 5,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            onPressed: showAlarmsModal,
            icon: Icon(
              CupertinoIcons.alarm,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => clockManager.switchStyle(),
              icon: Icon(
                clockManager.style == ClockStyle.Digital
                    ? CupertinoIcons.stopwatch
                    : CupertinoIcons.clock_solid,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Consumer<ClockManager>(
          builder: (context, clockManager, child) => GestureDetector(
            onTap: showAddAlarmDialog,
            child: Container(
              // alignment: Alignment.center,
              margin: EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: screenBackgroundColor,
              ),
              width: double.infinity,
              height: Get.height,
              child: AnalogClock(
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0, color: Colors.black),
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                width: 150.0,
                isLive: true,
                // hourHandColor: clockManager.style == ClockStyle.Digital
                //     ? Colors.transparent
                //     : Colors.black,
                // minuteHandColor: clockManager.style == ClockStyle.Digital
                //     ? Colors.transparent
                //     : Colors.black87,
                showAllNumbers: true,
                showSecondHand: clockManager.style != ClockStyle.Digital,
                numberColor: clockManager.style == ClockStyle.Digital
                    ? Colors.transparent
                    : Colors.black,
                secondHandColor: clockManager.style == ClockStyle.Digital
                    ? Colors.transparent
                    : Colors.red,
                datetime: displayDate,
                textScaleFactor: 1.4,
                showTicks: clockManager.style != ClockStyle.Digital,
                showDigitalClock: clockManager.style == ClockStyle.Digital,
              ),
            ),
          ),
        ),
      );
}
