package horastrabajadas;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import proyectos.Proyecto;
import proyectos.ProyectoDAO;
import tareas.Tarea;
import tareas.TareaDAO;
import usuarios.Usuario;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import etapas.Etapa;
import etapas.EtapaDAO;
import exceptions.DAOException;

/**
 * Servlet implementation class HoraTrabajadaServlet
 */
@WebServlet("/HoraTrabajadaServlet")
public class HoraTrabajadaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private HoraTrabajadaDAO hdao;
	private TareaDAO tdao;
	private ProyectoDAO pdao;
	private EtapaDAO edao;
       
	
	public void init() {
		tdao = new TareaDAO();
		pdao = new ProyectoDAO();
		edao = new EtapaDAO();
		hdao = new HoraTrabajadaDAO();
		
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    
    private void cargarDatosMisTareas(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
            if (usuario == null) {
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            List<Tarea> tareas = tdao.getByUsuarioId(usuario.getId());
            List<Proyecto> proyectos = new ArrayList<Proyecto>();

            for (Tarea t : tareas) {
                Etapa etapa = edao.getOne(t.getIdEtapa());
                Proyecto proyecto = pdao.getById(etapa.getIdProyecto());
                proyectos.add(proyecto);
            }

            request.setAttribute("tareas", tareas);
            request.setAttribute("proyectos", proyectos);
            request.setAttribute("usuario", usuario);

        } catch (DAOException e) {
            request.setAttribute("error", "Error al cargar tareas: " + e.getMessage());
        }
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		//String rol = usuario != null ? usuario.getRol().toLowerCase() : "";
		String action = (request.getParameter("action")) == null ? "list" : request.getParameter("action") ;
		
		switch(action) {
		
		case "new":
			try {
	            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
	            int idEmpleado = Integer.parseInt(request.getParameter("idEmpleado"));

	            // Setear atributos para el modal
	            request.setAttribute("idTarea", idTarea);
	            request.setAttribute("idEmpleado", idEmpleado);
	            request.setAttribute("abrirModal", true);

	            // OBTENER DATOS DE NUEVO (tareas, proyectos, usuario)
	            // (puedes tener un método que cargue todo)
	            cargarDatosMisTareas(request, response);

	            // FORWARD A LA MISMA PÁGINA
	            request.getRequestDispatcher("/tareas/mis-tareas.jsp").forward(request, response);
	            return;

	        } catch (NumberFormatException e) {
	            request.setAttribute("error", "ID inválido");
	            // fallback
	        }
			break;
		
		case "list":
			System.out.println(action);
			// OBTENER DATOS DE NUEVO (tareas, proyectos, usuario)
            // (puedes tener un método que cargue todo)
            cargarDatosMisTareas(request, response);

			break;
		}
		
		// Si no es "new", redirigir o mostrar lista
	    response.sendRedirect("TareaServlet?action=mis-tareas");
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
	    if (usuario == null || !"Empleado".equalsIgnoreCase(usuario.getRol())) {
	        response.sendRedirect("login.jsp");
	        return; 
	    }
	    
    	int idTarea = request.getParameter("idTarea") == null || request.getParameter("idTarea").isEmpty()
                ? 0 : Integer.parseInt(request.getParameter("idTarea"));
    	int idEmpleado = request.getParameter("idEmpleado") == null || request.getParameter("idEmpleado").isEmpty()
                ? 0 : Integer.parseInt(request.getParameter("idEmpleado"));
    	int cantidad = Integer.parseInt(request.getParameter("cantidad"));
    	 String fechaStr = request.getParameter("fecha");
    	 
         Date fecha = null;
         try {
             SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
             fecha = sdf.parse(fechaStr);
         } catch (ParseException e) {
             e.printStackTrace();
             // Handle error, perhaps redirect with error message
             response.sendRedirect("ProyectoServlet?error=invalid_date");
             return;
         }
    	
    	String action = request.getParameter("action");
    	
    	switch(action) {
    	case "new":
    		HoraTrabajada hora = new HoraTrabajada();
    		hora.setIdTarea(idTarea);
    		hora.setIdEmpleado(idEmpleado);
    		hora.setCantidad(cantidad);
    		hora.setFecha(fecha);
    		try {
				hdao.insert(hora);
			} catch (DAOException e) {
				request.setAttribute("error", e);
			}
    		
    	}
    	
    	// OBTENER DATOS DE NUEVO (tareas, proyectos, usuario)
        // (puedes tener un método que cargue todo)
        cargarDatosMisTareas(request, response);
        request.getRequestDispatcher("/tareas/mis-tareas.jsp").forward(request, response);
	}

}
