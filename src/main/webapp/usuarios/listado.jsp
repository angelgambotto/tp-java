<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.LinkedList" %>
<%@page import = "usuarios.Usuario" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Listado de usuarios</title>
<script src="https://cdn.tailwindcss.com"></script>
     <script>
        function toggleModal(nameModal) {
            const modal = document.getElementById(nameModal);
            modal.classList.toggle('hidden');
        }
    </script>

<%LinkedList<Usuario> usuarios=(LinkedList<Usuario>)request.getAttribute("usuarios"); %>


</head>
<body>
<body class="bg-gray-100">
<jsp:include page="../header.jsp" />
<!-- Mostrar errores -->
<div class="p-8">
    <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-100 text-red-700 p-4 rounded mb-4">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
</div>
<div class="p-8">
 <div class="flex items-center justify-between mb-4">
 
    <h2 class="text-2xl font-bold text-black">Listado de usuarios</h2>

     
    <div class="relative flex-1 max-w-md">
        <input type="text" placeholder="Buscar..."
               class="w-full border border-gray-300 rounded px-3 py-2 pr-10 focus:ring-indigo-500 focus:border-indigo-500" />
        <button class="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-4.35-4.35m1.85-5.65a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
        </button>
    </div>

    <a href="UsuariosServlet?action=new" 
   class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
   Crear usuario
</a>

  </div>

<div class="flex mt-8 bg-white shadow-lg rounded-lg p-6"> 
    <table class="w-full border-collapse border border-gray-300">
    	<thead>
        <tr>
            <th class="border border-gray-300 px-4 py-2">Nombre</th>
            <th class="border border-gray-300 px-4 py-2">Apellido</th>
             <th class="border border-gray-300 px-4 py-2">Mail</th>
              <th class="border border-gray-300 px-4 py-2">Usuario</th>
            <th class="border border-gray-300 px-4 py-2">Rol</th>
            <th class="border border-gray-300 px-4 py-2">Supervisor</th>
            <th class="border border-gray-300 px-4 py-2  w-[180px]">Acciones</th>
        </tr>
        </thead>
        <tbody>        
        <%
       
        if(usuarios!=null){
        for(Usuario user :usuarios){ %>
       
        <tr class="hover:bg-gray-100">
            <td class="border border-gray-300 px-4 py-2"><%= user.getNombre() %></td>
            <td class="border border-gray-300 px-4 py-2"><%= user.getApellido() %></td>
            <td class="border border-gray-300 px-4 py-2"><%= user.getMail() %></td>
              <td class="border border-gray-300 px-4 py-2"><%= user.getUsuario() %></td> 
                         <td class="border border-gray-300 px-4 py-2"><%= user.getRol() %></td>
            <td class="border border-gray-300 px-4 py-2"><%= user.getNombreSupervisor() %></td>
            <td class="border border-gray-300 px-4 py-2">
             <a href="UsuariosServlet?action=edit&id=<%= user.getId() %>" class="bg-blue-600 text-white px-2 py-1 rounded text-sm hover:bg-blue-700 w-[70px] inline-block text-center"  >Editar</a>

                <a href="UsuariosServlet?action=delete&id=<%= user.getId() %>"
                   class="bg-blue-600 text-white px-2 py-1 rounded text-sm hover:bg-red-700 w-[70px] inline-block text-center">Eliminar</a>
            </td>
        </tr>
        <%      }
            }
        %>
        </tbody>
    </table>
</div>

<jsp:include page="formulario.jsp" />
<jsp:include page= "modalEliminar.jsp"/>

</div>
</body>
</html>