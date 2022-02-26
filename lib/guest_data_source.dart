import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:tqwcoviddata/guest.dart';

class GuestDataSource extends DataGridSource {
  GuestDataSource({required List<Guest> guests}) {
    _guests = guests
        .map<DataGridRow>(
          (g) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'name', value: g.nName),
              DataGridCell<String>(columnName: 'name', value: g.vName),
              DataGridCell<String>(columnName: 'location', value: g.location),
              DataGridCell<String>(
                columnName: 'Entry Date',
                value: DateFormat('yyyy-MM-dd').format(g.entryTime),
              ),
              DataGridCell<String>(
                columnName: 'Entry Time',
                value: DateFormat('kk:mm').format(g.entryTime),
              ),
              DataGridCell<String>(columnName: 'email', value: g.email),
              DataGridCell<String>(columnName: 'phone', value: g.phone),
            ],
          ),
        )
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
          padding: const EdgeInsets.all(16),
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}
