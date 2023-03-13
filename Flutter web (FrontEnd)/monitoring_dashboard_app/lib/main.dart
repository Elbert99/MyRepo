import 'view_components/save_file_web_pdf.dart' as helper;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:open_file/open_file.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:monitoring_dashboard_app/model/user.dart';
import 'package:monitoring_dashboard_app/view_components/user_data_grid_source.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'dart:convert';
import 'model/user.dart';
import 'dart:core';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page', key: null,),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  late String _id = "99121407960";
  final _textFieldController = TextEditingController();

  late UserDataGridSource _userGridSource;
  List<User> _users = [];
  List<User> _usersByCI = [];
  List<User> _usersByCIElectricMetroType = [];
  List<User> _usersByCIWaterMetroType = [];
  List<User> _usersByCIGasMetroType = [];

  final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
  final GlobalKey<SfCartesianChartState> _cartesianChartKey = GlobalKey<SfCartesianChartState>();
  final GlobalKey<SfCartesianChartState> _cartesianChart2Key = GlobalKey<SfCartesianChartState>();

  late TooltipBehavior _tooltipBehavior;
  late TooltipBehavior _tooltipBehavior2;
  late ZoomPanBehavior _zoomPanBehavior;

  bool _flag = false;
  bool _flag1 = false;
  bool _showAll = false;
  bool _showSecondChart = false;
  bool _serverError = false;
 // bool _isSearching = false;

  late Map<String, double> columnWidths = {
    'carnetID': double.nan,
    'name': double.nan,
    'address': double.nan,
    'metroType': double.nan,
    'lecture': double.nan,
    'consume': double.nan,
    'toPay': double.nan
  };

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior2 = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
        enablePinching: true,
        enableDoubleTapZooming: true,
        enableSelectionZooming: true,
        selectionRectBorderColor: Colors.red,
        selectionRectBorderWidth: 2,
        selectionRectColor: Colors.grey,
        enablePanning: true,
        enableMouseWheelZooming: true,
        maximumZoomLevel: 0.7,
    );
        super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight:80,
            title:  const Center(child: Text("Dashboard para el monitoreo de datos", textAlign: TextAlign.center)),
            leading: IconButton(
              icon: const Icon(Icons.person_search),
              onPressed: () {
               },
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
                //topLeft: Radius.circular(25),
                //topRight: Radius.circular(25),
              )
            ),
            actions:  <Widget>[
              IconButton(
                icon: const Icon(Icons.dashboard),
                onPressed: () { },

              ),
            ],
          ),
          body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: <Widget>[
                     _buildSearchTextField(),
                     _buildRowToShowButtons(),
                     const SizedBox(height: 20.0),
                     _buildChart(),
                     const SizedBox(height: 20.0),
                     _buildSecondChart(),
                     const SizedBox(height: 20.0),
                     _buildDataGrid(),
           ],
      ),
   ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(_users.isNotEmpty) {
                _buildShowDialog1();
              }setState(() { });
            },
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.refresh),
          ),
  )
 );
 }

  Future _buildShowDialog1(){
    return  showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Comprobación de datos'),
            content: const Text('Ya los datos han sido cargados.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); //close Dialog
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        });
  }

 Widget _buildDataGrid(){
    return  FutureBuilder(
      future: generateUserList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? SfDataGridTheme(
          data: SfDataGridThemeData(
            headerColor:  Colors.deepPurple,
            gridLineColor: Colors.deepPurple,
            gridLineStrokeWidth: 3.0,
          ),
          child:SfDataGrid(
            key: key,
            allowPullToRefresh: true,
            refreshIndicatorStrokeWidth: 3.0,
            refreshIndicatorDisplacement: 60.0,
            allowColumnsResizing: true,
            source: _userGridSource,
            columns: getColumns(),
            //columnWidthMode: ColumnWidthMode.fill,
            isScrollbarAlwaysShown: true,
            //gridLinesVisibility: GridLinesVisibility.both,
            //headerGridLinesVisibility: GridLinesVisibility.both,
            allowSorting: true,
            onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
              setState(() {columnWidths[details.column.columnName] = details.width; });
              return true;},
          ),)
            :  _buildCircularProgressIndicatorToNoData();
      },
    );
 }


  Widget _buildCircularProgressIndicatorToNoData(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:  <Widget>[
       const Center( child: CircularProgressIndicator(strokeWidth: 3,),),
       const SizedBox(height: 20.0),
       const Center( child: Text("No hay datos que cargar presiona el botón Ayuda para obtener más información"),),
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
          _buildShowDialog();
         }, child: const Text("Ayuda"),
        ),
      ],
    );
  }
  Future _buildShowDialog(){
    return  showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error al cargar la fuente de datos'),
            content: const Text('Si desea visualizar los datos en la tabla por favor inicie el servidor o insértele datos.\nSi el servidor ya fue iniciado y restaurado presione el botón de refrescar en la esquina inferior derecha.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); //close Dialog
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        });
  }

