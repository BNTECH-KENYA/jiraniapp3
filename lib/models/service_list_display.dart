import 'dart:ffi';

class Service_List_Display {

   final String service_location;
   final String service_name;
   final List<dynamic> service_photo_links;
   final String service_cloud_id;
   final String service_category;
   final String phone;
   final String created_by;


  Service_List_Display({required
    this.service_location,
    required this.service_name,
    required this.service_photo_links,
    required this.service_cloud_id,
    required this.service_category,
    required this.phone,
    required this.created_by,
  });
}
//servicename,phone, servicedesc, location, photosLinks
