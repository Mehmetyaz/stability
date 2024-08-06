/// Stability AI API client
///
/// This package prepared by using [the documentation](https://platform.stability.ai/docs/getting-started).
/// Some limitations may apply. Please check the documentation for more information.
///
/// Example:
///
/// ```dart
///
/// import 'package:stability/stability.dart';
///
/// void main() async {
///
///     final stability = Stability(apiKey: "YOUR_API_KEY");
///     // or
///     final stability = Stability(); // apiKey will be read from STABILITY_API_KEY environment variable or --stability-api-key argument
///
///     final engines = await stability.engines.list();
///
///     print(engines);
///
///     final FileHandler file = await stability.image.generate.diffusion3Image2Image(
///       image: FileFrom.path("path/to/image.jpg"),
///       strength: 0.5
///     );
///
///     await file.writeToFile("path/to/output.jpg");
///     // or
///     final Uint8List bytes = await file.readAsBytes();
///
///     final (seed, finishReason) = await file.readHeaders();
///
///     print(seed);
/// }
///
/// ```
///
/// When an API call fails, a [StabilityError] will be thrown.
///
/// See [FileFrom] for more information about how to provide an image.
///
/// See [FileHandler] for more information about how to handle the file
/// response.
///
library;

export 'src/stability_base.dart';
