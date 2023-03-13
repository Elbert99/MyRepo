import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sense_and_send_app/src/bussiness%20logic/controller/mqtt_app_state_controller.dart';
import 'package:sense_and_send_app/src/bussiness%20logic/model/metrocounter_model.dart';
import 'package:sense_and_send_app/src/presentation/pages/text_recognition_view.dart';
import '../../bussiness logic/model/mqtt_manager_model.dart';
import '../../bussiness logic/model/user_data_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../widgets/button.dart';


class MQTTView extends StatefulWidget {
  const MQTTView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MQTTViewState();
  }
}

class _MQTTViewState extends State<MQTTView> {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final items = ['Electricidad','Agua','Gas'];
  final items_municiples = ['Arroyo Naranjo','Boyeros','Centro Habana','Cotorro','Diez de Octubre','Marianao','Playa'];
  String? selectedItem = 'Electricidad';
  String? selectedItemMuniciple = 'Boyeros';

  late TextEditingController _textFieldController = TextEditingController() ;

  late UserDataModel _userDataManager;
  late MetrocounterModel _metrocounter;
  late String _toJson;


  late String _id = '0';
  late String _username;
  late String _address;
  late double _lecture = 0;
  late int _temp = 0;

  File? _image;
  late MQTTManagerModel manager;
  late MQTTAppStateController currentAppState;
  late bool validForm = true;

