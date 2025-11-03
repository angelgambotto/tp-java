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

    <form action="LoginServlet" method="post" class="space-y-4">
        <div>
            <label class="block font-medium">Usuario:</label>
            <input type="text" name="usuario" 
                   required
                   class="w-full border border-gray-300 rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
        </div>

        <div>
            <label class="block font-medium">Clave:</label>
            <input type="password" name="clave" 
                   required
                   class="w-full border border-gray-300 rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
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

</body>
</html>
