import 'package:flutter/material.dart';
import 'package:power_consumption_analyzer_frontend/power_socket/power_socket_manager.dart';
import 'package:power_consumption_analyzer_frontend/user_request_handler.dart';

class StatsPage extends StatefulWidget {
  StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  String totalConsumption = '0.00';
  String totalBill = '0.00';

  @override
  void initState() {
    super.initState();
    startTimeController.text = '2010-01-01 00:00:00';
    endTimeController.text = '2030-01-01 00:00:00';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '總電量',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$totalConsumption kWh',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '總電費',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$totalBill NT',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: startTimeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '起始時間',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: endTimeController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '結束時間',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  startTimeController.text = '2000-01-01 00:00:00';
                  endTimeController.text =
                      '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}';
                },
                child: Text('現在時間'),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  startTimeController.text = '2023-05-30 19:46:03';
                  endTimeController.text = '2023-05-30 19:48:03';
                },
                child: Text('test'),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (UserRequestHandler.I.userId == null) {
                    return;
                  }
                  String userId = UserRequestHandler.I.userId;
                  String startTime = startTimeController.text;
                  String endTime = endTimeController.text;
                  String consumption =
                      await PowerSocketManager.I.getTotalConsumptionBetweenTime(
                    userId: userId,
                    startTime: startTime,
                    endTime: endTime,
                  );
                  String bill =
                      await PowerSocketManager.I.getTotalBillBetweenTime(
                    userId: userId,
                    startTime: startTime,
                    endTime: endTime,
                  );
                  setState(() {
                    totalConsumption = consumption;
                    totalBill = bill;
                  });
                },
                child: Text('查詢'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
