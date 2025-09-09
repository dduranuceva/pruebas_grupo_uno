import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Nombre y Apellido',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FormularioPage(),
    );
  }
}

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  // Controladores para los campos de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();

  // Variable para mostrar el resultado
  String _nombreCompleto = '';

  // Función para concatenar nombre y apellido
  void _concatenarNombres() {
    setState(() {
      String nombre = _nombreController.text.trim();
      String apellido = _apellidoController.text.trim();

      if (nombre.isNotEmpty && apellido.isNotEmpty) {
        _nombreCompleto = '$nombre $apellido';
      } else if (nombre.isNotEmpty) {
        _nombreCompleto = nombre;
      } else if (apellido.isNotEmpty) {
        _nombreCompleto = apellido;
      } else {
        _nombreCompleto = 'Por favor ingresa nombre y apellido';
      }
    });
  }

  // Limpiar los campos
  void _limpiarCampos() {
    setState(() {
      _nombreController.clear();
      _apellidoController.clear();
      _nombreCompleto = '';
    });
  }

  @override
  void dispose() {
    // Liberar los controladores cuando el widget se destruye
    _nombreController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Formulario de Nombres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Campo de texto para el nombre
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ingresa tu nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 20),

            // Campo de texto para el apellido
            TextField(
              controller: _apellidoController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                hintText: 'Ingresa tu apellido',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 30),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _concatenarNombres,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Mostrar Nombre Completo'),
                ),
                OutlinedButton(
                  onPressed: _limpiarCampos,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Mostrar el resultado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Nombre Completo:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _nombreCompleto.isEmpty
                        ? 'Aquí aparecerá tu nombre completo'
                        : _nombreCompleto,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _nombreCompleto.isEmpty
                          ? Colors.grey
                          : Colors.deepPurple,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
