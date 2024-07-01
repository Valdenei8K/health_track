import 'package:flutter/material.dart';

dialogDelete({
  required BuildContext context,
  required int index,
  Function()? onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirmar exclusão"),
        content: Text("Tem certeza que deseja excluir este lembrete?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o AlertDialog
            },
          ),
          TextButton(child: Text("Excluir"), onPressed: onPressed),
        ],
      );
    },
  );
}
