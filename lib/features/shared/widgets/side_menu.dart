import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Rastreador de dulces')),
          ListTile(
            leading: Icon(Icons.dashboard_outlined),
            title: Text('Dashboar'),
            subtitle: Text('Crear o editar un punto'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => context.push('/'),
          ),
        ],
      ),
    );
  }
}
