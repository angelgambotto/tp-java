<%@page import="proyectos.Proyecto"%>
<%@page import="adjuntosComentario.AdjuntosComentarioDAO"%>
<%@page import="adjuntosComentario.AdjuntosComentario"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="tareas.Tarea" %>
<%@ page import="horastrabajadas.HoraTrabajada" %>
<%@ page import="comentarios.Comentario" %>
<%@ page import="usuarios.Usuario" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>Detalle de Tarea</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .tab-active {
            border-bottom: 2px solid #2563eb;
            color: #2563eb;
        }
    </style>
</head>

<script>
window.addEventListener("DOMContentLoaded", function() {
    const tab = "<%= request.getAttribute("tab") %>";
    if (tab === "comentarios") {
        cambiarTab("comentarios");
    }
});
</script>

<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<%
    Tarea tarea = (Tarea) request.getAttribute("tarea");
	Usuario usuario = (Usuario) request.getAttribute("usuario");
    List<HoraTrabajada> horas = (List<HoraTrabajada>) request.getAttribute("horas");
    List<Comentario> comentarios = (List<Comentario>) request.getAttribute("comentarios");
    List<Usuario> empleadosAsignados = (List<Usuario>) request.getAttribute("empleadosAsignados");
    List<Usuario> empleadosDisponibles = (List<Usuario>) request.getAttribute("empleadosDisponibles");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfTime = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    Usuario usuarioActual = (Usuario) session.getAttribute("usuario");
    String rol = usuarioActual.getRol();
    Proyecto pro = (Proyecto) request.getAttribute("proyecto");
%>

<div class="container mx-auto px-4 sm:px-6 lg:px-8 py-4 sm:py-6 lg:py-8">

	<!-- BOTÓN VOLVER -->
	<div class="mb-4">
	    <a href="TareaServlet?action=list&idEtapa=<%= tarea.getIdEtapa() %>"
	       class="flex items-center gap-2 text-gray-600 hover:text-gray-800 font-medium transition">
	        
	        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
	            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
	        </svg>
	
	        Volver a Etapa
	    </a>
	</div>

    <!-- HEADER DE LA TAREA -->
    <% if (tarea != null) { %>
        <div class="bg-white rounded-lg shadow p-4 sm:p-6 mb-4 sm:mb-6">
            <div class="flex flex-col lg:flex-row lg:items-start lg:justify-between gap-4 mb-4">
                <div class="flex-1">
                    <div class="flex flex-wrap items-center gap-2 mb-2">
                        <h1 class="text-xl sm:text-2xl font-bold text-gray-800"><%= tarea.getNombre() %></h1>
                        <span class="px-3 py-1 text-xs font-semibold rounded-full
                            <%= "To Do".equals(tarea.getEstado()) ? "bg-yellow-100 text-yellow-800" :
                                "In Progress".equals(tarea.getEstado()) ? "bg-blue-100 text-blue-800" :
                                "Done".equals(tarea.getEstado()) ? "bg-green-100 text-green-800" :
                                "bg-red-100 text-red-800" %>">
                            <%= tarea.getEstado() %>
                        </span>
                    </div>
                    <p class="text-sm sm:text-base text-gray-600 mb-3"><%= tarea.getDescripcion() %></p>
                    
                    <!-- Fechas -->
                    <div class="flex flex-wrap gap-4 text-sm text-gray-600">
                        <div class="flex items-center">
                            <svg class="w-4 h-4 mr-1.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                            </svg>
                            <span class="font-medium">Inicio:</span>
                            <span class="ml-1"><%= tarea.getFechaInicio() != null ? sdf.format(tarea.getFechaInicio()) : "—" %></span>
                        </div>
                        <div class="flex items-center">
                            <svg class="w-4 h-4 mr-1.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                            </svg>
                            <span class="font-medium">Fin:</span>
                            <span class="ml-1"><%= tarea.getFechaFin() != null ? sdf.format(tarea.getFechaFin()) : "—" %></span>
                        </div>
                    </div>
                </div>

                <!-- Botón de editar -->
                <div class="flex-shrink-0">
                  <% if (rol.equalsIgnoreCase("administrador") ||
                  		usuarioActual.getId() == pro.getSupervisor().getId()) { %>
	          
                    <a href="TareaServlet?action=edit&idTarea=<%= tarea.getId() %>" 
                       class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 sm:px-6 rounded-lg shadow transition text-center">
                        <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                        </svg>
                        Editar Tarea
                    </a>
                    <% } %>
                </div>
            </div>

            <!-- EMPLEADOS ASIGNADOS -->
            <div class="border-t pt-4">
                <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-3">
                    <h3 class="text-sm font-semibold text-gray-700 flex items-center">
                        <svg class="w-5 h-5 mr-2 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
                        </svg>
                        Personas Asignadas
                    </h3>
                     <% if (rol.equalsIgnoreCase("administrador") ||
                     		usuarioActual.getId() == pro.getSupervisor().getId()) { %>
	          
                    <button onclick="toggleModal('modalAsignarEmpleado')" 
                            class="text-sm bg-green-600 hover:bg-green-700 text-white font-medium py-1.5 px-4 rounded-lg transition">
                        + Asignar Persona
                    </button>
                    <% } %>
                </div>

                <div class="flex flex-wrap gap-2">
                    <% if (empleadosAsignados != null && !empleadosAsignados.isEmpty()) { 
                        for (Usuario emp : empleadosAsignados) { 
                            String[] colores = {"bg-purple-400", "bg-blue-400", "bg-indigo-400"};
                            String color = colores[emp.getId() % colores.length];
                    %>
                        <div class="flex items-center gap-2 <%= color %> text-white px-3 py-1.5 rounded-full text-sm font-medium">
                            <span><%= emp.getNombre() %> <%= emp.getApellido() %></span>
                        </div>
                    <% } 
                    } else { %>
                        <p class="text-sm text-gray-500 italic">No hay personas asignadas aún</p>
                    <% } %>
                </div>
            </div>
        </div>
    <% } else { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4 sm:mb-6">
            Tarea no encontrada
        </div>
    <% } %>

