import 'package:firebase_database/firebase_database.dart';

class pedido_modelo{
  String _id;
  String _nombreProducto;
  String _fecha;
  int _folio;
  String _maximo;
  String _minimo;
  String _costoFactura;
  int _existencia;
  String _codigoDeBarra;
  String _ultimoInventario;
  String _nombreProveedor;
  String _foto;
  String _estado;

  pedido_modelo(this._id, this._nombreProducto, this._fecha,this._folio, this._maximo, this._minimo, this._costoFactura, this._existencia, this._codigoDeBarra, this._ultimoInventario, this._nombreProveedor, this._foto, this._estado);

  //Crea la estructura en la BD
  map(dynamic obj){
    _nombreProducto = obj ['producto'];
    _fecha = obj ['fecha'];
    _folio = obj ['folio'];
    _maximo = obj ['newid'];
    _minimo = obj ['minimo'];
    _costoFactura = obj ['costoFactura'];
    _existencia = obj ['existencia'];
    _codigoDeBarra = obj ['codigoDeBarra'];
    _ultimoInventario = obj ['ultimoInventario'];
    _nombreProveedor = obj ['nombreProveedor'];
    _foto = obj ['foto'];
    _estado= obj ['estado'];


  }

  String get nombreProducto => _nombreProducto;
  String get fecha => _fecha;
  String get id => _id;
  int get folio => _folio;
  String get maximo => _maximo;
  String get minimo => _minimo;
  int get existencia => _existencia;
  String get costoFactura => _costoFactura;
  String get codigoDeBarra => _codigoDeBarra;
  String get ultimoInventario => _ultimoInventario;
  String get nombreProveedor => _nombreProveedor;
  String get foto => _foto;
  String get estado => _estado;


}