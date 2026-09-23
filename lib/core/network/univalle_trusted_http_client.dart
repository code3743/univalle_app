import 'dart:convert';
import 'dart:io';

import 'certificates/digicert_global_root_g2.dart';

/// Builds an [HttpClient] that trusts the DigiCert chain behind
/// `*.univalle.edu.co`, for use as a Dio [IOHttpClientAdapter]'s
/// `createHttpClient`.
///
/// Some of the university's subdomains (opac, evaluacioncursos,
/// restauranteuniversitario) only send their leaf certificate during the
/// TLS handshake and omit the intermediate that issued it, so the OS can't
/// build a trust path on its own. Registering the intermediate and root
/// explicitly closes that gap regardless of which subdomain is being hit.
HttpClient createUnivalleTrustedHttpClient() {
  final context = SecurityContext(withTrustedRoots: true)
    ..setTrustedCertificatesBytes(utf8.encode(digicertGlobalG2Ca1Pem))
    ..setTrustedCertificatesBytes(utf8.encode(digicertGlobalRootG2Pem));
  return HttpClient(context: context);
}
