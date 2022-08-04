class Store_Model {

  final String store_location;
  final String storename;
  final List<dynamic> store_photo_links;
  final String store_cloud_id;
  final String store_category;
  final String store_phone;
  final String createdby_store;
  final String store_description;


  Store_Model({required
  this.store_location,
    required this.storename,
    required this.store_photo_links,
    required this.store_cloud_id,
    required this.store_category,
    required this.store_phone,
    required this.createdby_store,
    required this.store_description,
  });
}
