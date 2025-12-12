<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Planera - Sistema de Gestión de Proyectos</title>
<script src="https://cdn.tailwindcss.com"></script>
<style>
    .bg-gradient-blue {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
</style>
</head>
<body class="bg-gray-50 min-h-screen">

<div class="min-h-screen flex flex-col lg:flex-row">
    
    <!-- PANEL IZQUIERDO - INFORMACIÓN -->
    <div class="lg:w-1/2 bg-gradient-blue text-white p-8 lg:p-12 flex flex-col justify-center relative overflow-hidden">
        
        <div class="relative z-10 max-w-xl mx-auto">
            <!-- Logo y título -->
            <div class="mb-8 lg:mb-12">
                <div class="flex items-center gap-3 mb-4">
                    <div class="bg-white bg-opacity-20 backdrop-blur-sm p-3 rounded-xl">
                        <svg class="w-8 h-8 sm:w-10 sm:h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
                        </svg>
                    </div>
                    <h1 class="text-3xl sm:text-4xl lg:text-5xl font-bold">Planera</h1>
                </div>
                <p class="text-lg sm:text-xl text-blue-100">Sistema de Gestión de Proyectos Empresarial</p>
            </div>

            <!-- Características -->
            <div class="space-y-6 mb-8 lg:mb-12">
                <div class="flex items-start gap-4">
                    <div class="bg-white bg-opacity-20 backdrop-blur-sm p-2.5 rounded-lg flex-shrink-0">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-semibold text-lg mb-1">Gestión Integral</h3>
                        <p class="text-blue-100 text-sm">Administra proyectos, etapas y tareas en un solo lugar</p>
                    </div>
                </div>

                <div class="flex items-start gap-4">
                    <div class="bg-white bg-opacity-20 backdrop-blur-sm p-2.5 rounded-lg flex-shrink-0">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-semibold text-lg mb-1">Colaboración en Equipo</h3>
                        <p class="text-blue-100 text-sm">Asigna tareas y colabora con tu equipo en tiempo real</p>
                    </div>
                </div>

                <div class="flex items-start gap-4">
                    <div class="bg-white bg-opacity-20 backdrop-blur-sm p-2.5 rounded-lg flex-shrink-0">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-semibold text-lg mb-1">Control y Seguimiento</h3>
                        <p class="text-blue-100 text-sm">Visualiza el progreso y registra horas trabajadas</p>
                    </div>
                </div>
            </div>

            <!-- Información de acceso -->
            <div class="bg-white bg-opacity-10 backdrop-blur-sm border border-white border-opacity-20 rounded-lg p-4">
                <div class="flex items-start gap-3">
                    <svg class="w-5 h-5 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <div class="text-sm">
                        <p class="font-semibold mb-1">Acceso Corporativo</p>
                        <p class="text-blue-100">Este sistema es exclusivo para empresas. Si tu organización está registrada, solicita tus credenciales al administrador.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- PANEL DERECHO - FORMULARIO DE LOGIN -->
    <div class="lg:w-1/2 flex items-center justify-center p-6 sm:p-8 lg:p-12 bg-white">
        <div class="w-full max-w-md">
            
            <!-- Header del formulario -->
            <div class="mb-8">
                <h2 class="text-2xl sm:text-3xl font-bold text-gray-800 mb-2">Bienvenido de nuevo</h2>
                <p class="text-gray-600">Ingresa tus credenciales para continuar</p>
            </div>

            <!-- Mensaje de error -->
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) { 
            %>
                <div class="bg-red-50 border border-red-200 text-red-700 text-sm p-4 rounded-lg mb-6 flex items-start gap-2">
                    <svg class="w-5 h-5 flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path>
                    </svg>
                    <span><%= error %></span>
                </div>
            <% } %>

            <!-- Formulario -->
            <form action="LoginServlet" method="post" class="space-y-5" autocomplete="off">
                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Usuario</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                            </svg>
                        </div>
                        <input type="text" name="usuario" 
                               required
                               placeholder="usuario@empresa.com"
                               class="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition" />
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">Contraseña</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                            </svg>
                        </div>
                        <input id="passwordInput" type="password" name="clave" 
                               required
                               placeholder="••••••••"
                               class="w-full pl-10 pr-12 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition" />
                        
                        <button id="togglePassword" type="button" aria-pressed="false" 
                                class="absolute inset-y-0 right-0 pr-3 flex items-center hover:text-gray-700">
                            <svg id="eyeOpen" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                            <svg id="eyeSlash" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400 hidden" viewBox="0 0 24 24" stroke="currentColor" fill="none">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a10.05 10.05 0 012.223-3.503M6.17 6.17A9.956 9.956 0 0112 5c4.477 0 8.268 2.943 9.542 7a9.97 9.97 0 01-4.168 5.64M3 3l18 18" />
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <input type="checkbox" id="recordar" name="recordar" class="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
                        <label for="recordar" class="ml-2 text-sm text-gray-700">Recordarme</label>
                    </div>
                    <a href="#" class="text-sm text-blue-600 hover:text-blue-700 font-medium transition">¿Olvidaste tu contraseña?</a>
                </div>

                <button type="submit" class="w-full bg-gradient-blue text-white font-semibold py-3 px-4 rounded-lg hover:opacity-90 transition shadow-lg hover:shadow-xl">
                    Iniciar Sesión
                </button>
            </form>

            <!-- Footer del formulario -->
            <div class="mt-8 pt-6 border-t border-gray-200">
                <div class="bg-blue-50 border border-blue-100 rounded-lg p-4">
                    <div class="flex items-start gap-3">
                        <svg class="w-5 h-5 text-blue-600 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                        </svg>
                        <div class="text-sm text-gray-700">
                            <p class="font-semibold mb-1">¿Tu empresa necesita Planera?</p>
                            <p class="text-gray-600 mb-2">Contacta con nuestro equipo de ventas para más información.</p>
                            <a href="mailto:franciscolovatti08@gmail.com" class="text-blue-600 hover:text-blue-700 font-medium">
                                ventas@planera.com
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
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