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
import tareas.TareaDAO;
import categoriaTarea.CategoriaTarea;
import categoriaTarea.CategoriaTareaDAO;
import usuarios.Usuario;
import usuarios.UsuariosDAO;

@WebServlet("/EtapaServlet")
public class EtapaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EtapaDAO edao;
    private ProyectoDAO pdao;
    private TareaDAO tdao;
    private CategoriaTareaDAO cdao;
    private UsuariosDAO udao;

    @Override
    public void init() {
        edao = new EtapaDAO();
        pdao = new ProyectoDAO();
        cdao = new CategoriaTareaDAO();
        tdao=new TareaDAO();
        udao= new UsuariosDAO();
    }

	private List<CategoriaTarea> cargarCategoriasSeguro(HttpServletRequest request) {
	    try {
	        return cdao.getAll();
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudieron cargar las categorías: " + e.getMessage());
	        return new ArrayList<>();
	    }
	}
    
    private List<Etapa> cargarEtapasSeguro(HttpServletRequest request) {
        try {
            return edao.getByProyectoIdConTareas(Integer.parseInt(request.getParameter("idProyecto")));
        } catch (DAOException e) {
            request.setAttribute("error", e.getMessage());
            return new ArrayList<>();
        }
    }

    private Etapa cargarEtaSeguro(HttpServletRequest request, int id) {
        try {
            return edao.getOne(id);
        } catch (DAOException e) {
            request.setAttribute("error", e.getMessage());
            return new Etapa();
        }
    }

    private List<Usuario> cargarUsuariosSeguro(HttpServletRequest request) {
	    try {
	        return udao.getAll();
	    } catch (DAOException e) {
	        request.setAttribute("error", "No se pudieron cargar los clientes: " + e.getMessage());
	        return new ArrayList<>();
	    }
	}
    
    // DO GET 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null || !("Administrador".equalsIgnoreCase(usuario.getRol()) || "Empleado".equalsIgnoreCase(usuario.getRol()))) {
            response.sendRedirect("login.jsp");
            return;
        }
        //limpiar errores
        request.setAttribute("error", null);
        
        request.setAttribute("usuario", usuario);
        
        String action = (request.getParameter("action") == null ? "view" : request.getParameter("action"));
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // --- OBTENER idProyecto CON VALIDACIÓN ---
        int idProyecto = 0;
        String estadoProyecto="";
        String idProyectoParam = request.getParameter("idProyecto");
        if (idProyectoParam != null && !idProyectoParam.trim().isEmpty()) {
            try {
                idProyecto = Integer.parseInt(idProyectoParam.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de proyecto inválido");
                idProyecto = 0;
            }
        } else {
            request.setAttribute("error", "Falta el parámetro idProyecto");
        }

        
        // --- FIJAR DESTINO PARA REDIRECCIONAR O MANTENER LA PAGINA ---
        String destino = (String) request.getAttribute("destino");
        System.out.println("destino: "+destino);
        if (destino == null) destino = "proyectos/unProyecto.jsp";
        
        // --- CARGAR PROYECTO Y ETAPAS (SIEMPRE) ---
        Proyecto proyecto = null;
        List<Etapa> etapas = new ArrayList<>();
        List<Usuario> usuariosAsignados = new ArrayList<>();

        if (idProyecto > 0) {
            try {
                proyecto = pdao.getById(idProyecto);
                usuariosAsignados = pdao.getUsuariosAsignados(idProyecto);
            } catch (DAOException e) {
                request.setAttribute("error", "Proyecto no encontrado");
            }
            etapas = cargarEtapasSeguro(request);            
        }

        // --- PASAR DATOS COMUNES ---
        request.setAttribute("categorias", cargarCategoriasSeguro(request));
        request.setAttribute("proyecto", proyecto);
        request.setAttribute("etapas", etapas);
        request.setAttribute("idProyecto", idProyecto);
        request.setAttribute("usuarios", cargarUsuariosSeguro(request));
        request.setAttribute("usuariosAsignados", usuariosAsignados);

        System.out.println("idProyecto que recibe la etapa: " + idProyecto);
        System.out.println("Etapas encontradas: " + etapas.size());
        for (Etapa e : etapas) {
            System.out.println("Etapa: " + e.getNombre() + " | Estado: " + e.getEstado());
        }
        
        System.out.println("=== EDIT DEBUG ===");
        System.out.println("action: " + action);
        System.out.println("id parámetro: " + request.getParameter("idEtapa"));
        System.out.println("idProyecto: " + request.getParameter("idProyecto"));

        // ACCIONES 
        
        switch(action) {
        case "new":
        	 estadoProyecto=proyecto.getEstado();
        	if ("Done".equals(estadoProyecto)) {
        		request.setAttribute("error", "No se pueden agregar etapas en un proyecto finalizado.");
        		request.getRequestDispatcher("etapas/listado.jsp").forward(request, response);
        		return;
        		}
        	String currentDate = sdf.format(new Date());
            request.setAttribute("fechaInicio", currentDate);
            request.setAttribute("ProyectoFinalizado", estadoProyecto.equals("Done"));
            request.setAttribute("abrirModal", true);
            request.setAttribute("tienePendientes", true);
            break;
            
        case "edit":
        	 int editId = Integer.parseInt(request.getParameter("id"));
        	 try{
            	 boolean tienePendientes=tdao.tieneTareasIncompletas(editId);
            	 request.setAttribute("tienePendientes",tienePendientes);
            	 }
            	 catch(DAOException e) {
            		 request.setAttribute("error",e.getMessage());
            	 }
             Etapa etapa = cargarEtaSeguro(request, editId);
             estadoProyecto=proyecto.getEstado();
             request.setAttribute("ProyectoFinalizado", estadoProyecto.equals("Done"));
             request.setAttribute("id", etapa.getId());
             request.setAttribute("nombre", etapa.getNombre());
             request.setAttribute("descripcion", etapa.getDescripcion());
             request.setAttribute("estado", etapa.getEstado());
             if (etapa.getFechaInicio() != null) {
                 request.setAttribute("fechaInicio", sdf.format(etapa.getFechaInicio()));
             } else {
                 request.setAttribute("fechaInicio", ""); 
             }
             if (etapa.getFechaTentativa() != null) {
                 request.setAttribute("fechaTentativa", sdf.format(etapa.getFechaTentativa()));
             }
             if (etapa.getFechaFin() != null) {
                 request.setAttribute("fechaFin", sdf.format(etapa.getFechaFin()));
             }
             request.setAttribute("abrirModal", true);
             break;
             
        case "delete":
        	 int deleteId = Integer.parseInt(request.getParameter("id"));
             Etapa eta = cargarEtaSeguro(request, deleteId);
             request.setAttribute("etapa", eta);
             
             // ESTO HABRIA QUE PASARLO AL DOPOST SI QUEREMOS CONFIRMACION
             try {
                 edao.delete(deleteId);
             } catch (DAOException e) {
                 request.setAttribute("error", e.getMessage());
                 request.getRequestDispatcher("etapas/listado.jsp").forward(request, response);
                 return;
             }
             break;
        }

        // CARGAR ETAPAS DE NUEVO
        request.setAttribute("etapas", cargarEtapasSeguro(request));

        request.getRequestDispatcher(destino).forward(request, response);
    }

    // DO POST 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
        if (usuario == null || !"Administrador".equalsIgnoreCase(usuario.getRol())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idStr = request.getParameter("id");

        int id = (idStr == null || idStr.isEmpty() || idStr.equals("null")) ? 0 : Integer.parseInt(idStr);
        
        boolean tienePendientes;
        
        String nombre = request.getParameter("nombre");
        String descripcion = request.getParameter("descripcion");
        String estado = request.getParameter("estado");
        
        String fechaIni = request.getParameter("fechaInicio");
        String fechaTenta = request.getParameter("fechaTentativa");
        String fechaFi = request.getParameter("fechaFin");
     // --- VALIDAR idProyecto ---
        int idProyecto = 0;
        String idProyectoParam = request.getParameter("idProyecto");
        if (idProyectoParam == null || idProyectoParam.trim().isEmpty()) {
            request.setAttribute("error", "Falta idProyecto");
            request.setAttribute("idProyecto", 0);
            request.setAttribute("action", "list");
            doGet(request, response);
            return;
        }
        try {	
            tienePendientes=tdao.tieneTareasIncompletas(id);
            request.setAttribute("tienePendientes", tienePendientes);}
           catch(DAOException e) {
           	request.setAttribute("error", e.getMessage());
           	doGet(request, response);
               return;
           }
        if(tienePendientes && "Done".equals(estado)) {
        	request.setAttribute("error", "No puedes marcar como 'Done' una etapa con tareas incompletas... " );
        	doGet(request, response);
        }
        
        try {
            idProyecto = Integer.parseInt(idProyectoParam.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de proyecto inválido");
            request.setAttribute("idProyecto", 0);
            request.setAttribute("action", "list");
            doGet(request, response);
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        // --- FECHA INICIO ---
        java.sql.Date sqlInicio = null;
        if (fechaIni != null && !fechaIni.trim().isEmpty()) {
            try {
                sqlInicio = new java.sql.Date(sdf.parse(fechaIni).getTime());
            } catch (ParseException e) {
                e.printStackTrace();
            }
        } else {
            throw new IllegalArgumentException("Fecha de inicio es obligatoria");
        }

        // --- FECHA TENTATIVA ---
        java.sql.Date sqlTentativa = null;
        if (fechaTenta != null && !fechaTenta.trim().isEmpty()) {
            try {
                sqlTentativa = new java.sql.Date(sdf.parse(fechaTenta).getTime());
            } catch (ParseException e) {
                throw new IllegalArgumentException("Fecha tentativa inválida");
            }
        }

        // --- FECHA FIN ---
        java.sql.Date sqlFin = null;
        if (fechaFi != null && !fechaFi.trim().isEmpty()) {
            try {
                sqlFin = new java.sql.Date(sdf.parse(fechaFi).getTime());
            } catch (ParseException e) {
                throw new IllegalArgumentException("Fecha fin inválida");
            }
        }

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
        
        //PARA DEBUG
        System.out.println("=== ETAPA GUARDADA ===");
        System.out.println("ID: " + id);
        System.out.println("Nombre: " + nombre);
        System.out.println("Estado: " + estado);
        System.out.println("idProyecto: " + idProyecto);
        System.out.println("Fecha Inicio: " + sqlInicio);
        System.out.println("Fecha Tentativa: " + sqlTentativa);
        System.out.println("Fecha Fin: " + sqlFin);

        // INSERT O UPDATE
        try {
            if (id > 0) {
                edao.update(eta);
            } else {
                edao.insert(eta);
            }
	         // ÉXITO: LIMPIAR ERROR
	            request.getSession().setAttribute("error", null); // o request
	            request.setAttribute("error", null); // mejor: limpiar del request

            // Opcional: mensaje de éxito
            request.getSession().setAttribute("success", "Etapa guardada correctamente");
            response.sendRedirect("EtapaServlet?action=view&idProyecto=" + idProyecto);

        } catch (DAOException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("idProyecto", idProyecto);
            request.setAttribute("action", "view");
            doGet(request, response); 
            return;
        }
    }
}