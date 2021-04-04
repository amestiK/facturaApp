# FacturaApp
Preview de FacturaApp

![Gif1](https://user-images.githubusercontent.com/77164627/113045660-7aa88e00-9175-11eb-836b-a92639eb1160.gif)

![Gift2](https://user-images.githubusercontent.com/77164627/113047949-569a7c00-9178-11eb-811c-7e3224947929.gif)


Factura app es una aplicación que permite realizar la emision de documentos electronicos a traves de un entorno mobile para iOS/Android. Sus funcionalidades integran el consumo de Open Factura por medio de sus Apis.

Paginas y funcionalidades de la app:

Login_page: Contiene el inicio de sesión a la aplicación.

Home_Page: Es la página a la que se ingresa despues de iniciar sesion, tiene como presentacion organization_page y permite navegar a receptor_page y viceversa, a traves de un bottomBar.

Organization_Page: Pagina de bienvenida que presenta y muestra los datos del emisor.

Receptor_Page: Este mantenedor contiene un buscador por rut, permite obtener los datos del receptor.

Factura_Page: Este mantenedor permite ingresar los productos que seran facturados. Envia la factura y redirecciona a pdf_page para desplegar el PDF.

Pdf_page: Despliega el pdf del documento electrónico emitido.

Librerías

-http: Provee los métodos para trabajar con las Api's.

-dart_rut_validator: Nos permite validar un rut (sea persona natural o empresa) y dar formato al texto del rut.

-intl: Este paquete permite traducir, dar formate a fechas y numeros.

-rxdart: Nos permite agregar validaciones extra a las que ya posee Dart, durante este proyecto se han utilizado para el desarrollo del Login.

-flutter_plugin_pdf_viewer: Un complemento de flutter para manejar archivos PDF. Funciona tanto en Android como en iOS

-path_provider: Un complemento de Flutter para encontrar ubicaciones de uso común en el sistema de archivos. Soporta iOS, Android, Linux y MacOS. No todos los métodos son compatibles con todas las plataformas

-io: Permite crear archivos, designar sus rutas para el almacenamiento y desplegarlos. En este proyecto se utilizaron para almacenar y desplegar el pdf.

-share_preferences: plugin que nos permite guardar datos en la data del celular, estos datos se borraran al momento de actualizar la app o borrar el cache. Funciona tanto en Android como en iOS

-ImagePicker: plugin que nos permite seleccionar imagenes de la galeria o tomar fotos con la camara del celular. Funciona tanto en Android como en iOS

-filePicker: puglin que nos permite seleccionar archivos del celular. Funciona tanto en Android como en iOS

-google_sign_in: puglin que permite crear un login con google. Funciona tanto en Android como en iOS

-firebase_core: puglin que nos permite hacer una conexión con la api de Firebase. Funciona tanto en Android como en iOS

-firebase_auth: puglin que permite hacer un login con la api de Firebase. Funciona tanto en Android como en iOS

-flutter_signin_button: puglin que nos permite crear botones con el diseño de los tipos de login mas conocidos (Google, Twitter, Facebook, etc.). Funciona tanto en Android como en iOS

-dio: puglin que nos da soporte para realizar conexiones http, configuraciones globales, etc. Funciona tanto en Android como en iOS

-flutter_flavor: puglin que nos permite crear los distintos flavors en la app, es decir tener una para debug otra, de desarrollo y producción. Funciona tanto en Android como en iOS
 
-printing: puglin que permite a la app de flutter generar una impresion en cualquier dispositivo. Funciona tanto en Android como en iOS

-provider: puglin que permite hacer un uso mas facil de los InheritedWidget. Funciona tanto en Android como en iOS

-io: puglin para poder crear conexiones a archivos, formato de codigo, etc. Funciona tanto en Android como en iOS

-math_expressions: puglin para parsiar y evaluar expresiones matematicas. Funciona tanto en Android como en iOS

-esys_flutter_share: puglin para compartir imagenes, texto, etc. Con otras aplicaciones. Funciona tanto en Android como en iOS

-ars_progress_dialog: puglin que genera un popup animado y un progressDialog con un estilo nativo. Funciona tanto en Android como en iOS

-random_string: puglin que generar numeros random, segun el tipo que se necesite. Funciona tanto en Android como en iOS


