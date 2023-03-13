class MetrocounterModel {
  late String _metrocounterType;
  late double _lecture;
  late DateTime _sendDate;
  late int _sendDateMonth;

  // Constructor
  MetrocounterModel(
      {required String metrocounterType,
        required double lecture,
      })
      :  _metrocounterType = metrocounterType,
        _lecture = lecture;

  String get metrocounterType => _metrocounterType;

  set metrocounterType(String value) {
    _metrocounterType = value;
  }

  double get lecture => _lecture;

  set lecture(double value) {
    _lecture = value;
  }

  void setLecture(double value){
    _lecture = value;
    _sendDate = DateTime.now();
    _sendDateMonth = _sendDate.month;
  }
  //'fecha de envío':_sendDate
  Map toJson() => {'tipo de metrocontador':_metrocounterType,'lectura':_lecture,'# de mes de envío':_sendDateMonth};

}