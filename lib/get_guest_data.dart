import 'dart:convert';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Alignment, Column, Row;
import 'package:tqwcoviddata/guest.dart';
import 'package:tqwcoviddata/guest_data_source.dart';

///Logger
final logger = Logger();

///[GetGuestData]
///API to retrieve Guest data from firebase and display it,
///export it
class GetGuestData extends StatefulWidget {
  ///ctor
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

    ///Function to comply with GDPR, instead of DB-sided job
    ///checks if any Guest entries are older than 28 days
    ///and removes them from the DB
    void guestDataTimeCheck() {
      final cut = DateTime.now().subtract(const Duration(days: 28));
      final cutoff = Timestamp.fromDate(cut);

      FirebaseFirestore.instance
          .collection('guests')
          .where('entryTime', isLessThanOrEqualTo: cutoff)
          .get()
          .then((QuerySnapshot query) {
        for (final DocumentSnapshot doc in query.docs) {
          final map = doc.data()! as Map<String, dynamic>;
          final dt = (map['entryTime'] ??= Timestamp.now()).toDate() as DateTime;
          logger.log(Level.info, dt.toString());
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

          final guestList = <Guest>[];
          for (final g in data.docs) {
            guestList.add(g.data()! as Guest);
          }
          guestDataTimeCheck();

          List<ExcelDataRow> _buildReportDataRows() {
            return guestList.map<ExcelDataRow>((Guest e) {
              return ExcelDataRow(cells: <ExcelDataCell>[
                ExcelDataCell(columnHeader: 'name', value: e.nName),
                ExcelDataCell(columnHeader: 'name', value: e.vName),
                ExcelDataCell(columnHeader: 'location', value: e.location),
                ExcelDataCell(
                    columnHeader: 'Entry Time',
                    value:
                        DateFormat('yyyy-MM-dd – kk:mm').format(e.entryTime),),
                ExcelDataCell(columnHeader: 'email', value: e.email),
                ExcelDataCell(columnHeader: 'phone', value: e.phone),
              ],);
            }).toList();

          }

          ///Exports all guests as .xlsx
          Future<void> exportDataGridToExcel() async {
            final workbook = Workbook();
            final dataRows = _buildReportDataRows();

            final sheet = workbook.worksheets[0]
                ..importList(guestList, 1, 1, true)
                ..importData(dataRows, 1, 1);

            final bytes = workbook.saveAsStream();
            workbook.dispose();

            AnchorElement(
                href:
                    'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}',)
              ..setAttribute('download', 'GuestData.xlsx')
              ..click();
          }

          return Scaffold(
              backgroundColor: const Color(0xffffffff),
              appBar: AppBar(
                title: Text(
                    'Derzeitige Anmeldungen: ${guestList.length}',),
                backgroundColor: Colors.black,
                actions: <Widget>[
                  IconButton(
                      icon: const Icon(Icons.download_rounded),
                      onPressed: exportDataGridToExcel,),
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
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.centerLeft,
                        child: const Text('Vorname'),
                      ),),
                  GridColumn(
                      columnName: 'nName',
                      label: Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          child: const Text('Vorname'),),),
                  GridColumn(
                      columnName: 'location',
                      label: Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          child: const Text('Ort'),),),
                  GridColumn(
                      columnName: 'entryTime',
                      label: Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          child: const Text('Zeit'),),),
                  GridColumn(
                      columnName: 'email',
                      label: Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          child: const Text('Email'),),),
                  GridColumn(
                      columnName: 'phone',
                      label: Container(
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          child: const Text('TEL'),),),
                ],
              ),);
        },);
  }
}