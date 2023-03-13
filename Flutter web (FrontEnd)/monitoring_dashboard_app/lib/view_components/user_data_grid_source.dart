import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../model/user.dart';
import 'package:intl/intl.dart';

class UserDataGridSource extends DataGridSource {
  UserDataGridSource(this.userList) {
    buildDataGridRow();
  }
   List<DataGridRow> dataGridRows =[];
   List<User> userList =[];

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
     Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[4].value.toStringAsFixed(1),
            overflow: TextOverflow.ellipsis,
          )),
      Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[5].value.toStringAsFixed(1),
            overflow: TextOverflow.ellipsis,
          )),
          Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row.getCells()[6].value.toStringAsFixed(1),
                overflow: TextOverflow.ellipsis,
              )),

      // Container(
      //  alignment: Alignment.centerRight,
      //  padding: const EdgeInsets.all(8.0),
      //  child: Text(
      //    DateFormat('MM/dd/yyyy').format(row.getCells()[3].value).toString(),
      //    overflow: TextOverflow.ellipsis,
      //  ),
      //),
    ]);
  }

  @override
  Future<void> handleRefresh() async {
    await Future.delayed(const Duration(seconds: 5));
    buildDataGridRow();
    notifyListeners();
  }


  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = userList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'carnetID', value: dataGridRow.carnetID),
        DataGridCell<String>(
            columnName: 'name', value: dataGridRow.name),
        DataGridCell<String>(
            columnName: 'address', value: dataGridRow.address),
        DataGridCell<String>(
            columnName: 'metroType', value: dataGridRow.metroType),
        DataGridCell<double>(
            columnName: 'lecture', value: dataGridRow.lecture),
        DataGridCell<double>(
            columnName: 'consume', value: dataGridRow.consume),
        DataGridCell<double>(
            columnName: 'toPay', value: dataGridRow.toPay),
      ]);
    }).toList(growable: false);
  }
}
