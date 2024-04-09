import 'package:flutter/material.dart';
import 'package:teste/model/book.dart';

class Detalhes extends StatefulWidget {
  final Book livro;

  const Detalhes({Key? key, required this.livro}) : super(key: key);

  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  late TextEditingController _anotacoesController;

  @override
  void initState() {
    super.initState();
    _anotacoesController = TextEditingController(text: widget.livro.notes);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Define o número de abas
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detalhes do Livro"),
          backgroundColor: Colors.orange,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Informações'),
              Tab(text: 'Anotações'),
            ],
            labelColor: Colors.white,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                  width: 2.0,
                  color: Colors.white), // Cor e espessura da linha indicadora
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Conteúdo da aba 'Informações'
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        widget.livro.title,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          width: 150,
                          child: Image.network(
                            widget.livro.coverUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                'ISBN:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                widget.livro.isbn,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Páginas:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.livro.pageCount ?? "Não especificado"}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Autor(es):',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.livro.authors.join(', '),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Editora:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.livro.publisher,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sinopse:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.livro.synopsis ?? "Não disponível",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Conteúdo da aba 'Anotações'
            SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _anotacoesController,
                    decoration: InputDecoration(
                      labelText: 'Anotações',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _salvarAnotacoes();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.orange), // Cor de fundo do botão
                        foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white), // Cor do texto do botão
                      ),
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          fontSize: 16, // Tamanho do texto do botão
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _salvarAnotacoes() {
    String anotacoes = _anotacoesController.text.trim();
    setState(() {
      widget.livro.notes = anotacoes;
    });
    // **Adicionar persistência de dados aqui
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Anotações salvas com sucesso!'),
      ),
    );
  }

  @override
  void dispose() {
    _anotacoesController.dispose();
    super.dispose();
  }
}
