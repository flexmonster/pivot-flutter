import 'package:flutter/material.dart';
import 'package:flutter_flexmonster/flutter_flexmonster.dart';

class UsingApiCalls extends StatelessWidget {
  const UsingApiCalls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Flexmonster pivot = Flexmonster(
        height: "500",
        width: "100%",
        toolbar: true,
        report: "https://cdn.flexmonster.com/github/demo-report.json");

    return Column(
      children: [
        Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              label: const Text('Show Piechart'),
              backgroundColor: const Color.fromARGB(255, 223, 56, 0),
              icon: const Icon(
                Icons.pie_chart,
                size: 24.0,
                color: Color.fromARGB(255, 233, 233, 233),
              ),
              onPressed: () {
                pivot.showCharts("pie");
              },
            ),
            FloatingActionButton.extended(
              label: const Text('Show Grid'),
              backgroundColor: const Color.fromARGB(255, 223, 56, 0),
              icon: const Icon(
                Icons.table_chart_outlined,
                size: 24.0,
                color: Color.fromARGB(255, 233, 233, 233),
              ),
              onPressed: () {
                pivot.showGrid();
              },
            ),
          ],
        )),
        SizedBox(height: 500, child: pivot),
      ],
    );
  }
}
