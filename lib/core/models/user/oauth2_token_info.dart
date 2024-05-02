class Oauth2TokenInfo {
  final String? accessToken;
  final String? expiresIn;
  final String? refreshExpiresIn;
  final String? refreshToken;
  final int? notBeforePolicy;
  final String? sessionState;
  final String? scope;

  Oauth2TokenInfo({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.refreshToken,
    required this.notBeforePolicy,
    required this.sessionState,
    required this.scope,
  });

  factory Oauth2TokenInfo.fromJson(Map<String, dynamic> json) {
    return Oauth2TokenInfo(
      accessToken: json['access_token'],
      expiresIn: json['expires_in'],
      refreshExpiresIn: json['refresh_expires_in'],
      refreshToken: json['refresh_token'],
      notBeforePolicy: json['not-before-policy'],
      sessionState: json['session_state'],
      scope: json['scope'],
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'expires_in': expiresIn,
        'refresh_expires_in': refreshExpiresIn,
        'refresh_token': refreshToken,
        'not-before-policy': notBeforePolicy,
        'session_state': sessionState,
        'scope': scope,
      };
}
