package tareas;
import usuarios.UsuariosDAO;

import java.util.ArrayList;
import java.util.Iterator;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import proyectos.Proyecto;
import proyectos.ProyectoDAO;
import usuarios.Usuario;

import java.io.IOException;
import java.time.LocalDate;

import etapas.Etapa;
import etapas.EtapaDAO;
import exceptions.DAOException;
import categoriaTarea.CategoriaTarea;
import categoriaTarea.CategoriaTareaDAO;
/**
 * Servlet implementation class TareaServlet
 */
@WebServlet("/TareaServlet")
public class TareaServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private TareaDAO tdao;
    private UsuariosDAO udao;
    private CategoriaTareaDAO cdao;
    private EtapaDAO edao;
    private ProyectoDAO pdao;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TareaServlet() {
        super();
        // TODO Auto-generated constructor stub
    }
    @Override
    public void init() {
        cdao = new CategoriaTareaDAO();
        udao = new UsuariosDAO();
        tdao=new TareaDAO();
        edao=new EtapaDAO();
        pdao = new ProyectoDAO();
    }
     List<Tarea> tareas;
     List<Usuario> usuarios;
     
     /*private List<Tarea> cargarTareasSeguro(HttpServletRequest request) {
         try {
             return tdao.getByEtapaId(Integer.parseInt(request.getParameter("idEtapa")));
         } catch (DAOException e) {
             request.setAttribute("error", e.getMessage());
             return new ArrayList<>();
         }
     }
     private Tarea cargarTareaSeguro(HttpServletRequest request, int id) {
         try {
             return tdao.getOne(id);
         } catch (DAOException e) {
             request.setAttribute("error", e.getMessage());
             return new Tarea();
         }
     }*/
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
			String rol = usuario != null ? usuario.getRol().toLowerCase() : "";

			
        boolean esAdmin = "administrador".equals(rol);
        boolean esEmpleado = "empleado".equals(rol);

        // Acción por defecto según rol
        String action = request.getParameter("action");
        if (action == null) {
            action = esAdmin ? "list" : "mis-tareas";
        }
        
        switch(action) {
        case "list":
        	if (!esAdmin) {
                response.sendRedirect("TareaServlet?action=mis-tareas");
                return;
            }
        	int idEtapa=Integer.parseInt(request.getParameter("idEtapa"));
        	List<Tarea> tareas=tdao.getByEtapaId(idEtapa);
        	request.setAttribute("tareas", tareas);
        	Etapa e=edao.getOne(idEtapa);
        	request.setAttribute("etapa", e);
        	request.setAttribute("esAdmin", true);
        	request.getRequestDispatcher("etapas/unaEtapa.jsp").forward(request, response);
        	break;
        case "new":
        	idEtapa = Integer.parseInt(request.getParameter("idEtapa"));
            List<Usuario> usuariosDisponibles = udao.getAll();
            List<CategoriaTarea> categorias = cdao.getAll();
            request.setAttribute("usuarios", usuariosDisponibles);
            request.setAttribute("categorias", categorias);
            request.setAttribute("idEtapa", idEtapa);
            request.setAttribute("abrirModal", true);
           

            request.getRequestDispatcher("etapas/unaEtapa.jsp").forward(request, response);
            break;
        case "edit":
        	int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            Tarea tarea = tdao.getOne(idTarea);

            
            String idEtapaParam = request.getParameter("idEtapa");
            if (idEtapaParam != null && !idEtapaParam.isEmpty()) {
                idEtapa = Integer.parseInt(idEtapaParam);
            } else {
                idEtapa = tarea.getIdEtapa();
            }
            usuariosDisponibles = udao.getAll();
            categorias = cdao.getAll();
            List<Usuario> usuariosAsignados = tdao.getUsuariosAsignados(idTarea);
            request.setAttribute("tarea", tarea);
            request.setAttribute("usuarios", usuariosDisponibles);
            request.setAttribute("usuariosAsignados", usuariosAsignados);
            request.setAttribute("categorias", categorias);
           
            request.setAttribute("idEtapa", idEtapa);
            request.setAttribute("abrirModal", true);
            request.getRequestDispatcher("etapas/unaEtapa.jsp").forward(request, response);
            break;
        case "mis-tareas":
            List<Tarea> misTareas = tdao.getByUsuarioId(usuario.getId());
            List<Proyecto> proyectos = new ArrayList<Proyecto>();
            for (Tarea tarea2 : misTareas) {
				Proyecto pro = pdao.getById((edao.getOne(tarea2.getIdEtapa()).getIdProyecto()));
				proyectos.add(pro);
				
				// IMPRIMIR CADA PROYECTO
		        System.out.println("Tarea: " + tarea2.getNombre() + 
		                         " | Proyecto ID: " + pro.getId() + 
		                         " | Nombre proyecto: " + pro.getNombre());
            }
		    
            System.out.println("Total proyectos: " + proyectos.size());
		    System.out.println("==========================");
			
            request.setAttribute("tareas", misTareas);
            request.setAttribute("proyectos", proyectos);
            request.setAttribute("usuario", usuario);
            request.setAttribute("esEmpleado", true);
            request.getRequestDispatcher("/tareas/mis-tareas.jsp").forward(request, response);
            break;
        }
        
		}
		catch(DAOException e) {
			System.out.println("DAOException en : " + e.getMessage());
			e.printStackTrace();
			throw new ServletException("Error en tareaservlet get");
		}
	
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		// DESPUES VER DE NO PERMITIRLE CIERTAS COSAS AL EMPLEADO
		/*Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
	    if (usuario == null || !"administrador".equalsIgnoreCase(usuario.getRol())) {
	        response.sendRedirect("TareaServlet"); // o "mis-tareas"
		
	        response.sendRedirect("TareaServlet?action=mis-tareas");
	        return;
	    }*/
		String action=request.getParameter("action");
		switch(action) {
		case "insert":
			insertarTarea(request,response);
			break;
		case "update":
			actualizarTarea(request,response);
			break;
		case "delete":
			borrarTarea(request,response);
		break;
		
		}
		
	}
	private void borrarTarea(HttpServletRequest request,HttpServletResponse response) throws IOException{
		String idTareaParam=(request.getParameter("idTarea"));
		String idEtapaParam=(request.getParameter("idEtapa"));
		if (idTareaParam == null || idEtapaParam == null) {
	        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Faltan parámetros para eliminar la tarea");
	        return;
	    }
		int idTarea = Integer.parseInt(idTareaParam);
	    int idEtapa = Integer.parseInt(idEtapaParam);
	   
	    
	    System.out.println("el valor de id tarea es: "+ idTarea);
	    System.out.println("El valor de id etapa es:  "+idEtapa);
	    int idProyecto=0;
		try{
			tdao.delete(idTarea);
			Etapa etapa=edao.getOne(idEtapa);
			idProyecto=etapa.getIdProyecto(); 
			request.setAttribute("idProyecto", idProyecto);
		}
		catch(DAOException e) {
			request.setAttribute("error al eliminar la tarea: ", e);
		
		}
	
		response.sendRedirect("EtapaServlet?action=list&idEtapa="+idEtapa+"&idProyecto="+idProyecto);
		
	}
