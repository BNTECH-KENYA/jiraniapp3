class task {
  final String imgpath;
  final String taskname;
  final String bgimgpath;

  task({required
    this.imgpath,
    required this.taskname,
    required this.bgimgpath,
  });

  static List<task> taskk = [
    task(imgpath: "1.svg", taskname: "Brian Sofware Corner", bgimgpath: "1.png"),
    task(
        imgpath: "2.svg",
        taskname: "Jane Audit Services",
        bgimgpath: "2.png"),
    task(imgpath: "3.svg", taskname: "Muthoni Catering Corner", bgimgpath: "3.png"),
    task(imgpath: "1.svg", taskname: "Muringo Health Screening", bgimgpath: "4.png"),
  ];
}