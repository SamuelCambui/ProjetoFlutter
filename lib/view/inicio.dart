import 'package:flutter/material.dart';
import 'package:teste/model/user.dart';
import 'package:teste/model/apibrasil.dart';
import 'package:teste/model/book.dart';
import 'detalhes.dart';

class inicio extends StatefulWidget {
  const inicio({Key? key}) : super(key: key);

  @override
  _inicioState createState() => _inicioState();
}

class _inicioState extends State<inicio> {
  late TextEditingController _isbnController;
  late TextEditingController _tituloController;
  late List<Book> _livros;
  List<Book> _livrosFiltrados = [];
  bool _mostrarCampoPesquisa = false;

  @override
  void initState() {
    super.initState();
    _isbnController = TextEditingController();
    _tituloController = TextEditingController();
    _livros = [];
    _livrosFiltrados = [];
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    List<String> isbnList = [
      '9788545702870', // Akira
      //'9788593695025', // Moby Dick
      //'8533619626', // O senhor dos aneis
      //'978-65-5097-120-5', // O pequeno principe
      //'978-85-8070-079-4', // A divina comedia
      //'9788545102137', // Dom quixote
      //'978-65-5692-005-4', // O apanhador no campo de centeio
      //'9788566798401', // Crime e Castigo
      //'978-65-87036-47-2', // Guerra e Paz
    ];

    try {
      for (String isbn in isbnList) {
        Book book = await ApiBrasil.getBookInfo(isbn);
        setState(() {
          _livros.add(book);
          _livrosFiltrados = List.of(_livros);
        });
      }
    } catch (e) {
      print('Erro ao carregar livros: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minha Biblioteca"),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            User? user = await User.verificaUsuario();
            if (user != null) {
              int ret = await user.removerUsuario();
              if (ret == 1) {
                Navigator.pushNamed(context, '/login');
              } else {
                final snackBar = SnackBar(
                  content: const Text('Não foi possível remover o usuário'),
                  backgroundColor: Colors.amber,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _mostrarCampoPesquisa = true;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_mostrarCampoPesquisa || _tituloController.text.isNotEmpty)
            Container(
              color: Colors.orange,
              padding: EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: _tituloController,
                decoration: InputDecoration(
                  hintText: 'Pesquisar por título...',
                  filled: true,
                  fillColor: Colors.orange,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                onChanged: (value) {
                  _pesquisarLivroPorTitulo(value);
                },
                onEditingComplete: () {
                  if (_tituloController.text.isEmpty) {
                    setState(() {
                      _mostrarCampoPesquisa = false;
                    });
                  }
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _livrosFiltrados.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Detalhes(livro: _livrosFiltrados[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(_livrosFiltrados[index].title),
                      subtitle:
                          Text(_livrosFiltrados[index].authors.join(', ')),
                      trailing: Image.network(_livrosFiltrados[index].coverUrl),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirPopupISBN(context);
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
    );
  }

  void _exibirPopupISBN(BuildContext context) async {
    bool _isLoading = false;

    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Adicionar Livro"),
              content: Container(
                height: _isLoading ? 100.0 : 80.0,
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : TextField(
                        controller: _isbnController,
                        decoration: InputDecoration(
                          labelText: 'ISBN',
                          border: OutlineInputBorder(),
                        ),
                      ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Adicionar'),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          String isbn = _isbnController.text.trim();
                          if (isbn.isNotEmpty) {
                            try {
                              setState(() {
                                _isLoading = true;
                              });

                              // Verificar se o livro já existe
                              String isbnNormalizado = _normalizarISBN(isbn);
                              bool livroJaExiste = _livros.any((livro) =>
                                  _normalizarISBN(livro.isbn) ==
                                  isbnNormalizado);
                              if (livroJaExiste) {
                                throw Exception(
                                    'Este livro já foi adicionado.');
                              }

                              // Obter informações do livro
                              Book book = await ApiBrasil.getBookInfo(isbn);

                              // Atualizar o estado para adicionar o livro
                              setState(() {
                                _livros.add(book);
                                _livrosFiltrados =
                                    List.of(_livros); // Clonar a lista
                              });

                              // Indicar que a operação foi concluída
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Livro adicionado com sucesso!'),
                                ),
                              );

                              // Fechar o AlertDialog com sucesso (retorna true)
                              Navigator.of(context).pop(true);
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Erro ao adicionar livro: $error'),
                                ),
                              );
                            } finally {
                              // Finaliza o loading (após sucesso ou erro)
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Por favor, insira um ISBN válido.'),
                              ),
                            );
                          }
                        },
                ),
              ],
            );
          },
        );
      },
    );

    // Após fechar o popup, verificar o resultado
    if (result != null && result == true) {
      // Se o livro foi adicionado com sucesso, atualizar a tela principal
      setState(() {});
    }
  }

  void _pesquisarLivroPorTitulo(String titulo) {
    titulo = titulo.trim();
    if (titulo.isNotEmpty) {
      setState(() {
        _livrosFiltrados = _livros
            .where((livro) =>
                livro.title.toLowerCase().contains(titulo.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        _livrosFiltrados = List.of(_livros); // Exibir todos os livros novamente
      });
    }
  }

  String _normalizarISBN(String isbn) {
    return isbn.replaceAll(RegExp(r'[^0-9]'), '');
  }

  @override
  void dispose() {
    _isbnController.dispose();
    _tituloController.dispose();
    super.dispose();
    
  }
}
