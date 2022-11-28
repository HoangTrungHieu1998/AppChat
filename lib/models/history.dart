import 'package:skype_clone/models/log.dart';

class History {
    List<Log>? history;

    History({this.history});

    factory History.fromJson(Map<String, dynamic> json) {
        return History(
            history: json['history'] != null ? (json['history'] as List).map((i) => Log.fromJson(i)).toList() : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        if (history != null) {
            data['history'] = history!.map((v) => v.toMap()).toList();
        }
        return data;
    }
}