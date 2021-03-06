// Run as
// dart web/drive_v2/console/files/update_example.dart

import "dart:io";
import "dart:json" as JSON;
import "package:google_oauth2_client/google_oauth2_console.dart";
import "package:google_drive_v2_api/drive_v2_api_console.dart" as drivelib;
import "package:google_drive_v2_api/drive_v2_api_client.dart" as client;
import "package:crypto/crypto.dart";

void run(Map client_secrets) {
  String identifier = client_secrets["client_id"];
  String secret = client_secrets["client_secret"];

  List scopes = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
  final auth = new OAuth2Console(identifier: identifier, secret: secret, scopes: scopes);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;

  String fileId = "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4";
  String content = "All work and no play makes Jack a dull boy";
  String base64content = CryptoUtils.bytesToBase64(content.codeUnits);
  drive.files.get(fileId).then((client.File rtrvdFile){
    drive.files.update(rtrvdFile, fileId, content:base64content).then((client.File updatedFile){
      print("Updated: ${updatedFile.title}: ${updatedFile.id}");
    });
  });
}

void main() {
  String path = "client_secrets.json";
  File secrets = new File(path);
  secrets.exists().then((bool exists){
    if(exists) {
      secrets.readAsString().then((String content){
        Map client_secret_installed = JSON.parse(content);
        Map client_secrets = client_secret_installed["installed"];
        run(client_secrets);
      });
    }
  });
}