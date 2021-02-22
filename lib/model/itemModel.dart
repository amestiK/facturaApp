import 'dart:convert';

List<Item> itemFromJson(String str) =>
    List<Item>.from(json.decode(str).map((x) => Item.fromJson(x)));

String itemToJson(List<Item> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Item {
  Item({
    this.item,
  });

  ItemClass item;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        item: ItemClass.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "item": item.toJson(),
      };
}

class ItemClass {
  ItemClass({
    this.item1,
    this.item2,
    this.item3,
  });

  String item1;
  String item2;
  String item3;

  factory ItemClass.fromJson(Map<String, dynamic> json) => ItemClass(
        item1: json["item1"],
        item2: json["item2"],
        item3: json["item3"],
      );

  Map<String, dynamic> toJson() => {
        "item1": item1,
        "item2": item2,
        "item3": item3,
      };
}
