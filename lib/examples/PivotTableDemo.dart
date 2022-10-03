import 'package:flutter/material.dart';
import 'package:flutter_flexmonster/flutter_flexmonster.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PivotTableDemo extends StatefulWidget {
  const PivotTableDemo({super.key});

  @override
  State<PivotTableDemo> createState() => _PivotTableDemoState();
}

class _PivotTableDemoState extends State<PivotTableDemo> {
  Flexmonster pivot =
      Flexmonster(width: "100%", height: "500", toolbar: true, report: const {
    "dataSource": {
      "type": "json",
      "filename": "https://cdn.flexmonster.com/data/retail-data.json",
      "mapping": {
        "Quantity": {"type": "number"},
        "Price": {"type": "number"},
        "Retail Category": {"type": "string"},
        "Sales": {"type": "number"},
        "Order Date": {"type": "year/quarter/month/day"},
        "Date": {"type": "date"},
        "Status": {"type": "string"},
        "Product Code": {"type": "string"},
        "Phone": {"type": "string"},
        "Country": {"type": "string", "folder": "Location"},
        "City": {"type": "string", "folder": "Location"},
        "CurrencyID": {"type": "property", "hierarchy": "Country"},
        "Contact Last Name": {"type": "string"},
        "Contact First Name": {"type": "string"},
        "Deal Size": {"type": "string"}
      }
    },
    "slice": {
      "rows": [
        {
          "uniqueName": "Country",
          "filter": {
            "members": [
              "country.[australia]",
              "country.[usa]",
              "country.[japan]"
            ]
          }
        },
        {
          "uniqueName": "Status",
        }
      ],
      "columns": [
        {"uniqueName": "Order Date"},
        {"uniqueName": "[Measures]"}
      ],
      "measures": [
        {
          "uniqueName": "Price",
          "aggregation": "sum",
          "format": "-13w0a1w1c23j00"
        }
      ],
      "sorting": {
        "column": {
          "type": "desc",
          "tuple": [],
          "measure": {"uniqueName": "Price", "aggregation": "sum"}
        }
      },
      "expands": {
        "rows": [
          {
            "tuple": ["country.[japan]"]
          }
        ]
      },
      "drills": {
        "columns": [
          {
            "tuple": ["order date.[2019]"]
          }
        ]
      },
      "flatSort": [
        {"uniqueName": "Price", "sort": "desc"}
      ]
    },
    "conditions": [
      {
        "formula": "#value > 35000",
        "measure": "Price",
        "aggregation": "sum",
        "format": {
          "backgroundColor": "#00A45A",
          "color": "#FFFFFF",
          "fontFamily": "Arial",
          "fontSize": "12px"
        }
      },
      {
        "formula": "#value < 2000",
        "measure": "Price",
        "aggregation": "sum",
        "format": {
          "backgroundColor": "#df3800",
          "color": "#FFFFFF",
          "fontFamily": "Arial",
          "fontSize": "12px"
        }
      }
    ],
    "formats": [
      {
        "name": "-13w0a1w1c23j00",
        "thousandsSeparator": " ",
        "decimalSeparator": ".",
        "decimalPlaces": 0,
        "currencySymbol": "\$",
        "positiveCurrencyFormat": "\$1",
        "nullValue": "-",
        "textAlign": "right",
        "isPercent": false
      }
    ]
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      WebViewController controller = await pivot.controller.future;
      pivot.on("reportcomplete", () async {
        await controller.runJavascript('''
        flexmonster.customizeCell(customizeCellFunction);
        function customizeCellFunction(cell, data) {
              if (data.type == "header" && data.hierarchy && data.hierarchy.caption == "Country" && data.member && data.member.properties) {
                const name = data.member.properties.CurrencyID;
                cell.addClass('fm-custom-cell');
                let flag;
          let style = `<style type="text/css">
          .fm-custom-cell .flag-icon {
            width: 21px !important;
            height: 16px !important;
            margin-left: 0 !important;
            margin-right: 2px !important;
          }
          </style>`;
                if (data.expanded) {
                  flag = `\${style}<i class="fm-icon fm-expanded-icon" title="Click to collapse"></i><img class="flag-icon" src="https://cdn.flexmonster.com/flags/\${name.toLowerCase()}.svg">`;
                } else {
                  flag = `\${style}<i class="fm-icon fm-collapsed-icon" title="Click to expand"></i>
            <img class="flag-icon" src="https://cdn.flexmonster.com/flags/\${name.toLowerCase()}.svg">`;
                }
              cell.text = `\${style}<div style="display:flex; align-items:center; font-size:12px; position:relative;">\${flag}<span style="margin-left: 2px; line-height: 16px;">\${data.member.caption}</span></div>`;
              }
        }''');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [SizedBox(height: 500, child: pivot)]);
  }
}
