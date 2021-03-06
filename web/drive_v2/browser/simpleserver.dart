import 'dart:io';

_sendNotFound(HttpResponse response) {
  response.statusCode = HttpStatus.NOT_FOUND;
  response.close();
}

startServer(String basePath) {
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen((HttpRequest request) {
      final String path = request.uri.path == '/' ? '/index.html' : request.uri.path;
      //print("${basePath}${path}");
      final File file = new File('${basePath}${path}');
      file.exists().then((bool found) {
        if (found) {
          file.fullPath().then((String fullPath) {
            if (!fullPath.startsWith(basePath) && !fullPath.contains(".pub-cache")) {
              _sendNotFound(request.response);
            } else {
              file.openRead()
                  .pipe(request.response)
                  .catchError((e) { });
            }
          });
        } else {
          _sendNotFound(request.response);
        }
      });
    });
  });
}

main() {
  // Compute base path for the request based on the location of the
  // script and then start the server.
  
  File file = new File("/Users/damondouglas/.pub-cache/hosted/pub.dartlang.org/browser-0.4.3+1/lib/dart.js");
  file.exists().then((bool found){
    
    file.readAsString().then((file){
      
    });
  });
  
  File script = new File(new Options().script);
  script.directory().then((Directory d) {
    
    startServer(d.path);
  });
}