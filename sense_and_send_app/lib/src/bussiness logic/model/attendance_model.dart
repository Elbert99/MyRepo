class AttendanceModel {
  late String _check_in;
  late String _check_out;
  late int _employee_id;
  late int _department_id;

  AttendanceModel(
      { required String check_in,
        required String check_out,
        required int employee_id,
        required int department_id,
      })
      : _check_in = check_in,
        _check_out = check_out,
        _employee_id = employee_id,
        _department_id = department_id;

  int get department_id => _department_id;

  set department_id(int value) {
    _department_id = value;
  }

  int get employee_id => _employee_id;

  set employee_id(int value) {
    _employee_id = value;
  }

  String get check_out => _check_out;

  set check_out(String value) {
    _check_out = value;
  }

  String get check_in => _check_in;

  set check_in(String value) {
    _check_in = value;
  }
}
