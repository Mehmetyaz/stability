part of '../stability_base.dart';

/// Stability API Error
class StabilityError {
  /// HTTP status code
  final int status;

  /// HTTP status text
  final String statusText;

  /// Response body
  final Map<String, dynamic> body;

  /// Stability API Error
  StabilityError({
    required this.status,
    required this.statusText,
    required this.body,
  });
}

/// Clip guidance preset.
///
/// See Stability API documentation for more information.
enum ClipGuidancePreset {
  /// `NONE`
  none("NONE"),

  /// `FAST_BLUE`
  fastBlue("FAST_BLUE"),

  /// `FAST_GREEN`
  fastGreen("FAST_GREEN"),

  /// `FAST_RED`
  simple("SIMPLE"),

  /// `SLOW`
  slow("SLOW"),

  /// `SLOWER`
  slower("SLOWER"),

  /// `SLOWEST`
  slowest("SLOWEST");

  /// Value
  const ClipGuidancePreset(this.value);

  /// Value
  final String value;
}

/// Sampler type.
///
/// See Stability API documentation for more information.
enum Sampler {
  /// `DDIM`
  ddim("DDIM"),

  /// `DDPM`
  ddpm("DDPM"),

  /// `K_DPMPP_2M`
  kDpmpp2m("K_DPMPP_2M"),

  /// `K_DPMPP_2S_ANCESTRAL`
  kDpmpp2sAncestral("K_DPMPP_2S_ANCESTRAL"),

  /// `K_DPM_2`
  kDpm2("K_DPM_2"),

  /// `K_DPM_2_ANCESTRAL`
  kDpm2Ancestral("K_DPM_2_ANCESTRAL"),

  /// `K_EULER`
  kEuler("K_EULER"),

  /// `K_EULER_ANCESTRAL`
  kEulerAncestral("K_EULER_ANCESTRAL"),

  /// `K_HEUN`
  kHeun("K_HEUN"),

  /// `K_LMS`
  kLms("K_LMS");

  /// Value
  const Sampler(this.value);

  /// Value
  final String value;
}

/// Some endpoints returns files in base64 format.
///
/// This class helps to handle base64 files.
class Base64File {
  /// Base64 content
  final String base64;

  /// Base64File
  Base64File({
    required this.base64,
  });

  /// Write base64 content to a file.
  Future<void> writeToFile(String path) async {
    final file = File(path);

    await file.writeAsBytes(base64Decode(base64));
  }

  /// Read base64 content as bytes.
  Uint8List readBytes() {
    return base64Decode(base64);
  }
}

/// Many endpoints which returns files, also returns `finish_reason`
/// in headers or response body.
enum FinishReason {
  /// `CONTENT_FILTERED`
  contentFiltered("CONTENT_FILTERED"),

  /// `SUCCESS`
  success("SUCCESS"),

  /// `ERROR`
  error("ERROR");

  /// Value
  const FinishReason(this.value);

  /// Value
  final String value;

  /// Get enum value from string.
  static FinishReason fromValue(String value) {
    return FinishReason.values.firstWhere((e) => e.value == value);
  }
}

/// File source.
///
/// This class helps to handle files from different sources and provide a
/// [MultipartFile] object to be used in HTTP requests.
///
class FileFrom {
  /// File path. Have to be a valid absolute path.
  final String? path;

  /// File bytes.
  final Uint8List? bytes;

  /// File base64 content.
  final String? base64;

  final String? contentType;

  /// Get a file from path.
  factory FileFrom.path(String path, [String? contentType]) =>
      FileFrom._(path: path, contentType: contentType);

  /// Get a file from bytes.
  factory FileFrom.bytes(Uint8List bytes, [String? contentType]) =>
      FileFrom._(bytes: bytes, contentType: contentType);

  /// Get a file from base64 content.
  factory FileFrom.base64(String base64, [String? contentType]) =>
      FileFrom._(base64: base64, contentType: contentType);

  FileFrom._({this.path, this.bytes, this.base64, this.contentType});

  /// Convert to [MultipartFile].
  MultipartFile toMultipartFile(String field) {
    if (path != null) {
      late var segments = Uri.file(path!).pathSegments;
      var filename = segments.isEmpty ? '' : segments.last;
      var file = File(path!);
      var length = file.lengthSync();
      var stream = ByteStream(file.openRead());
      return MultipartFile(field, stream, length,
          filename: filename,
          contentType:
              contentType == null ? null : MediaType.parse(contentType!));
    } else if (bytes != null) {
      return MultipartFile.fromBytes(field, bytes!,
          filename: "file",
          contentType:
              contentType == null ? null : MediaType.parse(contentType!));
    } else if (base64 != null) {
      return MultipartFile.fromString(field, base64!,
          filename: "file",
          contentType:
              contentType == null ? null : MediaType.parse(contentType!));
    } else {
      throw ArgumentError("One of path, bytes or base64 must be provided");
    }
  }
}

/// Style preset for image generation.
///
/// See Stability API documentation for more information.
enum StylePreset {
  /// `3d-model`
  d3dModel("3d-model"),

  /// `analog-film`
  analogFilm("analog-film"),

  /// `anime`
  anime("anime"),

  /// `cinematic`
  cinematic("cinematic"),

  /// `comic-book`
  comicBook("comic-book"),

  /// `digital-art`
  digitalArt("digital-art"),

  /// `enhance`
  enhance("enhance"),

  /// `fantasy-art`
  fantasyArt("fantasy-art"),

  /// `isometric`
  isometric("isometric"),

  /// `line-art`
  lineArt("line-art"),

  /// `low-poly`
  lowPoly("low-poly"),

  /// `modeling-compound`
  modelingCompound("modeling-compound"),

  /// `neon-punk`
  neonPunk("neon-punk"),

  /// `origami`
  origami("origami"),

  /// `photographic`
  photographic("photographic"),

  /// `pixel-art`
  pixelArt("pixel-art"),

  /// `tile-texture`
  tileTexture("tile-texture");

  /// Value
  const StylePreset(this.value);

  /// Value
  final String value;

  /// Get enum value from string.
  static StylePreset fromValue(String value) {
    return StylePreset.values.firstWhere((e) => e.value == value);
  }
}

/// Output format for image generation.
enum OutputFormat {
  /// `png`. Many endpoints use this as default.
  png,

  /// `jpeg`
  jpeg,

  /// `webp`
  webp,
}

/// Aspect ratio for image generation.
enum AspectRatio {
  /// `16:9`
  a16_9("16:9"),

  /// `1:1`
  a1_1("1:1"),

  /// `21:9`
  a21_9("21:9"),

  /// `2:3`
  a2_3("2:3"),

  /// `3:2`
  a3_2("3:2"),

  /// `4:5`
  a4_5("4:5"),

  /// `5:4`
  a5_4("5:4"),

  /// `9:16`
  a9_16("9:16"),

  /// `9:21`
  a9_21("9:21");

  /// Value
  final String value;

  /// AspectRatio
  const AspectRatio(this.value);
}
