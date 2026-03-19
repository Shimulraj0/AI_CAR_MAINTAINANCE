import 'package:http/http.dart' as http;

void main() async {
  var headers = {
    'Accept': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzczOTU2NDkxLCJpYXQiOjE3NzM4NzAwOTEsImp0aSI6IjI3YTBhMmM0NTFiOTQ2MDE4YmZiY2I1MDgxNWQ1NDNkIiwidXNlcl9pZCI6IjY1YzA4OTYyLTUwOWYtNDU1ZC1hZmI5LTIyYmYxYmZkZTMyNSJ9.9VFm_FjfW3C9YxH0YQWleg6pwiS7rBjpz_iZkSc1Z_Y',
    'Cookie': 'csrftoken=JzRi4cSVcW79ODedGqUV7PoqbctoDGR3',
  };
  var request = http.Request(
    'GET',
    Uri.parse('http://10.10.7.120:8000/api/maintenance/tasks/?status=overdue'),
  );

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
