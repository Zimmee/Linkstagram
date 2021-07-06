import 'dart:html' as html;
import 'dart:convert';
import 'dart:js' as js;

class FileUploader {
  void uploadFile(String profilePicture, Function f) {
    html.window.addEventListener('message', (event) {
      html.MessageEvent event2 = event;
      f(json.decode(event2.data));
    });
    js.context.callMethod('uploadFile', [profilePicture, 'profilePicture']);
  }
}
