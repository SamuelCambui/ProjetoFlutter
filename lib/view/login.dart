import 'package:flutter/material.dart';
import 'package:teste/model/user.dart';
import 'package:teste/view/tela3.dart';
import 'package:intl/intl.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String status = '';

  Widget avaliation(BuildContext context) {
    return FutureBuilder<User?>(
      future: User.verificaUsuario(),
      builder: (context, snapshot) {
        // Verifica se há erro ao carregar o Future
        if (snapshot.hasError) {
          return Text('Erro ao verificar usuário: ${snapshot.error}');
        }

        // Verifica se o Future ainda está sendo processado
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Mostra um indicador de progresso enquanto verifica o usuário
        }

        // Verifica se o usuário foi encontrado
        if (snapshot.hasData && snapshot.data != null) {
          Navigator.pushNamed(context,
              '/inicio'); // Navega para tela de inicio se o usuário existir
        }

        // Caso contrário, retorna a interface de login
        return build(context);
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtém as dimensões da tela
    final screenSize = MediaQuery.of(context).size;
    //bool isImageOne = true;
    bool isPasswordVisible = false;

    double calculateFontSize(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      //determinar qual é o menor valor entre screenWidth e screenHeight
      final smallestDimension =
          screenWidth < screenHeight ? screenWidth : screenHeight;

      if (smallestDimension < 400) {
        return 18; // Fonte menor para telas estreitas
      } else if (screenWidth < 600) {
        return 20; // Fonte média para telas de tamanho médio
      } else {
        return 24; // Fonte maior para telas largas
      }
    }

    return Scaffold(
      //backgroundColor: Color(0xFF010920),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: Column(
            ////filhos de um widget alinhados ao longo do eixo x
            mainAxisAlignment: MainAxisAlignment.center,
            //filhos de um widget alinhados ao longo do eixo y
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, -180.0),
                child: Container(
                  margin: EdgeInsets.only(
                      //top: 8,
                      //right: 8,
                      //left: 8,
                      bottom: 20.0), // Define a margem
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Image(
                      image: AssetImage('assets/11.jpg'),
                      height: screenSize.height * 0.8,
                      //width: screenSize.width * 0.8,
                      width: screenSize.width,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -370.0),
                child: Column(
                  children: [
                    Text(
                      'Bem vindo de volta',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 6, 87),
                        fontSize: calculateFontSize(context) * 1.4,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Faça seu login',
                      style: TextStyle(
                        color: Color.fromARGB(255, 143, 144, 148),
                        fontSize: calculateFontSize(context) - 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Color.fromARGB(80, 185, 186, 192),
                      ),
                      child: TextField(
                        controller: userController,
                        cursorColor: Color.fromARGB(255, 255, 145, 0),
                        style: TextStyle(
                            color: Color.fromARGB(255, 2, 2, 2),
                            fontSize: calculateFontSize(context)),
                        decoration: InputDecoration(
                          hintText: 'Digite seu e-mail',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 143, 144, 148),
                            fontSize: calculateFontSize(context),
                          ),
                          alignLabelWithHint: true, // Define o texto do rótulo
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 7.5),
                          // Define a borda do campo de texto
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.height * 0.4,
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -355.0),
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Color.fromARGB(80, 185, 186, 192),
                  ),
                  child: TextField(
                    controller: passwordController,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: calculateFontSize(context)),
                    cursorColor: Color.fromARGB(255, 255, 145, 0),
                    maxLines: 1,
                    //scrollPhysics: AlwaysScrollableScrollPhysics(),
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Color.fromARGB(255, 143, 144, 148),
                          fontSize: calculateFontSize(context)),
                      //alignLabelWithHint: true, // Define o texto do rótulo
                      /*suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Image.asset(
                            isPasswordVisible
                                ? 'olhofechado.png'
                                : 'olhoaberto.png', // Ícone que você deseja adicionar
                            width: 24.0,
                            height: 24.0,
                          ), // Cor do ícone
                        ),
                        */
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical:
                              7.5), // Define o ícone à esquerda do campo de texto // Define a borda do campo de texto
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
              Transform.translate(
                offset: Offset(0, -320.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        String username = userController.text;
                        String pass = passwordController.text;
                        DateTime agora = DateTime.now();
                        String dataformada =
                            DateFormat('dd-MM-yy').format(agora);
                        User user = User(username, pass, dataformada);
                        user.autentica().then((value) {
                          if (value['resposta'] == 'ok') {
                            user.insereUsuario().then((value) {
                              if (value > 0)
                                Navigator.pushNamed(context, '/inicio');
                            });
                          } else {
                            setState(() {
                              status = value['motivo']!;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text('Erro de Autenticação',
                                      style: TextStyle(color: Colors.red)),
                                  content: Text(status,
                                      style: TextStyle(color: Colors.black)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                      child: Text('OK',
                                          style:
                                              TextStyle(color: Colors.orange)),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        });
                        return Container();
                      }),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Color.fromARGB(255, 255, 145, 0),
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 145, 0), // Cor da borda
                        width: 2.0, // Largura da borda
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: calculateFontSize(
                              context), // Tamanho da fonte do texto
                        ),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.height * 0.4,
                  ),
                ),
              ),
              Column(
                children: [
                  Transform.translate(
                    offset: Offset(0, -310.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        'Esqueceu sua senha?',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          decoration: TextDecoration.none,
                          fontSize: calculateFontSize(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Espaço entre os textos
                  Transform.translate(
                    offset: Offset(0, -280.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: const Color.fromARGB(255, 143, 144, 148),
                            fontSize: calculateFontSize(context),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Não possui uma conta? ',
                            ),
                            TextSpan(
                              text: 'Registre-se',
                              style: TextStyle(
                                color: Colors.orange, // Cor laranja
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
