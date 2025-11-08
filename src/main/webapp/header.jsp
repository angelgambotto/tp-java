<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="usuarios.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    boolean logueado = (usuario != null);
%>

<header class="bg-blue-600 text-white p-4 shadow-lg">
    <div class="container mx-auto grid grid-cols-3 items-center">
        
        <h1 class="text-xl font-bold justify-self-start">Planera</h1>

       
        <nav class="flex justify-center space-x-8">
        	<% 
        	if(logueado){
	        	switch(usuario.getRol().toLowerCase()){
		        	case "administrador":
			        	%>
			            <a href="UsuariosServlet" class="hover:underline">Usuarios</a>
			            <a href="ProyectoServlet" class="hover:underline">Proyectos</a>
			            <a href="ClienteServlet" class="hover:underline">Clientes</a>
			            <a href="CategoriaTareaServlet" class="hover:underline">Categorías</a>
			            <% break;
		        	case "supervisor":
		            	%>
		            	<a href="ProyectoServlet" class="hover:underline">Proyectos</a>
		            	<a href="TareaServlet" class="hover:underline">Mis tareas</a>
		            	<%
		            	break;
		        	case "empleado":
		            	%>
		            	<a href="TareaServlet" class="hover:underline">Mis tareas</a>
		            	<%
		            	break;
		        	case "usuario":
		            	%>
		            	<a href="TareaServlet" class="hover:underline">Mis tareas</a>
		            	<%
		            	break;
		            default:
		            	%>
		            	<div>test</div>
		            	<%
		            	break;
            	}
       		} %>
        </nav>

       
        <div class="justify-self-end">
            <% if (logueado) { %>
                <a href="LogoutServlet"
                   class="border border-white text-white bg-blue-600 hover:bg-blue-500 px-4 py-2 rounded-md transition-all">
                    Cerrar sesión
                </a>
            <% } else { %>
                <a href="login.jsp"
                   class="border border-white text-white bg-blue-600 hover:bg-blue-500 px-4 py-2 rounded-md transition-all">
                    Iniciar sesión
                </a>
            <% } %>
        </div>
    </div>
</header>
