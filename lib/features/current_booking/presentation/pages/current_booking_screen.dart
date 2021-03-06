import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hot_desking/core/app_helpers.dart';
import 'package:hot_desking/features/booking_history/presentation/widgets/table_card.dart';
import 'package:hot_desking/features/current_booking/data/datasource/booked_ds.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_theme.dart';
import '../../../booking_history/presentation/widgets/room_card.dart';

class CurrentBookingScreen extends StatefulWidget {
  const CurrentBookingScreen({Key? key}) : super(key: key);

  @override
  State<CurrentBookingScreen> createState() => _CurrentBookingScreenState();
}

class _CurrentBookingScreenState extends State<CurrentBookingScreen> {
  bool _processing = true;
  bool _error = false;
  List _data = [];

  AppBar appbar = AppBar();
  TabBar tabBar = TabBar(tabs: []);

  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    DateTime now = new DateTime.now();
    var tim = now.hour.toString() + ':' + now.minute.toString();
    String cd = AppHelpers.formatDate(now);

    Map ct = await BookedDataSource.getCurrentHistory(
        cd, AppHelpers.formatTime(TimeOfDay.now()));
    Map tt = await BookedDataSource.getCurrentHistoryTable(
        cd, AppHelpers.formatTime(TimeOfDay.now()));

    if (ct['flag'] == false) {
      _error = true;
    } else {
      _data = ct['data'];
      _error = false;
    }

    if (tt['flag'] == false) {
      _error = true;
    } else {
      _data.addAll(tt['data']);
      _error = false;
    }

    _processing = false;
    setState(() {});
  }

  Widget _drawBody() {
    if (_error == true) {
      return Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: const Text("Error Occured"));
    }

    return RefreshIndicator(
      onRefresh: () async {
        loadData();
      },
      child: (_data.length == 0)
          ? SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      kBottomNavigationBarHeight,
                  child: const Center(child: Text("No Record to show"))),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                  height: Get.height * 0.9,
                  child: ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var node = _data[index];
                        if (node['tableid'] != null) {
                          return TableCard(
                              allowEdit: true,
                              fromCurrentBooking: true,
                              showWarning: true,
                              node: node,
                              onRefresh: () {
                                loadData();
                              });
                        } else {
                          return RoomCard(
                              showWarning: true,
                              fromCurrentBooking: true,
                              allowEdit: true,
                              node: node,
                              onRefresh: () {
                                loadData();
                              });
                        }
                      }))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kGreyBackground,
        appBar: AppTheme.appBar('Current Booking', context, false),
        body: _processing == true
            ? Column(
                children: [
                  const Expanded(
                      child: Center(child: CircularProgressIndicator())),
                ],
              )
            : _drawBody());
  }
}
