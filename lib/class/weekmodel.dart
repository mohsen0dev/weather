
class weekModel{
  var _dateTime;
  var _temp;
  String _main;
  String _description;
  String _icoon;


  weekModel(this._dateTime, this._temp, this._main, this._description, this._icoon);

  String get description => _description;

  String get main => _main;

  get temp => _temp;

  get dateTime => _dateTime;
  get icoon => _icoon;

}