import 'package:get/get.dart';
//Mikail imza - 30.10.20.22 ---- mikailimza@gmail.com 
class Language extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'titles': 'Sound To Text',
          'welcome': 'Welcome',
          'hearing': 'Hearing Impai',
          'blind': 'Blind',
          'register': 'Register',
          'loginok': 'Login',
          'tamam': 'OK',
        },
        'tr_TR': {
          'titles': 'Sound To Text',
          'welcome': 'Hoşgeldin',
          'hearing': 'Duyma Engelli',
          'blind': 'Görme Engelli',
          'register': 'Kayıt Ol',
          'loginok': 'Giriş Yap',
          'tamam': 'Tamam',
        }
      };
}
