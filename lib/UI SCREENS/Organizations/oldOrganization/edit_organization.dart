// import 'dart:convert';
//
// import 'package:community_app/models/CodeBook.dart';
// import 'package:community_app/models/keyvalue.dart';
// import 'package:community_app/constants/styles.dart';
// import 'package:community_app/models/organization.dart';
// import 'package:community_app/models/user.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../api_services/api_services.dart';
// import '../../models/code_book_values.dart';
// import '../../widgets/add_screen_text_field.dart';
// import '../../widgets/dropdown.dart';
// import '../Users/UserEdit.dart';
//
// class OrganizationEdit extends StatefulWidget {
//   final int? organizationId;
//   int? parentId;
//   //var jsondata;
//   //parent id currrently selected node
//   final bool isNew;
//    OrganizationEdit({Key? key,required this.isNew,required this.organizationId,
//    this.parentId,
//      //this.jsondata
//    }) : super(key: key);
//   @override
//   _OrganizationEditState createState() => _OrganizationEditState();
// }
// class _OrganizationEditState extends State<OrganizationEdit> {
//   var idcontroller = TextEditingController();
//   var OrganizationNameController = TextEditingController();
//   var countryController = TextEditingController();
//   var emailController = TextEditingController();
//   var addressLine1Controller = TextEditingController();
//   var phoneNoController = TextEditingController();
//   var zipCodeController = TextEditingController();
//   var descriptionController = TextEditingController();
//   var parentIdController = TextEditingController();
//   var stateController = TextEditingController();
//   var cityController = TextEditingController();
//   var orgTypeController= TextEditingController();
//   var addressLine2Controller = TextEditingController();
//   var dropdown = new DropDown(mylist: [] );
//   final _form = GlobalKey<FormState>(); //for storing form state.
//   var dropdownCodeBook = new DropDownCodebook(mylist: [] );
//   var organization = new Organization();
//   var codebook = CodeBook();
//   List<CodeBook> codebooks = [];
//   List<Organization> organizations = [] ;
//   List<KeyValue> Keyvaleus= [];
//   List<KeyValueCodeBook> Keyvaleuscodebook= [];
//   KeyValue? selectedKeyValue;
//   KeyValueCodeBook? selectedKeyValuecodebook;
//
//   Future<void> _saveForm(Organization organization) async{
//     final isValid = _form.currentState!.validate();
//     if (isValid) {
//       if(widget.isNew)
//       {
//         await ApiServices.postOrganization(organization);
//         ScaffoldMessenger.of(context)
//             .showSnackBar( const SnackBar(
//           content:Text("Organization Added Successfully"),));
//       }
//       else {
//         await ApiServices.postOrganizationbyid(idcontroller.text, organization );
//         ScaffoldMessenger.of ( context )
//             .showSnackBar ( const SnackBar (
//           content: Text ( "Organization Updated Successfully" ), ) );
//       }
//     }
//     else{
//       ScaffoldMessenger.of(context)
//           .showSnackBar( const SnackBar(
//         content:Text("Please fill form correctly"),));
//     }
//   }
//
//   _getOrganization() async{
//     await ApiServices.fetch("organization").then((response) {
//       setState ( () {
//         Iterable listorganizations = json.decode ( response.body);
//         // print(list);
//         organizations = listorganizations.map (
//                 (model) => Organization.fromJson ( model ) ).toList ( );
//         //org parent id dropdown
//         if (organizations.length > 0){
//           Keyvaleus.add ( new KeyValue( key: '0',
//               value: "Please select") );
//           for (int i = 0; i < organizations.length; i++){
//             Keyvaleus.add (
//                 new   KeyValue( key: organizations[i].Id.toString(),
//                 value: organizations[i].Id.toString() + "."+
//                     organizations[i].name.toString() + ':' +
//                     organizations[i].description.toString() ));
//           }
//         }
//       }
//       );
//     });
//
//     await ApiServices.fetchCodeBook("codebook",
//     tableName: "organization", codeName: "orgtype"
//     ).then((response) {
//       setState ( () {
//         Iterable listorganizations = json.decode ( response.body);
//         // print(list);
//         codebooks = listorganizations.map (
//                 (model) => CodeBook.fromJson ( model ) ).toList ( );
//         //org parent id dropdown
//         if (codebooks.length > 0){
//           Keyvaleuscodebook.add ( new KeyValueCodeBook( key: 0,
//               value: "Please select") );
//           for (int i = 0; i < codebooks.length; i++){
//             Keyvaleuscodebook.add (
//                 new   KeyValueCodeBook( key: codebooks[i].id,
//                     value: codebooks[i].display_Value.toString()  ));
//           }
//         }
//       }
//       );
//     });
//
//     print(Keyvaleus.length);
//     print(Keyvaleuscodebook.length);
//
//     if(widget.isNew==false) {
//       await ApiServices.fetchForEdit ( widget.organizationId , 'organization' )
//           .then ( (response) {
//         setState ( () {
//           var userBody = json.decode ( response.body );
//           organization = Organization.fromJson ( userBody );
//           if (organization != null) {
//             idcontroller.text = organization.Id.toString ( );
//            // idcontroller.text = widget.jsondata.toString ();
//             emailController.text = organization.Email.toString ( );
//             countryController.text = organization.country.toString ( );
//             addressLine1Controller.text = organization.address1.toString ( );
//             addressLine2Controller.text = organization.address2.toString ( );
//            OrganizationNameController.text=organization.name.toString();
//            descriptionController.text = organization.description.toString();
//            cityController.text=organization.city.toString();
//            parentIdController.text =organization.parentId.toString();
//            phoneNoController.text = organization.phoneNo.toString();
//            zipCodeController.text = organization.zipCode.toString();
//            stateController.text = organization.state.toString();
//            orgTypeController.text=organization.orgType.toString();
//
//             if (organization.parentId != "null" &&
//                 organization.parentId != null) {
//               //  print(user.default_Role_Id.toString()+" user edit");
//               //_selected_default_Role_Id=user.default_Role_Id;
//               //print(_selected_default_Role_Id.toString()+" user edit");
//               //_selected_default_Role_Id=user.default_Role_Id;
//               //dropdown.seletected_default_Role_Id=user.default_Role_Id;
//               selectedKeyValue = Keyvaleus.firstWhere ( (element) =>
//               element.key == organization.parentId );
//               //dropdown.seletected_value=selectedKeyValue;
//             }
//
//             // if (organization.orgType != "null" &&
//             //     organization.orgType != null) {
//             //   selectedKeyValuecodebook = Keyvaleuscodebook.firstWhere ( (element) =>
//             //   element.key == organization.orgType );
//             // }
//
//           }
//         } );
//       } );
//     }else{
//       if (widget.parentId != "null" &&
//           widget.parentId != null) {
//         //  print(user.default_Role_Id.toString()+" user edit");
//         //_selected_default_Role_Id=user.default_Role_Id;
//         //print(_selected_default_Role_Id.toString()+" user edit");
//         //_selected_default_Role_Id=user.default_Role_Id;
//         //dropdown.seletected_default_Role_Id=user.default_Role_Id;
//         selectedKeyValue = Keyvaleus.firstWhere ( (element) =>
//         element.key == widget.parentId );
//         //dropdown.seletected_value=selectedKeyValue;
//       }
//
//       // if (organization.orgType != "null" &&
//       //     organization.orgType != null) {
//       //   selectedKeyValuecodebook = Keyvaleuscodebook.firstWhere ( (element) =>
//       //   element.key == organization.orgType );
//       // }
//       parentIdController.text =widget.parentId.toString();
//       orgTypeController.text =organization.orgType.toString();
//     }
//     dropdown=new DropDown(mylist: Keyvaleus,
//         seletected_value: selectedKeyValue);
//
//     dropdownCodeBook=new DropDownCodebook(mylist: Keyvaleuscodebook,
//         seletected_value: selectedKeyValuecodebook);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _getOrganization();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           backgroundColor: backgroundColor,
//           body: SingleChildScrollView(
//             child: Form(
//               key: _form,
//               child: Stack(
//                 children: [
//                   IconButton(onPressed: (){
//                     Navigator.pop(context);
//                   }, icon: Icon(Icons.arrow_back)),
//                   Column(
//                     children: [
//                       SizedBox(height: MediaQuery.of(context).size.height/10,),
//
//                       Center(child:widget.isNew==false? Text("Edit Organization",style: TextStyle(fontSize: 24),):
//                       Text("Add Organization",style: TextStyle(fontSize: 24),),),
//                       midPadding2,
//                       AddScreenTextFieldWidget(
//                         p_readOnly: true,
//                         labelText: "Id",
//                         obsecureText: false,
//                         controller: idcontroller,
//                         textName: organization.Id.toString(),
//                         inputType: TextInputType.none,
//                       ),
//
//                       // AddScreenTextFieldWidget(
//                       //   p_readOnly: true,
//                       //   labelText: "Id",
//                       //   obsecureText: false,
//                       //   controller: idcontroller,
//                       //   textName: widget.jsondata.toString(),
//                       //   inputType: TextInputType.none,
//                       // ),
//                       AddScreenTextFieldWidget(
//                         labelText: "Organization Name",
//                         obsecureText: false,
//                         controller:OrganizationNameController ,
//                         textName:  organization.name.toString(),  inputType: TextInputType.name,
//                         validator: (text) {
//                           if (!(text!.length > 5) && text.isNotEmpty) {
//                             return "Enter Organization name of more then 5 characters!";
//                           }
//                           return null;
//                         },
//                       ),
//                       const Padding(
//                         padding: const EdgeInsets.only(top: 8.0,bottom: 8,left: 17),
//                         child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text("Organization Parent Id",
//                               style: BlackTextStyleNormal16,)),
//                       ),
//                       dropdown,
//                       const Padding(
//                         padding: const EdgeInsets.only(top: 10.0,bottom: 8,left: 17),
//                         child: Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text("Organization Type",
//                               style: BlackTextStyleNormal16,)),
//                       ),
//                       dropdownCodeBook,
//                       AddScreenTextFieldWidget(
//                         labelText: "Country",
//                         obsecureText: false,
//                         controller: countryController,
//                         textName: organization.country.toString(),
//                         inputType: TextInputType.name,
//                         validator: (text) {
//                           if (!(text!.length > 2) && text.isNotEmpty) {
//                             return "*Required";
//                           }
//                           return null;
//                         },
//                       ),
//                       AddScreenTextFieldWidget(
//                         labelText: "Email",
//                         obsecureText: false,
//                         controller: emailController,
//                         textName:organization.Email.toString(),
//                         inputType: TextInputType.emailAddress,
//                         validator: (value){
//                           if(value!.isEmpty)
//                           {
//                             return 'Please Enter your email';
//                           }
//                           if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").
//                           hasMatch(value)){
//                             return 'Please enter a valid Email';
//                           }
//                           return null;
//                         },
//
//                       ),
//                       AddScreenTextFieldWidget(
//                         labelText: "Address Line 1",
//                         obsecureText: false,
//                         controller: addressLine1Controller,
//                         textName: organization.address1.toString(),
//                         inputType: TextInputType.name,
//                         validator: (text) {
//                           if (!(text!.length > 5) && text.isNotEmpty) {
//                             return "*Required";
//                           }
//                           return null;
//                         },
//                       ),
//                       AddScreenTextFieldWidget(
//                         labelText: "Address Line  (Optional)",
//                         obsecureText: false,
//                         controller: addressLine2Controller,
//                         textName: organization.address2.toString(),
//                         inputType: TextInputType.name,
//                       ),
//                       AddScreenTextFieldWidget(
//                         labelText: "State",
//                         obsecureText: false,
//                         controller: stateController,
//                         textName: organization.state.toString(),
//                         inputType: TextInputType.name,
//                         validator: (text) {
//                           if (!(text!.length > 1) && text.isNotEmpty) {
//                             return "*Required";
//                           }
//                           return null;
//                         },
//                       ),
//                       AddScreenTextFieldWidget(
//                         labelText: "City",
//                         obsecureText: false,
//                         controller: cityController,
//                         textName: organization.city.toString(),
//                         inputType: TextInputType.name,
//                         validator: (text) {
//                           if (!(text!.length > 4) && text.isNotEmpty) {
//                             return "*Required";
//                           }
//                           return null;
//                         },
//                       ),
//                       AddScreenTextFieldWidget(
//                         labelText: "Postal Code",
//                         obsecureText: false,
//                         controller: zipCodeController,
//                         textName: organization.zipCode.toString(),
//                         inputType: TextInputType.name,
//                         validator: (text) {
//                           if ( text!.isEmpty) {
//                             return "*Required";
//                           }
//                           return null;
//                         },
//                       ),
//                       AddScreenTextFieldWidget(
//                         labelText: "Phone Number",
//                         obsecureText: false,
//                         controller: phoneNoController,
//                         textName: organization.phoneNo.toString(),
//                         inputType: TextInputType.number,
//                         validator: (text) {
//                           if (!(text!.length > 4) && text.isNotEmpty) {
//                             return "*Required";
//                           }
//                           return null;
//                         },
//                       ),
//                       AddScreenTextFieldWidget(
//                         labelText: "Description",
//                         obsecureText: false,
//                         controller: descriptionController,
//                         textName: organization.description.toString(),
//                         inputType: TextInputType.name,
//                         validator: (text) {
//                           if (!(text!.length > 5) && text.isNotEmpty) {
//                             return "Description should not be "
//                                 "less than 5 characters";
//                           }
//                           return null;
//                         },
//                       ),
//                       midPadding,
//                       Container(
//                         width: MediaQuery.of(context).size.width/4,
//                         child: ElevatedButton(
//                           onPressed: () async{
//                             Organization organization ;
//                             if(!widget.isNew) {
//                               organization= Organization.WithId (
//                                   Id: int.parse ( idcontroller.text ),
//                                   parentId: int.parse(parentIdController.text),
//                                   name: OrganizationNameController.text,
//                                   Email: emailController.text,
//                                   country: countryController.text,
//                                 zipCode: zipCodeController.text,
//                                 city: cityController.text,
//                                 address1: addressLine1Controller.text,
//                                 address2: addressLine2Controller.text,
//                                 description: descriptionController.text,
//                                 phoneNo: phoneNoController.text,
//                                 state: stateController.text,
//                                 orgType: orgTypeController.text
//                               );
//                             }
//                             else
//                             {
//                               organization= Organization (
//                                   parentId: int.parse(parentIdController.text),
//                                   name: OrganizationNameController.text,
//                                   Email: emailController.text,
//                                   country: countryController.text,
//                                   zipCode: zipCodeController.text,
//                                   city: cityController.text,
//                                   address1: addressLine1Controller.text,
//                                   address2: addressLine2Controller.text,
//                                   description: descriptionController.text,
//                                   phoneNo: phoneNoController.text,
//                                   state: stateController.text,
//                                   orgType: orgTypeController.text
//
//                               );
//                             }
//                             await _saveForm(organization);
//
//                           },
//                           style: ElevatedButton.styleFrom(
//                               primary: Colors.blue, // background
//                               onPrimary: Colors.white,
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.all(Radius.circular(24))
//                               )// foreground
//                           ),
//                           child: const Text("Save"),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           )
//       ),
//     );
//   }
// }
//
