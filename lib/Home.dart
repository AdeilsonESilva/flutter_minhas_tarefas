import 'package:flutter/material.dart';
import 'package:flutter_minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:flutter_minhas_anotacoes/model/Anotation.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _tituloController = TextEditingController();
  var _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  var _anotacoes = List<Anotation>();

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
    var id = await _db.saveAnotation(anotation);

    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();

    print(id);
  }

  void _recuperarAnotacoes() async {
    var anotacoesRecuperadas = await _db.getAnotations();

    setState(() {
      _anotacoes = anotacoesRecuperadas
          .map((anotacao) => Anotation.fromMap(anotacao))
          .toList();
    });

    print(anotacoesRecuperadas);
  }

  String _formatarData(String data) {
    var formatador = DateFormat('dd/MM/y HH:mm:ss', 'pt_BR');
    // var formatador = DateFormat.yMMMEd('pt_BR');
    var dataConvertida = DateTime.parse(data);
    var dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR');
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Anotações'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _anotacoes.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: Text(_anotacoes[index].title),
              subtitle: Text(
                  '${_formatarData(_anotacoes[index].date)} - ${_anotacoes[index].description}'),
            ),
          ),
        ),
      ),
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
