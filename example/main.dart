import 'dart:io';

import 'package:stability/src/stability_base.dart';

void main() async {
  print("Hello, Stability AI!");
  // API Key provided as an environment variable
  final stability = StabilityAI();

  final account = await stability.user.account();

  print("User account: ${account.email}");

  final files =
      await stability.sdxlV1.textToImage(prompts: [Prompt("Awesome river")]);

  print("Generated ${files.length} images");

  files[0]
      .image
      .writeToFile("${Directory.current.path}/example/awesome_river.png");

  print("Image saved to ${Directory.current.path}/example/awesome_river.png");

  final sd3 = stability.image.generate.diffusion3Text2Image(
      prompt: "A beautiful sunset", model: Diffusion3Model.sd3LargeTurbo);

  await sd3.writeToFile("${Directory.current.path}/example/sunset.png");

  print("Image saved to ${Directory.current.path}/example/sunset.png");
}
