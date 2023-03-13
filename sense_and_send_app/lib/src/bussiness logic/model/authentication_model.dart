class Authentication {
   late String _jsonrpc;
   late Params _params;

   Authentication(
       { required String jsonrpc,
         required Params params,
       })
       : _jsonrpc = jsonrpc,
         _params = params;

   Params get params => _params;

  set params(Params value) {
    _params = value;
  }

  String get jsonrpc => _jsonrpc;

  set jsonrpc(String value) {
    _jsonrpc = value;
  }
}

class Params {
  late String _db;
  late String _login;
  late String _password;

  Params(
      { required String db,
        required String login,
        required String password,
      })
      : _db = db,
        _login = login,
        _password = password;

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get login => _login;

  set login(String value) {
    _login = value;
  }

  String get db => _db;

  set db(String value) {
    _db = value;
  }
}