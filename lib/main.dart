import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Completo',
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  
  // Key para el formulario
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para mostrar los resultados
  String _nombreCompleto = '';
  
  // Variables adicionales
  DateTime? _fechaNacimiento;
  String? _generoSeleccionado;
  bool _datosGuardados = false;

  // Variables para la imagen
  File? _imagenSeleccionada;
  final ImagePicker _imagePicker = ImagePicker();
  
  // Lista de géneros
  final List<String> _generos = ['Masculino', 'Femenino', 'Otro', 'Prefiero no decir'];

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
      _emailController.clear();
      _telefonoController.clear();
      _direccionController.clear();
      _nombreCompleto = '';
      _imagenSeleccionada = null;
      _fechaNacimiento = null;
      _generoSeleccionado = null;
      _datosGuardados = false;
    });
  }

  // Validar email
  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingresa un email válido';
    }
    return null;
  }

  // Validar teléfono
  String? _validarTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un teléfono';
    }
    if (value.length < 10) {
      return 'El teléfono debe tener al menos 10 dígitos';
    }
    return null;
  }

  // Seleccionar fecha de nacimiento
  Future<void> _seleccionarFecha() async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 años atrás
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaNacimiento = fechaSeleccionada;
      });
    }
  }

  // Guardar datos completos
  void _guardarDatos() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        String nombre = _nombreController.text.trim();
        String apellido = _apellidoController.text.trim();
        _nombreCompleto = '$nombre $apellido';
        _datosGuardados = true;
      });
      
      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Datos guardados exitosamente!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Calcular edad
  int _calcularEdad() {
    if (_fechaNacimiento == null) return 0;
    final ahora = DateTime.now();
    int edad = ahora.year - _fechaNacimiento!.year;
    if (ahora.month < _fechaNacimiento!.month ||
        (ahora.month == _fechaNacimiento!.month && ahora.day < _fechaNacimiento!.day)) {
      edad--;
    }
    return edad;
  }

  // Seleccionar imagen desde galería
  Future<void> _seleccionarImagenGaleria() async {
    final XFile? imagen = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path);
      });
    }
  }

  // Seleccionar imagen desde cámara
  Future<void> _seleccionarImagenCamara() async {
    final XFile? imagen = await _imagePicker.pickImage(source: ImageSource.camera);
    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path);
      });
    }
  }

  // Mostrar opciones para seleccionar imagen
  void _mostrarOpcionesImagen() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () {
                  _seleccionarImagenGaleria();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () {
                  _seleccionarImagenCamara();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget helper para mostrar información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Formulario Completo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Sección de imagen
                GestureDetector(
                  onTap: _mostrarOpcionesImagen,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(75),
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                    ),
                    child: _imagenSeleccionada != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(75),
                            child: Image.file(
                              _imagenSeleccionada!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Toca para agregar una foto',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 30),
                
                // Campo de nombre
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ingresa tu nombre',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo de apellido
                TextFormField(
                  controller: _apellidoController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                    hintText: 'Ingresa tu apellido',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa tu apellido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo de email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'ejemplo@correo.com',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validarEmail,
                ),
                const SizedBox(height: 20),

                // Campo de teléfono
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    hintText: '3001234567',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _validarTelefono,
                ),
                const SizedBox(height: 20),

                // Selector de fecha de nacimiento
                InkWell(
                  onTap: _seleccionarFecha,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.grey),
                        const SizedBox(width: 12),
                        Text(
                          _fechaNacimiento == null
                              ? 'Selecciona tu fecha de nacimiento'
                              : '${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}',
                          style: TextStyle(
                            color: _fechaNacimiento == null ? Colors.grey : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Dropdown de género
                DropdownButtonFormField<String>(
                  value: _generoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Género',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_2),
                  ),
                  items: _generos.map((String genero) {
                    return DropdownMenuItem<String>(
                      value: genero,
                      child: Text(genero),
                    );
                  }).toList(),
                  onChanged: (String? nuevoValor) {
                    setState(() {
                      _generoSeleccionado = nuevoValor;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona tu género';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo de dirección
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    hintText: 'Calle 123 #45-67',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa tu dirección';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Botones
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _concatenarNombres,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                          child: const Text('Ver Nombre'),
                        ),
                        OutlinedButton(
                          onPressed: _limpiarCampos,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                          child: const Text('Limpiar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _guardarDatos,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Guardar Todos los Datos',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Mostrar el resultado completo
                if (_datosGuardados) 
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '📋 Resumen de Datos Guardados',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildInfoRow('👤 Nombre Completo:', _nombreCompleto),
                        _buildInfoRow('📧 Email:', _emailController.text),
                        _buildInfoRow('📱 Teléfono:', _telefonoController.text),
                        if (_fechaNacimiento != null) ...[
                          _buildInfoRow(
                            '🎂 Fecha de Nacimiento:',
                            '${_fechaNacimiento!.day}/${_fechaNacimiento!.month}/${_fechaNacimiento!.year}',
                          ),
                          _buildInfoRow('🎯 Edad:', '${_calcularEdad()} años'),
                        ],
                        if (_generoSeleccionado != null)
                          _buildInfoRow('⚤ Género:', _generoSeleccionado!),
                        _buildInfoRow('🏠 Dirección:', _direccionController.text),
                        if (_imagenSeleccionada != null) ...[
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              Text(
                                '📸 Foto: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('✅ Imagen cargada'),
                            ],
                          ),
                        ],
                      ],
                    ),
                  )
                else
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
                              ? 'Completa el formulario y guarda los datos'
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
        ),
      ),
    );
  }
}