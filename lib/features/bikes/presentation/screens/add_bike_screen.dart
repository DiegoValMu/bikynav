import 'package:bikynav/features/nav/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () {
            // TODO: Save bike data
            Navigator.pop(context);
          },
        ),
      ],
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

class _RegisterBikeFormState extends State<_RegisterBikeForm> {
  final _etiquetaController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _numeroDeSerieController = TextEditingController();

  List<String> aro = ['650C (26")', '27,5"', '700C (28")', '29"'];
  List<String> tipo = ['MTB', 'Ruta', 'Gravel'];
  List<String> modeloCuadro = ['Masculino', 'Femenino'];
  List<String> talla = ['S', 'M', 'M/L', 'L', 'XL'];

  List<String> colores = [
    'Rojo', 'Azul', 'Verde', 'Amarillo', 'Negro', 'Blanco', 'Naranja', 'Morado'
  ];

  String? selectedAro;
  String? selectedTipo;
  String? selectedModeloCuadro;
  String? selectedTalla;
  String? selectedColorPrincipal;

  @override
  Widget build(BuildContext context) {
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
                              controller: _etiquetaController,
                              icon: Icons.edit,
                              placeholder: 'Etiqueta',
                              inputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              controller: _marcaController,
                              icon: Icons.directions_bike,
                              placeholder: 'Marca',
                              inputType: TextInputType.name,
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              controller: _modeloController,
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
                          controller: _numeroDeSerieController,
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
