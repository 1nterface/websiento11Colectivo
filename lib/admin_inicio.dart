import 'package:flutter/material.dart';
// ignore: camel_case_types
class Admin_Inicio extends StatelessWidget {
  const Admin_Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff6DA08E),
        title: Text('Siento11 Colectivo', style: const TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset : false,
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20.0,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height:170),
                  SizedBox(
                    height: 200,
                    child: Image.asset('images/siento11.png'),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 800,
                  height: 50,
                  child: SizedBox(
                    child: RaisedButton(
                      color: Color(0xff6DA08E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      child: Text('COLECTIVO', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                      onPressed: () async {

                        //Navigator.of(context).pushNamed("/panel_de_control");
                        Navigator.of(context).pushNamed("/gerencia_login");

                      },
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 800,
                  height: 50,
                  child: SizedBox(
                    child: RaisedButton(
                      color: Color(0xff6DA08E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      child: Text('PANEL DE CONTROL', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                      onPressed: () async {

                        //al entrar ver lista de afiliados, boton flotante par agregar nuevos afiliados.
                        //Navigator.of(context).pushNamed("/panel_de_control");
                        Navigator.of(context).pushNamed("/panel_login");

                      },
                    ),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
