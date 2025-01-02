import 'dart:convert';

class Usuario {
    List<dynamic>? imagen;
    List<dynamic>? bicicletas;
    List<dynamic>? recorridos;
    String? id;
    String? nombre;
    String? apellidos;
    DateTime? fechaNacimiento;
    String? telefono;
    String? email;
    String? direccion;
    String? rol;

    Usuario({
        this.imagen,
        this.bicicletas,
        this.recorridos,
        this.id,
        this.nombre,
        this.apellidos,
        this.fechaNacimiento,
        this.telefono,
        this.email,
        this.direccion,
        this.rol,
    });

    factory Usuario.fromRawJson(String str) => Usuario.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        imagen: List<dynamic>.from(json["imagen"].map((x) => x)),
        bicicletas: List<dynamic>.from(json["bicicletas"].map((x) => x)),
        recorridos: List<dynamic>.from(json["recorridos"].map((x) => x)),
        id: json["_id"],
        nombre: json["nombre"],
        apellidos: json["apellidos"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        telefono: json["telefono"],
        email: json["email"],
        direccion: json["direccion"],
        rol: json["rol"],
    );

    Map<String, dynamic> toJson() => {
        "imagen": List<dynamic>.from(imagen!.map((x) => x)),
        "bicicletas": List<dynamic>.from(bicicletas!.map((x) => x)),
        "recorridos": List<dynamic>.from(recorridos!.map((x) => x)),
        "_id": id,
        "nombre": nombre,
        "apellidos": apellidos,
        "fecha_nacimiento": fechaNacimiento!.toIso8601String(),
        "telefono": telefono,
        "email": email,
        "direccion": direccion,
        "rol": rol,
    };
}
