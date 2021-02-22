//game api
const String _apiKey = 'W0AQGbjlZE';
const String _apiBaseUrl = 'https://www.boardgameatlas.com/api';
const String kApiUrl = '$_apiBaseUrl/search?order_by=popularty&ascending=false&pretty=true&client_id=$_apiKey';

//base conn string
const String _baseAuthConnString = 'https://localhost:44397/Auth/';
const String _baseDataConnString = 'https://localhost:44397/Data/';

//auth api
const String kConnLogin = '${_baseAuthConnString}Login';
const String kConnRegister = '${_baseAuthConnString}Register';

//data api
const String kConnDataGetAll = '${_baseDataConnString}GetAll';
const String kConnDataGetAllForUser = '${_baseDataConnString}GetAllForUser';
const String kConnDataAdd = '${_baseDataConnString}AddEvent';
const String kConnDataDelete = '${_baseDataConnString}DeleteEvent';
const String kSaveSelectedEvents = '${_baseDataConnString}SaveSelectedEvents';
