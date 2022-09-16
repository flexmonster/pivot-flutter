// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_flexmonster/flutter_flexmonster.dart';

void main() => runApp(MaterialApp(home: WebViewExample()));

class WebViewExample extends StatefulWidget {
  const WebViewExample({Key? key}) : super(key: key);

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    //This Flexmonster object should be passed to the "body"
    Flexmonster pivot = Flexmonster(
      height: "1500",
      width: "100%",
      toolbar: true,
      report: const {
        'dataSource': {
          'filename':
              "https://www.flexmonster.com/fm_uploads/2021/05/sales_data_to_format.csv",
          'mapping': {
            "Region": {'hierarchy': "Geography"},
            "State": {'parent': "Region", 'hierarchy': "Geography"},
            "City": {'parent': "State", 'hierarchy': "Geography"}
          }
        },
        'slice': {
          'rows': [
            {'uniqueName': "Geography"}
          ],
          'columns': [
            {'uniqueName': "Category"},
            {'uniqueName': "[Measures]"}
          ],
          'measures': [
            {"uniqueName": "Revenue", "aggregation": "sum"}
          ]
        }
      },
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 223, 56, 0),
          foregroundColor: Color.fromARGB(255, 233, 233, 233),
          title: const Text('Flutter Flexmonster'),
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
          actions: <Widget>[
            //Pass the Flexmonster object to have access to WebViewController and perform API calls
            NavigationControls(pivot),
          ],
        ),
        body: pivot);
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this.pivot, {Key? key}) : super(key: key);

  final Flexmonster pivot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.api,
            color: Color.fromARGB(255, 233, 233, 233),
          ),
          onPressed: () async {
            await pivot.showCharts();
            //pivot.off('afterchartdraw');
          },
        ),
      ],
    );
  }
}
