package etapas;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import exceptions.DAOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import proyectos.Proyecto;
import proyectos.ProyectoDAO;
import usuarios.Usuario;

@WebServlet("/EtapaServlet")
public class EtapaServlet extends HttpServlet {
	 private static final long serialVersionUID = 1L;
	 private EtapaDAO edao;
	 private ProyectoDAO pdao;
    @Override
    public void init() {
        edao = new EtapaDAO();
        pdao = new ProyectoDAO();
    }
    
	//metodo para cargar los proyectos y no tener problemas con el bloque try catch
	private List<Etapa> cargarEtapasSeguro(HttpServletRequest request) {
	    try {
	        return edao.getByProyectoId(Integer.parseInt(request.getParameter("idProyecto")));
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudieron cargar las etapas: " + e.getMessage());
	        return new ArrayList<>();
	    }
	}
	
	private Etapa cargarEtaSeguro(HttpServletRequest request, int id) {
	    try {
	        return edao.getOne(id);
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudo cargar la etapa: " + e.getMessage());
	        return new Etapa();
	    }
	}
 
	 protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 
		 Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		    if (usuario == null || !"Administrador".equalsIgnoreCase(usuario.getRol())) {
		        response.sendRedirect("login.jsp");
		        return; 
		    }
	    	String action = request.getParameter("action");

	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	        
	        if ("view".equals(action)) {
	            // --- AQUÍ RECIBIMOS EL ID DEL PROYECTO ---
	            int idProyecto = Integer.parseInt(request.getParameter("id"));

	            // 1. Cargar el PROYECTO
	           Proyecto proyecto = null;
	            try {
	                proyecto = pdao.getById(idProyecto);
	            } catch (DAOException e) {
	                request.setAttribute("error", "Proyecto no encontrado");
	            }

	            // 2. Cargar TODAS LAS ETAPAS de ese proyecto
	            List<Etapa> etapas = new ArrayList<>();
	            try {
	                etapas = edao.getByProyectoId(idProyecto);
	            } catch (DAOException e) {
	                request.setAttribute("error", "Error al cargar etapas: " + e.getMessage());
	            }

	            // 3. Pasar todo a la JSP
	            request.setAttribute("proyecto", proyecto);
	            request.setAttribute("etapas", etapas);

	            // 4. Mostrar la página
	            request.getRequestDispatcher("proyectos/unProyecto.jsp").forward(request, response);
	            return;
	        }
	        
	        if (action == null) action = "list";
	        switch (action) {
        	case "new":
                String currentDate = sdf.format(new Date());
                request.setAttribute("fechaInicio", currentDate);
       		 	request.setAttribute("abrirModal", true);
        		break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Etapa etapa = cargarEtaSeguro(request, editId);
                request.setAttribute("id", etapa.getId());
                request.setAttribute("nombre", etapa.getNombre());               
                request.setAttribute("descripcion", etapa.getDescripcion());
                request.setAttribute("estado", etapa.getEstado());   
                request.setAttribute("fechaInicio", sdf.format(etapa.getFechaInicio()));
                request.setAttribute("fechaTentativa", sdf.format(etapa.getFechaTentativa()));
                request.setAttribute("fechaFin", sdf.format(etapa.getFechaFin()));
                request.setAttribute("abrirModal", true);
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                Etapa eta = cargarEtaSeguro(request, deleteId);
                request.setAttribute("etapa", eta);
                //request.setAttribute("abrirModalEliminar", true);
             
                
                try {                	
                	edao.delete(deleteId);
                } catch (DAOException e) {
                	request.setAttribute("error", e.getMessage());
        	        request.getRequestDispatcher("etapas/listado.jsp").forward(request, response);
                }
                
                break;
        }

        request.setAttribute("etapas", cargarEtapasSeguro(request));
        request.getRequestDispatcher("etapas/listado.jsp").forward(request, response);
    }

		 
	 
	 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 
		 Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		    if (usuario == null || !"Administrador".equalsIgnoreCase(usuario.getRol())) {
		        response.sendRedirect("login.jsp");
		        return; 
		    }
	    	int id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
	                 ? 0 : Integer.parseInt(request.getParameter("id"));
	        
	        //para hacer el update/insert
	    	String nombre = request.getParameter("nombre");
	        String descripcion = request.getParameter("descripcion");
	        String estado = request.getParameter("estado");
	        String fechaIni = request.getParameter("fechaInicio");
	        String fechaTenta = request.getParameter("fechaTentativa");
	        String fechaFi = request.getParameter("fechaFin");
	        int idProyecto = Integer.parseInt(request.getParameter("idProyecto"));

	        // Conversion de fechas
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	        java.util.Date utilInicio = null;
	        java.util.Date utilTentativa = null;
	        java.util.Date utilFin = null;

	        try {
	            utilInicio = sdf.parse(fechaIni);
	            utilTentativa = sdf.parse(fechaTenta);
	            utilFin = sdf.parse(fechaFi);
	        } catch (ParseException e) {
	            e.printStackTrace();
	            response.sendRedirect("EtapaServlet?error=fecha_invalida");
	            return;
	        }

	        // CONVERSIÓN: java.util.Date → java.sql.Date
	        java.sql.Date sqlInicio = new java.sql.Date(utilInicio.getTime());
	        java.sql.Date sqlTentativa = new java.sql.Date(utilTentativa.getTime());
	        java.sql.Date sqlFin = new java.sql.Date(utilFin.getTime());
	        
	       
	       Etapa eta = new Etapa(); 
	        eta.setId(id);
	        eta.setNombre(nombre);
	        eta.setDescripcion(descripcion);
	        eta.setEstado(estado);
	        eta.setFechaInicio(sqlInicio);
	        eta.setFechaTentativa(sqlTentativa);
	        eta.setFechaFin(sqlFin);
	        eta.setIdProyecto(idProyecto);
	        eta.setTareas(new java.util.LinkedList<>());
	        
	        try {        	
	        	if (id > 0) {
	        		edao.update(eta);
	        	} else {
	        		edao.insert(eta);
	        	}
	        	response.sendRedirect("EtapaServlet");
	        	
	        } catch (DAOException e) {
	        	request.setAttribute("error", e.getMessage());
		        request.getRequestDispatcher("etapas/listado.jsp").forward(request, response);
	        }
	        
		 
	 } //cierra el doPost
} //cierra el servlet
