class ResponseDto {
  String termsofuse;
  List<dynamic> item;
  ResponseDto({
    this.termsofuse,
    this.item,
  });

  ResponseDto.fromJson(dynamic json)
      : termsofuse = json['items']['termsofuse'],
        item = json['items']['item'];
}
