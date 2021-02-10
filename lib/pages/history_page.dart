import 'package:factura/providers/organizationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  OrgProvider infoReg = new OrgProvider();

  TableDataSource _dataSource = TableDataSource();
  int _defalutRowPageCount = 8;
  int _sortColumnIndex;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Historial'), primary: true),
        // Wrap the outer layer with ListView
        body: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                // infoReg.cargarReg();
              },
              child: Text('Cargar'),
            ),
            // PaginatedDataTable
            PaginatedDataTable(
              // Table data source
              source: _dataSource,
              // default is 0
              initialFirstRowIndex: 0,
              // select all operation
              onSelectAll: (bool checked) {
                _dataSource.selectAll(checked);
              },
              // The number of rows displayed per page
              rowsPerPage: _defalutRowPageCount,
              // Callback after the number of displays per page has changed
              onRowsPerPageChanged: (value) {
                setState(() {
                  _defalutRowPageCount = value;
                });
              },
              // Set the row value list options that can be displayed on each page
              availableRowsPerPage: [5, 8],
              // Page turning operation callback
              onPageChanged: (value) {
                print('$value');
              },
              // Whether to sort in ascending order
              sortAscending: _sortAscending,
              sortColumnIndex: _sortColumnIndex,
              // table header
              header: Text('Facturas'),
              // column
              columns: <DataColumn>[
                DataColumn(label: Text('Folio')),
                DataColumn(label: Text('Receptor')),
                DataColumn(
                    label: Text('Monto'),
                    // Add sort operation
                    onSort: (int columnIndex, bool ascending) {
                      _sort<num>(
                          (RowHistory p) => p.monto, columnIndex, ascending);
                    }),
                DataColumn(
                    label: Text('Fecha'),
                    onSort: (int columnIndex, bool ascending) {
                      _sort<num>(
                          (RowHistory p) => int.parse(
                              p.fecha.microsecondsSinceEpoch.toString()),
                          columnIndex,
                          ascending);
                    }),
              ],
            ),
          ],
        ));
  }

  //Sort association _sortColumnIndex,_sortAscending
  void _sort<T>(Comparable<T> getField(RowHistory s), int index, bool b) {
    _dataSource._sort(getField, b);
    setState(() {
      this._sortColumnIndex = index;
      this._sortAscending = b;
    });
  }
}

class RowHistory {
  final String folio;
  final String receptor;
  final int monto;
  final DateTime fecha;

  // The default is not selected
  bool selected = false;
  RowHistory(this.folio, this.receptor, this.monto, this.fecha);
}

class TableDataSource extends DataTableSource {
  final List<RowHistory> rowsHistory = <RowHistory>[
    RowHistory('1000', 'Kis', 110, DateTime.parse('20200301')),
    RowHistory('1001', 'Cencosud', 130, DateTime.parse('20201201')),
    RowHistory('1002', 'Unimarc', 140, DateTime.parse('20201001')),
    RowHistory('1004', 'Peugeot', 100, DateTime.parse('20201101')),
    RowHistory('1005', 'Adidas', 190, DateTime.parse('20201111')),
    RowHistory('1006', 'Coca cola', 400, DateTime.parse('20200406')),
    RowHistory('1007', 'Toyota', 500, DateTime.parse('20200411')),
    RowHistory('1008', 'Jeep', 230, DateTime.parse('20200612')),
    RowHistory('1009', 'Fiat', 730, DateTime.parse('20200716')),
    RowHistory('1010', 'Ferrari', 130, DateTime.parse('20200501')),
    RowHistory('1011', 'BMW', 101, DateTime.parse('20200301')),
    RowHistory('1012', 'Nescafé', 140, DateTime.parse('20200201')),
  ];
  int _selectedCount = 0;

  ///Get content line according to location
  @override
  DataRow getRow(int index) {
    RowHistory rowHistory = rowsHistory.elementAt(index);
    return DataRow.byIndex(
        cells: <DataCell>[
          DataCell(
            Text('${rowHistory.folio}'),
            placeholder: true,
          ),
          DataCell(
            Text('${rowHistory.receptor}'),
            placeholder: true,
          ),
          DataCell(Text('${rowHistory.monto}'), showEditIcon: true),
          DataCell(Text('${rowHistory.fecha}'), showEditIcon: false),
        ],
        selected: rowHistory.selected,
        index: index,
        onSelectChanged: (bool isSelected) {
          if (rowHistory.selected != isSelected) {
            _selectedCount += isSelected ? 1 : -1;
            rowHistory.selected = isSelected;
            notifyListeners();
          }
        });
  }

  @override

  ///Is the number of rows uncertain?
  bool get isRowCountApproximate => false;

  @override

  ///Rows
  int get rowCount => rowsHistory.length;

  @override

  ///Number of selected rows
  int get selectedRowCount => _selectedCount;

  void selectAll(bool checked) {
    for (RowHistory rowHistory in rowsHistory) {
      rowHistory.selected = checked;
    }
    _selectedCount = checked ? rowsHistory.length : 0;
    notifyListeners();
  }

  //Sort,
  void _sort<T>(Comparable<T> getField(RowHistory rowHistory), bool b) {
    rowsHistory.sort((RowHistory s1, RowHistory s2) {
      if (!b) {
        //Two items are exchanged
        final RowHistory temp = s1;
        s1 = s2;
        s2 = temp;
      }
      final Comparable<T> s1Value = getField(s1);
      final Comparable<T> s2Value = getField(s2);
      return Comparable.compare(s1Value, s2Value);
    });
    notifyListeners();
  }
}

void onTap() {
  print('data onTap');
}