  @override
  void initState() {
    // TODO: implement initState
   //_textFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MQTTAppStateController appState = Provider.of<MQTTAppStateController>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Lectura del Metrocontador"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child:SingleChildScrollView(
              scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                _buildConnectionStateText(
                _prepareStateMessageFrom(currentAppState.getAppConnectionState)),
                _createDropdownField(),
                _createUsernameField(),
                _createIDField(),
                _createAddressField(),
                _createMunicipleDropdownField(),
                _buildConnectButtonFrom(currentAppState.getAppConnectionState),
                _buildSendButtonFrom(currentAppState.getAppConnectionState),
                _buildSelectorButton(),
                _buildNotificatorButton(),
              ],
            ),
          ),
          ),
        ));
  }
  //Widget _loadImagebyMetrocounterType() {
   // return Image(image: image)
  //}
  Widget _createDropdownField() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          icon: Icon( Icons.amp_stories_outlined, color: Colors.deepPurple ),
          labelText: 'Tipo de Metrocontador',
          //enabledBorder: OutlineInputBorder(
          //  borderSide: BorderSide(width: 3, color: Colors.deepPurple),
          //),
        ),
        value: selectedItem,
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        items: items.map(buildMenuItem).toList(),
        onChanged: (item) => setState(() => selectedItem = item),
      ),
    );
  }

  Widget _createUsernameField() {
    return TextFormField(
      validator: (val) =>_validateUserName(val!),
      //controller: _textFieldController,
      onSaved: (val) => _username = val!,
      autocorrect: false,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        icon: Icon( Icons.account_circle, color: Colors.deepPurple ),
        hintText: 'Ej de nombre: Alexa',
        labelText: 'Nombre',
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        errorMaxLines: 1
      ),
    );
  }

  Widget _createIDField() {
    return TextFormField(
      inputFormatters: [_createMaskFormatter('3')],
      validator: (val) =>_validateID(val!),
      //controller: _textFieldController,
      onSaved: (val) => _id = val!.toString(),
      autocorrect: false,
      controller: _textFieldController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        icon: Icon( Icons.account_box_sharp, color: Colors.deepPurple ),
        hintText: 'Ej de C.I: 99121407960',
        labelText: 'Carné de Identidad',
        focusedBorder:UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        errorBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        border:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        errorMaxLines: 1
      ),
    );
  }

  Widget _createAddressField() {
    return TextFormField(
      inputFormatters: [_createMaskFormatter('2')],
      validator: (val) => _validateAddress(val!),
      //controller: _textFieldController,
      onSaved: (val) => _address = val!,
      autocorrect: false,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        icon: Icon( Icons.add_location, color: Colors.deepPurple ),
        hintText: 'Ej: calle:20 %:19 y 18 La Habana #:',
        labelText: 'Dirección',
        focusedBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        enabledBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        errorBorder:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        border:  UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
        errorMaxLines: 1
      ),
    );
  }

  Widget _createMunicipleDropdownField() {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          icon: Icon( Icons.where_to_vote, color: Colors.deepPurple ),
          labelText: 'Municipio',
          //enabledBorder: OutlineInputBorder(
          //  borderSide: BorderSide(width: 3, color: Colors.deepPurple),
          //),
        ),
        value: selectedItemMuniciple,
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        items: items_municiples.map(buildMenuItem).toList(),
        onChanged: (item) => setState(() => selectedItemMuniciple = item),
      ),
    );
  }

  //Widget _createLectureField() {
   // return TextFormField(
    //  inputFormatters: [_crateMaskFormatter('1')],
   //  controller: _textFieldController,
   //   validator: (val) => _validateLecture(val!),
    //  onSaved: (val) => _lecture = double.tryParse(val!.replaceAll(" ", ""))!,
   //   autocorrect: false,
    //  keyboardType: TextInputType.number,
      ////autovalidateMode: AutovalidateMode.onUserInteraction,
    //  decoration: const InputDecoration(
    //    icon: Icon( Icons.vignette, color: Colors.deepPurple ),
    //    hintText: 'Ejemplo de lectura: 10 000.3',
     //   labelText: 'Lectura del Metrocontador',
     //   focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
     //   enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
     //   errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    //    border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.green)),
    //    errorMaxLines: 1
    //  ),
    //);
  //}

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
    ),
  );

  Widget _buildConnectButtonFrom(MQTTAppConnectionState state) {
    // ignore: deprecated_member_use
    return  RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      label:  const Text('Conectar',style: TextStyle(color: Colors.white ),),
      onPressed: state == MQTTAppConnectionState.disconnected
          ? _configureAndConnect
          : null,
      textColor: Colors.white,
      icon: const Icon(Icons.wifi_tethering),  //
    );
  }

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
    // ignore: deprecated_member_use
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      label: const Text('Enviar',style: TextStyle(color: Colors.white, ),),
      onPressed: state == MQTTAppConnectionState.connected
          ? () {
        if(_submit()) {
          _buildShowDialog(context);

        }
        else if (_temp == 0 ){
          _buildShowDialog2(context);
        }
        else if (_temp == 1 ){
          _buildShowDialog3(context);
        }
      }
          : null,
      textColor: Colors.white,
      icon: const Icon(Icons.send_rounded), //
    );
  }

  Widget _buildSelectorButton() {
    return  Button(
      icon: Icons.wallpaper_rounded,
      onPress: () {_showImageSourceActionSheet();},
      text: 'Lectura',
    );
  }

  Widget _buildNotificatorButton() {
    return  Button(
      icon: Icons.notifications,
      onPress: () { _performNotification();},
      text: 'Aviso',
    );
  }

 // Widget _buildSelectorButton() {
    // ignore: deprecated_member_use
   // return RaisedButton.icon(
  //    shape: RoundedRectangleBorder(
   //     borderRadius: BorderRadius.circular(20.0)
   //   ),
   //   color: Colors.deepPurple,
   //   label: const Text('Lectura',style: TextStyle(color: Colors.white, ),),
   //   icon: const Icon(Icons.wallpaper_rounded),
   //   textColor: Colors.white,
   //  onPressed:  () {
   //     _showImageSourceActionSheet();
   //   },
  //  );
  //}

  Future _buildShowDialog2(BuildContext context){
    return showDialog(
        context: context,
        builder: (context)=> const AlertDialog(
          title: Text('Comprobación de Envío'),
          content: Text('Aún no has realizado la lectura. Usted debe presionar el botón ¨Lectura¨'),
            //la lectura esta en 0
        )
    );
  }
  Future _buildShowDialog3(BuildContext context){
    return showDialog(
        context: context,
        builder: (context)=> const AlertDialog(
          title: Text('Comprobación de Envío'),
          content: Text('Usted debe realizar al menos una lectura correcta antes de enviar. Por favor presione el botón Lectura.'),//lectura del metro en 0
          //la lectura esta en 0
        )
    );
  }

  void _performNotification() {
    String n = manager.getNotification();
    final json = jsonDecode(n);
    int consumo = json["consumo"];
    int tarifa = json["tarifa"];
    if (_textFieldController.text == json["carnet"]){
      final snackbar = SnackBar(
        content: Text("Esto es lo que te acaba de enviar el sistema:\nSu consumo mensual es:$consumo\nEste mes tiene que pagar:$tarifa"),
      );
      scaffoldKey.currentState!.showSnackBar(snackbar);
    }else {const snackbar = SnackBar(
      content: Text("El sistema no le ha enviado ninguna notificación"),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
    }
  }

  Future _buildShowDialog4(BuildContext context){
    String n = manager.getNotification();
    final json = jsonDecode(n);
    double consumo = json["consumo"];
    double tarifa = json["tarifa"];

    return _id == json["carnet"]? showDialog(
        context: context,
        builder: (context)=> AlertDialog(
          title: Text('Notificación'),
          content: Text("Esto es lo que te acaba de enviar el sistema:\nSu consumo mensual es:$consumo\nEste mes tiene que pagar:$tarifa"),
          actions: <Widget>[
            TextButton(
                child: const Text('Aceptar'),
                onPressed: (){
                  Navigator.of(context).pop();
                }
            ),
          ],
        )
    ):showDialog(
        context: context,
        builder: (context)=> AlertDialog(
      title: Text('Notificación'),
      content: Text("El sistema no le ha enviado ninguna notificación"),
      actions: <Widget>[
        TextButton(
            child: const Text('Aceptar'),
            onPressed: (){
              Navigator.of(context).pop();
            }
        ),
      ],
    ),
    );
  }
//Widget _buildTestButtonToVerifyPersistenceTextInFields() {
  // ignore: deprecated_member_use
  // return RaisedButton(
  //   color: Colors.deepPurple,
  //  child: const Text('Enviar',style: TextStyle(color: Colors.white, ),),
  //  onPressed: state == MQTTAppConnectionState.connected
  //       ? () {
  //   if(_submit()) {
  //      _buildShowDialog(context);
  //    }
  //   }
  //       : null, //
  // );
  //}

  Future _buildShowDialog(BuildContext context){
    return showDialog(
        context: context,
        builder: (context)=> AlertDialog(
          title: const Text('Comprobación de Envío'),
          content: Text('¿Seguro de que quieres enviar estos datos?:\n $_toJson'),
          actions: <Widget>[
            TextButton(
                child: const Text('Si'),
                onPressed: (){
                  _performLogin();
                  _publishMessage(_toJson);
                  //_textFieldController.clear();
                  Navigator.of(context).pop();
                  _temp = 0;
                  _metrocounter.setLecture(0);
                }
            ),
            TextButton(
              child: const Text('No'),
              onPressed: (){
                Navigator.of(context).pop();
                _temp = 2;
              }
            ),
          ],
        )
    );
  }

  Widget _buildConnectionStateText(String status) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              color: Colors.deepOrangeAccent,
              child: Text(status, textAlign: TextAlign.center)),
        ),
      ],
    );
  }

  bool _submit() {
    bool out=false;
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      print( _metrocounter.lecture);
      if ( _metrocounter.lecture !=0) {
        _userDataManager = UserDataModel(id: _id, username: _username, address: _address, municiple: selectedItemMuniciple!, metrocounter: _metrocounter);
        _toJson = jsonEncode(_userDataManager);
        print( _metrocounter.lecture);
        out=true;//el usuario presiona Lectura
        _temp=2;
      }
    }
    return out;
  }

  void _performLogin() {
    final snackbar = SnackBar(
      content: Text("Esto es lo que acabas de enviar:\n $_toJson"),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  void _configureAndConnect() {
    // ignore: flutter_style_todos
    // TODO: Use UUID
    manager = MQTTManagerModel(state: currentAppState);
    manager.connect();

  }

  String? _validateUserName(String val){
    String? out;
    if(val.isEmpty) {
      out = 'Por favor rellene este campo';
    } else if (val.length >=50) {
      out = 'Por favor acorte el nombre.';
    }
    return out;
  }

  String? _validateAddress(String val){
    String? out;
    if(val.isEmpty) {
      out = 'Por favor rellene este campo';
    }
   else if (val.length <37) {
      out = 'Su dirección es demasiado corta. ';
    }
    //else if (val.length >=50) {
     // out = 'Su dirección es muy extensa.';
    //}
    return out;
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

  //String? _validateLecture(String val) {
  // String? out;
  // if(val.isEmpty) {
//   out = 'Por favor rellene este campo';
  //  } else if (val.length < 8 ) {
//    out = 'Su lectura es incorrecta. Debería tener 6 dígitos';
  //  }
     // for (int i=0; i < val.length;i++){
       // if(i != 5){
         //if(val.contains(",",i))
          //    out = ', Detectada';
       // }
   // }
//return out;
  //}

  // Utility functions
  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Conectado';
      case MQTTAppConnectionState.connecting:
        return 'Conectando...';
      case MQTTAppConnectionState.disconnected:
        return 'Desconectado. Por favor conéctese a Internet';
    }
  }

  void _publishMessage(String message) {
    manager.publish(message);
  }

  void _showImageSourceActionSheet() {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Cámara'),
              onPressed: () {
                Navigator.pop(context);
                _getImageFromSource(ImageSource.camera) ;
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Galería'),
              onPressed: () {
                Navigator.pop(context);
                _getImageFromSource(ImageSource.gallery);
              },
            )
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)
        ),
        context: context,
        builder: (context) => Wrap(children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Cámara'),
            onTap: () {
              Navigator.pop(context);
              _getImageFromSource(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Galería'),
            onTap: () {
              Navigator.pop(context);
              _getImageFromSource(ImageSource.gallery);
            },
          ),
        ]),
      );
    }
  }

 // Future _buildShowDialog3(){
  //   return showDialog(
  //       context: context,
  //       builder: (context)=> const AlertDialog(
  //         title: Text('Alerta'),
  //         content: Text('No seleccionaste ninguna imagen'),
  //         //la lectura esta en 0
  //       )
