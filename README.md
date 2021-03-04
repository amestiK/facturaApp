# factura

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
