import 'dart:convert';
import 'package:community_new/constants/styles.dart';
import 'package:community_new/models/organization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../api_services/api_services.dart';
import '../edit_organizationnew.dart';


class OrganizationList extends StatefulWidget {
  @override
  _OrganizationListState createState() => _OrganizationListState();
}

class _OrganizationListState extends State<OrganizationList> {
  final ApiServices apiService = ApiServices();

  List<Organization> organizations = [] ;

  _getOrganization()async {
    await ApiServices.fetch('organization').then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        organizations = list.map((model) => Organization.fromJson(model)).toList();
        //  print(response.body);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    _getOrganization();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: appColor,
          child: Icon(Icons.add,color: whiteColor,),
          onPressed: () {  Navigator.push(
              context, MaterialPageRoute(builder: (context) =>
              OrganizationEditnew(

                  organizationId: 0, isNew: true))); },
        ),
        appBar: AppBar(
          title: const Text('Organizations',style: TextStyle(color: whiteColor),),
          centerTitle: true,
          backgroundColor: appColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        backgroundColor: backgroundColor,
        body: organizations.isEmpty
            ? Center(child: Text('Empty'))
            : ListView.builder(
            itemCount: organizations.length,
            itemBuilder: (context, index) {
              return Column(children: [
                Card(
                    color: Colors.white,
                    elevation: 1.0,
                    child: ListTile(
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(organizations[index].parentId.toString()),
                      ),
                      onTap: null,
                      title: Row(
                        children: [
                          Text(organizations[index].Id.toString()),
                          widthSizedBox,
                          Text(organizations[index].name.toString()),
                          const Spacer(),
                          IconButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrganizationEditnew(
                                            isNew: false,
                                            organizationId : organizations[index]
                                                .Id
                                        )));
                              },
                              icon: FaIcon(FontAwesomeIcons.edit,color: blackColor,)),
                          widthSizedBox,
                          IconButton(
                              onPressed: () async {
                                await apiService.deleteFn(int.parse(
                                    organizations[index].Id.toString()),'organization');
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content:  Text("Organization Deleted Successfully")));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrganizationList(),
                                    ));
                              },
                              icon: FaIcon(FontAwesomeIcons.trash,color: blackColor,size: size,)),
                        ],
                      ),)
              ) ],);
            }));
  }
}
