package comentarios;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import proyectos.Proyecto;
import proyectos.ProyectoDAO;
import tareas.TareaDAO;
import tareas.Tarea;
import comentarios.Comentario;
import comentarios.ComentarioDAO;
import etapas.Etapa;
import etapas.EtapaDAO;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import adjuntosComentario.AdjuntosComentario;
import adjuntosComentario.AdjuntosComentarioDAO;
import usuarios.Usuario;
import utils.mail.EmailService;
import exceptions.DAOException;

/**
 * Servlet implementation class ComentarioServlet
 */
@WebServlet("/ComentarioServlet")
@MultipartConfig(                                     
	    fileSizeThreshold = 1024 * 1024 * 2,   // 2 MB en memoria
	    maxFileSize = 1024 * 1024 * 15,        // 15 MB por archivo
	    maxRequestSize = 1024 * 1024 * 60      // 60 MB total (varios archivos)
	)
public class ComentarioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ComentarioDAO cdao;
	private TareaDAO tdao;
	private EtapaDAO edao;
	private ProyectoDAO pdao;
    private EmailService emailService;

	
	public void init() {
		tdao = new TareaDAO();
		cdao = new ComentarioDAO();
		edao = new EtapaDAO();
		pdao = new ProyectoDAO();
		
		this.emailService = (EmailService) getServletContext().getAttribute("emailService");
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8"); // importante para tildes
		
		//chequeo de rol
		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		if (usuario == null) {
			response.sendRedirect("LoginServlet");
		}
		
		//obtencion id y accion
		String rol = usuario != null ? usuario.getRol().toLowerCase() : "";
		int idTarea = request.getParameter("idTarea") == null || request.getParameter("idTarea").isEmpty()
                ? 0 : Integer.parseInt(request.getParameter("idTarea"));
		String action = request.getParameter("action");
		
		
		switch(action) {
		
		case "new":
			try {
				System.out.println("entro al crear comentario");
	            Tarea tarea = tdao.getOne(idTarea);
	            List<Usuario> asignados = tdao.getUsuariosAsignados(tarea.getId());
	            Etapa etapa = edao.getOne(tarea.getIdEtapa());
	            Proyecto pro = pdao.getById(etapa.getIdProyecto());
	            String texto = request.getParameter("texto");
	            
	            // Checkeo que sea parte
	            boolean pertenece = false;
	            for (Usuario u : asignados) {
	                if (u.getId() == usuario.getId()) {
	                    pertenece = true;
	                    break;
	                }
	            }
	            int idSup = pro.getSupervisor().getId();
	            if(idSup == usuario.getId()) {
	            	pertenece = true;
	            }
	            if (!pertenece && !"administrador".equalsIgnoreCase(rol)) {
	            	response.sendRedirect("ProyectoServlet");
	            	return;
	            }
	            
	            
	            // 1. Inserto el comentario
	            Date hoy = new Date();
	            Comentario comentario = new Comentario();
	            comentario.setIdTarea(tarea.getId());
	            comentario.setIdEmpleado(usuario.getId());
	            comentario.setTexto(texto);
	            comentario.setFecha(hoy);
	            //recupero el id para los adjuntos
	            int idComentario = cdao.insert(comentario);
	            System.out.println("idComentario insertado" + idComentario);
	            // 2. SUBIR ARCHIVOS (si los hay)
	            String uploadPath = getServletContext().getRealPath("") 
                        + File.separator + "uploads" 
                        + File.separator + "comentarios";
	            File uploadDir = new File(uploadPath);
	            if (!uploadDir.exists()) uploadDir.mkdirs();
		
		      // AQUÍ ESTÁ EL TRUCO: solo recorremos UNA VEZ los parts
	            for (Part part : request.getParts()) {
		          String fieldName = part.getName();
		          
		          // Ignoramos los campos de texto (texto, idTarea, action)
		          if ("archivos".equals(fieldName)) {
		              String fileName = getFileName(part);
		              
		              if (fileName != null && !fileName.isEmpty()) {
		                  System.out.println("Subiendo archivo: " + fileName + " (" + part.getSize() + " bytes)");
		
		                  String extension = fileName.contains(".") 
		                      ? fileName.substring(fileName.lastIndexOf(".")) : "";
		                  String nombreGuardado = idComentario + "_" + System.currentTimeMillis() + extension;
		
		                  File archivoDestino = new File(uploadDir, nombreGuardado);
		                  
		                  // ¡ESTE ES EL QUE FUNCIONA!
		                  part.write(archivoDestino.getAbsolutePath());  // ← MÉTODO MÁGICO DE Part
		                  System.out.println("Archivo físicamente guardado en: " + archivoDestino.getAbsolutePath());     
		                  // Guardar en base de datos
	                        AdjuntosComentario adjunto = new AdjuntosComentario();
	                        adjunto.setIdComentario(idComentario);
	                        adjunto.setNombreOriginal(fileName);
	                        adjunto.setNombreGuardado(nombreGuardado);
	                        adjunto.setRuta("/uploads/comentarios/" + nombreGuardado);
	                        adjunto.setTamanoKb((int) (part.getSize() / 1024));
	                        adjunto.setTipoMime(part.getContentType());
	                        
	                        System.out.println("ENTRO AL DAO ADJUNTOS");
	                        AdjuntosComentarioDAO.insertar(adjunto);
	                        System.out.println("SALIO DEL DAO ADJUNTOS");
	                        
		                    }
		                }
		      }
	            
	            
	            // ENVÍO DE MAIL AL CREAR UN COMENTARIO
	            
	            for (Usuario u : asignados) {

	                // Evitar enviar al autor
	                if (u.getId() == usuario.getId()) 
	                    continue;

	                String asunto = "Nuevo comentario en la tarea: " + tarea.getNombre();

	                String cuerpo =
	                	    "<div style='font-family: Arial, sans-serif; background:#f4f4f4; padding:20px;'>"
	                	  + "  <div style='max-width:600px; margin:auto; background:#ffffff; padding:20px; border-radius:8px;'>"
	                	  + "    <h2 style='color:#1a73e8;'>Nuevo comentario en una tarea</h2>"
	                	  + "    <p>Hola <strong>" + u.getNombreCompleto() + "</strong>,</p>"
	                	  + "    <p>Se agregó un nuevo comentario en la tarea <strong>" + tarea.getNombre() + "</strong>.</p>"

	                	  + "    <hr style='border:none; border-top:1px solid #ddd; margin:20px 0;'>"

	                	  + "    <h3 style='color:#444;'>Comentario</h3>"
	                	  + "    <p style='white-space:pre-line; background:#f7f7f7; padding:12px; border-radius:6px;'>" 
	                	  +          texto + "</p>"

	                	  + "    <p><strong>Autor:</strong> " + usuario.getNombreCompleto() + "</p>"

	                	  + "    <p>Podés ver el detalle completo ingresando al sistema.</p>"
	                	  + "  </div>"
	                	  + "</div>";

	                try {
	                    emailService.enviar(u.getMail(), asunto, cuerpo);
	                } catch (Exception exMail) {
	                    System.out.println("[ERROR] No se pudo enviar mail a " + u.getMail());
	                    exMail.printStackTrace();
	                }
	            }
	            
	            // FORWARD A LA MISMA PÁGINA
	            response.sendRedirect("TareaServlet?action=detalle&idTarea=" + tarea.getId() + "&idEtapa=" + tarea.getIdEtapa()+ "&tab=comentarios");
	            return;

	        } catch (DAOException e) {
	            request.setAttribute("error", "Comentario invalido");
	            // fallback
	        }
			break;
		
		case "delete":
			try {
				int idComentario = Integer.parseInt(request.getParameter("idComentario"));
				System.out.println("comentario a borrar: "+idComentario);
				Comentario c = cdao.getById(idComentario);
				
				idTarea = c.getIdTarea();
				Tarea tarea = tdao.getOne(idTarea);
				
				
				request.setAttribute(action, tarea);
				if (usuario.getId() != c.getIdEmpleado()) {
					response.sendRedirect("TareaServlet?action=detalle&idTarea=" + tarea.getId() + "&idEtapa=" + tarea.getIdEtapa() + "&tab=comentarios" +"&error=invalid_id");
				}
				
				cdao.delete(c.getId());
				
				// FORWARD A LA MISMA PÁGINA
	            response.sendRedirect("TareaServlet?action=detalle&idTarea=" + tarea.getId() + "&idEtapa=" + tarea.getIdEtapa() + "&tab=comentarios");
	            return;
				
			} catch (DAOException e) {
	            request.setAttribute("error", "Comentario invalido");
	            // fallback
	        }
		}
	} //do post
	
	// Método auxiliar para sacar el nombre original del archivo
	private String getFileName(Part part) {
		String contentDisposition = part.getHeader("content-disposition");
		if (contentDisposition != null) {
			for (String cd : contentDisposition.split(";")) {
				if (cd.trim().startsWith("filename")) {
					String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
					return fileName.isEmpty() ? null : fileName;
				}
			}
		}
		return null;
	}
} //servlet



