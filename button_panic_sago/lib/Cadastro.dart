import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerCpf = TextEditingController();
  TextEditingController _controllerContato = TextEditingController();

  void _cadastrar() async{
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String cpf = _controllerCpf.text;
    String contato = _controllerContato.text;
    String url = "http://10.9.254.33/panicoSago/api/cadastrar_cliente.php?"
        "nome=" + nome +
        "&email=" + email +
        "&senha=" + senha +
        "&cpf=" + cpf +
        "&contato=" + contato;

    http.Response response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("idCliente", retorno["idcliente"].toString());
    _showMyDialog(retorno['success'].toString());
  }

  Future<void> _showMyDialog(String texto) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sucesso'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(texto),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
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
      body: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("img/background.jpeg"),
          fit: BoxFit.fill,
          )
        ),
        padding: EdgeInsets.all(42),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Image.asset("img/logo.png",),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Degite seu Nome"
                ),
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white
                ),
                controller: _controllerNome,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: "Digite seu Email"
                ),
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white
                ),
                controller: _controllerEmail,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Digite sua senha",
                ),
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.white
                ),
                controller: _controllerSenha,
              ),

              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Digite seu CPF",
                ),
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white
                ),
                controller: _controllerCpf,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Digite seu Contato",
                ),
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white
                ),
                controller: _controllerContato,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15),
                  onPressed: _cadastrar,
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Voltar para o Login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
