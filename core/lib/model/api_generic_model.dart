import 'dart:convert';

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse<T> {
  ApiResponse({
    this.s = 0,
    this.m = "",
    this.r,
  });

  int s;
  String m;
  T? r;
  factory ApiResponse.fromBaseJson(Map<String, dynamic> json) => ApiResponse<T>(
    s: json["s"] == null ? null : json["s"],
    m: json["m"] == null ? null : json["m"],
  );

  bool get isValid => s==1;

  factory ApiResponse.fromStringJson(Map<String, dynamic> json,Function(String) create) => ApiResponse<T>(
    s: json["s"] == null ? null : json["s"],
    m: json["m"] == null ? null : json["m"],
    r: json["r"] == null ? null : create(json["r"]),
  );

  factory ApiResponse.fromMapJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) =>
      ApiResponse<T>(
        s: json["s"] == null ? null : json["s"],
        m: json["m"] == null ? null : json["m"],
        r: json["r"] == null ? null : create(json["r"]),
      );

  //FOR GETTING LIST OF MAPS
  factory ApiResponse.fromListJson(
      Map<String, dynamic> json, Function(List<dynamic>) create) =>
      ApiResponse<T>(
        s: json["s"] == null ? null : json["s"],
        m: json["m"] == null ? null : json["m"],
        r: json["r"] == null ? null : create(json["r"]),
      );

  //FOR GETTING OF MAPS
  factory ApiResponse.fromJson(
      Map<String, dynamic> json) =>
      ApiResponse<T>(
        s: json["s"] == null ? null : json["s"],
        m: json["m"] == null ? null : json["m"],
        r: json["r"] == null ? null : json["r"],
      );

  //FOR GETTING INTS
  factory ApiResponse.fromIntJson(
      Map<String, dynamic> json, Function(int) create) =>
      ApiResponse<T>(
        s: json["s"] == null ? null : json["s"],
        m: json["m"] == null ? null : json["m"],
        r: json["r"] == null ? null : create(json["r"]),
      );

  //Factory method for returning error models directly to the view
  factory ApiResponse.fromError(
      {String errorMessage = "Something went wrong"}) =>
      ApiResponse<T>(
        s: 0,
        m: errorMessage,
      );

  factory ApiResponse.fromEmpty(
      {String errorMessage = "Something went wrong"}) =>
      ApiResponse<T>(
        s: 0,
        m: errorMessage,
      );

  Map<String, dynamic> toJson() => {
    "s": s,
    "m": m,
    "r": r,
  };
}