package tareas;
import usuarios.UsuariosDAO;
import utils.mail.EmailService;
import java.util.ArrayList;
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
import etapas.Etapa;
import etapas.EtapaDAO;
import exceptions.DAOException;
import categoriaTarea.CategoriaTarea;
import categoriaTarea.CategoriaTareaDAO;
import clientes.Cliente;
import comentarios.Comentario;
import comentarios.ComentarioDAO;
import horastrabajadas.HoraTrabajada;
import horastrabajadas.HoraTrabajadaDAO;

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
    private ComentarioDAO comdao;
    private HoraTrabajadaDAO htdao;
    private EmailService emailService;

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
        comdao = new ComentarioDAO();
        htdao = new HoraTrabajadaDAO();
        
        this.emailService = (EmailService) getServletContext().getAttribute("emailService");
    }
    
     List<Tarea> tareas;
     List<Usuario> usuarios;
     List<CategoriaTarea> categorias;
     
     /*private List<Tarea> cargarTareasSeguro(HttpServletRequest request) {
         try {
             return tdao.getByEtapaId(Integer.parseInt(request.getParameter("idEtapa")));
         } catch (DAOException e) {
             request.setAttribute("error", e.getMessage());
             return new ArrayList<>();
         }
     } */
     
     private Tarea cargarTareaSeguro(HttpServletRequest request, int id) {
         try {
             return tdao.getOne(id);
         } catch (DAOException e) {
             request.setAttribute("error", e.getMessage());
             return new Tarea();
         }
     }
     private Proyecto cargarProSeguro(HttpServletRequest request, int id) {
         try {
             return pdao.getById(id);
         } catch (DAOException e) {
             request.setAttribute("error", e.getMessage());
             return new Proyecto();
         }
     }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
			String rol = usuario != null ? usuario.getRol().toLowerCase() : "";
			request.setAttribute("usuario", usuario);
			
        boolean esAdmin = "administrador".equals(rol);
        boolean esEmpleado = "empleado".equals(rol);

        // Acción por defecto según rol
        String action = request.getParameter("action");
        if (action == null) {
            action = esAdmin ? "list" : "mis-tareas";
        }
        
        switch(action) {
        case "list":
        	//if (!esAdmin) {
            //    response.sendRedirect("TareaServlet?action=mis-tareas");
            //    return;
            //}
        	int idEtapa=Integer.parseInt(request.getParameter("idEtapa"));

        	List<Tarea> tareas=tdao.getByEtapaId(idEtapa);
        	Etapa e=edao.getOne(idEtapa);
        	int idProyecto = e.getIdProyecto();
        	Proyecto p = cargarProSeguro(request, idProyecto);
        	
        	categorias=cdao.getAll();
        	
        	request.setAttribute("categorias", categorias);
        	request.setAttribute("etapa", e);
        	request.setAttribute("tareas", tareas);
        	request.setAttribute("proyecto", p);
        	request.setAttribute("esAdmin", true);
        	request.getRequestDispatcher("etapas/unaEtapa.jsp").forward(request, response);
        	break;
        case "new":
        	idEtapa = Integer.parseInt(request.getParameter("idEtapa"));
        	String estadoEtapa=edao.getOne(idEtapa).getEstado();
        	
            List<Usuario> usuariosDisponibles  = udao.getAll();
            List<CategoriaTarea> categorias = cdao.getAll();
          
            int idEt=Integer.parseInt(request.getParameter("idEtapa"));
        	List<Tarea> tar=tdao.getByEtapaId(idEt);
        	request.setAttribute("tareas", tar);
        	
        	Etapa et=edao.getOne(idEtapa);
        	int idProNew = et.getIdProyecto();
        	Proyecto proNew = cargarProSeguro(request, idProNew);
        	request.setAttribute("proyecto", proNew);
        	if ("Done".equals(estadoEtapa)) {
        		request.setAttribute("error", "No se pueden agregar tareas en una etapa finalizada.");
        		request.getRequestDispatcher("etapas/unaEtapa.jsp").forward(request, response);;
        		}
        	request.setAttribute("etapa", et);
        	
        	request.setAttribute("EtapaFinalizada", estadoEtapa.equals("Done"));
            request.setAttribute("usuarios", usuariosDisponibles);
            request.setAttribute("categorias", categorias);
            request.setAttribute("idEtapa", idEtapa);
            request.setAttribute("abrirModalTarea", true);
            
            
            request.getRequestDispatcher("etapas/unaEtapa.jsp").forward(request, response);
            break;
        case "edit":
        	int idTarea = Integer.parseInt(request.getParameter("idTarea"));
            Tarea tarea = tdao.getOne(idTarea);
            
            String idEtapaParam = request.getParameter("idEtapa");
            if (idEtapaParam  != null && !idEtapaParam.isEmpty()) {
                idEtapa = Integer.parseInt(idEtapaParam);
            } else {
                idEtapa = tarea.getIdEtapa();
            }
            Etapa eta = edao.getOne(idEtapa);
            int idProyec = eta.getIdProyecto();
        	Proyecto proyec = cargarProSeguro(request, idProyec);
        	request.setAttribute("proyecto", proyec);
            List<HoraTrabajada> hs = htdao.getAllByIdTarea(tarea.getId());
            List<Usuario> asig = tdao.getUsuariosAsignados(idTarea);
        	List<Usuario> dispo = pdao.getUsuariosAsignados(eta.getIdProyecto());
        	List<Comentario> comen = comdao.getAllByIdTarea(tarea.getId());
            usuariosDisponibles = udao.getAll();
            categorias = cdao.getAll();
            estadoEtapa="";
            try {
            	estadoEtapa=edao.getEstadoByTareaId(idTarea);
            }
            catch(DAOException ex) {
            	ex.printStackTrace();
            	request.setAttribute("error", "error al obtener estado de etapa por tarea con id: "+idTarea);
            }
            List<Usuario> usuariosAsignados = tdao.getUsuariosAsignados(idTarea);
            request.setAttribute("tarea", tarea);
            request.setAttribute("etapa", eta);
            request.setAttribute("usuariosAsignados", usuariosAsignados);
            request.setAttribute("EtapaFinalizada", estadoEtapa.equals("Done"));
            request.setAttribute("usuarios", usuariosDisponibles);
            request.setAttribute("comentarios", comen);
            request.setAttribute("empleadosDisponibles", dispo);
            request.setAttribute("empleadosAsignados", asig);
            request.setAttribute("categorias", categorias); 
            request.setAttribute("idEtapa", idEtapa);
            request.setAttribute("horas", hs);
            request.setAttribute("abrirModalTarea", true); 
            request.getRequestDispatcher("tareas/unaTarea.jsp").forward(request, response);
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
        case "detalle":
        	String tab = request.getParameter("tab");
        	int idE=Integer.parseInt(request.getParameter("idEtapa"));
        	int idT=Integer.parseInt(request.getParameter("idTarea"));
        	Etapa etapa = edao.getOne(idE);
        	int idPDetalle = etapa.getIdProyecto();
        	Proyecto proDetalle = cargarProSeguro(request, idPDetalle);
        	
        	Tarea tareaDetalle = tdao.getOne(idT);
        	List<Usuario> asignados = tdao.getUsuariosAsignados(idT);
        	List<Usuario> disponibles = pdao.getUsuariosAsignados(etapa.getIdProyecto());
        	List<Comentario> comentarios = comdao.getAllByIdTarea(tareaDetalle.getId());
        	List<HoraTrabajada> horas = htdao.getAllByIdTarea(tareaDetalle.getId());
        	
		    System.out.println("==========================");
            System.out.println("Tarea seleccionada: "+tareaDetalle);
            System.out.println("Usuarios asignados: "+asignados);
            System.out.println("==========================");
            
        	request.setAttribute("etapa", etapa);
        	request.setAttribute("tarea", tareaDetalle);
        	request.setAttribute("empleadosAsignados", asignados);
        	request.setAttribute("empleadosDisponibles", disponibles);
        	request.setAttribute("comentarios", comentarios);
        	request.setAttribute("horas", horas);
            request.setAttribute("usuario", usuario);
            request.setAttribute("proyecto", proDetalle);
            request.setAttribute("tab",tab);
        	request.getRequestDispatcher("/tareas/unaTarea.jsp").forward(request, response);
            break;
            
        case "delete":
        	
    		int deleteId = Integer.parseInt(request.getParameter("idTarea"));
    		int idEtapaToDelete = Integer.parseInt(request.getParameter("idEtapa"));
    		if (deleteId != 0) {
    			try {
    				Tarea t = cargarTareaSeguro(request, deleteId);
    				request.setAttribute("tarea", t);
    				Etapa etapaDelete = edao.getOne(idEtapaToDelete);
    				int idProDelete = etapaDelete.getIdProyecto();
    				Proyecto proDelete = cargarProSeguro(request, idProDelete);
    				
    				request.setAttribute("etapa", etapaDelete);
    				request.setAttribute("proyecto", proDelete);
    				request.setAttribute("abrirModalEliminar", true);
    				
    			} catch(NumberFormatException e1) {
    				request.setAttribute("error", e1 );
    			}
    			
    		}
    		request.getRequestDispatcher("etapas/unaEtapa.jsp").forward(request,response);
            break;
        } //cierra switch
        } catch(DAOException e) {
			throw new ServletException("Error en tareaservlet get");
		}
	
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String action=request.getParameter("action");
		switch(action) {
		case "insert":
			insertarTarea(request,response);
			break;
		case "update":
			actualizarTarea(request,response);
			break;
		case "confirmDelete":
			borrarTarea(request,response);
		break;
		case "asignar":
			asignarUsuarios(request,response);
		
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
			System.out.println("no puedo borrar tarea"+e.getMessage());
		
		}
	
		response.sendRedirect("TareaServlet?action=list&idEtapa="+idEtapa);
		
	}
	
	private void insertarTarea(HttpServletRequest request,HttpServletResponse response) throws IOException{
		try{Tarea tarea=new Tarea();
		tarea.setNombre(request.getParameter("nombre"));
		tarea.setDescripcion(request.getParameter("descripcion"));
		tarea.setEstado(request.getParameter("estado"));
		tarea.setFechaInicio(Date.valueOf(request.getParameter("fechaInicio")));
		String fechaFinStr=request.getParameter("fechaFin");
		if(fechaFinStr==null||fechaFinStr.trim().isEmpty()){
			tarea.setFechaFin(null);
		}
		else {
			tarea.setFechaFin(Date.valueOf(fechaFinStr));
		}
		tarea.setIdEtapa(Integer.parseInt(request.getParameter("idEtapa")));
		tarea.setIdCategoria(Integer.parseInt(request.getParameter("idCategoria")));
		System.out.println("===== DEBUG INSERT TAREA =====");
		System.out.println("hasta el insertar llegue");
		Etapa e=edao.getOne(Integer.parseInt(request.getParameter("idEtapa")));
		String estadoEtapa=e.getEstado();
		if(estadoEtapa.equals("Done")){
			request.setAttribute("error", "No se puede crear una tarea cuando la etapa está finalizada");
			request.setAttribute("tareas", tdao.getByEtapaId(tarea.getIdEtapa()));
			request.setAttribute("categorias", cdao.getAll());
			request.setAttribute("etapa", edao.getOne(tarea.getIdEtapa()));
			request.getRequestDispatcher("etapas/unaEtapa.jsp");
		}
		
		
		

			Integer idTarea=tdao.insert(tarea);
			
			

		
			

			response.sendRedirect("TareaServlet?action=detalle&idTarea="+idTarea+"&idEtapa=" + tarea.getIdEtapa());
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
	       

	        
	        tdao.update(tarea);
	        
	        List<Usuario> usuarios=tdao.getUsuariosAsignados(tarea.getId());
	        System.out.println("los usuarios de la tarea son:"+usuarios);
//obtener usuarios asignados a la tarea para poder mandar mail
	        for (Usuario u : usuarios) {
                
                if (u != null) {
                	String asunto = "Actualización en la tarea: " + tarea.getNombre();

                	String cuerpo =
                		    "<div style='font-family: Arial, sans-serif; background:#f4f4f4; padding:20px;'>"
                		  + "  <div style='max-width:600px; margin:auto; background:#ffffff; padding:20px; border-radius:8px;'>"
                		  + "    <h2 style='color:#1a73e8;'>Actualización en una tarea</h2>"
                		  + "    <p>Hola <strong>" + u.getNombreCompleto() + "</strong>,</p>"
                		  + "    <p>Una tarea en la que estás asignado ha sido modificada.</p>"

                		  + "    <hr style='border:none; border-top:1px solid #ddd; margin:20px 0;'>"

                		  + "    <h3 style='color:#444;'>Detalles actualizados</h3>"
                		  + "    <p><strong>Nombre:</strong> " + tarea.getNombre() + "<br>"
                		  + "       <strong>Descripción:</strong> " + tarea.getDescripcion() + "<br>"
                		  + "       <strong>Estado:</strong> " + tarea.getEstado() + "<br>"
                		  + "       <strong>Inicio:</strong> " + tarea.getFechaInicio() + "<br>"
                		  + "       <strong>Fin:</strong> " + tarea.getFechaFin() + "</p>"

                		  + "    <p>Ingresá al sistema para revisar los cambios.</p>"
                		  + "  </div>"
                		  + "</div>";

                    try {
                        emailService.enviar(u.getMail(), asunto, cuerpo);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        System.out.println("[ERROR] No se envió mail a " + u.getMail());
                    }
                }
            }

	       
	        response.sendRedirect("TareaServlet?action=detalle&idTarea="+tarea.getId()+"&idEtapa=" + tarea.getIdEtapa());

	    } catch (DAOException e) {
	        throw new ServletException("Error al actualizar tarea", e);
	    }
    }
	
	private void asignarUsuarios(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
        	int id = request.getParameter("idTarea") == null || request.getParameter("idTarea").isEmpty()
        	        ? 0 : Integer.parseInt(request.getParameter("idTarea"));
        	Tarea tarea = tdao.getOne(id);

        	// Usuarios que ya estaban asignados antes de guardar
        	List<Integer> usuariosAntes = tdao.getUsuariosAsignados(id)
        	        .stream()
        	        .map(Usuario::getId)	
        	        .toList();

        	String[] usuariosForm = request.getParameterValues("usuarios");

        	List<Integer> usuariosSeleccionados = new ArrayList<>();
        	if (usuariosForm != null) {
        	    for (String idU : usuariosForm) {
        	        usuariosSeleccionados.add(Integer.parseInt(idU));
        	    }
        	}

        	tdao.asignarEmpleados(id, usuariosSeleccionados);

        	// Detectar solo los nuevos usuarios asignados
        	List<Integer> usuariosNuevos = usuariosSeleccionados.stream()
        	        .filter(u -> !usuariosAntes.contains(u))
        	        .toList();


        	// =============== ENVÍO DE MAIL SOLO A NUEVOS ===============
        	for (Integer idUser : usuariosNuevos) {
        	    Usuario u = udao.getOne(idUser);

        	    if (u != null) {
        	        String asunto = "Nueva tarea asignada: " + tarea.getNombre();

        	        String cuerpo =
        	                "<div style='font-family: Arial, sans-serif; background:#f4f4f4; padding:20px;'>"
        	              + "  <div style='max-width:600px; margin:auto; background:#ffffff; padding:20px; border-radius:8px;'>"
        	              + "    <h2 style='color:#1a73e8;'>Nueva tarea asignada</h2>"
        	              + "    <p>Hola <strong>" + u.getNombreCompleto() + "</strong>,</p>"
        	              + "    <p>Se te ha asignado una nueva tarea.</p>"
        	              + "    <hr style='border:none; border-top:1px solid #ddd; margin:20px 0;'>"
        	              + "    <h3 style='color:#444;'>Detalles</h3>"
        	              + "    <p><strong>Tarea:</strong> " + tarea.getNombre() + "<br>"
        	              + "       <strong>Descripción:</strong> " + tarea.getDescripcion() + "<br>"
        	              + "       <strong>Fecha inicio:</strong> " + tarea.getFechaInicio() + "<br>"
        	              + "       <strong>Fecha fin:</strong> " + tarea.getFechaFin() + "</p>"
        	              + "  </div>"
        	              + "</div>";

        	        try {
        	            emailService.enviar(u.getMail(), asunto, cuerpo);
        	        } catch (Exception ex) {
        	            ex.printStackTrace();
        	            System.out.println("[ERROR] No se envió mail a " + u.getMail());
        	        }
        	    }
        	}

            response.sendRedirect("TareaServlet?action=detalle&idEtapa=" + tarea.getIdEtapa() + "&idTarea=" + tarea.getId());

        } catch (Exception e) {  // <--- Captura cualquier error
            throw new ServletException("Error en asignarUsuarios", e);
        }
    }
}
	


