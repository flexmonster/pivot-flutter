import 'package:flutter/material.dart';
import 'package:flutter_flexmonster/flutter_flexmonster.dart';
import 'package:pivot_flutter/uielements/Log.dart';

final List<String> _eventListWithData = [
  "aftergriddraw",
  "beforegriddraw",
  "cellclick",
  "chartclick",
  "celldoubleclick",
  "datachanged",
  "dataerror",
  "drillthroughopen",
  "filteropen",
  "queryerror",
  "olapstructureerror",
];

final List<String> _eventListWithoutData = [
  "afterchartdraw",
  "datafilecancelled",
  "dataloaded",
  "drillthroughclose",
  "exportcomplete",
  "exportstart",
  "fieldslistclose",
  "fieldslistopen",
  "filterclose",
  "loadingdata",
  "loadinglocalization",
  "loadingolapstructure",
  "loadingreportfile",
  "localizationerror",
  "localizationloaded",
  "olapstructureloaded",
  "openingreportfile",
  "querycomplete",
  "ready",
  "reportchange",
  "reportcomplete",
  "reportfilecancelled",
  "reportfileerror",
  "runningquery",
  "update"
];

class UsingEvents extends StatefulWidget {
  const UsingEvents({super.key});

  @override
  State<UsingEvents> createState() => _UsingEventsState();
}

class _UsingEventsState extends State<UsingEvents> {
  Widget _lastLog = const Log(
    eventName: "...",
  );

  @override
  Widget build(BuildContext context) {
    Flexmonster pivot = Flexmonster(
        height: "500",
        width: "100%",
        toolbar: true,
        report: "https://cdn.flexmonster.com/github/demo-report.json");

    for (String event in _eventListWithoutData) {
      pivot.on(event, () {
        setState(() {
          _lastLog = Log(eventName: event);
        });
      });
    }
    for (String event in _eventListWithData) {
      pivot.on(event, (data) {
        setState(() {
          _lastLog = Log(eventName: event);
        });
      });
    }
    return Column(children: [
      SizedBox(height: 500, child: pivot),
      Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Container(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(17)),
              child: _lastLog))
    ]);
  }
}
