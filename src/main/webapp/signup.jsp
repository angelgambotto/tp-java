<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Registrarse</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

<div id="registroModal" class="bg-white rounded-lg shadow-lg p-6 w-full max-w-md">
    <h2 class="text-2xl font-bold mb-4 text-center">Crear Cuenta</h2>

    

    <form action="UsuariosServlet?action=signup" method="post" class="space-y-4">
     
        <div>
            <label class="block font-medium">Nombre:</label>
            <input type="text" name="nombre" 
                   required
                   class="w-full border border-gray-300 rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
        </div>

       
        <div>
            <label class="block font-medium">Apellido:</label>
            <input type="text" name="apellido" 
                   required
                   class="w-full border border-gray-300 rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
        </div>

        
        <div>
            <label class="block font-medium">Usuario:</label>
            <input type="text" name="usuario" 
                   required
                   class="w-full border border-gray-300 rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
        </div>

       
        <div>
            <label class="block font-medium">Correo electrónico:</label>
            <input type="email" name="mail" 
                   required
                   class="w-full border border-gray-300 rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
        </div>

       
        <div>
            <label class="block font-medium">Contraseña:</label>
            <input type="password" name="clave" 
                   required
                   class="w-full border border-gray-300 rounded px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
        </div>

        
        <div class="flex justify-end space-x-4">
            <button type="button" onclick="window.location.href='login.jsp';"
                    class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400">
                Cancelar
            </button>
            <button type="submit" 
                    class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                Registrarme
            </button>
        </div>

        
        <p class="text-sm text-center text-gray-700 mt-4">
            ¿Ya tenés una cuenta?
            <a href="login.jsp" class="text-blue-600 hover:underline">Iniciá sesión</a>
        </p>
    </form>
</div>

</body>
</html>
