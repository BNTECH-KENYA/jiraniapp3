
class ChatModel{

  String name;
  String icon;
  String time;
  String currentMessage;
  String groupidmd;
  bool select = false;

  ChatModel(
  {required this.name, required this.icon, required this.time,required this.currentMessage,
    required this.select, required this.groupidmd}
      );
}