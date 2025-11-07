package tareas;
import usuarios.UsuariosDAO;

import java.util.ArrayList;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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
        if (usuario == null || !"Administrador".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }
        String action = request.getParameter("action");
        switch(action) {
        case "list":
        	int idEtapa=Integer.parseInt(request.getParameter("idEtapa"));
        	List<Tarea> tareas=tdao.getByEtapaId(idEtapa);
        	request.setAttribute("tareas", tareas);
        	Etapa e=edao.getOne(idEtapa);
        	request.setAttribute("etapa", e);
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

            request.getRequestDispatcher("/tareas/formulario.jsp").forward(request, response);
            break;
        case "edit":
        	int idTarea = Integer.parseInt(request.getParameter("id"));
            Tarea tarea = tdao.getOne(idTarea);
            usuariosDisponibles = udao.getAll();
            categorias = cdao.getAll();
            List<Usuario> usuariosAsignados = tdao.getUsuariosAsignados(idTarea);
            request.setAttribute("tarea", tarea);
            request.setAttribute("usuarios", usuariosDisponibles);
            request.setAttribute("usuariosAsignados", usuariosAsignados);
            request.setAttribute("categorias", categorias);
            request.setAttribute("abrirModal", true);
            request.setAttribute("idEtapa", tarea.getIdEtapa());
            request.getRequestDispatcher("/tareas/formulario.jsp").forward(request, response);
            break;
        }
        
		}
		catch(DAOException e) {
			e.printStackTrace();
			throw new ServletException("Error en tareaservlet get");
		}
	
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
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
		int idTarea=Integer.parseInt(request.getParameter("idTarea"));
		int idEtapa=Integer.parseInt(request.getParameter("idEtapa"));
		try{
			tdao.delete(idTarea);
		}
		catch(DAOException e) {
			request.setAttribute("error al eliminar la tarea: ", e);
		}
		response.sendRedirect("EtapaServlet?action=list&idEtapa="+idEtapa);
		
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
	
	if(usuarios!=null) {
		for (String u:usuarios) {
			ids.add(Integer.parseInt(u));
			
		}
	}
	
	
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
	        tarea.setId(Integer.parseInt(request.getParameter("id")));
	        tarea.setNombre(request.getParameter("nombre"));
	        tarea.setDescripcion(request.getParameter("descripcion"));
	        tarea.setIdEtapa(Integer.parseInt(request.getParameter("idEtapa")));
	        tarea.setIdCategoria(Integer.parseInt(request.getParameter("idCategoria")));

	        tarea.setFechaInicio(Date.valueOf(request.getParameter("fechaInicio")));
	        tarea.setFechaFin(Date.valueOf(request.getParameter("fechaFin")));

	 
	        String[] usuariosForm = request.getParameterValues("idUsuariosAsignados");

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
	


