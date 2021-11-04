import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'guest.dart';
import 'package:intl/intl.dart';

class GuestDataSource extends DataGridSource {
  GuestDataSource({required List<Guest> guests}) {
    _guests = guests
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'name', value: e.nName),
              DataGridCell<String>(columnName: 'name', value: e.vName),
              DataGridCell<String>(columnName: 'location', value: e.location ),
              DataGridCell<String>(
                  columnName: 'Entry Time',
                  value: DateFormat('yyyy-MM-dd – kk:mm').format(e.entryTime)),
              DataGridCell<String>(columnName: 'email', value: e.email),
              DataGridCell<String>(columnName: 'phone', value: e.phone),
            ]))
        .toList();
  }
  List<DataGridRow> _guests = [];

  @override
  List<DataGridRow> get rows => _guests;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}