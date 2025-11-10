<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="proyectos.Proyecto" %>
<%@ page import="etapas.Etapa" %>
<%@ page import="tareas.Tarea" %>
<%@ page import="categoriaTarea.CategoriaTarea" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>Proyecto - Etapas</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        function toggleModal(modalId) {
            const modal = document.getElementById(modalId);
            modal.classList.toggle('hidden');
        }

        // Cerrar modal al hacer clic fuera
        window.onclick = function(e) {
            const modals = document.querySelectorAll('.modal');
            modals.forEach(modal => {
                if (e.target === modal) {
                    modal.classList.add('hidden');
                }
            });
        }
    </script>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .column-container {
            min-height: 400px;
        }
        .task-card {
            transition: all 0.2s ease;
        }
        .task-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        .etapa:hover{
        	transform: translateY(-2px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        tr.clickable-row, tr.clickable-row td {
        cursor: pointer;
    	}
    </style>
</head>

<body class="bg-gray-100 font-sans">

<jsp:include page="../header.jsp" />

<%
    Proyecto pro = (Proyecto) request.getAttribute("proyecto");
    List<Etapa> etapas = (List<Etapa>) request.getAttribute("etapas");
    List<CategoriaTarea> categorias = (List<CategoriaTarea>) request.getAttribute("categorias");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<div class="container mx-auto px-4 py-8">

    <!-- ENCABEZADO DEL PROYECTO -->
    <% if (pro != null) { %>
        <div class="bg-white rounded-lg shadow p-6 mb-6">
	        <div class="flex items-center justify-between">
	            <div>
	                <h1 class="text-2xl font-bold text-gray-800"><%= pro.getNombre() %></h1>
	                <p class="text-gray-600"><%= pro.getDescripcion() %></p>
	                <p class="text-sm text-gray-500 mt-2">
	                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
	                        <%= pro.getEstado() %>
	                    </span>
	                </p>
	            </div>
	            <a href="EtapaServlet?action=new&idProyecto=<%= pro.getId() %>" 
	                    class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-6 rounded-lg shadow transition">
	                + Nueva Etapa
	            </a>
	        </div>
	    </div>
    <% } else { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
            Proyecto no encontrado
        </div>
    <% } %>

	<!-- MENSAJE DE ERROR -->
    <% if (request.getAttribute("error") != null) { %>
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <!-- CONTROLES DE VISTA -->
    <div class="mb-4 flex items-center justify-between">
        <div class="flex gap-2">
            <button id="btnKanban" onclick="cambiarVista('kanban')" 
                    class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
                <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17V7m0 10a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h2a2 2 0 012 2m0 10a2 2 0 002 2h2a2 2 0 002-2M9 7a2 2 0 012-2h2a2 2 0 012 2m0 10V7m0 10a2 2 0 002 2h2a2 2 0 002-2V7a2 2 0 00-2-2h-2a2 2 0 00-2 2"></path>
                </svg>
                Columnas
            </button>
            <button id="btnLista" onclick="cambiarVista('lista')" 
                    class="px-4 py-2 bg-gray-200 text-gray-700 rounded hover:bg-gray-300">
                <svg class="inline w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                </svg>
                Lista
            </button>
        </div>
    </div>

	<% if (etapas == null || etapas.isEmpty()) { %>
            <div class="p-8 text-center text-gray-500">
                No hay etapas creadas aún.
            </div>
        <% } else { %>
        
        
	<!-- ESTADÍSTICAS RÁPIDAS -->
        <%
            int etapasPendientes = 0;
            int etapasEnProgreso = 0;
            int etapasCompletadas = 0;
            
            for (Etapa e : etapas) {    
	            if ("To Do".equals(e.getEstado())) etapasPendientes++;
	            else if ("In Progress".equals(e.getEstado())) etapasEnProgreso++;
	            else if ("Done".equals(e.getEstado())) etapasCompletadas++;
            }
                
            
        %>
        
        <div class="grid grid-cols-4 gap-4 mb-6">
            <div class="bg-white rounded-lg shadow p-4">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Total Etapas</p>
                        <p class="text-2xl font-bold text-gray-800"><%= etapas.size() %></p>
                    </div>
                    <div class="bg-purple-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
                        </svg>
                    </div>
                </div>
            </div>
            
            <div class="bg-white rounded-lg shadow p-4">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Pendientes</p>
                        <p class="text-2xl font-bold text-yellow-600"><%= etapasPendientes %></p>
                    </div>
                    <div class="bg-yellow-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </div>
                </div>
            </div>
            
            <div class="bg-white rounded-lg shadow p-4">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">En Progreso</p>
                        <p class="text-2xl font-bold text-blue-600"><%= etapasEnProgreso %></p>
                    </div>
                    <div class="bg-blue-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                        </svg>
                    </div>
                </div>
            </div>
            
            <div class="bg-white rounded-lg shadow p-4">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm text-gray-600">Completadas</p>
                        <p class="text-2xl font-bold text-green-600"><%= etapasCompletadas %></p>
                    </div>
                    <div class="bg-green-100 p-3 rounded-full">
                        <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                    </div>
                </div>
            </div>
        </div>
        
        
    <!-- VISTA KANBAN -->
    <div id="vistaKanban" class="flex gap-6 overflow-x-auto pb-4">
    	<% for (Etapa etapa : etapas) { 
            List<Tarea> tareasEtapa = etapa.getTareas();
            System.out.println(tareasEtapa);
            int numTareas = (tareasEtapa != null) ? tareasEtapa.size() : 0;
        %>
        <!-- ETAPAS -->
        <div class="bg-white shadow-lg rounded-lg p-6 column-container cursor-pointer etapa flex-shrink-0 w-80" onclick="window.location.href='TareaServlet?action=list&idEtapa=<%= etapa.getId() %>'">
            
			
			<!-- HEADER DE LA ETAPA -->
			<div class="border-b border-gray-200 pb-3 mb-4">
			    <div class="flex items-start justify-between mb-2">
			        <h3 class="text-lg font-bold text-gray-800 leading-tight flex-1 pr-2">
			            <%= etapa.getNombre() %>
			        </h3>
			        <span class="px-2.5 py-1 text-xs font-semibold rounded-full flex-shrink-0
			            <%= "To Do".equals(etapa.getEstado()) ? "bg-yellow-100 text-yellow-800" :
			                "In Progress".equals(etapa.getEstado()) ? "bg-blue-100 text-blue-800" :
			                "Done".equals(etapa.getEstado()) ? "bg-green-100 text-green-800" :
			                "bg-red-100 text-red-800" %>">
			            <%= etapa.getEstado() %>
			        </span>
			    </div>
			    
			    <% if (etapa.getDescripcion() != null && !etapa.getDescripcion().isEmpty()) { %>
			        <p class="text-sm text-gray-600 leading-snug"><%= etapa.getDescripcion() %></p>
			    <% } %>
			</div>
			
			<!-- CONTADOR DE TAREAS -->
			<div class="mb-4">
			    <div class="flex items-center text-sm text-gray-700">
			        <svg class="w-4 h-4 mr-1.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
			            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
			        </svg>
			        <span class="font-medium"><%= numTareas %></span>
			        <span class="ml-1 text-gray-500">tarea<%= numTareas != 1 ? "s" : "" %></span>
			    </div>
			</div>
			
			<!-- FECHAS DE LA ETAPA -->
			<div class="mb-4 space-y-2">
			    <% if (etapa.getFechaInicio() != null) { %>
			        <div class="flex items-center text-xs text-gray-600">
			            <svg class="w-3.5 h-3.5 mr-2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
			                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
			            </svg>
			            <span class="text-gray-500">Inicio:</span>
			            <span class="ml-1 font-medium text-gray-700"><%= sdf.format(etapa.getFechaInicio()) %></span>
			        </div>
			    <% } %>
			    <% if (etapa.getFechaTentativa() != null) { %>
			        <div class="flex items-center text-xs text-gray-600">
			            <svg class="w-3.5 h-3.5 mr-2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
			                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
			            </svg>
			            <span class="text-gray-500">Tentativa:</span>
			            <span class="ml-1 font-medium text-gray-700"><%= sdf.format(etapa.getFechaTentativa()) %></span>
			        </div>
			    <% } %>
			</div>
			
			<!-- BARRA DE PROGRESO -->
			<%
			    int tareasCompletadasEtapa = 0;
			    if (tareasEtapa != null && !tareasEtapa.isEmpty()) {
			        for (Tarea t : tareasEtapa) {
			            if ("Done".equals(t.getEstado())) tareasCompletadasEtapa++;
			        }
			    }
			    int progreso = (numTareas > 0) ? (tareasCompletadasEtapa * 100 / numTareas) : 0;
			    String colorBarra = progreso < 33 ? "bg-red-500" :
			                        progreso < 66 ? "bg-yellow-500" :
			                        progreso < 100 ? "bg-blue-500" : "bg-green-500";
			%>
			
			<div class="mb-4 pb-4 border-b border-gray-200">
			    <div class="flex justify-between items-center mb-2">
			        <span class="text-xs font-medium text-gray-700">Progreso</span>
			        <span class="text-sm font-bold text-gray-800"><%= progreso %>%</span>
			    </div>
			    <div class="w-full bg-gray-200 rounded-full h-2.5 overflow-hidden">
			        <div class="<%= colorBarra %> h-full rounded-full transition-all duration-300 ease-out" 
			             style="width: <%= progreso %>%"></div>
			    </div>
			    <div class="flex justify-between items-center mt-1.5">
			        <span class="text-xs text-gray-500">
			            <%= tareasCompletadasEtapa %> de <%= numTareas %> completadas
			        </span>
			    </div>
			</div>
            
            <div class="space-y-3 max-h-96 overflow-y-auto">
            <% if (tareasEtapa == null || tareasEtapa.isEmpty()) { %>
	            <div class="text-center py-8 text-gray-400">
	                <svg class="mx-auto h-12 w-12 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
	                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
	                </svg>
	                <p class="text-sm">Sin tareas</p>
	                <a href="TareaServlet?action=new&idEtapa=<%= etapa.getId() %>" 
	                   class="text-blue-600 hover:text-blue-700 text-xs font-medium mt-2 inline-block">
	                    + Agregar tarea
	                </a>
	            </div>
	        <% } else { 
	            for (Tarea tarea : tareasEtapa) { 
	            String estado = tarea.getEstado();
	            int idCat = tarea.getIdCategoria();
	            String nombreCat = "Sin categoría";
	            System.out.println("categorias"+categorias);
	            if (categorias != null) {
	                for (CategoriaTarea c : categorias) {
						if (c.getId() == idCat) {
	  						nombreCat = c.getNombre();
	  						break; // ya la encontraste, salís del bucle
						}
	                }
				}
				%>
                <!-- TAREAS -->
                <div class="task-card bg-gray-50 p-4 rounded-lg border-l-4 cursor-pointer
                				<%= "To Do".equals(estado) ? "border-yellow-500" :
                                "In Progress".equals(estado) ? "border-blue-500" :
                                "Done".equals(estado) ? "border-green-500" :
                                "border-red-500" %>">
                                
                    <div class="flex justify-between items-start mb-2">
                        <h4 class="font-semibold text-gray-900 text-sm"><%= tarea.getNombre() %></h4>
                        <button class="text-gray-400 hover:text-gray-600">
                            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                                <path d="M10 6a2 2 0 110-4 2 2 0 010 4zM10 12a2 2 0 110-4 2 2 0 010 4zM10 18a2 2 0 110-4 2 2 0 010 4z"></path>
                            </svg>
                        </button>
                    </div>
                    
                    <p class="text-xs text-gray-600 mb-3"><%= tarea.getDescripcion() %></p>
                    
                    <div class="mb-2">
                        <span class="px-2 py-1 text-xs font-medium rounded-full
                            <%= "To Do".equals(estado) ? "bg-yellow-100 text-yellow-800" :
                                "In Progress".equals(estado) ? "bg-blue-100 text-blue-800" :
                                "Done".equals(estado) ? "bg-green-100 text-green-800" :
                                "bg-red-100 text-red-800" %>">
                            <%= estado %>
                        </span>
                    </div>
                    
                    <div class="flex items-center justify-between text-xs text-gray-500">
	                    
                    <% if (!"Done".equals(estado)) { %>
                        <div class="flex items-center">
                            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                            </svg>
                            <%= tarea.getFechaInicio() != null ? sdf.format(tarea.getFechaInicio()) : "—"%>
                            →
                            <%= tarea.getFechaFin() != null ? sdf.format(tarea.getFechaFin()) : "—"%>
                        </div>
                    <% } else { %> 
                        <div class="flex items-center text-green-600">
                            <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                            </svg>
                            <%= tarea.getFechaInicio() != null ? sdf.format(tarea.getFechaInicio()) : "—"%>
                            →
                            <%= tarea.getFechaFin() != null ? sdf.format(tarea.getFechaFin()) : "—"%>
                        </div>
                    <% } %>
                        <div class="flex -space-x-2">
                            <div class="w-6 h-6 bg-purple-500 text-white rounded-full flex items-center justify-center text-xs font-bold border-2 border-white" title="Juan Pérez">
                                JP
                            </div>
                            <div class="w-6 h-6 bg-green-500 text-white rounded-full flex items-center justify-center text-xs font-bold border-2 border-white" title="María García">
                                MG
                            </div>
                            <div class="w-6 h-6 bg-green-500 text-white rounded-full flex items-center justify-center text-xs font-bold border-2 border-white" title="María García">
                                MG
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-2">
                        <span class="inline-block bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded">
                        <%= nombreCat %>
                        </span>
                    </div>
                </div>
                <% } %>
                <% } %>
            </div>
        </div>
        
        <% } %>
    </div>

    <!-- VISTA LISTA (oculta inicialmente) -->
    <div id="vistaLista" class="hidden bg-white rounded-lg shadow overflow-hidden">
    	<table class="w-full">
	        <thead class="bg-gray-50 border-b">
	            <tr>
	                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Etapa</th>
	                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Estado</th>
	                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fechas</th>
	                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Acciones</th>
	            </tr>
	        </thead>
	        <tbody class="bg-white divide-y divide-gray-200">
	            <% for (Etapa e : etapas) { %>
	                <tr class="hover:bg-gray-50 transition clickable-row" onclick="window.location.href='TareaServlet?action=list&idEtapa=<%= e.getId() %>'">
	                    <td class="px-6 py-4 whitespace-nowrap">
	                        <div>
	                            <div class="text-sm font-medium text-gray-900"><%= e.getNombre() %></div>
	                            <% if (e.getDescripcion() != null && !e.getDescripcion().isEmpty()) { %>
	                                <div class="text-sm text-gray-500"><%= e.getDescripcion() %></div>
	                            <% } %>
	                        </div>
	                    </td>
	                    <td class="px-6 py-4 whitespace-nowrap">
	                        <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full
	                            <%= "To Do".equals(e.getEstado()) ? "bg-yellow-100 text-yellow-800" :
	                                "In Progress".equals(e.getEstado()) ? "bg-blue-100 text-blue-800" :
	                                "Done".equals(e.getEstado()) ? "bg-green-100 text-green-800" :
	                                "bg-red-100 text-red-800" %>">
	                            <%= e.getEstado() %>
	                        </span>
	                    </td>
	                    <td class="px-6 py-4 text-sm text-gray-600">
	                        <div><strong>Inicio:</strong> <%= e.getFechaInicio() != null ? sdf.format(e.getFechaInicio()) : "—"%></div>
	                        <div><strong>Tentativa:</strong> <%= e.getFechaTentativa() != null ? sdf.format(e.getFechaTentativa()) : "—"%></div>
	                        <div><strong>Fin:</strong> <%= e.getFechaFin() != null ? sdf.format(e.getFechaFin()) : "—"%></div>
	                    </td>
	                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
	                        <a href="EtapaServlet?action=edit&id=<%= e.getId() %>&idProyecto=<%= pro.getId() %>"
	                           class="text-indigo-600 hover:text-indigo-900 mr-4">
	                            Editar
	                        </a>
	                        <a href="EtapaServlet?action=delete&id=<%= e.getId() %>&idProyecto=<%= pro.getId() %>"
	                           class="text-red-600 hover:text-red-900"
	                           onclick="return confirm('¿Eliminar etapa <%= e.getNombre() %>?')">
	                            Eliminar
	                        </a>
	                    </td>
	                </tr>
	            <% } %>
	        </tbody>
    	</table>
    </div>
    <% } %>
</div>


<script>
function toggleModal(modalId) {
    const modal = document.getElementById(modalId);
    modal.classList.toggle('hidden');
}

function cambiarVista(vista) {
    const vistaKanban = document.getElementById('vistaKanban');
    const vistaLista = document.getElementById('vistaLista');
    const btnKanban = document.getElementById('btnKanban');
    const btnLista = document.getElementById('btnLista');
    
    if (vista === 'kanban') {
        vistaKanban.classList.remove('hidden');
        vistaLista.classList.add('hidden');
        btnKanban.classList.remove('bg-gray-200', 'text-gray-700');
        btnKanban.classList.add('bg-blue-600', 'text-white');
        btnLista.classList.remove('bg-blue-600', 'text-white');
        btnLista.classList.add('bg-gray-200', 'text-gray-700');
    } else {
        vistaKanban.classList.add('hidden');
        vistaLista.classList.remove('hidden');
        btnLista.classList.remove('bg-gray-200', 'text-gray-700');
        btnLista.classList.add('bg-blue-600', 'text-white');
        btnKanban.classList.remove('bg-blue-600', 'text-white');
        btnKanban.classList.add('bg-gray-200', 'text-gray-700');
    }
}
</script>

<!-- INCLUIR EL MODAL DE FORMULARIO -->
<jsp:include page="../etapas/formulario.jsp" />

</body>
</html>
