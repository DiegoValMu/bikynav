import 'package:bikynav/features/bikes/app/services/bike_services.dart';
import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:bikynav/features/users/app/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBikeScreen extends StatelessWidget {
  const AddBikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: _buildAppBar(context),
        ),
      ),
      body: const _RegisterBikeForm(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Registrar bicicleta'),
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
    );
  }
}

class _RegisterBikeForm extends StatefulWidget {
  const _RegisterBikeForm({super.key});

  @override
  State<_RegisterBikeForm> createState() => _RegisterBikeFormState();
}

class _RegisterBikeFormState extends State<_RegisterBikeForm> with WidgetsBindingObserver {
  final etiquetaController = TextEditingController();
  final marcaController = TextEditingController();
  final modeloController = TextEditingController();
  final numeroDeSerieController = TextEditingController();

  List<String> aro = ['650C (26")', '27,5"', '700C (28")', '29"'];
  List<String> tipo = ['MTB', 'Ruta', 'Urbana'];
  List<String> modeloCuadro = ['Femenino', 'Masculino','Unisex'];
  List<String> talla = ['S', 'M', 'M/L', 'L', 'XL'];

  List<String> colores = [
    'Rojo', 'Azul', 'Verde', 'Amarillo', 'Negro', 'Blanco', 'Naranja', 'Morado'
  ];

  String? selectedAro;
  String? selectedTipo;
  String? selectedModeloCuadro;
  String? selectedTalla;
  String? selectedColorPrincipal;

  bool _isKeyboardVisible = false; 

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

 
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userServices = Provider.of<UserServices>(context, listen: false);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only( top: 16 ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric( horizontal:  16.0),
                    child: ExpansionTile(
                      leading: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){}, 
                        icon: const Icon( Icons.info )),
                      title: const Text(
                        'Información básica',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      initiallyExpanded: true,
                      maintainState: true,
                      tilePadding: EdgeInsets.zero, // Quita el padding del encabezado
                      childrenPadding: EdgeInsets.zero, // Elimina el padding extra de los hijos
                      collapsedBackgroundColor: Colors.white, // Asegura el fondo blanco cerrado
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      children: [ 
                        Column(
                          children: [
                            const Divider(),
                            CustomTextFormField(
                              controller: etiquetaController,
                              icon: Icons.edit,
                              placeholder: 'Etiqueta',
                              inputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              controller: marcaController,
                              icon: Icons.directions_bike,
                              placeholder: 'Marca',
                              inputType: TextInputType.name,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              controller: modeloController,
                              icon: Icons.build,
                              placeholder: 'Modelo',
                              inputType: TextInputType.name,
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Color principal',
                                prefixIcon: const Icon(Icons.colorize_sharp, color: Colors.grey),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              value: selectedColorPrincipal,
                              items: colores
                                  .map((color) => DropdownMenuItem(
                                        value: color,
                                        child: Text(color),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedColorPrincipal = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ]
                    ),
                  )
                ),
                
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ExpansionTile(
                      leading: IconButton(
                        onPressed: (){}, 
                        icon: const Icon( Icons.info )),
                      title: const Text(
                        'Información técnica',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      maintainState: true,
                      tilePadding: EdgeInsets.zero, // Quita el padding del encabezado
                      childrenPadding: EdgeInsets.zero, // Elimina el padding extra de los hijos
                      collapsedBackgroundColor: Colors.white, // Asegura el fondo blanco cerrado
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide.none),
                      children: [
                        const Divider(),
                        CustomTextFormField(
                          controller: numeroDeSerieController,
                          icon: Icons.qr_code_2,
                          placeholder: 'Número de serie',
                          inputType: TextInputType.name,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Tipo',
                            prefixIcon: const Icon(Icons.category, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedTipo,
                          items: tipo
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            selectedTipo = value; // Si necesitas actualizar un valor, hazlo aquí
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Aro',
                            prefixIcon: const Icon(Icons.height, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedAro,
                          items: aro
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            selectedAro = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Modelo de cuadro',
                            prefixIcon: Icon(
                              selectedModeloCuadro == 'Femenino'
                                  ? Icons.female
                                  : selectedModeloCuadro == 'Masculino'
                                      ? Icons.male
                                      : Icons.transgender,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedModeloCuadro,
                          items: modeloCuadro
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            selectedModeloCuadro = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Talla',
                            prefixIcon: const Icon(Icons.straighten, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          value: selectedTalla,
                          items: talla
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            selectedTalla = value;
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                (_isKeyboardVisible)
                ? Text('')
                : Align(
                  alignment: Alignment.bottomCenter,
                  child: FilledButton(
                    child: const Text('Registrar'),
                    onPressed: () async {
                      // TODO: Save bike data

                      final etiqueta = etiquetaController.text.trim();
                      final marca = marcaController.text.trim();
                      final modelo = modeloController.text.trim();
                      final codigoSerie = numeroDeSerieController.text.trim();

                      final bike = <String, dynamic>{
                        'etiqueta': etiqueta,
                        'marca': marca,
                        'modelo': modelo,
                        'codigo_serie': codigoSerie,
                        'color_principal': selectedColorPrincipal,
                        'tipo': selectedTipo,
                        'aro': selectedAro,
                        'modelo_cuadro': selectedModeloCuadro,
                        'talla': selectedTalla,
                        'usuario': userServices.usuario.id
                      };

                      try {
                        final bikeServices = Provider.of<BikeServices>(context, listen: false);
                        await bikeServices.bikeRegister(bike);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Problemas con el servicio $e")),
                        );
                        Navigator.of(context).pop();
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Bicicleta registrada correctamente")),
                      );
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
