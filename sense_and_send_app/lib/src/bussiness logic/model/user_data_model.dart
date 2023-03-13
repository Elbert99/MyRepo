import 'metrocounter_model.dart';

class UserDataModel {
  late final String _id;
  late final String _username;
  late final String _address;
  late final String _municiple;
  late final MetrocounterModel _metrocounter;

  // Constructor
  UserDataModel(
      {required String id,
        required String username,
        required String address,
        required String municiple,
        required MetrocounterModel metrocounter,
       })
      : _id = id,
        _username = username,
        _address = address,
        _municiple = municiple,
        _metrocounter = metrocounter;

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get municiple => _municiple;

  set municiple(String value) {
    _municiple = value;
  }

  set metrocounter(MetrocounterModel value) {
    _metrocounter = value;
  }

  MetrocounterModel get metrocounter => _metrocounter;

  Map toJson() {
    Map? metrocounter =_metrocounter != null ? _metrocounter.toJson() : null;
    return {'ci':_id,'nombre':_username,'dirección':_address,'municipio':_municiple,'metrocontador':metrocounter};
  }

}
