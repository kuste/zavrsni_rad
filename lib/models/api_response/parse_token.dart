class ParsedToken {
  String nameId;
  String uniqueName;
  int nbf;
  int exp;
  int iat;
  String role;
  ParsedToken({
    this.nameId,
    this.uniqueName,
    this.nbf,
    this.exp,
    this.iat,
    this.role,
  });

  ParsedToken.fromJson(Map<String, dynamic> json)
      : nameId = json['nameid'],
        uniqueName = json['unique_name'],
        nbf = json['nbf'],
        exp = json['exp'],
        role = json['role'],
        iat = json['iat'];
}
