<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import = "usuarios.Usuario" %>  
    <%@page import = "clientes.Cliente" %>  
    <%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>Formulario de Usuarios</title>
<script src="https://cdn.tailwindcss.com"></script>

<%Usuario user=(Usuario) request.getAttribute("user");
List<Usuario> empleados=(List<Usuario>) request.getAttribute("empleados");
List<Cliente> clientes=(List<Cliente>) request.getAttribute("clientes");
%>
</head>
<body>

<div id="insert/update" class="fixed inset-0 bg-gray-900 bg-opacity-50 <%= (request.getAttribute("abrirModal") != null) ? "" : "hidden" %> flex items-center justify-center p-4 z-50">
    <div class="bg-white rounded-lg p-6 w-full max-w-md max-h-screen overflow-y-auto"> <h2 class="text-2xl font-bold mb-4"><%=user!=null?"Editar usuario":"Crear usuario" %></h2>
        
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
                <label class="block font-medium">Usuario:</label>
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
            
           <div>
               <label class="block font-medium">Rol:</label>
               <select name="rol" id="rolSelector" required 
                       class="w-full border border-gray-300 rounded px-3 py-2"
                       onchange="manejarRol(this.value)">
               
               <option value="">Seleccione un rol</option>
                <option value="Administrador" <%= (user != null && "Administrador".equals(user.getRol())) ? "selected" : "" %>>
                    Administrador
                </option>
               <option value="Empleado" <%= (user != null && "Empleado".equals(user.getRol())) ? "selected" : "" %>>
                    Empleado
                </option>
                <option value="Cliente" <%= (user != null && "Cliente".equals(user.getRol())) ? "selected" : "" %>>
                    Usuario Cliente
                </option>
                </select>
           </div>
           
            <div id="campoSupervisor" class="hidden"> 
                <label class="block font-medium">Supervisor:</label>
                <select name="supervisor" class="w-full border border-gray-300 rounded px-3 py-2">
                    <option value="">Sin supervisor</option>
                    <%
                        if (empleados != null) {
                            for (Usuario s : empleados) 
                            {  
                                String selected = "";
                                if (request.getAttribute("user") != null) {
                                    Usuario selectedUsuario = (Usuario) request.getAttribute("user");
                                    // Nota: Se corrige la condición del supervisor en el JSP
                                    if (selectedUsuario.getSupervisor() != null && (s.getId() == selectedUsuario.getSupervisor())) {
                                        selected = "selected";
                                    }
                                }
                    %>
                                <option value="<%= s.getId() %>" <%= selected %>><%= s.getNombreCompleto() %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
            
            <div id="campoCliente" class="hidden"> 
                <label class="block font-medium">Cliente:</label>
                <select name="cliente" class="w-full border border-gray-300 rounded px-3 py-2">
                    <option value="">Sin cliente</option>
                    <%
                        if (clientes != null) {
                            for (Cliente c : clientes) {  
                            	String selected = "";
                            	if (request.getAttribute("user") != null) {
                                    Usuario selectedUsuario = (Usuario) request.getAttribute("user");
                                    // Nota: Se corrige la condición del cliente en el JSP
                                    if (selectedUsuario.getIdCliente() != 0 && (c.getId() == selectedUsuario.getIdCliente())) {
                                        selected = "selected";
                                    }
                                }
                    %>
                                <option value="<%= c.getId() %>" <%= selected %>><%= c.getRazonSocial() %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
            
            
            

            <div class="flex justify-end space-x-4">
                <button type="button" class="bg-gray-300 text-black px-4 py-2 rounded hover:bg-gray-400" onclick="toggleModal('insert/update')">
                    Cancelar
                </button>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                    <%= request.getAttribute("user") != null ? "Actualizar" : "Guardar" %>
                </button>
            </div>
        </form>
    </div>
   </div>

<script>
    // Toggle modal function (debe estar disponible globalmente)
    function toggleModal(modalId) {
        const modal = document.getElementById(modalId);
        modal.classList.toggle('hidden');
    }

    // Lógica para mostrar/ocultar campos basada en el Rol
    document.addEventListener('DOMContentLoaded', function() {
        const rolSelector = document.getElementById('rolSelector');
        // Inicializar la vista al cargar (importante para el modo 'Editar')
        if (rolSelector) {
            manejarRol(rolSelector.value);
        }
    });

    function manejarRol(rolSeleccionado) {
        const campoSupervisor = document.getElementById('campoSupervisor');
        const campoCliente = document.getElementById('campoCliente');

        // 1. Ocultar ambos campos por defecto
        campoSupervisor.classList.add('hidden');
        campoCliente.classList.add('hidden');

        // 2. Mostrar el campo correspondiente
        if (rolSeleccionado === 'Empleado') {
            campoSupervisor.classList.remove('hidden');
        } else if (rolSeleccionado === 'Cliente') {
            campoCliente.classList.remove('hidden');
        }
    }
</script>

</body>
</html>