// return Scaffold(
//    body: Container(
//     padding: const EdgeInsets.all(20.0),
//      child: Form(
//        child:SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Row(
//           children: <Widget>[
//             _buildElectricityChart()
//           ],
//         ),
//       ),
//     ),
//   )
//);

  Future<UserDataGridSource> getUserDataSource() async {
    var userList = await generateUserList();
    var data = UserDataGridSource(userList);
    return data;
  }

  Future generateUserList() async {
    List<User> usersToReturn = [];
    String _electricType = "Electricidad";
    String _waterType = "Agua";
    String _gasType = "Gas";

    if(_flag ==false) {
      //final httpUri = Uri.http('127.0.0.1:8000', 'api/users');
      //var response = await http.get(httpUri);
      var response = await http.get(Uri.parse('http://localhost:8000/api/users/'));
      var decodedUsers = json.decode(response.body).cast<Map<String, dynamic>>();
      _users = await decodedUsers.map<User>((json) => User.fromJson(json)).toList();
      _userGridSource = UserDataGridSource(_users);
      usersToReturn = _users;
    }
    else {
      var response = await http.get(Uri.parse('http://localhost:8000/api/users/$_id'));
      var decodedUsers = json.decode(response.body).cast<Map<String, dynamic>>();
      _usersByCI = await decodedUsers.map<User>((json) => User.fromJson(json)).toList();
      _userGridSource = UserDataGridSource(_usersByCI);
      _flag1 = true;


      var response1 = await http.get(Uri.parse('http://localhost:8000/api/users/$_id/metrocounter/$_electricType'));
      var decodedUsersMetroElectric = json.decode(response1.body).cast<Map<String, dynamic>>();
      _usersByCIElectricMetroType = await decodedUsersMetroElectric.map<User>((json) => User.fromJson(json)).toList();

      var response2 = await http.get(Uri.parse('http://localhost:8000/api/users/$_id/metrocounter/$_waterType'));
      var decodedUsersMetroWater = json.decode(response2.body).cast<Map<String, dynamic>>();
      _usersByCIWaterMetroType = await decodedUsersMetroWater.map<User>((json) => User.fromJson(json)).toList();

      var response3 = await http.get(Uri.parse('http://localhost:8000/api/users/$_id/metrocounter/$_gasType'));
      var decodedUsersMetroGas = json.decode(response3.body).cast<Map<String, dynamic>>();
      _usersByCIGasMetroType = await decodedUsersMetroGas.map<User>((json) => User.fromJson(json)).toList();

      usersToReturn =  _usersByCI;
      setState(() { });
    }
    return usersToReturn;
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridTextColumn(
          width: columnWidths['carnetID']!,
          columnName: 'carnetID',
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('Carnet',
                  overflow: TextOverflow.clip, softWrap: true, style: TextStyle(color: Colors.white))
          )
      ),
      GridTextColumn(
          width: columnWidths['name']!,
          columnName: 'name',
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('Nombre',
                  overflow: TextOverflow.clip, softWrap: true, style: TextStyle(color: Colors.white))
          )
      ),
      GridTextColumn(
          width: columnWidths['address']!,
          columnName: 'address',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('Dirección',
                  overflow: TextOverflow.clip, softWrap: true, style: TextStyle(color: Colors.white))
          )
      ),
      GridTextColumn(
          width: columnWidths['metroType']!,
          columnName: 'metroType',
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('Tipo de Metrocontador', style: TextStyle(color: Colors.white))
          )
      ),
      GridTextColumn(
          width: columnWidths['lecture']!,
          columnName: 'lecture',
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text('Lectura', style: TextStyle(color: Colors.white))
          )
      ),
      GridTextColumn(
          width: columnWidths['consume']!,
          columnName: 'consume',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('Consumo', style: TextStyle(color: Colors.white))
          )
      ),
      GridTextColumn(
          width: columnWidths['toPay']!,
          columnName: 'toPay',
          label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.center,
              child: const Text('Tarifa', style: TextStyle(color: Colors.white))
          )
      ),
    ];
  }

 Widget _buildChart(){
     if (_usersByCI.isNotEmpty) {
       _showSecondChart = true;
       return SfCartesianChart(
             key: _cartesianChartKey,
             title: ChartTitle(text: 'Consumo marcado por los metrocontadores'),
             legend: Legend(isVisible: true),
             tooltipBehavior: _tooltipBehavior,
             zoomPanBehavior: _zoomPanBehavior,
             borderColor: Colors.deepPurple,
             series: <ChartSeries>[
               StackedLineSeries<User, DateTime>(
                   name: 'Consumo de electricidad (kWh)',
                   markerSettings: const MarkerSettings(isVisible:true),
                   dataSource: _usersByCIElectricMetroType,
                   xValueMapper: (User user, _) => user.timestamp,  //mes
                   yValueMapper: (User user, _) => user.consume,
                   dataLabelSettings: const DataLabelSettings(isVisible: true),
                   enableTooltip: true,
                   color: Colors.amber,
                   width: 4
               ),
               StackedLineSeries<User, DateTime>(
                   name: 'Consumo de agua (m³)',
                   markerSettings: const MarkerSettings(isVisible:true),
                   dataSource: _usersByCIWaterMetroType,
                   xValueMapper: (User user, _) => user.timestamp,  //mes
                   yValueMapper: (User user, _) => user.consume,
                   dataLabelSettings: const DataLabelSettings(isVisible: true),
                   enableTooltip: true,
                   color: Colors.blue,
                   width: 4
               ),
               StackedLineSeries<User, DateTime>(
                   name: 'Consumo de gas (m³)',
                   markerSettings: const MarkerSettings(isVisible:true),
                   dataSource: _usersByCIGasMetroType,
                   xValueMapper: (User user, _) => user.timestamp,  //mes
                   yValueMapper: (User user, _) => user.consume,
                   dataLabelSettings: const DataLabelSettings(isVisible: true),
                   enableTooltip: true,
                   color: Colors.pink,
                   width: 4
               )
             ],
             primaryXAxis: DateTimeAxis(
               majorGridLines: const MajorGridLines(width: 0),
               edgeLabelPlacement: EdgeLabelPlacement.shift,
               interval: 3,
               dateFormat: DateFormat.yMMMMd(),
               intervalType: DateTimeIntervalType.auto,
               title: AxisTitle(text: 'Tiempo (mes/día/año)')),
             primaryYAxis: NumericAxis(
                 axisLine: const AxisLine(width: 0),
                 labelFormat: '{value} U',
                 majorTickLines: const MajorTickLines(size: 0),
                 title: AxisTitle(text: 'Consumo (U)'),
             ),
   );
     } else {
       _showSecondChart = false;
       return _buildToShow();
     }
 }

 Widget _buildSecondChart(){
    return _showSecondChart ? SfCartesianChart(
      key: _cartesianChart2Key,
      title: ChartTitle(text: 'Tarifa por consumo'),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior2,
      zoomPanBehavior: _zoomPanBehavior,
      borderColor: Colors.deepPurple,
      series: <ChartSeries>[
        StackedLineSeries<User, DateTime>(
            name: 'Tarifa de electricidad',
            markerSettings: const MarkerSettings(isVisible:true),
            dataSource: _usersByCIElectricMetroType,
            xValueMapper: (User user, _) => user.timestamp,  //mes
            yValueMapper: (User user, _) => user.toPay,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
            color: Colors.amber,
            width: 4
        ),
        StackedLineSeries<User, DateTime>(
            name: 'Tarifa de agua',
            markerSettings: const MarkerSettings(isVisible:true),
            dataSource: _usersByCIWaterMetroType,
            xValueMapper: (User user, _) => user.timestamp,  //mes
            yValueMapper: (User user, _) => user.toPay,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
            color: Colors.blue,
            width: 4
        ),
        StackedLineSeries<User, DateTime>(
            name: 'Tarifa de gas',
            markerSettings: const MarkerSettings(isVisible:true),
            dataSource: _usersByCIGasMetroType,
            xValueMapper: (User user, _) => user.timestamp,  //mes
            yValueMapper: (User user, _) => user.toPay,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
            color: Colors.pink,
            width: 4
        )
      ],
      primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 3,
          dateFormat: DateFormat.yMMMMd(),
          intervalType: DateTimeIntervalType.auto,
          title: AxisTitle(text: 'Tiempo (mes/día/año)')),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
        majorTickLines: const MajorTickLines(size: 0),
        title: AxisTitle(text: 'Tarifa (pesos)'),
      ),
    ): const Text("No es posible cargar el segundo gráfico");
 }


  Widget _buildToShow(){
    String toShow = "Realiza la búsqueda por Carnet de Identidad para visualizar el gráfico";
    if(_usersByCI.isEmpty && _flag1){
      toShow = "El usuario con carnet de identidad '$_id' que acabas de buscar no existe.\n                      Vuelva a buscar otro usuario para visualizar el gráfico.";
      _flag1 = false;
    }
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(toShow),
        ),
      ],
    );
  }

  Widget _buildSearchTextField(){
  return  Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
            key: formKey,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: <Widget>[
                    _createIDField(),
               ],
             ),
           ),
      );
}

  Widget _createIDField() {
    return TextFormField(
      inputFormatters: [_createMaskFormatter()],
      validator: (val) =>_validateID(val!),
      controller: _textFieldController,
      onSaved: (val) => _id = val!.toString(),
      autocorrect: false,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          prefixIcon: Icon( Icons.search, color: Colors.deepPurple ),
          hintText: 'Ej de C.I: 99121407960',
          labelText: 'Buscar por Carnet de Identidad',
          focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          errorBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          border:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          //border: OutlineInputBorder( borderRadius: BorderRadius.all( Radius.circular(10.0),  ),
          errorMaxLines: 1
      ),
      onTap: () {
        _submit();
      },
      //onTap: _submit(),
      //onEditingComplete: ,
    );
  }

  void _submit() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      _flag = true;
      //_flag1 = true;
      _showAll = true;
      _id = _textFieldController.text;

      //_textFieldController.clear();
      setState(() { });
    }
  }

  MaskTextInputFormatter _createMaskFormatter(){
    MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
          mask: '###########',
          filter: { "#": RegExp(r'[0-9]') },
          type: MaskAutoCompletionType.lazy
      );

    return  maskFormatter;
  }

  String? _validateID(String val) {
    String? out;
    if(val.isEmpty) {
      out = 'Por favor rellene este campo';
    } else if (val.length < 11) {
      out = 'Debe tener 11 dígitos.';
    }
    return out;
  }

  Widget _buildRowToShowButtons() {
    // ignore: deprecated_member_use
    return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
             _buildShowAllButton(),
             const SizedBox(width: 10.0),
             _buildDeleteAllByIDButton(),
             const SizedBox(width: 10.0),
             _buildExportPDFButton(),
       ],
    );
  }

  Widget _buildShowAllButton() {
    // ignore: deprecated_member_use
    return  RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      label:  const Text('Ver todos',style: TextStyle(color: Colors.white ),),
      onPressed: _showAll
          ? _getAllUsers
          : null,
      textColor: Colors.white,
      icon: const Icon(Icons.youtube_searched_for),  //
    );
  }

  void _getAllUsers(){
    _textFieldController.clear();
    _showAll = false;
    setState(() { _usersByCI.clear(); _flag = false; });
  }

  Widget _buildDeleteAllByIDButton() {
    // ignore: deprecated_member_use
    return  RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      label:  const Text('Eliminar',style: TextStyle(color: Colors.white ),),
      onPressed: _showAll && _usersByCI.isNotEmpty
          ? _buildShowDialogConfirmDeleted
          : null,
      textColor: Colors.white,
      icon: const Icon(Icons.person_off),  //
    );
  }

  Future _buildShowDialogConfirmDeleted(){
    return  showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirmación de operación'),
            content: Text("Usted desea eliminar completamente del sistema al usuario con el carnet de identidad '$_id'\n"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _deleteAllUsersByID();
                  Navigator.pop(context);
                 _buildShowDialogConfirmedDeleted();
                 //close Dialog
                },
                child: const Text('Aceptar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); //close Dialog
                },
                child: const Text('Cancelar'),
              ),
            ],
          );
        });
  }

  Future _buildShowDialogConfirmedDeleted(){
    return  showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Operación realizada con éxito'),
            content: Text("El usuario con carnet de identidad '$_id' ha sido eliminado completamente del sistema.\nEs por ello que la tabla está vacía. Para visualizar los restantes usuarios presione el botón Ver todos"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); //close Dialog
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        });
  }

  void _deleteAllUsersByID() async {
      var response = await http.delete(Uri.parse('http://localhost:8000/api/users/$_id'));
      _usersByCI.clear();
      _userGridSource = UserDataGridSource(_usersByCI);
  }

  Widget _buildExportPDFButton(){
    // ignore: deprecated_member_use
    return  RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      label:  const Text('Exportar a PDF',style: TextStyle(color: Colors.white ),),
      onPressed: _createPDF,
      textColor: Colors.white,
      icon: const Icon(Icons.exit_to_app),  //
    );
  }
    Future<void> _createPDF() async{
    String title = '';
    if(_flag) {
      title = 'Registros de usuario con el carnet ''$_id';
      }else {
      title = 'Listado de usuarios del sistema';
    }
      //final List<int> imageBytes = await _readImageData();
      //final PdfBitmap bitmap = PdfBitmap(imageBytes);
      //final List<int> image2Bytes = await _readImage2Data();
      //final PdfBitmap bitmap2 = PdfBitmap(image2Bytes);

      final PdfDocument document = key.currentState!.exportToPdfDocument(
        fitAllColumnsInOnePage: true,
         headerFooterExport: (DataGridPdfHeaderFooterExportDetails headerFooterExport) {
        final double width = headerFooterExport.pdfPage.getClientSize().width;
        final PdfPageTemplateElement header = PdfPageTemplateElement(Rect.fromLTWH(0, 0, width, 65));
        header.graphics.drawString(
          title,
          PdfStandardFont(PdfFontFamily.helvetica, 13, style: PdfFontStyle.bold),
          bounds: const Rect.fromLTWH(0, 25, 200, 60),
        );
        headerFooterExport.pdfDocumentTemplate.top = header;
      },
      cellExport: (details) {
      if (details.cellType == DataGridExportCellType.columnHeader) {
        details.pdfCell.style.backgroundBrush = PdfBrushes.pink;
      }
      if (details.cellType == DataGridExportCellType.row) {
        details.pdfCell.style.backgroundBrush = PdfBrushes.lightCyan;
      }
    },
    );
    //document.pageSettings.size = Size(bitmap.width.toDouble(), bitmap.height.toDouble());
    //final PdfPage page = document.pages.add();
    //final Size pageSize = page.getClientSize();
    //page.graphics.drawImage( bitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));

    //document.pageSettings.size = Size(bitmap2.width.toDouble(), bitmap2.height.toDouble());
    //final PdfPage page2 = document.pages.add();
    //final Size pageSize2 = page2.getClientSize();
    //page2.graphics.drawImage( bitmap2, Rect.fromLTWH(0, 0, pageSize2.width, pageSize2.height));

      final List<int> bytes = document.save();
      if(_flag) {
        await helper.saveAndLaunchFile(bytes, 'Registros_del_usuario_CI .pdf');
      }else {
        await helper.saveAndLaunchFile(bytes, 'Listado_de_usuarios.pdf');
      }

      document.dispose();
    }

  Future<List<int>> _readImageData() async {
    final ui.Image data = await _cartesianChartKey.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  Future<List<int>> _readImage2Data() async {
    final ui.Image data = await _cartesianChart2Key.currentState!.toImage(pixelRatio: 3.0);
    final ByteData? bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

}





























