class User{
  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
        carnetID: json['carnet'],
        name: json['nombre'],
        address: json['dirección'],
        //municiple: json['municipio'],
        metroType: json['tipoMetro'],
        lecture: json['lectura'],
        //lectureSendMonth: json['mes_de_envio_lectura'],
        consume: json['consumo'],
        toPay: json['tarifa'],
        timestamp: DateTime.parse(json['timestamp'])
    );
    return user;
  }


  User(
      {  this.carnetID,
         this.name,
         this.address,
         //this.municiple,
         this.metroType,
         this.lecture,
       //  this.lectureSendMonth,
         this.consume,
         this.toPay,
         this.timestamp, });

   String? carnetID;
   String? name;
   String? address;
   //String? municiple;
   String? metroType;
   double? lecture;
   //int? lectureSendMonth;
   double? consume;
   double? toPay;
   DateTime? timestamp;

}
