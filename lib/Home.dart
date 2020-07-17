import 'package:flutter/material.dart';
import 'package:flutter_minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:flutter_minhas_anotacoes/model/Anotation.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _tituloController = TextEditingController();
  var _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();

  void _exibirTelaCadastro() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar anotação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _tituloController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Título',
                hintText: 'Digite título...',
              ),
            ),
            TextField(
              controller: _descricaoController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: 'Digite descrição...',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          FlatButton(
            onPressed: () {
              _salvarAnotacao();

              Navigator.pop(context);
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _salvarAnotacao() async {
    var titulo = _tituloController.text;
    var descricao = _descricaoController.text;

    // print('data: ${DateTime.now()}');
    Anotation anotation =
        Anotation(titulo, descricao, DateTime.now().toString());
    int id = await _db.saveAnotation(anotation);

    _tituloController.clear();
    _descricaoController.clear();

    print(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Anotações'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
