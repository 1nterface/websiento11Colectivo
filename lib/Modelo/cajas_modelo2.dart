import 'package:firebase_database/firebase_database.dart';

class cajas_modelo2{
  String _id;
  String _nombreProducto;
  String _fecha;
  int _folio;
  int _maximo;
  int _minimo;
  double _precioVenta;
  int _existencia;
  String _codigoDeBarra;
  String _nombreProveedor;
  String _foto;
  String _estado;
  String _newid;
  double _costoProducto, _latitud, _longitud;
  String _empresa;

  cajas_modelo2(this._id, this._nombreProducto, this._fecha,this._folio, this._maximo, this._minimo, this._precioVenta, this._existencia, this._codigoDeBarra, this._nombreProveedor, this._foto, this._estado, this._newid, this._costoProducto, this._latitud, this._longitud, this._empresa);

  //Crea la estructura en la BD
  map(dynamic obj){
    _nombreProducto = obj ['producto'];
    _fecha = obj ['fecha'];
    _folio = obj ['folio'];
    _maximo = obj ['newid'];
    _minimo = obj ['minimo'];
    _precioVenta = obj ['precioVenta'];
    _existencia = obj ['existencia'];
    _codigoDeBarra = obj ['codigoDeBarra'];
    _nombreProveedor = obj ['nombreProveedor'];
    _foto = obj ['foto'];
    _estado= obj ['estado'];
    _newid= obj ['newid'];
    _latitud= obj ['latitud'];
    _longitud= obj ['longitud'];
    _empresa= obj ['empresa'];


  }

  String get nombreProducto => _nombreProducto;
  String get fecha => _fecha;
  String get id => _id;
  int get folio => _folio;
  int get maximo => _maximo;
  int get minimo => _minimo;
  int get existencia => _existencia;
  double get precioVenta => _precioVenta;
  String get codigoDeBarra => _codigoDeBarra;
  String get nombreProveedor => _nombreProveedor;
  String get foto => _foto;
  String get estado => _estado;
  String get newid => _newid;
  double get costoProducto => _costoProducto;
  double get latitud => _latitud;
  double get longitud => _longitud;
  String get empresa => _empresa;


}