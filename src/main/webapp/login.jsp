<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Inicio de Sesión</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

<div id="loginModal" class="bg-white rounded-lg shadow-lg p-6 w-full max-w-md">
    <h2 class="text-2xl font-bold mb-4 text-center">Iniciar Sesión</h2>

    <% 
        String error = (String) request.getAttribute("error");
        if (error != null) { 
    %>
        <div class="bg-red-100 text-red-700 text-sm p-3 rounded mb-4 text-center">
            <%= error %>
        </div>
    <% } %>

    <form action="LoginServlet" method="post" class="space-y-4" autocomplete="off">
        <div>
            <label class="block font-medium">Usuario:</label>
            <input type="text" name="usuario" 
                   required
                   class="w-full border border-gray-300 rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
        </div>

        <div>
            <label class="block font-medium">Clave:</label>

            <!-- contenedor relativo para posicionar el ojo -->
            <div class="relative">
                <input id="passwordInput" type="password" name="clave" 
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2 pr-10 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />

                <!-- botón ojo (type="button" para no enviar el form) -->
                <button id="togglePassword" type="button" aria-pressed="false" 
                        class="absolute inset-y-0 right-0 flex items-center pr-3">
                    <!-- icono ojo abierto -->
                    <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                    </svg>

                    <!-- icono ojo tachado (oculto por defecto) -->
                    <svg id="eyeSlash" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-600 hidden" viewBox="0 0 24 24" stroke="currentColor" fill="none">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a10.05 10.05 0 012.223-3.503M6.17 6.17A9.956 9.956 0 0112 5c4.477 0 8.268 2.943 9.542 7a9.97 9.97 0 01-4.168 5.64M3 3l18 18" />
                    </svg>
                </button>
            </div>
        </div>

        <div class="flex justify-between items-center">
            <div>
                <input type="checkbox" id="recordar" name="recordar" class="mr-1">
                <label for="recordar" class="text-sm text-gray-700">Recordarme</label>
            </div>
            <a href="#" class="text-sm text-blue-600 hover:underline">¿Olvidaste tu clave?</a>
        </div>

        <div class="flex justify-end space-x-4">
            <button type="reset" onclick="window.location.href='UsuariosServlet';" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400">
                Cancelar
            </button>
            <button type="submit"  class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                Ingresar
            </button>
        </div>
        <p class="text-sm text-center text-gray-700 mt-4">
            ¿No tenés cuenta?
            <a href="signup.jsp" class="text-blue-600 hover:underline">Registrate acá</a>
        </p>
    </form>
</div>

<script>
    (function() {
        const toggle = document.getElementById('togglePassword');
        const pwd = document.getElementById('passwordInput');
        const eyeOpen = document.getElementById('eyeOpen');
        const eyeSlash = document.getElementById('eyeSlash');

        toggle.addEventListener('click', function() {
            const isHidden = pwd.type === 'password';
            if (isHidden) {
                pwd.type = 'text';
                eyeOpen.classList.add('hidden');
                eyeSlash.classList.remove('hidden');
                toggle.setAttribute('aria-pressed', 'true');
            } else {
                pwd.type = 'password';
                eyeOpen.classList.remove('hidden');
                eyeSlash.classList.add('hidden');
                toggle.setAttribute('aria-pressed', 'false');
            }
        });
    })();
</script>

</body>
</html>
