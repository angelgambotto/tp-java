package proyectos;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import usuarios.Usuario;
import usuarios.UsuariosDAO;
import clientes.Cliente;
import clientes.ClienteDAO;
import exceptions.DAOException;

/**
 * Servlet implementation class ProyectoServlet
 */
@WebServlet("/ProyectoServlet")
public class ProyectoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProyectoDAO dao;
    private UsuariosDAO usuarioDao;
    private ClienteDAO clienteDAO;
    
	//metodo para cargar los clientes y no tener problemas con el bloque try catch
	private List<Cliente> cargarClientesSeguro(HttpServletRequest request) {
	    try {
	        return clienteDAO.getAll();
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudieron cargar los clientes: " + e.getMessage());
	        return new ArrayList<>();
	    }
	}
	
	//metodo para cargar los usuarios y no tener problemas con el bloque try catch
	private List<Usuario> cargarUsuariosSeguro(HttpServletRequest request) {
	    try {
	        return usuarioDao.getAll();
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudieron cargar los usuarios: " + e.getMessage());
	        return new ArrayList<>();
	    }
	}
	//metodo para cargar los proyectos y no tener problemas con el bloque try catch
	private List<Proyecto> cargarProyectosSeguro(HttpServletRequest request) {
	    try {
	        return dao.getAll();
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudieron cargar los clientes: " + e.getMessage());
	        return new ArrayList<>();
	    }
	}
	//metodo para cargar un proyecto y no tener problemas con el bloque try catch
	private Proyecto cargarProSeguro(HttpServletRequest request, int id) {
	    try {
	        return dao.getById(id);
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudo cargar el proyecto: " + e.getMessage());
	        return new Proyecto();
	    }
	}	
	
	private List<Usuario> cargarAsignadosSeguro(HttpServletRequest request, int id){
		try {
			return dao.getUsuariosAsignados(id);
		} catch (DAOException e) {
	        request.setAttribute("error", "No se pudieron cargar los usuarios: " + e.getMessage());
	        return new ArrayList<>();
	    }
	}

    @Override
    public void init() {
        dao = new ProyectoDAO();
        usuarioDao = new UsuariosDAO();
        clienteDAO = new ClienteDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
	    
    	String action = request.getParameter("action");

        if (action == null) action = "list";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        switch (action) {
        	case "new":
                String currentDate = sdf.format(new Date());
                request.setAttribute("fechaCreacion", currentDate);
       		 	request.setAttribute("abrirModal", true);
        		break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Proyecto proEdit = cargarProSeguro(request, editId);
                request.setAttribute("id", proEdit.getId());
                request.setAttribute("nombre", proEdit.getNombre());
                request.setAttribute("descripcion", proEdit.getDescripcion());
                request.setAttribute("estado", proEdit.getEstado());
                request.setAttribute("cliente", proEdit.getCliente());
                request.setAttribute("fechaCreacion", sdf.format(proEdit.getFechaCreacion()));
                request.setAttribute("supervisorId", proEdit.getSupervisor().getId());
                request.setAttribute("abrirModal", true);
                break;

            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                Proyecto pro = cargarProSeguro(request, deleteId);
                request.setAttribute("proyecto", pro);
                //request.setAttribute("abrirModalEliminar", true);
             
                
                try {                	
                	dao.delete(deleteId);
                } catch (DAOException e) {
                	request.setAttribute("error", e.getMessage());
        	    	request.setAttribute("supervisores", cargarUsuariosSeguro(request));
        	        request.getRequestDispatcher("proyectos/listado.jsp").forward(request, response);
                }
                
                break;
        }

        request.setAttribute("proyectos", cargarProyectosSeguro(request));
        request.setAttribute("clientes", cargarClientesSeguro(request));
        request.setAttribute("supervisores", cargarUsuariosSeguro(request));
        request.getRequestDispatcher("proyectos/listado.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	System.out.println(">>> Entró a post proyecto <<<");
    	Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
    	
    	int id = request.getParameter("id") == null || request.getParameter("id").isEmpty()
                ? 0 : Integer.parseInt(request.getParameter("id"));
    	
    	List<Usuario> asig = cargarAsignadosSeguro(request, id);
    	Boolean esta = asig.contains(usuario);
	    if (esta == false && !"Administrador".equalsIgnoreCase(usuario.getRol())) {
	        response.sendRedirect("login.jsp");
	        return; 
	    }
	    
	    String action=request.getParameter("action");
	    System.out.println("action: "+ action);
	    if (action == null) {
	    	action = "insert-update";
	    }
	    
		switch(action) {
		case "insert-update":
			insertarProyecto(request,response, id);
			break;
		case "asignar":
			System.out.println(">>> Entró a asignarUsuarios <<<");
			asignarUsuarios(request,response, id);
			break;
		
		}
        
    } //cierra el doPost

    private void insertarProyecto(HttpServletRequest request,HttpServletResponse response, int id) throws IOException, ServletException{
       
       //para hacer el update/insert
       String nombre = request.getParameter("nombre");
       String descripcion = request.getParameter("descripcion");
       String estado = request.getParameter("estado");
       String fechaStr = request.getParameter("fechaCreacion");
       
       int clienteId = Integer.parseInt(request.getParameter("clienteId"));
       int supervisorId = Integer.parseInt(request.getParameter("supervisorId"));

       Date fechaCreacion = null;
       try {
           SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
           fechaCreacion = sdf.parse(fechaStr);
       } catch (ParseException e) {
           e.printStackTrace();
           // Handle error, perhaps redirect with error message
           response.sendRedirect("ProyectoServlet?error=invalid_date");
           return;
       }
       
       Cliente cliente = new Cliente();
       cliente.setId(clienteId);

       Usuario supervisor = new Usuario();
       supervisor.setId(supervisorId);

       Proyecto pro = new Proyecto(id, nombre, descripcion, estado, cliente, fechaCreacion, supervisor, new LinkedList<>());

       try {        	
       	if (id > 0) {
       		dao.update(pro);
       	} else {
       		dao.insert(pro);
       	}
       	response.sendRedirect("ProyectoServlet");
       	
       } catch (DAOException e) {
       	request.setAttribute("error", e.getMessage());
	    request.setAttribute("supervisores", cargarUsuariosSeguro(request));
	    request.getRequestDispatcher("proyectos/listado.jsp").forward(request, response);
       }
    }
    
    private void asignarUsuarios(HttpServletRequest request, HttpServletResponse response, int id)
            throws IOException, ServletException {
    	System.out.println(">>> Entró estro a asignarUsuarios <<<");
        try {
            String[] usuariosForm = request.getParameterValues("usuarios");

            List<Integer> usuariosSeleccionados = new ArrayList<>();
            if (usuariosForm != null) {
                for (String idU : usuariosForm) {
                    usuariosSeleccionados.add(Integer.parseInt(idU));
                }
            }

            Proyecto pro = dao.getById(id);
            if (pro == null) {
                throw new ServletException("Proyecto no encontrado con ID: " + id);
            }

            dao.asignarEmpleados(pro.getId(), usuariosSeleccionados);

            response.sendRedirect("EtapaServlet?action=list&idProyecto=" + pro.getId());

        } catch (Exception e) {  // <--- Captura cualquier error
            throw new ServletException("Error en asignarUsuarios", e);
        }
    }

    
} //cierra el servlet