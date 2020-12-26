class BoardGame {
  //gamesgeek api
  // dynamic id;
  // dynamic rank;
  // dynamic image;
  // dynamic name;
  // dynamic yearPublished;
  // BoardGame({
  //   this.id,
  //   this.rank,
  //   this.image,
  //   this.name,
  //   this.yearPublished,
  // });
  // BoardGame.fromJson(dynamic json)
  //     : id = json['id'],
  //       rank = json['rank'],
  //       image = json['thumbnail']['value'],
  //       name = json['name']['value'],
  //       yearPublished = json['yearpublished']['value'];

  //game atlas api
  dynamic id;
  dynamic name;
  dynamic yearPublished;
  dynamic minPlayers;
  dynamic maxPlayers;
  dynamic minPlaytime;
  dynamic maxPlaytime;
  dynamic minAge;
  dynamic description;
  dynamic imageUrl;

  BoardGame.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'],
        yearPublished = json['year_published'],
        minPlayers = json['min_players'],
        maxPlayers = json['max_players'],
        minPlaytime = json['min_playtime'],
        maxPlaytime = json['max_playtime'],
        minAge = json['min_age'],
        description = json['description'],
        imageUrl = json['image_url'];
}
