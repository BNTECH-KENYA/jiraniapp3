
class GroupListModel{

  String groupname;
  String groupid;
  String groupprofilepic;
  String category;

  /*

   "groupname":groupname,
      "groupprofilepic":groupprofilepic,
      "category": groupcategory,
      "location": location,
      "documentlinks":documentlinks,
      "contributors":contributorsPhones,
      "toppingClassifier":FieldValue.serverTimestamp(),
      "latestContribution":"Group Created by: name",
      "createdby": {
        "phonenumber":uidAccess,
        "name": user_name,
   */

  GroupListModel(
      {
        required this.groupname,
        required this.groupid,
        required this.groupprofilepic,
        required this.category,

      }
      );
}