//   );
  //}

  Future _getImageFromSource(ImageSource sourceImg) async {
     var pickedImage = await ImagePicker().pickImage(source: sourceImg);

    if(pickedImage != null) {
       _image = File(pickedImage.path);
       _metrocounter = MetrocounterModel(metrocounterType: selectedItem!, lecture: _lecture);
        Navigator.push(context, MaterialPageRoute(builder: (context) => TextRecognitionView(metrocounter: _metrocounter, image: _image,)),
        );
       _temp = 1;
     } else {
       showDialog(
            context: context,
            builder: (context)=> const AlertDialog(
              title: Text('Alerta'),
              content: Text('No seleccionaste o tomaste ninguna imagen'),
             //la lectura esta en 0
            )
        );
       //_next = false;
       print('No seleccionaste ninguna imagen');
     }
    setState(() {});
    print(_image?.path);
 }

  MaskTextInputFormatter _createMaskFormatter(String temp){
    MaskTextInputFormatter maskFormatter;

    if(temp=='1'){
        maskFormatter = MaskTextInputFormatter(
        mask: '## ###.#',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
    }
    else  if(temp=='2'){
        maskFormatter = MaskTextInputFormatter(
        mask: 'calle:jj %:jj y jj La Habana #:jj jjj ',
        filter: { "j": RegExp(r'[0-9]') },
       // filter: { "n": RegExp(r'[A-Za-z-0-99999]') },
        type: MaskAutoCompletionType.lazy
      );
    }
    else {
        maskFormatter = MaskTextInputFormatter(
        mask: '###########',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
      );
    }
    return  maskFormatter;
  }

}

