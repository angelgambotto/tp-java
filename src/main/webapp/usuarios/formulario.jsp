<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import = "usuarios.Usuario" %>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Listado de usuarios</title>
<script src="https://cdn.tailwindcss.com"></script>

<%Usuario user=(Usuario) request.getAttribute("usuario"); %>
</head>
<body>

<div id="insert/update" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModal") != null) ? "" : "hidden" %> flex items-center justify-center">
    <div class="bg-white rounded-lg p-6 w-full max-w-md">
        <h2 class="text-2xl font-bold mb-4"><%=user!=null?"Editar usuario":"Crear usuario" %></h2>
        <form action="UsuariosServlet" method="post" class="space-y-4">
            <input type="hidden" name="id" value="<%= user != null ? user.getId() : 0 %>"  />

            <div>
                <label class="block font-medium">Nombre:</label>
                <input type="text" name="nombre" 
                		value="<%=user != null?user.getNombre():"" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>

            <div>
                <label class="block font-medium">Apellido:</label>
                <input type="text" name="apellido" 
                value="<%=user != null?user.getApellido():"" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>
            <div>
                <label class="block font-medium">Mail:</label>
                <input type="text" name="mail" 
                value="<%=user != null?user.getMail():"" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>
            <div>
                <label class="block font-medium">Rol:</label>
                <input type="text" name="rol"
                value="<%=user != null?user.getRol():"" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>
            <div>
                <label class="block font-medium">Supervisor:</label>
                <input type="text" name="usuario" 
                value="<%=user != null?user.getUsuario():"" %>"
                       required
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>
            <div>
                <label class="block font-medium">Clave:</label>
                <input type="password" name="clave"  
                 
                       class="w-full border border-gray-300 rounded px-3 py-2"/>
            </div>
            

            <div class="flex justify-end space-x-4">
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModal('insert/update')">
                    Cancelar
                </button>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    <%= request.getAttribute("usuario") != null ? "Actualizar" : "Guardar" %>
                </button>
            </div>
        </form>
    </div>
   </div>

</body>
</html>


