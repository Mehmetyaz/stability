## Stability AI API client

This package prepared by using [the documentation](https://platform.stability.ai/docs/getting-started).

All endpoints are implemented.

## Available Endpoints

| Group                   | Endpoint                   | Status                  |
|-------------------------|----------------------------|-------------------------|
| Engines                 |                            |                         |
|                         | List Engines               | :ballot_box_with_check: |
| User                    |                            |                         |
|                         | Account                    | :ballot_box_with_check: |
|                         | Balance                    | :ballot_box_with_check: |
| SDXL & SD1.6            |                            |                         |
|                         | Text to Image              | :white_check_mark:      |
|                         | Image to Image with Prompt | :ballot_box_with_check: |
|                         | Image to Image with Mask   | :ballot_box_with_check: |
|                         | Image to Image upscale     | :ballot_box_with_check: |
| 3D                      |                            |                         |
|                         | Stable Fast 3D             | :ballot_box_with_check: |
| Video                   |                            |                         |
|                         | Start Generation           | :ballot_box_with_check: |
|                         | Fetch Generation Result    | :ballot_box_with_check: |
| Stable Image - Generate |                            |                         |
|                         | Ultra                      | :ballot_box_with_check: |
|                         | Core                       | :ballot_box_with_check: |
|                         | Diffusion 3 - text2image   | :white_check_mark:      |
|                         | Diffusion 3 - image2image  | :ballot_box_with_check: |
| Stable Image - Upscale  |                            |                         |
|                         | Conservative               | :ballot_box_with_check: |
|                         | Start Upscale              | :ballot_box_with_check: |
|                         | Fetch Upscale Result       | :ballot_box_with_check: |
| Stable Image - Edit     |                            |                         |
|                         | Erase                      | :ballot_box_with_check: |
|                         | Inpaint                    | :ballot_box_with_check: |
|                         | Outpaint                   | :ballot_box_with_check: |
|                         | Search & Replace           | :ballot_box_with_check: |
|                         | Remove Background          | :ballot_box_with_check: |
| Stable Image - Control  |                            |                         |
|                         | Sketch                     | :ballot_box_with_check: |
|                         | Structure                  | :ballot_box_with_check: |
|                         | Style                      | :ballot_box_with_check: |

- :x: : not finished
- :ballot_box_with_check: : Not Tested
- :white_check_mark: : finished

Example:

 ```dart

import 'package:stability/stability.dart';

void main() async {
  final stability = Stability(apiKey: "YOUR_API_KEY");
  // or
  final stability = Stability(); // apiKey will be read from STABILITY_API_KEY environment variable or --stability-api-key argument

  final engines = await stability.engines.list();

  print(engines);

  final FileHandler file = stability.image.generate.diffusion3Image2Image(
      image: FileFrom.path("path/to/image.jpg"),
      strength: 0.5
  );

  await file.writeToFile("path/to/output.jpg");
  // or
  final Uint8List bytes = await file.readAsBytes();

  final (seed, finishReason) = await file.readHeaders();

  print(seed);
}

```

## Providing Files

Anywhere a file is required, you can provide it in the following ways:

```dart
doIt() {
  FileFrom.path("path/to/file.jpg");

  FileFrom.bytes(Uint8List.fromList([1, 2, 3]));

  FileFrom.base64("base64encodedstring");
}
```

## Handling Files

Anywhere a file is returned, you can handle it in the following ways:

If the endpoint returns single file:

```dart

doIt() async {
  final FileHandler file = stability.image.generate.diffusion3Image2Image(
      image: FileFrom.path("path/to/image.jpg"),
      strength: 0.5
  );


  await file.writeToFile("path/to/output.jpg");

// or

  final Uint8List bytes = await file.readAsBytes();
}

```

If the endpoint returns multiple files:

```dart
doIt() async {
  final res = await stability.sdxlV1.textToImage();

  final Base64File file1 = res.files[0];

  await file1.writeToFile("path/to/output1.jpg");

  final bytes = file1.readAsBytes();
}

```

## Handling Errors

```dart
doIt() async {
  try {
    final res = await stability.sdxlV1.textToImage();
  } on StabilityError catch (e) {
    print(e.status); // 404
    print(e.statusText); // Not Found
    print(e.body); // {"foo": "bar"}  
  }
}
```

That's it! You're ready to use the Stability AI API client.

## NOTE: This package is not an official package of Stability AI. It is created by [Mehmet Yaz](https://www.linkedin.com/in/mehmetyaz/).

## Support

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/mehmetyaz)
