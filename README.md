# Univalle App

¡Bienvenido a Univalle App! Esta aplicación móvil ha sido desarrollada para mejorar la experiencia de los estudiantes de la Universidad del Valle, proporcionando acceso fácil y rápido a diversos servicios universitarios desde sus dispositivos móviles.

>[!IMPORTANT]
> Esta proyecto se encuentra en fase de desarrollo

## Descripción

Univalle App reúne varios servicios esenciales en una interfaz amigable y optimizada para móviles. Gracias a esta aplicación, los estudiantes pueden:

- Consultar calificaciones de todos los semestres y del semestre actual.
- Ver su promedio académico.
- Consultar el tabulado de materias cursadas en el semestre actual.
- Calificar a los docentes.
- Buscar asignaturas y electivas disponibles.
- Ver su carnet estudiantil digital.
- Acceder a enlaces de interés relacionados con la universidad.


## Seguimiento de Desarrollo de Funcionalidades

| Funcionalidad                                            | Estado |
|----------------------------------------------------------|--------|
| Consultar calificaciones de todos los semestres          | ✅     |
| Consultar calificaciones del semestre actual             | ✅     |
| Ver su promedio académico                                | ✅     |
| Consultar el tabulado                                    | ✅     |
| Calificar a los docentes                                 | 🔄 (Parcialmente desarrollada)  |
| Buscar asignaturas y electivas disponibles               | ❌     |
| Carné estudiantil digital                                | ✅     |
| Acceder a enlaces de interés relacionados con la universidad | ❌     |


## Visión a Futuro

Nuestro objetivo es trasladar toda la lógica de la aplicación al backend, permitiendo que la aplicación móvil se enfoque únicamente en la presentación de la información. Esta estrategia no solo reducirá el tamaño de la aplicación y facilitará la división de responsabilidades, sino que también eliminará la dependencia de terceros y mejorará la mantenibilidad del sistema.


Actualmente, la aplicación realiza el web scraping y muestra la información directamente, en el futuro, planeamos desarrollar un backend robusto que gestione toda la lógica de negocio. Tener un backend independiente es importante porque, si cambian las formas de obtener la información, no será necesario desplegar una nueva versión de la aplicación, en su lugar, bastará con modificar el backend, lo que agiliza las actualizaciones y asegura un servicio más consistente y fiable.


## Tecnologías Utilizadas

- **Flutter**: Framework para desarrollo de aplicaciones móviles multiplataforma.
- **Web Scraping**: Técnicas para obtener información de la página web de la universidad.

## Instalación

Sigue estos pasos para instalar y ejecutar la aplicación en tu entorno local:

1. **Clona el repositorio:**
   ```bash
   git clone https://github.com/code3743/univalle_app.git
   cd univalle_app
   ```

2. **Instala las dependencias:**
   ```bash
   flutter pub get
   ```

3. **Ejecuta la aplicación:**
   ```bash
   flutter run
   ```

## Compilación

Para compilar la aplicación y generar un archivo APK, sigue estos pasos:

1. **Compila la aplicación:**
   ```bash
   flutter build apk --split-per-abi
   ```

>[!NOTE]
>para más información sobre la compilación de la aplicación, consulta la [documentación oficial de Flutter](https://docs.flutter.dev/deployment/android).

## Uso

Una vez que la aplicación esté en funcionamiento, los estudiantes pueden iniciar sesión con sus credenciales universitarias y acceder a todas las funcionalidades ofrecidas por Univalle App.

## Contribuciones

¡Las contribuciones son bienvenidas! Si deseas colaborar en el desarrollo de Univalle App, por favor sigue estos pasos:

- Haz un fork del proyecto.
- Crea una nueva rama con tus cambios: git checkout -b mi-nueva-funcionalidad
- Realiza los cambios necesarios y haz commit: git commit -m 'Agregar nueva funcionalidad'
- Sube los cambios a tu repositorio: git push origin mi-nueva-funcionalidad
- Crea un pull request en el repositorio original.

Para más detalles sobre cómo contribuir, consulta nuestro [CONTRIBUTING](CONTRIBUTING.md).

## Licencia

Este proyecto está licenciado bajo la [MIT License](LICENSE).

## Contacto

Si tienes alguna pregunta o sugerencia, no dudes en contactarme:

- **Nombre**: Jota E. López Ramírez
- **Correo Electrónico**: [jota.lopez@correounivalle.edu.co](mailto:jota.lopez@correounivalle.edu.co)
- **Instagram**: [@jotalopezr](https://www.instagram.com/jotalopezr/)
