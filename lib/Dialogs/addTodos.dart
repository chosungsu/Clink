import 'package:flutter/material.dart';

addTodos(BuildContext context, TextEditingController textEditingController,
    List<String> todolist) {
  textEditingController.text = "";
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black87,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            height: 250,
            width: 320,
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Add Todo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: textEditingController,
                  style: const TextStyle(color: Colors.white),
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintText: 'Add your new todo item',
                      hintStyle: TextStyle(color: Colors.white60)),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 320,
                  child: ElevatedButton(
                    onPressed: () {
                      todolist.add(textEditingController.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add Todo"),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
