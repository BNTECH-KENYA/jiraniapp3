class catagory {
  final String img;
  final String name;
  final String roundimg;
  final String roundimg2;

  catagory({
    required this.img,
    required this.name,
    required this.roundimg,
    required this.roundimg2,
  });
  static List<catagory> catagory1 = [
    catagory(
        img: "c1.jpeg",
        name: "Catering Services",
        roundimg: "f2.jpeg",
        roundimg2: "f3.jpeg"),
    catagory(
        img: "c2.jpeg",
        name: "Wedding Cleaning",
        roundimg: "f1.jpeg",
        roundimg2: "f3.jpeg"),
    catagory(
        img: "c3.jpeg",
        name: "office Cleaning",
        roundimg: "f1.jpeg",
        roundimg2: "f2.jpeg"),
    catagory(
        img: "c1.jpeg",
        name: "other Services",
        roundimg: "f2.jpeg",
        roundimg2: "f3.jpeg"),
  ];
}