private void insertarTarea(HttpServletRequest request,HttpServletResponse response) throws IOException{
	try{Tarea tarea=new Tarea();
	tarea.setNombre(request.getParameter("nombre"));
	tarea.setDescripcion(request.getParameter("descripcion"));
	tarea.setEstado(request.getParameter("estado"));
	tarea.setFechaInicio(Date.valueOf(request.getParameter("fechaInicio")));
	tarea.setFechaFin(Date.valueOf(request.getParameter("fechaFin")));
	tarea.setIdEtapa(Integer.parseInt(request.getParameter("idEtapa")));
	tarea.setIdCategoria(Integer.parseInt(request.getParameter("idCategoria")));
	String[] usuarios=request.getParameterValues("usuarios");
	List<Integer> ids=new ArrayList<>();
	System.out.println("===== DEBUG USUARIOS =====");
    System.out.println("usuarios array es null? " + (usuarios == null));
    if (usuarios != null) {
        System.out.println("Cantidad de usuarios recibidos: " + usuarios.length);
    }
	
	if(usuarios!=null) {
		for (String u:usuarios) {
		
			ids.add(Integer.parseInt(u));
			System.out.println("usuario: "+u);
		
			
		}
	}
	
		System.out.println(ids);
		tdao.insert(tarea, ids);
		response.sendRedirect("TareaServlet?action=list&idEtapa=" + tarea.getIdEtapa());
	}
	catch(DAOException e) {
		request.setAttribute("Error al insertar tarea: ", e);
	}
	
}


private void actualizarTarea(HttpServletRequest request,HttpServletResponse response) throws IOException,ServletException{
	

	    try {
	        Tarea tarea = new Tarea();
	        tarea.setId(Integer.parseInt(request.getParameter("idTarea")));
	        tarea.setNombre(request.getParameter("nombre"));
	        tarea.setDescripcion(request.getParameter("descripcion"));
	        tarea.setIdEtapa(Integer.parseInt(request.getParameter("idEtapa")));
	        tarea.setIdCategoria(Integer.parseInt(request.getParameter("idCategoria")));
	        tarea.setEstado(request.getParameter("estado"));
	        tarea.setFechaInicio(Date.valueOf(request.getParameter("fechaInicio")));
	        tarea.setFechaFin(Date.valueOf(request.getParameter("fechaFin")));
	        String[] usuariosForm = request.getParameterValues("usuarios");

	        List<Integer> usuariosSeleccionados = new ArrayList<>();
	        if (usuariosForm != null) {
	            for (String id : usuariosForm) {
	                usuariosSeleccionados.add(Integer.parseInt(id));
	            }
	        }

	        
	        tdao.update(tarea, usuariosSeleccionados);

	       
	        response.sendRedirect("TareaServlet?action=list&idEtapa=" + tarea.getIdEtapa());

	    } catch (DAOException e) {
	        throw new ServletException("Error al actualizar tarea", e);
	    }}}
	


