import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class olvidecontra extends StatefulWidget {
  const olvidecontra({Key? key}) : super(key: key);

  @override
  _olvidecontraState createState() => _olvidecontraState();
}

class _olvidecontraState extends State<olvidecontra> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contra = TextEditingController();

  void _mensajeFiltros (BuildContext context, String correo) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text('Te hemos enviado un correo electronico a $correo para reestablecer tu contraseña', style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(); //Te regresa a la pantalla anterior
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.yellow[700],
        title: Text('¿Olvidaste tu contraseña?'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(50)
                    ),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.yellow,
                          blurRadius: 5
                      )
                    ]
                ),
                child: TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Escribe tu correo';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.words,
                  controller: _contra,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.email,
                      color: Colors.yellow[700],
                    ),
                    hintText: 'Ingresa aqui tu correo',
                  ),
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                width: 400,
                height: 50,
                child: SizedBox(
                  child: RaisedButton(
                    color: Colors.yellow[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    child: Text('Recuperar contraseña', style: TextStyle(color: Colors.white,fontSize: 20.0),),
                    onPressed: () async {

                      if (_formKey.currentState!.validate()) {
                        FirebaseAuth.instance.sendPasswordResetEmail(email: _contra.text);
                        _mensajeFiltros(context, _contra.text);
                        _contra.clear();
                      }
                      //Navigator.of(context).pushNamed("/distribuidor_como_quieres_pagar");

                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
