import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hot_desking/features/booking_history/presentation/widgets/edit_booking_dialog.dart';
import 'package:hot_desking/features/booking_history/presentation/widgets/start_end_dialog.dart';
import 'package:http/http.dart' as http;

import '../../../../core/app_colors.dart';
import '../../../../core/app_helpers.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/app_urls.dart';

class TableCard extends StatelessWidget {
  final bool showWarning;
  final bool allowEdit;
  final bool fromCurrentBooking;
  final dynamic node;
  final Function onRefresh;

  const TableCard(
      {Key? key,
      this.allowEdit = false,
      this.showWarning = false,
      this.fromCurrentBooking = false,
      this.node,
      required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fromCurrentBooking
          ? () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                      child: Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: StartEndDialog(
                          type: 'Table',
                        ),
                      ),
                    );
                  });
            }
          : null,
      child: Container(
        // height: 114.h,
        width: 326.w,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(12),
        decoration: AppTheme.boxDecoration
            .copyWith(color: AppColors.kLightGreyContainer),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Table ${node != null ? node["tableid"] != null ? node['tableid'] : node['id'] != null ? node['id'] : 1 : 1}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                if (allowEdit)
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: EditBookingDialog(
                                    type: 'Table',
                                    node: node,
                                    onDelete: () async {
                                      var client = http.Client();
                                      var response = await client.post(
                                          Uri.parse(AppUrl.tablecancleMeeting),
                                          body: {
                                            "id": "${node['id'] ?? 0}",
                                            "status": "cancel"
                                          });
                                      print(response.body);
                                      onRefresh();
                                    },
                                    onEdit: (String date, String startTime,
                                        String endTime) async {
                                      var response = await http.Client().post(
                                          Uri.parse(AppUrl.updateTableBooking),
                                          //      headers: {
                                          //   HttpHeaders.contentTypeHeader: 'application/json'
                                          // },
                                          body: {
                                            "id": node['id'].toString(),
                                            "tableid":
                                                node['tableid'].toString(),
                                            "seatnumber":
                                                node['seatnumber'].toString(),
                                            "selecteddate": date,
                                            "fromtime": startTime,
                                            "totime": endTime,
                                            "employeeid": AppHelpers
                                                        .SHARED_PREFERENCES
                                                        .getInt('user_id') !=
                                                    null
                                                ? AppHelpers.SHARED_PREFERENCES
                                                    .getInt('user_id')
                                                    .toString()
                                                : 1.toString(),
                                          });
                                      print(response.body);
                                      onRefresh();
                                    },
                                  ),
                                ),
                              );
                            });
                      },
                      icon: const Icon(Icons.edit)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Seat Number',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        node != null
                            ? node['seatnumber'] != null
                                ? node['seatnumber']
                                : ''
                            : '',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        node != null
                            ? node['selecteddate'] != null
                                ? node['selecteddate']
                                : '21/12/2021'
                            : '21/12/2021',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Timing',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        node != null
                            ? node['fromtime'] != null && node['totime'] != null
                                ? node['fromtime'] + ' - ' + node['totime']
                                : '11 - 4 pm'
                            : '11 - 4 pm',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        node != null
                            ? node['status'] != null
                                ? node['status']
                                : ''
                            : '',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Floor',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        node != null
                            ? node['floor'] != null
                                ? node['floor']
                                : ''
                            : '',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showWarning)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'Note : ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.kRed,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Booked Table will be cancelled if the Table is not occupied within 15 minutes',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.kRed,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
