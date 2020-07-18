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

  void _exibirTelaCadastro({Anotation anotacao}) {
    var textoSalvarAtualizar = 'Salvar';
    _tituloController.clear();
    _tituloController.clear();

    if (anotacao != null) {
      _tituloController.text = anotacao.title;
      _descricaoController.text = anotacao.description;
      textoSalvarAtualizar = 'Atualizar';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$textoSalvarAtualizar anotação'),
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
              _salvarAtualizarAnotacao(anotacao: anotacao);

              Navigator.pop(context);
            },
            child: Text(textoSalvarAtualizar),
          ),
        ],
      ),
    );
  }

  Future<int> _incluirAnotacao(Anotation anotation) async {
    return await _db.saveAnotation(anotation);
  }

  void _salvarAtualizarAnotacao({Anotation anotacao}) async {
    var titulo = _tituloController.text;
    var descricao = _descricaoController.text;

    // print('data: ${DateTime.now()}');
    Anotation anotation =
        Anotation(titulo, descricao, DateTime.now().toString());

    int id;

    if (anotacao == null) {
      id = await _incluirAnotacao(anotation);
    } else {
      anotation.id = anotacao.id;
      id = await _db.updateAnotation(anotation);
    }

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

  void _removerAnotacao(int id) async {
    int quantidade = await _db.removeAnotation(id);

    _recuperarAnotacoes();

    print(quantidade);
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
          padding: EdgeInsets.only(bottom: 80),
          itemCount: _anotacoes.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              title: Text(_anotacoes[index].title),
              subtitle: Text(
                '${_formatarData(_anotacoes[index].date)} - ${_anotacoes[index].description}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _exibirTelaCadastro(anotacao: _anotacoes[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.edit,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      final itemExcluido = _anotacoes[index];
                      final snackBar = SnackBar(
                        content: Text('Item excluído!'),
                        action: SnackBarAction(
                          label: 'Desfazer',
                          onPressed: () {
                            _incluirAnotacao(itemExcluido);
                            _recuperarAnotacoes();
                          },
                        ),
                      );

                      _removerAnotacao(_anotacoes[index].id);
                      Scaffold.of(context).showSnackBar(snackBar);
                    },
                    child: Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
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