<% 
    // Variable que indica si el usuario puede ver el contenido sensible
    boolean puedeVerContenido = false;

    // 1. Es administrador?
    if ("administrador".equalsIgnoreCase(rol) ||
    		usuarioActual.getId() == pro.getSupervisor().getId()) {
        puedeVerContenido = true;
    }
    // 2. Si no es admin, revisamos si está asignado a la tarea
    else if (empleadosAsignados != null && usuarioActual != null) {
        for (Usuario emp : empleadosAsignados) {
            if (emp.getId() == usuarioActual.getId()) {
                puedeVerContenido = true;
                break;
            }
        }
    }
%>

<% if (puedeVerContenido) { %>
    <!-- TABS -->
    <div class="bg-white rounded-lg shadow mb-6">
        <div class="border-b overflow-x-auto">
            <nav class="flex min-w-max sm:min-w-0">
                <button onclick="cambiarTab('horas')" id="tabHoras" 
                        class="tab-active px-4 sm:px-6 py-3 text-sm font-medium text-gray-700 whitespace-nowrap transition">
                    <svg class="inline w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    Horas Trabajadas
                </button>
                <button onclick="cambiarTab('comentarios')" id="tabComentarios" 
                        class="px-4 sm:px-6 py-3 text-sm font-medium text-gray-700 hover:text-blue-600 whitespace-nowrap transition">
                    <svg class="inline w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
                    </svg>
                    Comentarios
                </button>
            </nav>
        </div>


        <!-- CONTENIDO DE HORAS TRABAJADAS -->
        <div id="contentHoras" class="p-4 sm:p-6">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-4">
                <h2 class="text-lg font-semibold text-gray-800">Registro de Horas</h2>
                 <% if (rol.equalsIgnoreCase("empleado") || rol.equalsIgnoreCase("administrador")) { %>
	          
                <a href="HoraTrabajadaServlet?action=new&idTarea=<%= tarea.getId() %>&idEmpleado=<%= usuarioActual.getId() %>&origin=unaTarea" 
                        class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg transition text-sm">
                    + Registrar Horas
                </a>
                <% } %>
            </div>

            <% if (horas == null || horas.isEmpty()) { %>
                <div class="text-center py-12 text-gray-400">
                    <svg class="mx-auto h-12 w-12 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <p class="text-sm">No hay horas registradas aún</p>
                </div>
            <% } else { %>
                <!-- Vista móvil: Cards -->
                <div class="block lg:hidden space-y-3">
                    <% 
                    int totalHoras = 0;
                    for (HoraTrabajada h : horas) {
                    	totalHoras += h.getCantidad();
                    	int idEmp = h.getIdEmpleado();
        	            String nombreEmp = "NN";
        	            if (empleadosAsignados != null) {
        	                for (Usuario e : empleadosAsignados) {
        						if (e.getId() == idEmp) {
        	  						nombreEmp = e.getApellido() + ", " +e.getNombre();
        	  						break;
        						}
        	                }
        				}
                    %>
                        <div class="bg-gray-50 rounded-lg p-4 border border-gray-200">
                            <div class="flex justify-between items-start mb-2">
                                <div>
                                    <p class="font-semibold text-gray-800"><%= nombreEmp %></p>
                                    <p class="text-xs text-gray-500"><%= h.getFecha() != null ? sdf.format(h.getFecha()) : "—" %></p>
                                </div>
                                <span class="bg-blue-100 text-blue-800 text-sm font-bold px-3 py-1 rounded-full">
                                    <%= h.getCantidad() %>h
                                </span>
                            </div>
                        </div>
                    <% } %>
                    <div class="bg-blue-50 rounded-lg p-4 border-2 border-blue-200">
                        <p class="text-sm text-gray-600">Total de horas:</p>
                        <p class="text-2xl font-bold text-blue-600"><%= totalHoras %> horas</p>
                    </div>
                </div>

                <!-- Vista desktop: Tabla -->
                <div class="hidden lg:block overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Empleado</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Fecha</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Detalle</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Horas</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            <% 
                            totalHoras = 0;
                            for (HoraTrabajada h : horas) { 
                                totalHoras += h.getCantidad();
                                int idEmp = h.getIdEmpleado();
                	            String nombreEmp = "NN";
                	            if (empleadosAsignados != null) {
                	                for (Usuario e : empleadosAsignados) {
                						if (e.getId() == idEmp) {
                	  						nombreEmp = e.getApellido() + ", " +e.getNombre();
                	  						break;
                						}
                	                }
                				}
                            %>
                                <tr class="hover:bg-gray-50">
                                    <td class="px-6 py-4 text-sm text-gray-900"><%= nombreEmp %></td>
                                    <td class="px-6 py-4 text-sm text-gray-600"><%= h.getFecha() != null ? sdf.format(h.getFecha()) : "—" %></td>
                                    <td class="px-6 py-4"><%= h.getDetalle() %></td>
                                    <td class="px-6 py-4">
                                        <span class="bg-blue-100 text-blue-800 text-sm font-semibold px-3 py-1 rounded-full">
                                            <%= h.getCantidad() %> horas
                                        </span>
                                    </td>
                                </tr>
                            <% } %>
                            <tr class="bg-blue-50 font-semibold">
                                <td colspan="3" class="px-6 py-4 text-sm text-gray-700">Total de horas</td>
                                <td class="px-6 py-4">
                                    <span class="bg-blue-600 text-white text-sm font-bold px-4 py-1.5 rounded-full">
                                        <%= totalHoras %> horas
                                    </span>
                                </td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <!-- CONTENIDO DE COMENTARIOS -->
        <div id="contentComentarios" class="p-4 sm:p-6 hidden">
            <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3 mb-6">
                <h2 class="text-lg font-semibold text-gray-800">Comentarios</h2>
            </div>
                        
            <!-- Formulario para nuevo comentario + archivos adjuntos -->
			<div class="bg-gray-50 rounded-lg p-4 mb-6">
			    <form action="ComentarioServlet" method="post" enctype="multipart/form-data">
			        <input type="hidden" name="action" value="new">
			        <input type="hidden" name="idTarea" value="<%= tarea != null ? tarea.getId() : "" %>">
			
			        <textarea name="texto" rows="3"
			                  class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
			                  placeholder="Escribe un comentario... (opcional si adjuntas archivos)" required></textarea>
		
			        <!-- Input para adjuntar archivos (múltiples) -->
			        <div class="mt-3">
			            <label class="block text-sm font-medium text-gray-700 mb-1">
			                Adjuntar archivos (imágenes, PDFs, documentos...)
			            </label>
			            <input type="file" 
			                   name="archivos" 
			                   multiple 
			                   accept="image/*,application/pdf,.doc,.docx,.xls,.xlsx,.txt"
			                   class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
			            <p class="text-xs text-gray-500 mt-1">Puedes seleccionar varios archivos (máx 10 MB total recomendado)</p>
			        </div>
			
			        <div class="mt-4 flex justify-end">
			            <button type="submit"
			                    class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg transition text-sm">
			                Publicar Comentario
			            </button>
			        </div>
   			 </form>
			</div>

            <!-- Lista de comentarios -->
            <div class="space-y-4">
                <% if (comentarios == null || comentarios.isEmpty()) { %>
                    <div class="text-center py-12 text-gray-400">
                        <svg class="mx-auto h-12 w-12 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"></path>
                        </svg>
                        <p class="text-sm">No hay comentarios aún</p>
                    </div>
                <% } else { 
                    for (Comentario c : comentarios) { 
                    	int idEmp = c.getIdEmpleado();
                	            String nombreEmp = "NN";
                	            String iniciales = "NN";
                	            if (empleadosAsignados != null) {
                	                for (Usuario e : empleadosAsignados) {
                						if (e.getId() == idEmp) {
                	  						nombreEmp = e.getApellido() + ", " +e.getNombre();
                	  						iniciales = e.getNombre().substring(0, 1) + e.getApellido().substring(0, 1);
                	  						break;
                						}
                	                }
                				}%>
                        <div class="bg-white border border-gray-200 rounded-lg p-4 hover:shadow-md transition">
                            <div class="flex items-start gap-3">
                                <div class="w-10 h-10 bg-gray-300 rounded-full flex items-center justify-center text-white font-semibold flex-shrink-0">
                                    <%= iniciales %>
                                </div>
                                <div class="flex-1 min-w-0">
                                    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-1 mb-2">
                                        <p class="font-semibold text-gray-900 text-sm"><%= nombreEmp %></p>
                                        <p class="text-xs text-gray-500"><%= c.getFecha() != null ? sdfTime.format(c.getFecha()) : "—" %></p>
                                    </div>
                                    <p class="text-sm text-gray-700 break-words"><%= c.getTexto() %></p>
                                    <!-- Archivos adjuntos -->
									<% 
									List<AdjuntosComentario> adjuntos = AdjuntosComentarioDAO.obtenerPorComentario(c.getId());
									if (adjuntos != null && !adjuntos.isEmpty()) { %>
									    <div class="mt-3 flex flex-wrap gap-2">
									        <% for (AdjuntosComentario a : adjuntos) { %>
									            <!-- <a href="<%= request.getContextPath() %><%= a.getRuta() %>"  target="_blank" 
									               class="inline-flex items-center gap-1 px-3 py-1.5 bg-gray-100 hover:bg-gray-200 rounded text-xs font-medium text-gray-700">
									                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
									                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.586-6.586"></path>
									                </svg>
									                <%= a.getNombreOriginal().length() > 30 ? a.getNombreOriginal().substring(0,27)+"..." : a.getNombreOriginal() %>
									            </a> -->
									            <% 
String rutaCompleta = request.getContextPath() + a.getRuta();
String tipo = a.getTipoMime() != null ? a.getTipoMime() : "";
boolean esImagen = tipo.startsWith("image/");
%>

<% if (esImagen) { %>
    <a href="<%= rutaCompleta %>" target="_blank">
        <img src="<%= rutaCompleta %>" alt="<%= a.getNombreOriginal() %>" 
             class="h-32 rounded border object-cover hover:opacity-80 transition">
    </a>
<% } else { %>
    <a href="<%= rutaCompleta %>" target="_blank"
       class="inline-flex items-center gap-1 px-3 py-1.5 bg-gray-100 hover:bg-gray-200 rounded text-xs font-medium text-gray-700">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.586-6.586"></path>
        </svg>
        <%= a.getNombreOriginal().length() > 30 ? a.getNombreOriginal().substring(0,27)+"..." : a.getNombreOriginal() %>
    </a>
<% } %>
									        <% } %>
									    </div>
									<% } %>
                                    <% if (usuarioActual != null && usuarioActual.getId() == c.getIdEmpleado()) { %>
                                        <button onclick="eliminarComentario(<%= c.getId() %>)" 
                                                class="text-xs text-red-600 hover:text-red-800 mt-2">
                                            Eliminar
                                        </button>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } 
                } %>
            </div>
        </div>
    </div>
    <% } else { %>
    <!-- Mensaje para quien no tiene permiso -->
    <div class="bg-white rounded-lg shadow p-8 text-center">
        <svg class="mx-auto h-16 w-16 text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
        </svg>
        <h3 class="text-lg font-medium text-gray-900 mb-2">Acceso restringido</h3>
        <p class="text-gray-600">Solo los administradores y las personas asignadas a esta tarea pueden ver esta información.</p>
    </div>
<% } %>
    
</div>

<!-- MODAL ASIGNAR EMPLEADO -->
<div id="modalAsignarEmpleado" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
    <div class="bg-white rounded-lg shadow-xl max-w-md w-full max-h-[90vh] overflow-y-auto">
        <div class="p-4 sm:p-6">
            <div class="flex items-center justify-between mb-4">
                <h3 class="text-lg font-semibold text-gray-900">Asignar Persona</h3>
                <button onclick="toggleModal('modalAsignarEmpleado')" class="text-gray-400 hover:text-gray-600">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
            </div>

            <form action="TareaServlet?action=asignar&idTarea=<%= tarea.getId() %>" method="post">
                <input type="hidden" name="action" value="asignar">
                <input type="hidden" name="idTarea" value="<%= tarea != null ? tarea.getId() : "" %>">

                <!-- Barra de búsqueda -->
                <input 
                    type="text" 
                    id="buscadorEmpleado"
                    placeholder="Buscar empleado..." 
                    class="w-full mb-3 px-3 py-2 border rounded-lg focus:ring focus:ring-blue-200"
                    onkeyup="filtrarEmpleados()"
                />

                <!-- Lista de empleados -->
                <div id="lista-empleados" class="border rounded-lg px-4 py-3 max-h-40 overflow-y-auto">

                <% if (empleadosDisponibles != null) {
                       for (Usuario u : empleadosDisponibles) {
                           boolean seleccionado = empleadosAsignados != null &&
                                   empleadosAsignados.stream().anyMatch(us -> us.getId() == u.getId());
                %>

                    <label class="flex items-center space-x-2 mb-2 cursor-pointer empleado-item">
                        <input type="checkbox"
                               name="usuarios"
                               value="<%= u.getId() %>"
                               <%= seleccionado ? "checked" : "" %>
                               class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded">
                        <span class="empleado-nombre">
                            <%= u.getNombre() %> <%= u.getApellido() %>
                        </span>
                    </label>

                <% } } %>

                </div>

                <div class="flex flex-col sm:flex-row gap-2 justify-end mt-4">
                    <button type="button" onclick="toggleModal('modalAsignarEmpleado')" 
                            class="px-4 py-2 text-gray-700 bg-gray-200 hover:bg-gray-300 rounded-lg transition">
                        Cancelar
                    </button>
                    <button type="submit" 
                            class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition">
                        Asignar
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../horasTrabajadas/formulario.jsp" />
<jsp:include page="../tareas/formulario.jsp" />
<script>
function toggleModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.classList.toggle('hidden');
}

function cambiarTab(tab) {
    const tabHoras = document.getElementById('tabHoras');
    const tabComentarios = document.getElementById('tabComentarios');
    const contentHoras = document.getElementById('contentHoras');
    const contentComentarios = document.getElementById('contentComentarios');
    
    if (tab === 'horas') {
        tabHoras.classList.add('tab-active');
        tabComentarios.classList.remove('tab-active');
        contentHoras.classList.remove('hidden');
        contentComentarios.classList.add('hidden');
    } else {
        tabComentarios.classList.add('tab-active');
        tabHoras.classList.remove('tab-active');
        contentComentarios.classList.remove('hidden');
        contentHoras.classList.add('hidden');
    }
}

function eliminarAsignacion(idEmpleado, idTarea) {
    if (confirm('¿Desea eliminar esta asignación?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'TareaEmpleadoServlet';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'eliminar';
        
        const tareaInput = document.createElement('input');
        tareaInput.type = 'hidden';
        tareaInput.name = 'idTarea';
        tareaInput.value = idTarea;
        
        const empInput = document.createElement('input');
        empInput.type = 'hidden';
        empInput.name = 'idEmpleado';
        empInput.value = idEmpleado;
        
        const fechaInput = document.createElement('input');
        fechaInput.type = 'hidden';
        fechaInput.name = 'fecha';
        fechaInput.value = fecha;
        
        form.appendChild(actionInput);
        form.appendChild(tareaInput);
        form.appendChild(empInput);
        form.appendChild(fechaInput);
        document.body.appendChild(form);
        form.submit();
    }
}

function eliminarComentario(id) {
    if (confirm('¿Desea eliminar este comentario?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'ComentarioServlet';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        
        const comInput = document.createElement('input');
        comInput.type = 'hidden';
        comInput.name = 'idComentario';
        comInput.value = id;
        
        form.appendChild(actionInput);
        form.appendChild(comInput);
        document.body.appendChild(form);
        form.submit();
    }
}

function filtrarEmpleados() {
    const texto = document.getElementById("buscadorEmpleado").value.toLowerCase();
    const items = document.querySelectorAll("#lista-empleados .empleado-item");

    items.forEach(item => {
        const nombre = item.querySelector(".empleado-nombre").innerText.toLowerCase();
        item.style.display = nombre.includes(texto) ? "flex" : "none";
    });
}

// Cerrar modales al hacer clic fuera
window.onclick = function(event) {
    const modals = document.querySelectorAll('[id^="modal"]');
    modals.forEach(modal => {
        if (event.target === modal) {
            modal.classList.add('hidden');
        }
    });
}
<% if (request.getAttribute("abrirModal") != null) { %>
window.onload = () => toggleModal("modalFormTarea");
<% } %>
</script>

</body>
</html>