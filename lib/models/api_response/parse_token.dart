class ParsedToken {
  String nameId;
  String uniqueName;
  int nbf;
  int exp;
  int iat;
  ParsedToken({
    this.nameId,
    this.uniqueName,
    this.nbf,
    this.exp,
    this.iat,
  });

  ParsedToken.fromJson(Map<String, dynamic> json)
      : nameId = json['nameid'],
        uniqueName = json['unique-name'],
        nbf = json['nbf'],
        exp = json['exp'],
        iat = json['iat'];
}
