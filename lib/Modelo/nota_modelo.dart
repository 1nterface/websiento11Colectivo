import 'package:firebase_database/firebase_database.dart';

class nota_modelo{
  String _id;
  String _nombreProducto;
  int _folio;
  int _cantidad;
  String _newid;
  String _direccion;
  double _totalNota;
  String _sucursal;
  double _latitud;
  double _longitud;
  String _tel;
  String _foto;
  String _formadepago;


  nota_modelo(this._id, this._nombreProducto, this._folio, this._cantidad, this._newid, this._direccion, this._totalNota, this._sucursal, this._latitud, this._longitud, this._tel, this._foto, this._formadepago);

  //Crea la estructura en la BD
  map(dynamic obj){
    _nombreProducto = obj ['nombreProducto'];
    _folio = obj ['folio'];
    _cantidad = obj ['cantidad'];
    _newid = obj ['newid'];
    _direccion = obj ['direccion'];
    _totalNota = obj ['totalNota'];
    _sucursal = obj ['sucursal'];
    _latitud = obj ['latitud'];
    _longitud = obj ['longitud'];
    _tel = obj ['tel'];
    _foto = obj ['foto'];
    _formadepago = obj ['formadepago'];


  }

  String get nombreProducto => _nombreProducto;
  int get folio => _folio;
  int get cantidad => _cantidad;
  String get id => _id;
  String get newid => _newid;
  String get direccion => _direccion;
  double get totalNota => _totalNota;
  String get sucursal => _sucursal;
  double get latitud => _latitud;
  double get longitud => _longitud;
  String get tel => _tel;
  String get foto => _foto;
  String get formadepago => _formadepago;



}