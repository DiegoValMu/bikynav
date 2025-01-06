import 'dart:convert';

class CountryData {
    final String name;
    final List<Region> regions;

    CountryData({
        required this.name,
        required this.regions,
    });

    factory CountryData.fromJson(String str) => CountryData.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CountryData.fromMap(Map<String, dynamic> json) => CountryData(
        name: json["name"],
        regions: List<Region>.from(json["regions"].map((x) => Region.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "regions": List<dynamic>.from(regions.map((x) => x.toMap())),
    };
}

class Region {
    final String name;
    final String romanNumber;
    final String number;
    final String abbreviation;
    final List<Commune> communes;

    Region({
        required this.name,
        required this.romanNumber,
        required this.number,
        required this.abbreviation,
        required this.communes,
    });

    factory Region.fromJson(String str) => Region.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Region.fromMap(Map<String, dynamic> json) => Region(
        name: json["name"],
        romanNumber: json["romanNumber"],
        number: json["number"],
        abbreviation: json["abbreviation"],
        communes: List<Commune>.from(json["communes"].map((x) => Commune.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "name": name,
        "romanNumber": romanNumber,
        "number": number,
        "abbreviation": abbreviation,
        "communes": List<dynamic>.from(communes.map((x) => x.toMap())),
    };
}

class Commune {
    final String name;

    Commune({
        required this.name,
    });

    factory Commune.fromJson(String str) => Commune.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Commune.fromMap(Map<String, dynamic> json) => Commune(
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "name": name,
    };
}
