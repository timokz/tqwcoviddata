import 'dart:html';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'guest.dart';
import 'guest_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Alignment, Column, Row;

class GetGuestData extends StatefulWidget {
  const GetGuestData({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GetGuestDataState();
}

class _GetGuestDataState extends State<GetGuestData> {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  Widget build(BuildContext context) {
    final guestRef = FirebaseFirestore.instance
        .collection('guests')
        .withConverter<Guest>(
          fromFirestore: (snapshots, _) => Guest.fromJson(snapshots.data()!),
          toFirestore: (guest, _) => guest.toJson(),
        );

    //checks if any Guest entries are older than 28 days, and removes them from the DB
    void guestDataTimeCheck() {
      DateTime cut = DateTime.now().subtract(const Duration(days: 28));
      Timestamp cutoff = Timestamp.fromDate(cut);

      FirebaseFirestore.instance
          .collection('guests')
          .where('entryTime', isLessThanOrEqualTo: cutoff)
          .get()
          .then((QuerySnapshot query) {
        for (DocumentSnapshot doc in query.docs) {
          Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
          DateTime dt = (map['entryTime'] ??= Timestamp.now()).toDate();
          // print(map['n_name'] + "  " + dt.toString());
          FirebaseFirestore.instance.collection('guests').doc(doc.id).delete();
        }
      });
    }

    GuestDataSource gdc(List<Guest> guestList) {
      return GuestDataSource(guests: guestList);
    }

    return StreamBuilder<QuerySnapshot<Guest>>(
        stream: guestRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;

          List<Guest> guestList = [];
          for (var g in data.docs) {
            guestList.add(g.data() as Guest);
          }
          guestDataTimeCheck();

          List<ExcelDataRow> _buildReportDataRows() {
            List<ExcelDataRow> excelDataRows = <ExcelDataRow>[];

            excelDataRows = guestList.map<ExcelDataRow>((Guest e) {
              return ExcelDataRow(cells: <ExcelDataCell>[
                ExcelDataCell(columnHeader: 'name', value: e.nName),
                ExcelDataCell(columnHeader: 'name', value: e.vName),
                ExcelDataCell(columnHeader: 'location', value: e.location),
                ExcelDataCell(
                    columnHeader: 'Entry Time',
                    value:
                        DateFormat('yyyy-MM-dd – kk:mm').format(e.entryTime)),
                ExcelDataCell(columnHeader: 'email', value: e.email),
                ExcelDataCell(columnHeader: 'phone', value: e.phone),
              ]);
            }).toList();

            return excelDataRows;
          }

          Future<void> exportDataGridToExcel() async {
            //  final Workbook workbook = _key.currentState!.exportToExcelWorkbook();

            //  final List<int> bytes = workbook.saveAsStream();
            // File('DataGrid.xlsx').writeAsBytes(bytes, flush: true);
            final Workbook workbook = Workbook();
            final Worksheet sheet = workbook.worksheets[0];
            sheet.importList(guestList, 1, 1, true);
            final List<ExcelDataRow> dataRows = _buildReportDataRows();
            sheet.importData(dataRows, 1, 1);
            final List<int> bytes = workbook.saveAsStream();
            workbook.dispose();

            AnchorElement(
                href:
                    "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
              ..setAttribute("download", "GuestData.xlsx")
              ..click();
          }

          return Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                title: Text(
                    "Derzeitige Anmeldungen: " + guestList.length.toString()),
                backgroundColor: Colors.black,
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.download_rounded),
                      onPressed: () => exportDataGridToExcel()),
                ],
              ),
              body: SfDataGrid(
                key: _key,
                source: gdc(guestList),
                columnWidthMode: ColumnWidthMode.fill,
                allowSorting: true,
                //  allowMultiColumnSorting: true,
                columns: <GridColumn>[
                  GridColumn(
                      columnName: 'vName',
                      label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.centerLeft,
                        child: const Text("Vorname"),
                      )),
                  GridColumn(
                      columnName: 'nName',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: const Text("Vorname"))),
                  GridColumn(
                      columnName: 'location',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: const Text("Ort"))),
                  GridColumn(
                      columnName: 'entryTime',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: const Text("Zeit"))),
                  GridColumn(
                      columnName: 'email',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: const Text("Email"))),
                  GridColumn(
                      columnName: 'phone',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          alignment: Alignment.centerLeft,
                          child: const Text("TEL"))),
                ],
              ));
        });
  }
}
