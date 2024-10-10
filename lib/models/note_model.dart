class NoteModel{
  String title;
  String desc;
  String? uid;
  NoteModel({required this.title,required this.desc,this.uid});

  factory NoteModel.fromDoc(Map<String,dynamic>doc){
    return NoteModel(title: doc['title'], desc: doc['desc']);
  }

  Map<String,dynamic> toMap(){
    return {
      'title': title,
      'desc' : desc,
      'uid' : uid
    };
  }
}