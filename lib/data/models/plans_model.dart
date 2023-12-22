class Plan {
  static List<Map<String, dynamic>> plans = [];
  static List<String> coverages = [];
  static Map<String, double> metrics = {
    '1': 370, // width for coverages
    '2': 155, // width for plans, boxes and inkwell
    '3': 30, // height of the boxes *calculated*
    '4': 100, // Positioned top for the boxes
    '5': 370, // Positioned left for the boxes and inkwell
    '6': 80, // height for the inkwell *calculated*
  };

  void fromJson(response) {
    plans = response['plans'];
    coverages = response['coverages'];
    metrics['3'] =
        (22 * int.parse(response['metrics']['valuesInBox'].toString())) -
            (int.parse(response['metrics']['valuesInBox'].toString()) - 1);
    metrics['6'] = 100 +
        (22 * coverages.length) +
        (coverages.length / 2) -
        (coverages.length - 1);
  }
}
