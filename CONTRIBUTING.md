# Contribuir a Univalle App

¡Gracias por tu interés en contribuir a Univalle App! A continuación se presentan las pautas y los pasos a seguir para contribuir al proyecto.

## Cómo Contribuir

1. **Haz un fork del proyecto:**

   Haz un fork de este repositorio haciendo clic en el botón "Fork" en la parte superior de la página.

2. **Clona el repositorio:**

   ```sh
    git remote add upstream https://github.com/code3743/univalle_app.git
   ```

3. **Crea una rama con tus cambios:**

   ```sh
   git checkout -b mi-nueva-funcionalidad
   ```

4. **Realiza los cambios necesarios y haz commit:**

   Asegúrate de escribir mensajes de commit claros y concisos.

   ```sh
   git commit -m 'Agregar nueva funcionalidad'
   ```

5. **Sincroniza tu rama con la rama principal del repositorio original (opcional pero recomendado):**

   ```sh
   git remote add upstream https://github.com/code3743/univalle_app.git
   git fetch upstream
   git merge upstream/main
   ```

6. **Sube los cambios a tu repositorio:**

   ```sh
   git push origin mi-nueva-funcionalidad
   ```

7. **Crea un pull request:**

   Ve al repositorio original y crea un pull request desde tu rama.

## Guía de Estilo

Por favor, sigue estas pautas de estilo para mantener la coherencia en el código del proyecto:

- Usa nombres de variables y funciones descriptivos.
- Escribe comentarios claros y útiles.
- Sigue las convenciones de estilo de código del lenguaje utilizado (Dart).

## Revisión de Pull Requests

- Todas las contribuciones serán revisadas por los mantenedores del proyecto.
- Es posible que te pidamos realizar cambios antes de que se pueda fusionar tu pull request.
- Asegúrate de estar disponible para responder preguntas o realizar modificaciones según sea necesario.

## Reporte de Problemas

Si encuentras algún problema o tienes una sugerencia para mejorar el proyecto, por favor, abre un [issue](https://github.com/code3743/univalle_app/issues) en el repositorio.

## Código de Conducta

Esperamos que todos los contribuyentes sigan nuestro [Código de Conducta](CODE_OF_CONDUCT). Sé respetuoso y considera a los demás.
