import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sense_and_send_app/src/bussiness%20logic/model/metrocounter_model.dart';
import 'package:sense_and_send_app/src/presentation/widgets/button.dart';


class TextRecognitionView extends StatefulWidget {
  final MetrocounterModel metrocounter;
  File? image;
  TextRecognitionView({Key? key, required this.metrocounter,required this.image}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextRecognitionViewState();
  }
}

class _TextRecognitionViewState extends State<TextRecognitionView> {
  int _scanning = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late double _lecture = 0;
  String _scannedText = "";
  late bool _showDialog = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Lectura del Metrocontador"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(scrollDirection: Axis.vertical,
                child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                  _buildImagePane(),
                  _callRecognition(),
                   const SizedBox(height: 20.0),
                  _buildSelectorButton(),
                  _buildStatusProgressIcon(),
                  _buildTextPane()
                ],
              ),
            ),
           ),
          );
  }

  Widget _buildImagePane() {
    //widget.image == null ? AssetImage('assets/images/SIN-IMAGEN.jpg') : FileImage(widget.image!); ??????
    Image returnWidget;
    if(widget.image == null){
      _scannedText = "";
      returnWidget = const Image(
        image: AssetImage('assets/images/SIN-IMAGEN.jpg'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }else {
      returnWidget = Image(
        image: FileImage(widget.image!),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
    return returnWidget;
  }

  Widget _buildSelectorButton() {
      return  Button(
        icon: Icons.wallpaper_rounded,
        onPress: () {_showImageSourceActionSheet();},
        text: 'Lectura',
      );
    }

  void setLectureInMetrocounter(String recognizedLecture){
    print(widget.metrocounter.lecture);
    widget.metrocounter.setLecture(convertStringToDouble(recognizedLecture));
    print(widget.metrocounter.lecture);
  }

  double convertStringToDouble(String myString) {
    double myDouble = double.parse(myString);
    print(myDouble); // 123.45
    return myDouble;
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

  Future _getImageFromSource(ImageSource sourceImg) async {
    setState(() {_scanning = 0;});
    var pickedImage = await ImagePicker().pickImage(source: sourceImg);

    if(pickedImage != null) {
      widget.image = File(pickedImage.path);
      _lecture = 1;
      _scanning = 0;

      setState(() {});
      _showDialog =true;

    } else {
      showDialog(
          context: context,
          builder: (context)=> const AlertDialog(
            title: Text('Alerta'),
            content: Text('No seleccionaste o tomaste ninguna foto de la lectura de tu metrocontador'),
            //la lectura esta en 0
          )
      );
      print('No seleccionaste ninguna imagen');
      widget.image = null;
      _scanning = 1;
      setState(() {});
    }
    print(widget.image?.path);
  }

  void _getRecognizedTextFromImage(File? image) async{
    InputImage inputImage = InputImage.fromFile(image!);
    TextRecognizer textRecognizer = TextRecognizer();
    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    _scannedText = "";
    _scanning = 0 ;

     for(TextBlock block in recognizedText.blocks) {
       for(TextLine line in block.lines) {
         for (TextElement element in line.elements){
             _scannedText = _scannedText + element.text;
         }
       }
     }

    if(_scannedText != "") {
      print(_scannedText);
      if(_validateTextRecognizedForJustLectureOfNumbersMeter(_scannedText)) {
        _scanning = 2;
      }
      else {
        _scanning = 1;
        _scannedText = "Esta lectura es incorrecta."+ "\n" "Vuelva a intentarlo";
        print(_scannedText);
      }
    }else {
      _scanning = 1;
      _scannedText = "Esta imagen no contiene datos";
      print(_scannedText);
    }
    setState(() {});
  }

  bool _validateTextRecognizedForJustLectureOfNumbersMeter(String scannedText) {
    int i = 0;
    bool out = false;
    bool isValid = true;
    String scannedLecture = '' ;

    print(scannedText.length);
    while( i<scannedText.length && !out){
      print(scannedText.characters.elementAt(i));
        if(!_isDigit(scannedText.characters.elementAt(i))) {
          print('entro al primer if');
           out = true;
        }else {
          if((scannedText.characters.elementAt(i) == '.'|| scannedText.characters.elementAt(i) == ',') && i!=5){
            out = true;
          }
           else if(scannedLecture.length<5) {
              scannedLecture = (scannedLecture + scannedText.characters.elementAt(i));//me quedo con los cinco primeros num como lo ace la empresa electrica en el recibo de lectura, las otras lecturas tmb tienen cinco primeros num enteros, solo me quedo con los enteros
            }
        }
          i++;
    }

    if(out== true || scannedLecture.length<5){
      isValid = false;
    }else{
      setLectureInMetrocounter(scannedLecture);
      if(_showDialog == true){
        showDialog(
            context: context,
            builder: (context)=>  AlertDialog(
              title:  const Text('Alerta'),
              content: Text("La lectura del Metrocontador es: $scannedLecture\n Se escogió sólo la parte entera.\n Si desea cambiarla presione el botón Lectura,\n de lo contrario si desea enviarla dirígase atrás y presione Enviar."),
            )
        );
        _showDialog = false;
      }
    }
     print(isValid);
    return isValid;
  }

  bool _isDigit(String character){
     bool isDigit = false;
     if(character == '0' || character == '1'|| character == '2'|| character == '3'|| character == '4'|| character == '5'|| character == '6'|| character == '7'|| character == '8'|| character == '9' || character == '.' || character == ',') {
       isDigit = true;
     }
     print(isDigit);
     return isDigit;
  }


  Widget _buildStatusProgressIcon() {
    Widget currentState;
    if(_scanning == 0) {
       currentState = const Center(child: CircularProgressIndicator.adaptive(),); //recognition loading
    }
    else if(_scanning == 1) {
       currentState = _buildProgressIcon(Icons.cancel_rounded, Colors.red);       //recognition failure
    }
    else {
      currentState = _buildProgressIcon(Icons.done_rounded , Colors.green);       //recognition succeed
    }
    return  currentState;
  }

  Widget _buildProgressIcon(IconData icon, Color color) {
    return Icon( icon, size: 40, color: color, );
  }

  Widget _buildTextPane() {
    return Center(
        child: Text(_scannedText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        )
    );
  }

  Widget _callRecognition() {
    _getRecognizedTextFromImage(widget.image);
    return const Center(
        child: Text("",
          textAlign: TextAlign.center,
        )
    );
  }

}





