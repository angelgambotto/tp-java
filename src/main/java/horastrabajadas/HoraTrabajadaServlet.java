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
import usuarios.UsuariosDAO;
import horasReporte.HorasReporte;
import horasReporte.HorasReporteDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import comentarios.ComentarioDAO;
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
	private UsuariosDAO udao;
	private HorasReporteDAO rdao;
	private ComentarioDAO cdao;
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
       
	
	public void init() {
		tdao = new TareaDAO();
		pdao = new ProyectoDAO();
		edao = new EtapaDAO();
		hdao = new HoraTrabajadaDAO();
		udao = new UsuariosDAO();
		rdao = new HorasReporteDAO();
		cdao = new ComentarioDAO();
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
    
    private void cargarDatosUnaTarea(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	try {
    		//1. OBTENER TAREA
    		int idTarea = request.getParameter("idTarea") == null || request.getParameter("idTarea").isEmpty()
                    ? 0 : Integer.parseInt(request.getParameter("idTarea"));
    		request.setAttribute("tarea", tdao.getOne(idTarea));
    		
    		//2. OBTENER HORAS
    		request.setAttribute("horas", hdao.getAllByIdTarea(idTarea));
    		
    		//3. OBTENER COMENTARIOS
    		request.setAttribute("comentarios", cdao.getAllByIdTarea(idTarea));
    		
    		//4. OBTENER EMPLEADOS ASIGNADOS
    		request.setAttribute("empleadosAsignados", tdao.getUsuariosAsignados(idTarea));
    		
    		//5. OBTENER EMPLEADOS DISPONIBLES
    		int idEtapa =  (tdao.getOne(idTarea)).getIdEtapa();
    		Etapa etapa = edao.getOne(idEtapa);
    		int idProyecto = etapa.getIdProyecto();
    		request.setAttribute("empleadosDisponibles", pdao.getUsuariosAsignados(idProyecto));
    		
    		//6. CARGAR EL PROYECTO PARA PARTE DEL SUPERVISOR
    		request.setAttribute("proyecto", pdao.getById(idProyecto));
    		
    	} catch(DAOException e) {
    		request.setAttribute("error", "Error al cargar los datos para UnaTarea: " + e.getMessage());
    	}
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("ACTION = " + request.getParameter("action")+" en GET");
		//Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		//String rol = usuario != null ? usuario.getRol().toLowerCase() : "";
		String action = (request.getParameter("action")) == null ? "misHoras" : request.getParameter("action") ;
		
		switch(action) {
		
		case "new":
			try {
	            int idTarea = Integer.parseInt(request.getParameter("idTarea"));
	            int idEmpleado = Integer.parseInt(request.getParameter("idEmpleado"));
	            String origin = request.getParameter("origin");
	            // Setear atributos para el modal
	            request.setAttribute("idTarea", idTarea);
	            request.setAttribute("idEmpleado", idEmpleado);
	            request.setAttribute("abrirModalHoras", true);
	            request.setAttribute("origin", origin);


	            if(origin.equals("unaTarea")) {
	            	cargarDatosUnaTarea(request, response);
	            	request.getRequestDispatcher("/tareas/unaTarea.jsp").forward(request, response);
	            } else {
	            	
	            	// OBTENER DATOS DE NUEVO (tareas, proyectos, usuario)
	            	// (puedes tener un método que cargue todo)
	            	cargarDatosMisTareas(request, response);
	            	// FORWARD A LA MISMA PÁGINA
	            	request.getRequestDispatcher("/tareas/mis-tareas.jsp").forward(request, response);
	            }
	         // VOLVEMOS A LA PÁGINA ANTERIOR (la que el usuario tenía abierta)
	            //response.sendRedirect(request.getHeader("Referer")); NO FUNCIONA ME INHABILITA LA CARGA
	            return;

	        } catch (NumberFormatException e) {
	            request.setAttribute("error", "ID inválido");
	            // fallback
	        }
			break;
		
		case "misHoras":
			System.out.println(action);
			// OBTENER DATOS DE NUEVO (tareas, proyectos, usuario)
            // (puedes tener un método que cargue todo)
            cargarDatosMisTareas(request, response);
            response.sendRedirect("TareaServlet?action=mis-tareas");
			break;
			
		case "reporte":
			
			System.out.println("====================");
			System.out.println("DEBUG REPORTES");
			
			Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");

	        if (usuario == null || !"administrador".equalsIgnoreCase(usuario.getRol())) {
	            request.getRequestDispatcher("login.jsp").forward(request, response);
	            return;
	        }

	        String lista = request.getParameter("lista");
	        System.out.println("Lista: "+lista);
	        if ("null".equals(lista) || lista == null) {
	        	lista = "usuarios";
	        }
	        String desdeStr = request.getParameter("desde");
	        String hastaStr = request.getParameter("hasta");

	        Date desde = null, hasta = null;
	        
	        try {
	            if (desdeStr != null && !desdeStr.isEmpty()) desde = sdf.parse(desdeStr);
	            if (hastaStr != null && !hastaStr.isEmpty()) hasta = sdf.parse(hastaStr);
	        } catch (ParseException e) {}

	        try {
	            switch (lista) {

	                case "usuarios":
	                    request.setAttribute("data", rdao.horasPorUsuario(desde, hasta));
	                    request.setAttribute("tipo", "usuarios");
	                    System.out.println("Entro a usuarios");
	                    break;

	                case "usuariosProyecto":
	                    request.setAttribute("data", rdao.horasPorUsuarioProyecto(desde, hasta));
	                    request.setAttribute("tipo", "usuariosProyecto");
	                    System.out.println("Entro a usuariosProyectos");
	                    break;

	                case "usuariosProyectoEtapa":
	                    request.setAttribute("data", rdao.horasPorUsuarioProyectoEtapa(desde, hasta));
	                    request.setAttribute("tipo", "usuariosProyectoEtapa");
	                    break;

	                case "usuariosProyectoEtapaTarea":
	                    request.setAttribute("data", rdao.horasPorUsuarioProyectoEtapaTarea(desde, hasta));
	                    request.setAttribute("tipo", "usuariosProyectoEtapaTarea");
	                    break;
	            }
	        } catch (DAOException e) {
	                request.setAttribute("error", e.getMessage());
	                System.out.println("error de dao");
	        }
	        System.out.println("====================");
            request.getRequestDispatcher("/horasTrabajadas/reporte.jsp").forward(request, response);    
	        
		    break;
		
		}
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("ACTION = " + request.getParameter("action")+" en POST");

		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		
	    if (usuario == null) {
	        response.sendRedirect("login.jsp");
	        return; 
	    }
		
	    
    	int idTarea = request.getParameter("idTarea") == null || request.getParameter("idTarea").isEmpty()
                ? 0 : Integer.parseInt(request.getParameter("idTarea"));
    	int idEmpleado = request.getParameter("idEmpleado") == null || request.getParameter("idEmpleado").isEmpty()
                ? 0 : Integer.parseInt(request.getParameter("idEmpleado"));
    	int cantidad = Integer.parseInt(request.getParameter("cantidad"));
    	String detalle = request.getParameter("detalle");
    	String fechaStr = request.getParameter("fecha");
    	System.out.println("idTarea"+idTarea+"idEmpleado"+idEmpleado);
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
    		System.out.println("estuve aqui");
    		HoraTrabajada hora = new HoraTrabajada();
    		hora.setIdTarea(idTarea);
    		hora.setIdEmpleado(idEmpleado);
    		hora.setCantidad(cantidad);
    		hora.setFecha(fecha);
    		hora.setDetalle(detalle);
    		try {
				hdao.insert(hora);
			} catch (DAOException e) {
				
				System.out.println("el error es:" +e.getMessage());
				request.setAttribute("error", e);
			}
    		
    	}
    	
    	String origin = request.getParameter("origin");
        
        if ("unaTarea".equals(origin)) {
            // Recargamos los datos de la tarea individual
           cargarDatosUnaTarea(request, response);
           request.getRequestDispatcher("/tareas/unaTarea.jsp").forward(request, response);
            
        } else { 
            cargarDatosMisTareas(request, response);
            request.getRequestDispatcher("/tareas/mis-tareas.jsp").forward(request, response);
        }
        
        return;
	}

}
